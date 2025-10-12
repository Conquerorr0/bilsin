# Firestore Duyuru Güncelleme Scripti

Bu script, Firestore'daki tüm duyuru koleksiyonlarını temizler ve her bölümün son 10 duyurusunu çeker.

## Kurulum

1. Python paketlerini yükleyin:
```bash
pip install -r requirements.txt
```

2. Firebase Service Account Key dosyasını indirin:
   - Firebase Console > Project Settings > Service Accounts
   - "Generate new private key" butonuna tıklayın
   - İndirilen JSON dosyasını `service-account-key.json` olarak kaydedin

## Kullanım

Scripti çalıştırın:
```bash
python update_firestore_announcements.py
```

## Script Ne Yapar?

1. **Koleksiyonları Temizler**: Her `bolum_{department_id}_duyurular` koleksiyonunu tamamen temizler
2. **Duyuruları Çeker**: Her bölümün web sayfasından son 10 duyuruyu çeker
3. **Firestore'a Kaydeder**: Çekilen duyuruları ilgili koleksiyonlara kaydeder
4. **Rate Limiting**: İstekler arası 2 saniye bekler (sunucu yükünü azaltmak için)

## Çıktı

Script çalışırken şu bilgileri gösterir:
- Hangi bölümün işlendiği
- Kaç duyuru çekildiği
- Hata durumları
- Toplam istatistikler

## Desteklenen Bölümler

Script şu 24 bölümü destekler:
- Adli Bilişim Mühendisliği
- Bilgisayar Mühendisliği
- Biyomühendislik
- Çevre Mühendisliği
- Elektrik-Elektronik Mühendisliği (MF/TF)
- Enerji Sistemleri Mühendisliği
- İnşaat Mühendisliği (MF/TF)
- Jeoloji Mühendisliği
- Kimya Mühendisliği
- Makine Mühendisliği (MF/TF)
- Mekatronik Mühendisliği (MF/TF)
- Metalurji ve Malzeme Mühendisliği (MF/TF)
- Mühendislik Fakültesi
- Otomotiv Mühendisliği
- Teknoloji Fakültesi
- Yapay Zeka ve Veri Mühendisliği
- Yazılım Mühendisliği (MF/TF/Uluslararası)

## Hata Durumları

Script şu durumları ele alır:
- Ağ bağlantı hataları
- HTML parse hataları
- Tarih formatı hataları
- Firestore yazma hataları

Her hata durumunda script bir sonraki bölüme geçer ve işleme devam eder.

## Notlar

- Script çalışırken internet bağlantısı gereklidir
- Firebase projesi aktif olmalıdır
- Service account key dosyası doğru konumda olmalıdır
- İşlem tamamlanması 24 bölüm için yaklaşık 5-10 dakika sürer
