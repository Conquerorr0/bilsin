import * as cheerio from "cheerio";
import axios from "axios";
import {ScrapedAnnouncement} from "./types";

/**
 * HTML'den duyuru verilerini çıkarır
 * @param {string} url URL to scrape
 * @return {Promise<ScrapedAnnouncement[]>} Array of scraped announcements
 */
export async function scrapeDepartmentAnnouncements(url: string):
  Promise<ScrapedAnnouncement[]> {
  try {
    console.log(`Scraping announcements from: ${url}`);

    // HTTP isteği gönder
    const response = await axios.get(url, {
      timeout: 30000, // 30 saniye timeout
      headers: {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) " +
          "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 " +
          "Safari/537.36",
      },
    });

    const $ = cheerio.load(response.data);
    const announcements: ScrapedAnnouncement[] = [];

    // Her duyuru linkini bul (her <a> tag'i ayrı bir duyuru)
    $(".news-section-card a").each((index, element) => {
      try {
        const $link = $(element);

        // Başlık
        const baslik = $link.find(".news-section-card-right-title p")
            .text().trim();

        // İçerik
        const icerik = $link.find(".news-section-card-right-explanation p")
            .text().trim();

        // Tarih
        const tarihText = $link.find(".news-section-card-left-date p")
            .text().trim();
        const tarih = parseTurkishDate(tarihText);

        // URL
        const href = $link.attr("href");
        const fullUrl = href ?
          (href.startsWith("http") ? href :
            `https://muhendislikf.firat.edu.tr${href}`) : "";

        // Geçerli veri kontrolü
        if (baslik && icerik && tarih && fullUrl) {
          announcements.push({
            baslik,
            icerik,
            tarih,
            url: fullUrl,
          });
        }
      } catch (error) {
        console.error(`Error parsing announcement link ${index}:`, error);
      }
    });

    console.log(`Found ${announcements.length} announcements from ${url}`);
    return announcements;
  } catch (error) {
    console.error(`Error scraping ${url}:`, error);
    throw error;
  }
}

/**
 * Türkçe tarih formatını ISO string'e çevirir
 * @param {string} dateText Date text to parse
 * @return {string} ISO date string
 */
function parseTurkishDate(dateText: string): string {
  try {
    const parts = dateText.trim().split(/\s+/);
    if (parts.length !== 3) {
      throw new Error(`Invalid date format: ${dateText}`);
    }

    const [, monthName, day] = parts;

    // Türkçe ay isimlerini İngilizce'ye çevir
    const monthMap: {[key: string]: string} = {
      "Oca": "Jan",
      "Şub": "Feb",
      "Mar": "Mar",
      "Nis": "Apr",
      "May": "May",
      "Haz": "Jun",
      "Tem": "Jul",
      "Ağu": "Aug",
      "Eyl": "Sep",
      "Eki": "Oct",
      "Kas": "Nov",
      "Ara": "Dec",
    };

    const month = monthMap[monthName];
    if (!month) {
      throw new Error(`Unknown month: ${monthName}`);
    }

    // Mevcut yılı kullan (2025 varsayılan)
    const currentYear = new Date().getFullYear();
    const dateString = `${day} ${month} ${currentYear}`;

    const date = new Date(dateString);
    if (isNaN(date.getTime())) {
      throw new Error(`Invalid date: ${dateString}`);
    }

    return date.toISOString();
  } catch (error) {
    console.error(`Error parsing date "${dateText}":`, error);
    // Hata durumunda mevcut tarihi döndür
    return new Date().toISOString();
  }
}

// scrapeAllAnnouncements fonksiyonu kaldırıldı - sadece ilk sayfa kullanılacak