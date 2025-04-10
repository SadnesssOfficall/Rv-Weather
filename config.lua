Config = {}

Config.SeasonDuration = 28
Config.WebhookURL = 'https://discord.com/api/webhooks/1358456104996311281/a4SFB8N8z1rsWafae78wkaN3qRhXXT2AIrHa8hYI8ZhIKCtLoJ8RxAjiavr63km8xIrq'
Config.Debug = true

Config.Notify = {
    system = "chat",
    prefix = "^5[Mevsim]:^7 "
}

Config.Seasons = {
    ["ilkbahar"] = {
        dayTime = 12,
        nightTime = 12,
        weatherChances = {
            { weather = 'CLEAR', chance = 50 },
            { weather = 'CLOUDS', chance = 30 },
            { weather = 'RAIN', chance = 20 }
        }
    },
    ["yaz"] = {
        dayTime = 14,
        nightTime = 10,
        weatherChances = {
            { weather = 'CLEAR', chance = 70 },
            { weather = 'EXTRASUNNY', chance = 20 },
            { weather = 'CLOUDS', chance = 10 }
        }
    },
    ["sonbahar"] = {
        dayTime = 11,
        nightTime = 13,
        weatherChances = {
            { weather = 'CLOUDS', chance = 40 },
            { weather = 'RAIN', chance = 40 },
            { weather = 'THUNDER', chance = 20 }
        }
    },
    ["kış"] = {
        dayTime = 9,
        nightTime = 15,
        weatherChances = {
            { weather = 'SNOW', chance = 50 },
            { weather = 'BLIZZARD', chance = 30 },
            { weather = 'CLOUDS', chance = 20 }
        }
    }
}

Config.WeatherEffects = {
    RAIN = {
        message = "Yağmur yağıyor, dikkatli ol!",
        effect = function() end
    },
    SNOW = {
        message = "Kar yağıyor, üşümemek için sıcak bir yer bul!",
        effect = function() end
    },
    BLIZZARD = {
        message = "Tipi var, dışarı çıkmak tehlikeli!",
        effect = function() end
    }
}
