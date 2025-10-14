import {onSchedule} from "firebase-functions/v2/scheduler";
import {onRequest} from "firebase-functions/v2/https";
import * as admin from "firebase-admin";
import {departments} from "./departmentLinks.js";
import {scrapeDepartmentAnnouncements} from "./scraper.js";
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

        // SADECE SON DUYURUYU KONTROL ET
        const firstPage = await scrapeDepartmentAnnouncements(
            department.url,
        );
        const latest = firstPage[0];

        let newAnnouncements: any[] = [];
        if (latest) {
          newAnnouncements = await saveAnnouncementsToFirestore(
              department.id,
              department.name,
              [latest],
          );
        }

        // Yeni duyuru varsa bildirim gönder
        if (newAnnouncements.length > 0) {
          console.log(`Found ${newAnnouncements.length} new announcements ` +
            `for ${department.name}`);

          // İlgili kullanıcıları bul
          const fcmTokens = await getUsersToNotify(department.id);

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
 * Manuel test bildirimi gönderme fonksiyonu
 * Sadece test amaçlıdır.
 */
export const sendTestNotification = onRequest(async (req, res) => {
  res.set("Access-Control-Allow-Origin", "*");
  res.set("Access-Control-Allow-Methods", "GET, POST");
  res.set("Access-Control-Allow-Headers", "Content-Type");

  if (req.method === "OPTIONS") {
    res.status(204).send("");
    return;
  }

  try {
    console.log("Test notification function triggered.");

    const departmentId = req.body.departmentId || "bilgisayar-muhendisligi";
    const departmentName = req.body.departmentName || "Bilgisayar Mühendisliği";
    const title = req.body.title || "🧪 TEST DUYURUSU - Bildirim Sistemi Testi";
    const content = req.body.content || "Bu bir test duyurusudur. Bildirim sisteminin çalışıp çalışmadığını kontrol etmek için eklenmiştir.";
    const url = req.body.url || "https://bilgisayarmf.firat.edu.tr/test-duyuru";

    const testAnnouncement = {
      id: `${departmentId}_${Date.now()}_test`,
      baslik: title,
      icerik: content,
      tarih: new Date().toISOString(),
      yayinlanmaTarihi: new Date().toISOString(),
      bolum_id: departmentId,
      bolum_adi: departmentName,
      url: url,
      olusturma_zamani: new Date(),
    };

    // İlgili kullanıcıları bul
    const fcmTokens = await getUsersToNotify(departmentId);

    if (fcmTokens.length === 0) {
      console.log(`No FCM tokens found for department ${departmentId}.`);
      res.status(200).json({
        success: false,
        message: `No users following ${departmentName} or no FCM tokens found.`,
      });
      return;
    }

    console.log(`Sending test notification to ${fcmTokens.length} users for ${departmentName}`);
    await sendNotificationToUsers(testAnnouncement, fcmTokens);

    res.status(200).json({
      success: true,
      message: "Test bildirimi başarıyla gönderildi.",
      department: departmentName,
      fcmTokensCount: fcmTokens.length,
      announcement: testAnnouncement,
    });
  } catch (error) {
    console.error("Error sending test notification:", error);
    res.status(500).json({
      success: false,
      message: "Test bildirimi gönderilirken bir hata oluştu.",
      error: (error as Error).message,
    });
  }
});

/**
 * Debug function - Firestore verilerini kontrol eder
 */
export const debugFirestore = onRequest(async (req, res) => {
  res.set("Access-Control-Allow-Origin", "*");
  res.set("Access-Control-Allow-Methods", "GET, POST");
  res.set("Access-Control-Allow-Headers", "Content-Type");

  try {
    console.log("Debug function triggered.");

    // Tüm kullanıcıları listele
    const usersSnapshot = await admin.firestore()
        .collection("kullanicilar")
        .get();

    const users = [];
    for (const doc of usersSnapshot.docs) {
      const data = doc.data();
      users.push({
        uid: doc.id,
        fcmToken: data.fcmToken || data.fcm_token || "YOK",
        takipEdilenBolumler: data.takipEdilenBolumler || data.takip_edilen_bolumler || [],
        bildirimTercihi: data.bildirimTercihi || data.bildirim_tercihi || "YOK",
      });
    }

    // Bilgisayar Mühendisliği takip eden kullanıcıları bul
    const bilgisayarUsers = users.filter((user) => 
      user.takipEdilenBolumler.includes("bilgisayar-muhendisligi")
    );

    res.status(200).json({
      success: true,
      totalUsers: users.length,
      bilgisayarUsers: bilgisayarUsers.length,
      allUsers: users,
      bilgisayarFollowers: bilgisayarUsers,
    });
  } catch (error) {
    console.error("Debug error:", error);
    res.status(500).json({
      success: false,
      error: (error as Error).message,
    });
  }
});

/**
 * Direct FCM test function - Token ile direkt bildirim gönderir
 */
export const directFCMTest = onRequest(async (req, res) => {
  res.set("Access-Control-Allow-Origin", "*");
  res.set("Access-Control-Allow-Methods", "GET, POST");
  res.set("Access-Control-Allow-Headers", "Content-Type");

  if (req.method === "OPTIONS") {
    res.status(204).send("");
    return;
  }

  try {
    console.log("Direct FCM test function triggered.");

    const fcmTokens = req.body.fcmTokens || [];
    const title = req.body.title || "🧪 DIRECT FCM TEST";
    const content = req.body.content || "Bu direkt FCM test bildirimidir!";

    if (fcmTokens.length === 0) {
      res.status(400).json({
        success: false,
        message: "FCM token array required",
      });
      return;
    }

    const testAnnouncement = {
      id: `direct_test_${Date.now()}`,
      baslik: title,
      icerik: content,
      tarih: new Date().toISOString(),
      yayinlanmaTarihi: new Date().toISOString(),
      bolum_id: "bilgisayar-muhendisligi",
      bolum_adi: "Bilgisayar Mühendisliği",
      url: "https://test.com",
      olusturma_zamani: new Date(),
    };

    console.log(`Sending direct FCM test to ${fcmTokens.length} tokens`);
    await sendNotificationToUsers(testAnnouncement, fcmTokens);

    res.status(200).json({
      success: true,
      message: "Direct FCM test bildirimi gönderildi!",
      tokensCount: fcmTokens.length,
      announcement: testAnnouncement,
    });
  } catch (error) {
    console.error("Direct FCM test error:", error);
    res.status(500).json({
      success: false,
      message: "Direct FCM test hatası",
      error: (error as Error).message,
    });
  }
});