#!/usr/bin/env python3
"""
Firestore'daki tüm duyuru koleksiyonlarını temizler ve her bölümün son 10 duyurusunu çeker.
"""

import firebase_admin
from firebase_admin import credentials, firestore
import requests
from bs4 import BeautifulSoup
import re
from datetime import datetime
import time
import sys

# Firebase yapılandırması
# Service account key dosyanızın yolunu buraya yazın
SERVICE_ACCOUNT_PATH = "android/app/bilsin-882ce-firebase-adminsdk-fbsvc-eaa7fc5441.json"

# Firebase'i başlat
try:
    # Service account key varsa kullan
    import os
    if os.path.exists(SERVICE_ACCOUNT_PATH):
        cred = credentials.Certificate(SERVICE_ACCOUNT_PATH)
        firebase_admin.initialize_app(cred)
        print("[OK] Service Account Key ile Firebase baslatildi")
    else:
        # Varsayılan credentials kullan (gcloud auth ile)
        firebase_admin.initialize_app()
        print("[OK] Varsayilan credentials ile Firebase baslatildi")
        print("[INFO] Service Account Key bulunamadi, gcloud auth kullaniliyor")
except Exception as e:
    print(f"[ERROR] Firebase baslatma hatasi: {e}")
    print("[TIP] Cozum: Firebase Service Account Key indirin veya 'gcloud auth login' yapin")
    sys.exit(1)

db = firestore.client()

# Bölümler ve URL'leri (bolum_linkleri.txt'den alındı)
DEPARTMENTS = {
    "muhendislik-fakultesi": "https://muhendislikf.firat.edu.tr/announcements-all",
    "bilgisayar-muhendisligi": "https://bilgisayarmf.firat.edu.tr/announcements-all",
    "biyomuhendislik": "https://bmmf.firat.edu.tr/announcements-all",
    "cevre-muhendisligi": "https://cevremf.firat.edu.tr/announcements-all",
    "elektrik-elektronik-muhendisligi-mf": "https://eemmf.firat.edu.tr/announcements-all",
    "insaat-muhendisligi-mf": "https://insaatmf.firat.edu.tr/announcements-all",
    "jeoloji-muhendisligi": "https://jeolojimf.firat.edu.tr/announcements-all",
    "kimya-muhendisligi": "https://kimyamf.firat.edu.tr/announcements-all",
    "makine-muhendisligi-mf": "https://makinamf.firat.edu.tr/announcements-all",
    "mekatronik-muhendisligi-mf": "https://mekatronikmf.firat.edu.tr/announcements-all",
    "metalurji-malzeme-muhendisligi-mf": "https://mmmf.firat.edu.tr/announcements-all",
    "yapay-zeka-veri-muhendisligi": "https://yzvm.firat.edu.tr/announcements-all",
    "yazilim-muhendisligi-mf": "https://yazmf.firat.edu.tr/announcements-all",
    "teknoloji-fakultesi": "https://teknolojif.firat.edu.tr/announcements-all",
    "adli-bilisim-muhendisligi": "https://abmtf.firat.edu.tr/tr/announcements-all",
    "elektrik-elektronik-muhendisligi-tf": "https://eemtf.firat.edu.tr/announcements-all",
    "enerji-sistemleri-muhendisligi": "https://entf.firat.edu.tr/announcements-all",
    "insaat-muhendisligi-tf": "https://insaattf.firat.edu.tr/tr/announcements-all",
    "makine-muhendisligi-tf": "https://makinatf.firat.edu.tr/announcements-all",
    "mekatronik-muhendisligi-tf": "https://mekatroniktf.firat.edu.tr/tr/announcements-all",
    "metalurji-malzeme-muhendisligi-tf": "https://mmtf.firat.edu.tr/tr/announcements-all",
    "otomotiv-muhendisligi": "https://otomotivmf.firat.edu.tr/tr/announcements-all",
    "yazilim-muhendisligi-tf": "https://yazilimtf.firat.edu.tr/tr/announcements-all",
    "yazilim-muhendisligi-uluslararasi": "https://yazilimmuholp.firat.edu.tr/announcements-all"
}

