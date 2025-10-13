import * as admin from "firebase-admin";
import {Announcement, ScrapedAnnouncement} from "./types";
import {Department} from "./departmentLinks";

// Firestore instance - lazy initialization
function getFirestore() {
  return admin.firestore();
}

/**
 * Duyuruları Firestore'a kaydeder ve yeni duyuruları döndürür
 * @param {string} departmentId Department ID
 * @param {string} departmentName Department name
 * @param {ScrapedAnnouncement[]} scrapedAnnouncements Scraped announcements
 * @return {Promise<Announcement[]>} New announcements
 */
export async function saveAnnouncementsToFirestore(
    departmentId: string,
    departmentName: string,
    scrapedAnnouncements: ScrapedAnnouncement[],
): Promise<Announcement[]> {
  const newAnnouncements: Announcement[] = [];

  try {
    // Mevcut duyuruları çek (son 30 gün)
    const thirtyDaysAgo = new Date();
    thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);

    const collectionName = `bolum_${departmentId}_duyurular`;
    const existingAnnouncements = await getFirestore()
      .collection(collectionName)
      .orderBy("olusturma_zamani", "desc")
      .limit(50) // Son 50 duyuruyu kontrol et
      .get();

    // Mevcut duyuru başlıklarını hash set olarak sakla - daha güçlü deduplication
    const existingKeys = new Set<string>();
    existingAnnouncements.forEach((doc) => {
      const data = doc.data();
      // Başlık + URL kombinasyonu ile daha güçlü kontrol
      const uniqueKey = `${data.baslik?.trim() || ''}-${data.url || ''}`;
      existingKeys.add(uniqueKey);
    });
    
    console.log(`DEBUG: Existing ${existingKeys.size} announcements in Firestore`);

    // Batch write için hazırla
    const batch = getFirestore().batch();
    let batchCount = 0;

    for (const scraped of scrapedAnnouncements) {
      // Başlık + URL kombinasyonu ile daha güçlü kontrol
      const announcementKey = `${scraped.baslik?.trim() || ''}-${scraped.url || ''}`;
      
      console.log(`DEBUG: Checking announcement: "${scraped.baslik}" - URL: "${scraped.url}" - Key: "${announcementKey}"`);

      // Yeni duyuru mu kontrol et
      if (!existingKeys.has(announcementKey)) {
        console.log(`DEBUG: New announcement found: "${scraped.baslik}"`);
        // Daha güvenli ID generation - başlık hash'i kullan
        const titleHash = Buffer.from(scraped.baslik || '').toString('base64').substring(0, 8);
        const announcementId = `${departmentId}_${Date.now()}_${titleHash}`;

        const announcement: Announcement = {
          id: announcementId,
          baslik: scraped.baslik,
          icerik: scraped.icerik,
          tarih: scraped.tarih,
          bolum_id: departmentId,
          bolum_adi: departmentName,
          url: scraped.url,
          olusturma_zamani: new Date(),
        };

        const docRef = getFirestore().collection(collectionName).doc(announcementId);
        batch.set(docRef, announcement);
        newAnnouncements.push(announcement);

        batchCount++;

        // Firestore batch limit (500)
        if (batchCount >= 500) {
          await batch.commit();
          batchCount = 0;
        }
      }
    }

    // Kalan batch'i commit et
    if (batchCount > 0) {
      await batch.commit();
    }

    // Eski duyuruları temizle (sadece son 10 duyuruyu tut)
    await cleanupOldAnnouncements(collectionName, departmentId);

    console.log(`Saved ${newAnnouncements.length} new announcements ` +
      `for ${departmentName} in collection ${collectionName}`);
    return newAnnouncements;
  } catch (error) {
    console.error(`Error saving announcements for ${departmentId}:`, error);
    throw error;
  }
}

/**
 * Eski duyuruları temizler, sadece son 10 duyuruyu tutar
 * @param {string} collectionName Collection name
 * @param {string} departmentId Department ID
 */
