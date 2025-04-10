# 🌦️ RV-Weather Sistemi | FiveM Mevsimsel RP Hava Sistemi

![version](https://img.shields.io/badge/version-2.0.0-blue.svg)  
🎯 **Sadness tarafından geliştirildi – RP sunucularına dinamik mevsim ve hava etkisi getirir!**

---

## 📌 Öne Çıkan Özellikler

- ✅ 4 Mevsim Sistemi (İlkbahar, Yaz, Sonbahar, Kış)
- 🌦️ Haftalık rastgele hava takvimi
- 🌀 Otomatik mevsim geçişi
- 🛠️ Manuel mevsim & hava değiştirme komutları
- 💾 SQL desteği (restart sonrası forecast korunur)
- 🔔 Discord Webhook + Notify Sistemi (chat, mythic, okok)
- 🧊 RP Etkileri: Kar, yağmur, fırtına oyuncuya tepki verir
- 🧠 Debug & loglama desteği

---

## ⚙️ Kurulum

```bash
cd resources/[local]
git clone https://github.com/kendi-repon/rv-weather.git
```

- `server.cfg` içine ekle:
```cfg
ensure rv-weather
```

- SQL tablosunu ekle:
```sql
CREATE TABLE IF NOT EXISTS seasonal_forecast (
    day_index INT PRIMARY KEY,
    day_weather VARCHAR(50),
    night_weather VARCHAR(50),
    season VARCHAR(20)
);
```

---

## 🛠️ config.lua Örneği

```lua
Config = {}

Config.SeasonDuration = 28
Config.WebhookURL = 'https://discord.com/api/webhooks/XXX/XXX'
Config.Debug = true

Config.Notify = {
    system = "chat", -- "chat", "mythic", "okok"
    prefix = "^5[Mevsim]:^7 "
}

Config.Seasons = {
    ["yaz"] = {
        dayTime = 14,
        nightTime = 10,
        weatherChances = {
            { weather = "CLEAR", chance = 70 },
            { weather = "EXTRASUNNY", chance = 20 },
            { weather = "CLOUDS", chance = 10 }
        }
    },
    ["kış"] = {
        dayTime = 9,
        nightTime = 15,
        weatherChances = {
            { weather = "SNOW", chance = 50 },
            { weather = "BLIZZARD", chance = 30 },
            { weather = "CLOUDS", chance = 20 }
        }
    }
}
```

---

## 📖 Komut Listesi

| Komut                | Açıklama                                      |
|----------------------|-----------------------------------------------|
| `/mevsim`            | Şu anki mevsim ve kalan günü gösterir         |
| `/takvim`            | Kaçıncı oyun gününde olduğunu gösterir        |
| `/hava_durumu`       | Haftalık hava tahminini listeler              |
| `/mevsim_degistir [ad]` | Adminler için mevsim değiştirme            |
| `/hava_degistir [hava]` | Hava durumunu manuel değiştirir            |
| `/rv help`           | Tüm komutları listeler                        |

---

## 💬 Notify Desteği

> `Config.Notify.system` değeri ile hangi sistem kullanılacak seçilir:

- `chat`: Basit `chat:addMessage`
- `mythic`: [mythic_notify](https://github.com/thelindat/mythic_notify) desteği
- `okok`: [okokNotify](https://github.com/okokProjects/okokNotify) için destek

---

## 🧊 RP Etki Sistemi

Bazı hava tipleri oyuncuya etkiler gösterir:

| Hava Durumu | RP Mesajı                                      |
|-------------|------------------------------------------------|
| RAIN        | Yağmur yağıyor, dikkatli ol!                   |
| SNOW        | Kar yağıyor, üşümemek için sıcak bir yer bul!  |
| BLIZZARD    | Tipi var, dışarı çıkmak tehlikeli!             |

---

## ✨ Geliştirici

**Sadness**  
Discord: `Sadness#XXXX`  
GitHub: [github.com/SadnessDev](https://github.com/SadnessDev)

> Beğendiysen ⭐ bırak, katkı yapmak istersen PR gönder!
