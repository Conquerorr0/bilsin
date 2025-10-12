export interface Announcement {
  id: string;
  baslik: string;
  icerik: string;
  tarih: string;
  bolum_id: string;
  bolum_adi: string;
  url: string;
  olusturma_zamani: Date;
}

export interface ScrapedAnnouncement {
  baslik: string;
  icerik: string;
  tarih: string;
  url: string;
}

export interface User {
  fcm_token: string;
  takip_edilen_bolumler: string[];
  bildirim_tercihi: "tumu" | "sadece_yeni";
  kayit_tarihi: Date;
}