async function cleanupOldAnnouncements(collectionName: string, departmentId: string): Promise<void> {
  try {
    // Eski duyuruları sil (11. duyurudan sonrasını sil)
    const oldAnnouncements = await getFirestore()
      .collection(collectionName)
      .orderBy("olusturma_zamani", "desc")
      .offset(10)
      .get();

    if (!oldAnnouncements.empty) {
      const batch = getFirestore().batch();
      oldAnnouncements.forEach((doc) => {
        batch.delete(doc.ref);
      });
      await batch.commit();
      console.log(`Cleaned up ${oldAnnouncements.size} old announcements from ${collectionName}`);
    }
  } catch (error) {
    console.error(`Error cleaning up old announcements for ${departmentId}:`, error);
  }
}

/**
 * Bölüm bilgilerini Firestore'a kaydeder
 * @param {Department} department Department object
 * @return {Promise<void>} Promise that resolves when complete
 */
export async function saveDepartmentToFirestore(department: Department):
  Promise<void> {
  try {
    await getFirestore().collection("bolumler").doc(department.id).set({
      ad: department.name,
      url: department.url,
      aktif: true,
      son_guncelleme: admin.firestore.FieldValue.serverTimestamp(),
    });
  } catch (error) {
    console.error(`Error saving department ${department.id}:`, error);
    throw error;
  }
}

/**
 * Bildirim gönderilecek kullanıcıları getirir
 * @param {string} departmentId Department ID
 * @return {Promise<admin.auth.UserRecord[]>} Array of users to notify
 */
export async function getUsersToNotify(departmentId: string):
  Promise<admin.auth.UserRecord[]> {
  try {
    const usersSnapshot = await getFirestore()
      .collection("kullanicilar")
      .where("takip_edilen_bolumler", "array-contains", departmentId)
      .where("fcm_token", "!=", null)
      .get();

    const users: admin.auth.UserRecord[] = [];

    for (const doc of usersSnapshot.docs) {
      const userData = doc.data();
      if (userData.fcm_token) {
        try {
          const userRecord = await admin.auth().getUser(doc.id);
          users.push(userRecord);
        } catch (error) {
          console.error(`Error getting user ${doc.id}:`, error);
        }
      }
    }

    return users;
  } catch (error) {
    console.error(`Error getting users to notify for ${departmentId}:`, error);
    throw error;
  }
}

/**
 * Kullanıcının FCM token'ını günceller
 * @param {string} userId User ID
 * @param {string} fcmToken FCM token
 * @return {Promise<void>} Promise that resolves when complete
 */
export async function updateUserFCMToken(userId: string, fcmToken: string):
  Promise<void> {
  try {
    await getFirestore().collection("kullanicilar").doc(userId).update({
      fcm_token: fcmToken,
      son_guncelleme: admin.firestore.FieldValue.serverTimestamp(),
    });
  } catch (error) {
    console.error(`Error updating FCM token for user ${userId}:`, error);
    throw error;
  }
}

/**
 * Kullanıcının takip ettiği bölümleri günceller
 * @param {string} userId User ID
 * @param {string[]} followedDepartments Followed departments
 * @return {Promise<void>} Promise that resolves when complete
 */
export async function updateUserFollowedDepartments(
    userId: string,
    followedDepartments: string[],
): Promise<void> {
  try {
    await getFirestore().collection("kullanicilar").doc(userId).update({
      takip_edilen_bolumler: followedDepartments,
      son_guncelleme: admin.firestore.FieldValue.serverTimestamp(),
    });
  } catch (error) {
    console.error(`Error updating followed departments for user ${userId}:`,
        error);
    throw error;
  }
}

/**
 * Kullanıcının bildirim tercihlerini günceller
 * @param {string} userId User ID
 * @param {"tumu" | "sadece_yeni"} preference Notification preference
 * @return {Promise<void>} Promise that resolves when complete
 */
export async function updateUserNotificationPreference(
    userId: string,
    preference: "tumu" | "sadece_yeni",
): Promise<void> {
  try {
    await getFirestore().collection("kullanicilar").doc(userId).update({
      bildirim_tercihi: preference,
      son_guncelleme: admin.firestore.FieldValue.serverTimestamp(),
    });
  } catch (error) {
    console.error(`Error updating notification preference for user ${userId}:`,
        error);
    throw error;
  }
}