# Fırat Üniversitesi Duyuru Takip Uygulaması

Fırat Üniversitesi'nin tüm bölümlerinden duyuruları takip eden, anlık push bildirimleri gönderen Flutter mobil uygulaması.

## 🚀 Özellikler

- **24 Bölüm Takibi**: Fırat Üniversitesi'nin tüm bölümlerinden duyuru takibi
- **Anlık Bildirimler**: Yeni duyurular için push bildirimleri
- **Arama ve Filtreleme**: Duyurularda arama ve bölüm bazında filtreleme
- **Offline Okuma**: İndirilen duyuruları internet olmadan okuma
- **Modern UI**: Material Design 3 ile modern arayüz
- **Cross-Platform**: iOS ve Android desteği

## 🏗️ Teknik Mimari

### Backend (Firebase)
- **Firestore**: NoSQL veritabanı
- **Cloud Functions**: Web kazıma ve bildirim servisleri
- **Cloud Scheduler**: 15 dakikada bir otomatik kazıma
- **Firebase Cloud Messaging (FCM)**: Push bildirimleri

### Frontend (Flutter)
- **Provider**: State management
- **Firebase SDK**: Veritabanı ve bildirim entegrasyonu
- **Local Notifications**: Yerel bildirim desteği

### Web Kazıma
- **Axios**: HTTP istekleri
- **Cheerio**: HTML parsing
- **TypeScript**: Cloud Functions geliştirme

## 📱 Kurulum

### Ön Gereksinimler

1. **Flutter SDK** (3.8.1+)
2. **Firebase CLI**
3. **Node.js** (18+)
4. **Google Cloud SDK**

### 1. Firebase Projesi Kurulumu

```bash
# Firebase CLI kurulumu
npm install -g firebase-tools

# Firebase'e giriş yap
firebase login

# Proje klasöründe Firebase'i başlat
firebase init

# Aşağıdaki seçenekleri seçin:
# - Firestore
# - Cloud Functions
# - TypeScript
```

### 2. Firebase Console'da Yapılandırma

