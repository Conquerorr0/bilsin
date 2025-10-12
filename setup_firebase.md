# Firebase Kurulum Talimatları

## 1. Firebase CLI Kurulumu

```bash
# Node.js kurulu olduğundan emin olun (18+)
node --version

# Firebase CLI'ı global olarak kurun
npm install -g firebase-tools

# Firebase CLI versiyonunu kontrol edin
firebase --version
```

## 2. Firebase'e Giriş

```bash
# Google hesabınızla giriş yapın
firebase login

# Giriş yapıp yapmadığınızı kontrol edin
firebase projects:list
```

## 3. Firebase Projesi Oluşturma

### Firebase Console'dan:
1. [Firebase Console](https://console.firebase.google.com/)'a gidin
2. "Add project" tıklayın
3. Proje adını girin: `firat-uni-duyuru-takip`
4. Google Analytics'i isteğe bağlı olarak etkinleştirin
5. "Create project" tıklayın

### Terminal'den:
```bash
# Proje klasöründe Firebase'i başlat
firebase init

# Aşağıdaki seçenekleri seçin:
# - Firestore: Configure security rules and indexes files
# - Functions: Configure a Cloud Functions directory and its files
# - Hosting: Configure files for Firebase Hosting (opsiyonel)

# Mevcut projeyi seçin veya yeni oluşturun
# TypeScript seçin
# ESLint'i etkinleştirin
# Bağımlılıkları otomatik yüklemeyi seçin
```

## 4. Firebase Servislerini Aktif Etme

### Firestore Database
1. Firebase Console > Firestore Database
2. "Create database" tıklayın
3. "Start in production mode" seçin
4. Konum: `europe-west1` (önerilen)

### Authentication
1. Firebase Console > Authentication
2. "Get started" tıklayın
3. Sign-in method > Anonymous > Enable

### Cloud Messaging
1. Firebase Console > Cloud Messaging
2. Otomatik olarak aktif olur

### Cloud Functions
1. Firebase Console > Functions
2. "Get started" tıklayın

## 5. Flutter Uygulaması için Yapılandırma

### Android
1. Firebase Console > Project Settings > General
2. "Add app" > Android
3. Package name: `com.example.bilsin`
4. `google-services.json` dosyasını indirin
5. `android/app/google-services.json` olarak yerleştirin

### iOS
1. Firebase Console > Project Settings > General  
2. "Add app" > iOS
3. Bundle ID: `com.example.bilsin`
4. `GoogleService-Info.plist` dosyasını indirin
5. `ios/Runner/GoogleService-Info.plist` olarak yerleştirin

## 6. Firebase Options Güncelleme

`lib/firebase_options.dart` dosyasını Firebase Console'dan alınan değerlerle güncelleyin:

```bash
# FlutterFire CLI kullanarak otomatik oluşturun
dart pub global activate flutterfire_cli
flutterfire configure
```

## 7. Cloud Functions Deploy

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

## 8. Cloud Scheduler Kurulumu

```bash
# Google Cloud SDK kurulumu (gerekirse)
# https://cloud.google.com/sdk/docs/install

# Project ID'yi ayarla
gcloud config set project YOUR_PROJECT_ID

# Cloud Scheduler API'yi aktif et
gcloud services enable cloudscheduler.googleapis.com

# Scheduler job oluştur
gcloud scheduler jobs create http scrapeDuyurular \
  --schedule="*/15 * * * *" \
  --uri="https://europe-west1-YOUR_PROJECT_ID.cloudfunctions.net/scheduledScraper" \
  --http-method=POST \
  --time-zone="Europe/Istanbul"
```

## 9. Test ve Doğrulama

### Cloud Functions Test
```bash
# Manuel kazıma testi
curl -X POST https://europe-west1-YOUR_PROJECT_ID.cloudfunctions.net/manualScraper \
  -H "Content-Type: application/json" \
  -d '{"departmentId": "muhendislik-fakultesi"}'
```

### Firestore Test
1. Firebase Console > Firestore Database
2. Verilerin geldiğini kontrol edin

### FCM Test
```bash
# Test bildirimi gönder
curl -X POST https://europe-west1-YOUR_PROJECT_ID.cloudfunctions.net/sendTestNotification \
  -H "Content-Type: application/json" \
  -d '{"fcmToken": "YOUR_FCM_TOKEN"}'
```

## 10. Güvenlik Kuralları

Firebase Console > Firestore Database > Rules sekmesinde aşağıdaki kuralları ekleyin:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /duyurular/{duyuruId} {
      allow read: if request.auth != null;
      allow write: if false;
    }
    match /kullanicilar/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    match /bolumler/{bolumId} {
      allow read: if request.auth != null;
      allow write: if false;
    }
  }
}
```

## 11. İndeksler

Firebase Console > Firestore Database > Indexes sekmesinde aşağıdaki bileşik indeksleri oluşturun:

1. **Collection**: duyurular
   - **Fields**: bolum_id (Ascending), tarih (Descending)

2. **Collection**: duyurular  
   - **Fields**: olusturma_zamani (Descending)

## 12. Billing Ayarları

1. Google Cloud Console > Billing
2. Firebase projesine billing hesabı bağlayın
3. Budget alerts ayarlayın (önerilen: $10/ay)

## Sorun Giderme

### Firebase CLI Hatası
```bash
# Firebase CLI'ı güncelleyin
npm update -g firebase-tools

# Cache'i temizleyin
firebase logout
firebase login
```

### Functions Deploy Hatası
```bash
# Node.js versiyonunu kontrol edin (18+ olmalı)
node --version

# Bağımlılıkları yeniden yükleyin
cd functions
rm -rf node_modules package-lock.json
npm install
npm run build
```

### Firestore Permission Hatası
- Security rules'ı kontrol edin
- Authentication'ın aktif olduğundan emin olun
- Anonymous sign-in'in etkin olduğunu kontrol edin

### FCM Token Hatası
- Firebase yapılandırma dosyalarının doğru yerleştirildiğini kontrol edin
- iOS için APNs sertifikalarını kontrol edin
- Android için google-services.json'ın güncel olduğunu kontrol edin
