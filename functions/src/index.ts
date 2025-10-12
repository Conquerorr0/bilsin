import {onSchedule} from "firebase-functions/v2/scheduler";
import {onRequest} from "firebase-functions/v2/https";
import * as admin from "firebase-admin";
import {departments} from "./departmentLinks.js";
import {scrapeAllAnnouncements} from "./scraper.js";
import {
  saveAnnouncementsToFirestore,
  saveDepartmentToFirestore,
  getUsersToNotify,
} from "./firestore.js";
import {sendNotificationToUsers} from "./notifications.js";

// Firebase Admin SDK'yı başlat
admin.initializeApp();

/**
 * Zamanlanmış duyuru kazıma fonksiyonu
 * Her 15 dakikada bir çalışır
 */
export const scheduledScraper = onSchedule("every 15 minutes", async (event) => {
  console.log("Scheduled scraper started at:", new Date().toISOString());

  try {
    let totalNewAnnouncements = 0;
    let processedDepartments = 0;

    // Tüm bölümleri işle
    for (const department of departments) {
      try {
        console.log(`Processing department: ${department.name}`);

        // Bölüm bilgilerini Firestore'a kaydet (güncelle)
        await saveDepartmentToFirestore(department);

        // Duyuruları kazı
        const scrapedAnnouncements = await scrapeAllAnnouncements(
            department.url,
        );

        // Yeni duyuruları Firestore'a kaydet
        const newAnnouncements = await saveAnnouncementsToFirestore(
            department.id,
            department.name,
            scrapedAnnouncements,
        );

        // Yeni duyuru varsa bildirim gönder
        if (newAnnouncements.length > 0) {
          console.log(`Found ${newAnnouncements.length} new announcements ` +
            `for ${department.name}`);

          // İlgili kullanıcıları bul
          const usersToNotify = await getUsersToNotify(department.id);
          const fcmTokens = usersToNotify
              .map((user) => user.customClaims?.fcm_token)
              .filter((token) => token) as string[];

          // Her yeni duyuru için bildirim gönder
          for (const announcement of newAnnouncements) {
            await sendNotificationToUsers(announcement, fcmTokens);

            // Bildirimler arası kısa bekleme
            await new Promise((resolve) => setTimeout(resolve, 100));
          }

          totalNewAnnouncements += newAnnouncements.length;
        }

        processedDepartments++;

        // Bölümler arası bekleme (rate limiting)
        await new Promise((resolve) => setTimeout(resolve, 2000));
      } catch (error) {
        console.error(`Error processing department ${department.name}:`,
            error as Error);
        // Bir bölümde hata olsa bile diğerlerine devam et
      }
    }

    console.log(`Scheduled scraper completed. Processed ` +
      `${processedDepartments} departments, found ` +
      `${totalNewAnnouncements} new announcements`);
  } catch (error) {
    console.error("Scheduled scraper failed:", error);
    throw error;
  }
});

/**
 * Manuel duyuru kazıma fonksiyonu (test için)
 */
export const manualScraper = onRequest(async (req, res) => {
  // CORS ayarları
  res.set("Access-Control-Allow-Origin", "*");
  res.set("Access-Control-Allow-Methods", "GET, POST");
  res.set("Access-Control-Allow-Headers", "Content-Type");

  if (req.method === "OPTIONS") {
    res.status(204).send("");
    return;
  }

  try {
    const {departmentId} = req.body;

    if (!departmentId) {
      res.status(400).json({error: "departmentId is required"});
      return;
    }

    const department = departments.find((d) => d.id === departmentId);
    if (!department) {
      res.status(404).json({error: "Department not found"});
      return;
    }

    console.log(`Manual scraping for department: ${department.name}`);

    // Duyuruları kazı
    const scrapedAnnouncements = await scrapeAllAnnouncements(
        department.url,
    );

    // Yeni duyuruları kaydet
    const newAnnouncements = await saveAnnouncementsToFirestore(
        department.id,
        department.name,
        scrapedAnnouncements,
    );

    res.json({
      success: true,
      department: department.name,
      totalScraped: scrapedAnnouncements.length,
      newAnnouncements: newAnnouncements.length,
      announcements: newAnnouncements,
    });
  } catch (error) {
    console.error("Manual scraper error:", error);
    res.status(500).json({error: (error as Error).message});
  }
});

/**
 * Tüm bölümleri manuel olarak kazı (test için)
 */