1. [Firebase Console](https://console.firebase.google.com/)'da yeni proje oluşturun
2. **Firestore Database** oluşturun (production mode)
3. **Authentication** aktif edin (Anonymous sign-in)
4. **Cloud Messaging** aktif edin
5. **Cloud Functions** aktif edin

### 3. Flutter Uygulaması Kurulumu

```bash
# Bağımlılıkları yükle
flutter pub get

# Firebase yapılandırma dosyalarını ekle
# android/app/google-services.json
# ios/Runner/GoogleService-Info.plist

# Firebase options dosyasını güncelle
# lib/firebase_options.dart içindeki değerleri Firebase Console'dan alın
```

### 4. Cloud Functions Kurulumu

```bash
# Functions klasörüne git
cd functions

# Bağımlılıkları yükle
npm install

# TypeScript'i derle
npm run build

# Functions'ları deploy et
firebase deploy --only functions
```

### 5. Cloud Scheduler Kurulumu

```bash
# Cloud Scheduler job oluştur
gcloud scheduler jobs create http scrapeDuyurular \
  --schedule="*/15 * * * *" \
  --uri="https://europe-west1-YOUR_PROJECT_ID.cloudfunctions.net/scheduledScraper" \
  --http-method=POST
```

## 🔧 Yapılandırma

### Firebase Options

`lib/firebase_options.dart` dosyasında Firebase yapılandırma değerlerini güncelleyin:

```dart
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'YOUR_ANDROID_API_KEY',
  appId: 'YOUR_ANDROID_APP_ID',
  messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
  projectId: 'YOUR_PROJECT_ID',
  storageBucket: 'YOUR_PROJECT_ID.appspot.com',
);
```

### Bölüm Linkleri

`bolum_linkleri.txt` dosyasında bölüm URL'lerini güncelleyebilirsiniz. Değişiklikler `functions/src/departmentLinks.ts` dosyasına yansıtılmalıdır.

## 🚀 Çalıştırma

### Development

```bash
# Flutter uygulamasını çalıştır
flutter run

# Cloud Functions'ı local olarak test et
cd functions
npm run serve
```

### Production Deploy

```bash
# Cloud Functions'ları deploy et
firebase deploy --only functions

# Flutter uygulamasını build et
flutter build apk --release  # Android
flutter build ios --release  # iOS
```

## 📊 Veri Yapısı

### Firestore Koleksiyonları

#### duyurular
```javascript
{
  id: "string",
  baslik: "string",
  icerik: "string", 
  tarih: "timestamp",
  bolum_id: "string",
  bolum_adi: "string",
  url: "string",
  olusturma_zamani: "timestamp"
}
```

#### kullanicilar
```javascript
{
  fcm_token: "string",
  takip_edilen_bolumler: ["string"],
  bildirim_tercihi: "string", // "tumu" | "sadece_yeni"
  kayit_tarihi: "timestamp"
}
```

#### bolumler
```javascript
{
  ad: "string",
  url: "string", 
  aktif: "boolean"
}
```

## 🔔 Bildirim Sistemi

1. **Cloud Scheduler** her 15 dakikada bir tetiklenir
2. **Web Kazıma** tüm bölümleri tarar
3. **Yeni Duyuru Kontrolü** Firestore ile karşılaştırır
4. **FCM Bildirimi** ilgili kullanıcılara gönderir

## 🧪 Test

### Manuel Test

```bash
# Tek bölüm kazıma testi
curl -X POST https://europe-west1-YOUR_PROJECT_ID.cloudfunctions.net/manualScraper \
  -H "Content-Type: application/json" \
  -d '{"departmentId": "muhendislik-fakultesi"}'

# Tüm bölümleri kazıma testi
curl -X POST https://europe-west1-YOUR_PROJECT_ID.cloudfunctions.net/scrapeAllDepartments

# Test bildirimi gönderme
curl -X POST https://europe-west1-YOUR_PROJECT_ID.cloudfunctions.net/sendTestNotification \
  -H "Content-Type: application/json" \
  -d '{"fcmToken": "YOUR_FCM_TOKEN"}'
```

## 📱 Uygulama Mağazası

### Android
- Google Play Console'da yeni uygulama oluşturun
- APK/AAB dosyasını yükleyin
- Store listing materyallerini hazırlayın

### iOS  
- Apple Developer Console'da App Store Connect oluşturun
- IPA dosyasını yükleyin
- App Store listing materyallerini hazırlayın

## 🤝 Katkıda Bulunma

1. Fork edin
2. Feature branch oluşturun (`git checkout -b feature/amazing-feature`)
3. Commit edin (`git commit -m 'Add amazing feature'`)
4. Push edin (`git push origin feature/amazing-feature`)
5. Pull Request oluşturun

## 📄 Lisans

Bu proje MIT lisansı altında lisanslanmıştır. Detaylar için `LICENSE` dosyasına bakın.

## 👥 Geliştirici

**Fırat Üniversitesi Dijital Dönüşüm ve Yazılım Ofisi**

- Email: dijital@firat.edu.tr
- Website: https://dijital.firat.edu.tr

## 🆘 Destek

Herhangi bir sorun yaşarsanız:

1. [Issues](https://github.com/firat-university/duyuru-takip/issues) sayfasında arama yapın
2. Yeni issue oluşturun
3. Detaylı hata açıklaması ekleyin

## 📈 Gelecek Özellikler

- [ ] Widget desteği
- [ ] Dark mode
- [ ] Çoklu dil desteği
- [ ] Offline senkronizasyon
- [ ] Kullanıcı yorumları
- [ ] Duyuru kategorileri
- [ ] Favori duyurular

---

**Not**: Bu uygulama Fırat Üniversitesi öğrenci ve personeli için geliştirilmiştir. Üniversite dışı kullanım için lütfen izin alın.