def parse_turkish_date(date_text):
    """Türkçe tarih formatını ISO string'e çevirir"""
    try:
        # Temizle ve parçala
        cleaned_text = ' '.join(date_text.strip().split())
        parts = cleaned_text.split()
        
        if len(parts) < 3:
            raise ValueError(f"Geçersiz tarih formatı: {date_text}")
        
        # Format: "Per Eki 9" -> gün_adı ay_adı gün_numarası
        day_name = parts[0]  # Per, Sal, Pts, Cum (gün adı)
        month_name = parts[1]  # Eki, Eyl, etc. (ay adı)
        day_number = parts[2]  # 9, 30, 6, 26 (gün numarası)
        
        # Yıl varsa al (4. parça olabilir)
        year = str(datetime.now().year)  # Varsayılan yıl
        if len(parts) > 3 and parts[3].isdigit() and len(parts[3]) == 4:
            year = parts[3]
        
        # Türkçe ay isimlerini İngilizce'ye çevir
        month_map = {
            "Oca": "Jan", "Şub": "Feb", "Mar": "Mar", "Nis": "Apr",
            "May": "May", "Haz": "Jun", "Tem": "Jul", "Ağu": "Aug",
            "Eyl": "Sep", "Eki": "Oct", "Kas": "Nov", "Ara": "Dec"
        }
        
        month = month_map.get(month_name)
        if not month:
            raise ValueError(f"Bilinmeyen ay: {month_name}")
        
        # ISO formatına çevir
        date_string = f"{day_number} {month} {year}"
        date_obj = datetime.strptime(date_string, "%d %b %Y")
        return date_obj.isoformat()
        
    except Exception as e:
        print(f"Tarih parse hatası '{date_text}': {e}")
        return datetime.now().isoformat()

def scrape_announcements(url, department_name, limit=10):
    """Belirtilen URL'den duyurulari ceker"""
    print(f"[FETCH] {department_name} duyurulari cekiliyor...")
    
    try:
        headers = {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
        }
        
        response = requests.get(url, headers=headers, timeout=30)
        response.raise_for_status()
        
        soup = BeautifulSoup(response.content, 'html.parser')
        announcements = []
        
        # Duyuru kartlarini bul
        announcement_cards = soup.select('.news-section-card a')
        
        for i, card in enumerate(announcement_cards[:limit]):
            try:
                # Baslik
                title_elem = card.select_one('.news-section-card-right-title p')
                title = title_elem.get_text(strip=True) if title_elem else ""
                
                # Icerik
                content_elem = card.select_one('.news-section-card-right-explanation p')
                content = content_elem.get_text(strip=True) if content_elem else ""
                
                # Tarih
                date_elem = card.select_one('.news-section-card-left-date p')
                date_text = date_elem.get_text(strip=True) if date_elem else ""
                date_iso = parse_turkish_date(date_text)
                
                # URL
                href = card.get('href', '')
                full_url = href if href.startswith('http') else f"https://muhendislikf.firat.edu.tr{href}"
                
                if title and content and date_iso and full_url:
                    announcement_id = f"{department_name}_{int(time.time())}_{i}"
                    
                    # Yayınlanma tarihini datetime objesi olarak al
                    publication_date = datetime.fromisoformat(date_iso.replace('Z', '+00:00'))
                    
                    announcement = {
                        'id': announcement_id,
                        'baslik': title,
                        'icerik': content,
                        'tarih': date_iso,  # ISO string formatında
                        'yayinlanma_tarihi': publication_date,  # DateTime objesi
                        'bolum_id': department_name,
                        'bolum_adi': get_department_display_name(department_name),
                        'url': full_url,
                        'olusturma_zamani': datetime.now()
                    }
                    
                    announcements.append(announcement)
                    print(f"  [OK] {title[:50]}...")
                else:
                    print(f"  [WARN] Eksik veri, atlaniyor: {title[:30]}...")
                    
            except Exception as e:
                print(f"  [ERROR] Duyuru parse hatasi: {e}")
                continue
        
        print(f"[STATS] {len(announcements)} duyuru basariyla cekildi")
        return announcements
        
    except Exception as e:
        print(f"[ERROR] {department_name} icin hata: {e}")
        return []