export const scrapeAllDepartments = onRequest(async (req, res) => {
  // CORS ayarları
  res.set("Access-Control-Allow-Origin", "*");
  res.set("Access-Control-Allow-Methods", "GET, POST");
  res.set("Access-Control-Allow-Headers", "Content-Type");

  if (req.method === "OPTIONS") {
    res.status(204).send("");
    return;
  }

  try {
    console.log("Manual scrape all departments started");

    let totalNewAnnouncements = 0;
    const results: any[] = [];

    for (const department of departments) {
      try {
        const scrapedAnnouncements = await scrapeAllAnnouncements(
            department.url,
        );
        
        // İlk 10 duyuruyu al
        const firstTen = scrapedAnnouncements.slice(0, 10);
        
        const newAnnouncements = await saveAnnouncementsToFirestore(
            department.id,
            department.name,
            firstTen,
        );

        results.push({
          department: department.name,
          scraped: scrapedAnnouncements.length,
          new: newAnnouncements.length,
        });

        totalNewAnnouncements += newAnnouncements.length;

        // Bölümler arası bekleme
        await new Promise((resolve) => setTimeout(resolve, 1000));
      } catch (error) {
        console.error(`Error scraping ${department.name}:`, error);
        results.push({
          department: department.name,
          error: (error as Error).message,
        });
      }
    }

    res.json({
      success: true,
      totalNewAnnouncements,
      results,
    });
  } catch (error) {
    console.error("Scrape all departments error:", error);
    res.status(500).json({error: (error as Error).message});
  }
});

/**
 * Eksik bölümleri Firestore'a ekle
 */
export const addMissingDepartments = onRequest(async (req, res) => {
  // CORS ayarları
  res.set("Access-Control-Allow-Origin", "*");
  res.set("Access-Control-Allow-Methods", "GET, POST");
  res.set("Access-Control-Allow-Headers", "Content-Type");

  if (req.method === "OPTIONS") {
    res.status(204).send("");
    return;
  }

  try {
    console.log("Adding missing departments to Firestore");

    const missingDepartments = [
      {
        id: "insaat-muhendisligi-tf",
        name: "İnşaat Mühendisliği (Teknoloji Fakültesi)",
        url: "https://insaattf.firat.edu.tr/tr/announcements-all"
      },
      {
        id: "makine-muhendisligi-tf", 
        name: "Makine Mühendisliği (Teknoloji Fakültesi)",
        url: "https://makinatf.firat.edu.tr/announcements-all"
      },
      {
        id: "mekatronik-muhendisligi-tf",
        name: "Mekatronik Mühendisliği (Teknoloji Fakültesi)", 
        url: "https://mekatroniktf.firat.edu.tr/tr/announcements-all"
      },
      {
        id: "metalurji-malzeme-muhendisligi-tf",
        name: "Metalurji ve Malzeme Mühendisliği (Teknoloji Fakültesi)",
        url: "https://mmtf.firat.edu.tr/tr/announcements-all"
      },
      {
        id: "otomotiv-muhendisligi",
        name: "Otomotiv Mühendisliği Bölümü",
        url: "https://otomotivmf.firat.edu.tr/tr/announcements-all"
      },
      {
        id: "yazilim-muhendisligi-tf",
        name: "Yazılım Mühendisliği (Teknoloji Fakültesi)",
        url: "https://yazilimtf.firat.edu.tr/tr/announcements-all"
      },
      {
        id: "yazilim-muhendisligi-uluslararasi",
        name: "Yazılım Mühendisliği Uluslararası Ortak Lisans Programı",
        url: "https://yazilimmuholp.firat.edu.tr/announcements-all"
      },
      {
        id: "enerji-sistemleri-muhendisligi",
        name: "Enerji Sistemleri Mühendisliği",
        url: "https://entf.firat.edu.tr/announcements-all"
      }
    ];

    const results = [];
    
    for (const dept of missingDepartments) {
      try {
        await saveDepartmentToFirestore(dept);
        results.push({
          department: dept.name,
          status: "success"
        });
        console.log(`Added department: ${dept.name}`);
      } catch (error) {
        results.push({
          department: dept.name,
          status: "error",
          error: (error as Error).message
        });
        console.error(`Error adding department ${dept.name}:`, error);
      }
    }

    res.json({
      success: true,
      message: "Missing departments added",
      results
    });
  } catch (error) {
    console.error("Add missing departments error:", error);
    res.status(500).json({error: (error as Error).message});
  }
});

/**
 * Test bildirimi gönder
 */
export const sendTestNotification = onRequest(async (req, res) => {
  // CORS ayarları
  res.set("Access-Control-Allow-Origin", "*");
  res.set("Access-Control-Allow-Methods", "GET, POST");
  res.set("Access-Control-Allow-Headers", "Content-Type");

  if (req.method === "OPTIONS") {
    res.status(204).send("");
    return;
  }

  try {
    const {fcmToken} = req.body;

    if (!fcmToken) {
      res.status(400).json({error: "fcmToken is required"});
      return;
    }

    const {sendTestNotification} = await import("./notifications.js");
    await sendTestNotification(fcmToken);

    res.json({success: true, message: "Test notification sent"});
  } catch (error) {
    console.error("Send test notification error:", error);
    res.status(500).json({error: (error as Error).message});
  }
});