import * as admin from "firebase-admin";
import {Announcement} from "./types";

/**
 * FCM ile bildirim gönderir
 * @param {Announcement} announcement Announcement object
 * @param {string[]} fcmTokens Array of FCM tokens
 * @return {Promise<void>} Promise that resolves when complete
 */
export async function sendNotificationToUsers(
    announcement: Announcement,
    fcmTokens: string[],
): Promise<void> {
  if (fcmTokens.length === 0) {
    console.log("No FCM tokens to send notification to");
    return;
  }

  try {
    const message = {
      notification: {
        title: `📢 ${announcement.bolum_adi} - Yeni Duyuru`,
        body: announcement.baslik.length > 100 
          ? `${announcement.baslik.substring(0, 100)}...`
          : announcement.baslik,
        imageUrl: "https://firebasestorage.googleapis.com/v0/b/your-project.appspot.com/o/app_icon.png?alt=media", // Firebase Storage URL'si
      },
      android: {
        notification: {
          icon: "ic_notification", // Android notification icon
          color: "#722D2C", // App theme color
          sound: "default",
          priority: "high" as const,
          defaultSound: true,
          defaultVibrateTimings: true,
          defaultLightSettings: true,
        },
      },
      apns: {
        payload: {
          aps: {
            sound: "default",
            badge: 1,
          },
        },
      },
      data: {
        duyuru_id: announcement.id,
        bolum_id: announcement.bolum_id,
        bolum_adi: announcement.bolum_adi,
        url: announcement.url,
        type: "new_announcement",
        title: announcement.baslik,
        department_color: announcement.bolum_adi, // Department color info
      },
      tokens: fcmTokens,
    };

    const response = await admin.messaging().sendEachForMulticast(message);

    console.log(`Notification sent successfully: ${response.successCount} ` +
      `successful, ${response.failureCount} failed`);

    // Başarısız token'ları logla
    if (response.failureCount > 0) {
      response.responses.forEach((resp, idx) => {
        if (!resp.success) {
          console.error(`Failed to send notification to token ${idx}: ` +
            `${resp.error?.message}`);
        }
      });
    }
  } catch (error) {
    console.error("Error sending notifications:", error);
    throw error;
  }
}

/**
 * Tek bir kullanıcıya bildirim gönderir
 * @param {string} fcmToken FCM token
 * @param {string} title Notification title
 * @param {string} body Notification body
 * @param {Object} data Additional data
 * @return {Promise<void>} Promise that resolves when complete
 */
export async function sendNotificationToUser(
    fcmToken: string,
    title: string,
    body: string,
    data?: {[key: string]: string},
): Promise<void> {
  try {
    const message = {
      notification: {
        title,
        body,
      },
      data: data || {},
      token: fcmToken,
    };

    await admin.messaging().send(message);
    console.log(`Notification sent to user with token: ` +
      `${fcmToken.substring(0, 20)}...`);
  } catch (error) {
    console.error(`Error sending notification to user: ${error}`);
    throw error;
  }
}

/**
 * Test bildirimi gönderir
 * @param {string} fcmToken FCM token
 * @return {Promise<void>} Promise that resolves when complete
 */
export async function sendTestNotification(fcmToken: string): Promise<void> {
  const testData = {
    duyuru_id: "test_" + Date.now(),
    bolum_id: "test",
    bolum_adi: "Test Bölümü",
    type: "test_notification",
  };

  await sendNotificationToUser(
      fcmToken,
      "Test Bildirimi",
      "Bu bir test bildirimidir. Uygulama doğru şekilde çalışıyor!",
      testData,
  );
}