def get_department_display_name(department_id):
    """Bölüm ID'sinden görüntüleme adını alır"""
    names = {
        "adli-bilisim-muhendisligi": "Adli Bilişim Mühendisliği",
        "bilgisayar-muhendisligi": "Bilgisayar Mühendisliği",
        "biyomuhendislik": "Biyomühendislik",
        "cevre-muhendisligi": "Çevre Mühendisliği",
        "elektrik-elektronik-muhendisligi-mf": "Elektrik-Elektronik Mühendisliği (MF)",
        "elektrik-elektronik-muhendisligi-tf": "Elektrik-Elektronik Mühendisliği (TF)",
        "enerji-sistemleri-muhendisligi": "Enerji Sistemleri Mühendisliği",
        "insaat-muhendisligi-mf": "İnşaat Mühendisliği (MF)",
        "insaat-muhendisligi-tf": "İnşaat Mühendisliği (TF)",
        "jeoloji-muhendisligi": "Jeoloji Mühendisliği",
        "kimya-muhendisligi": "Kimya Mühendisliği",
        "makine-muhendisligi-mf": "Makine Mühendisliği (MF)",
        "makine-muhendisligi-tf": "Makine Mühendisliği (TF)",
        "mekatronik-muhendisligi-mf": "Mekatronik Mühendisliği (MF)",
        "mekatronik-muhendisligi-tf": "Mekatronik Mühendisliği (TF)",
        "metalurji-malzeme-muhendisligi-mf": "Metalurji ve Malzeme Mühendisliği (MF)",
        "metalurji-malzeme-muhendisligi-tf": "Metalurji ve Malzeme Mühendisliği (TF)",
        "muhendislik-fakultesi": "Mühendislik Fakültesi",
        "otomotiv-muhendisligi": "Otomotiv Mühendisliği",
        "teknoloji-fakultesi": "Teknoloji Fakültesi",
        "yapay-zeka-veri-muhendisligi": "Yapay Zeka ve Veri Mühendisliği",
        "yazilim-muhendisligi-mf": "Yazılım Mühendisliği (MF)",
        "yazilim-muhendisligi-tf": "Yazılım Mühendisliği (TF)",
        "yazilim-muhendisligi-uluslararasi": "Yazılım Mühendisliği (Uluslararası)"
    }
    return names.get(department_id, department_id)

def clear_collection(collection_name):
    """Belirtilen koleksiyonu temizler"""
    print(f"[CLEAR] {collection_name} koleksiyonu temizleniyor...")
    
    try:
        collection_ref = db.collection(collection_name)
        docs = collection_ref.stream()
        
        batch = db.batch()
        count = 0
        
        for doc in docs:
            batch.delete(doc.reference)
            count += 1
            
            # Firestore batch limit (500)
            if count >= 500:
                batch.commit()
                batch = db.batch()
                count = 0
        
        if count > 0:
            batch.commit()
            
        print(f"[OK] {collection_name} koleksiyonu temizlendi")
        
    except Exception as e:
        print(f"[ERROR] {collection_name} temizleme hatasi: {e}")

def save_announcements(collection_name, announcements):
    """Duyurulari Firestore'a kaydeder"""
    if not announcements:
        print(f"[WARN] {collection_name} icin kaydedilecek duyuru yok")
        return
    
    print(f"[SAVE] {len(announcements)} duyuru {collection_name} koleksiyonuna kaydediliyor...")
    
    try:
        collection_ref = db.collection(collection_name)
        batch = db.batch()
        count = 0
        
        for announcement in announcements:
            doc_ref = collection_ref.document(announcement['id'])
            batch.set(doc_ref, announcement)
            count += 1
            
            # Firestore batch limit (500)
            if count >= 500:
                batch.commit()
                batch = db.batch()
                count = 0
        
        if count > 0:
            batch.commit()
            
        print(f"[OK] {count} duyuru basariyla kaydedildi")
        
    except Exception as e:
        print(f"[ERROR] {collection_name} kaydetme hatasi: {e}")

def main():
    """Ana fonksiyon"""
    print("[START] Firestore duyuru guncelleme islemi baslatiliyor...")
    print(f"[INFO] {len(DEPARTMENTS)} bolum islenecek\n")
    
    total_announcements = 0
    successful_departments = 0
    
    for department_id, url in DEPARTMENTS.items():
        print(f"\n{'='*60}")
        print(f"[DEPT] {get_department_display_name(department_id)}")
        print(f"{'='*60}")
        
        try:
            # Koleksiyonu temizle
            collection_name = f"bolum_{department_id}_duyurular"
            clear_collection(collection_name)
            
            # Duyurulari cek
            announcements = scrape_announcements(url, department_id, limit=10)
            
            if announcements:
                # Duyurulari kaydet
                save_announcements(collection_name, announcements)
                total_announcements += len(announcements)
                successful_departments += 1
            else:
                print(f"[WARN] {department_id} icin duyuru bulunamadi")
            
            # Rate limiting - istekler arasi bekleme
            time.sleep(2)
            
        except Exception as e:
            print(f"[ERROR] {department_id} isleme hatasi: {e}")
            continue
    
    print(f"\n{'='*60}")
    print("[COMPLETE] Islem tamamlandi!")
    print(f"[STATS] Toplam {successful_departments}/{len(DEPARTMENTS)} bolum basarili")
    print(f"[STATS] Toplam {total_announcements} duyuru islendi")
    print(f"{'='*60}")

if __name__ == "__main__":
    main()
