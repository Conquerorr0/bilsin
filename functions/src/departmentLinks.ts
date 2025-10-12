export interface Department {
  id: string;
  name: string;
  url: string;
}

export const departments: Department[] = [
  {
    id: "muhendislik-fakultesi",
    name: "Mühendislik Fakültesi",
    url: "https://muhendislikf.firat.edu.tr/announcements-all",
  },
  {
    id: "bilgisayar-muhendisligi",
    name: "Bilgisayar Mühendisliği",
    url: "https://bilgisayarmf.firat.edu.tr/announcements-all",
  },
  {
    id: "biyomuhendislik",
    name: "Biyomühendislik",
    url: "https://bmmf.firat.edu.tr/announcements-all",
  },
  {
    id: "cevre-muhendisligi",
    name: "Çevre Mühendisliği",
    url: "https://cevremf.firat.edu.tr/announcements-all",
  },
  {
    id: "elektrik-elektronik-muhendisligi-mf",
    name: "Elektrik Elektronik Mühendisliği (Mühendislik Fakültesi)",
    url: "https://eemmf.firat.edu.tr/announcements-all",
  },
  {
    id: "insaat-muhendisligi-mf",
    name: "İnşaat Mühendisliği",
    url: "https://insaatmf.firat.edu.tr/announcements-all",
  },
  {
    id: "jeoloji-muhendisligi",
    name: "Jeoloji Mühendisliği",
    url: "https://jeolojimf.firat.edu.tr/announcements-all",
  },
  {
    id: "kimya-muhendisligi",
    name: "Kimya Mühendisliği",
    url: "https://kimyamf.firat.edu.tr/announcements-all",
  },
  {
    id: "makine-muhendisligi-mf",
    name: "Makine Mühendisliği",
    url: "https://makinamf.firat.edu.tr/announcements-all",
  },
  {
    id: "mekatronik-muhendisligi-mf",
    name: "Mekatronik Mühendisliği",
    url: "https://mekatronikmf.firat.edu.tr/announcements-all",
  },
  {
    id: "metalurji-malzeme-muhendisligi-mf",
    name: "Metalurji ve Malzeme Mühendisliği",
    url: "https://mmmf.firat.edu.tr/announcements-all",
  },
  {
    id: "yapay-zeka-veri-muhendisligi",
    name: "Yapay Zeka ve Veri Mühendisliği",
    url: "https://yzvm.firat.edu.tr/announcements-all",
  },
  {
    id: "yazilim-muhendisligi-mf",
    name: "Yazılım Mühendisliği",
    url: "https://yazmf.firat.edu.tr/announcements-all",
  },
  {
    id: "teknoloji-fakultesi",
    name: "Teknoloji Fakültesi",
    url: "https://teknolojif.firat.edu.tr/announcements-all",
  },
  {
    id: "adli-bilisim-muhendisligi",
    name: "Adli Bilişim Mühendisliği",
    url: "https://abmtf.firat.edu.tr/tr/announcements-all",
  },
  {
    id: "elektrik-elektronik-muhendisligi-tf",
    name: "Elektrik Elektronik Mühendisliği (Teknoloji Mühendislik)",
    url: "https://eemtf.firat.edu.tr/announcements-all",
  },
  {
    id: "enerji-sistemleri-muhendisligi",
    name: "Enerji Sistemleri Mühendisliği",
    url: "https://entf.firat.edu.tr/announcements-all",
  },
  {
    id: "insaat-muhendisligi-tf",
    name: "İnşaat Mühendisliği (Teknoloji Fakültesi)",
    url: "https://insaattf.firat.edu.tr/tr/announcements-all",
  },
  {
    id: "makine-muhendisligi-tf",
    name: "Makine Mühendisliği (Teknoloji Fakültesi)",
    url: "https://makinatf.firat.edu.tr/announcements-all",
  },
  {
    id: "mekatronik-muhendisligi-tf",
    name: "Mekatronik Mühendisliği (Teknoloji Fakültesi)",
    url: "https://mekatroniktf.firat.edu.tr/tr/announcements-all",
  },
  {
    id: "metalurji-malzeme-muhendisligi-tf",
    name: "Metalurji ve Malzeme Mühendisliği (Teknoloji Fakültesi)",
    url: "https://mmtf.firat.edu.tr/tr/announcements-all",
  },
  {
    id: "otomotiv-muhendisligi",
    name: "Otomotiv Mühendisliği Bölümü",
    url: "https://otomotivmf.firat.edu.tr/tr/announcements-all",
  },
  {
    id: "yazilim-muhendisligi-tf",
    name: "Yazılım Mühendisliği (Teknoloji Fakültesi)",
    url: "https://yazilimtf.firat.edu.tr/tr/announcements-all",
  },
  {
    id: "yazilim-muhendisligi-uluslararasi",
    name: "Yazılım Mühendisliği Uluslararası Ortak Lisans Programı",
    url: "https://yazilimmuholp.firat.edu.tr/announcements-all",
  },
];

/**
 * Get department by ID
 * @param {string} id Department ID
 * @return {Department | undefined} Department object or undefined
 */
export function getDepartmentById(id: string): Department | undefined {
  return departments.find((dept) => dept.id === id);
}

/**
 * Get department by URL
 * @param {string} url Department URL
 * @return {Department | undefined} Department object or undefined
 */
export function getDepartmentByUrl(url: string): Department | undefined {
  return departments.find((dept) => dept.url === url);
}