local seasons = { "ilkbahar", "yaz", "sonbahar", "kış" }
local currentSeasonIndex = 1
local currentSeason = seasons[currentSeasonIndex]
local currentDay = 1
local weeklyForecast = {}

local seasonKey = "seasonalweather:currentSeason"
local dayKey = "seasonalweather:currentDay"

function getRandomWeatherFromSeason(seasonName)
    local season = Config.Seasons[seasonName]
    if not season then return "CLEAR" end

    local roll = math.random(1, 100)
    local total = 0

    for _, option in ipairs(season.weatherChances) do
        total = total + option.chance
        if roll <= total then
            return option.weather
        end
    end

    return "CLEAR"
end

function debugLog(title, msg)
    if Config and Config.Debug then
        print("[DEBUG] " .. title .. ": " .. msg)
        if Config.WebhookURL and Config.WebhookURL ~= "" then
            PerformHttpRequest(Config.WebhookURL, function() end, 'POST', json.encode({
                username = "Debug Log",
                embeds = {{
                    title = "[DEBUG] " .. title,
                    description = msg,
                    color = 16753920
                }}
            }), { ['Content-Type'] = 'application/json' })
        end
    end
end

function sendDiscordLog(title, description)
    if Config.WebhookURL and Config.WebhookURL ~= "" then
        PerformHttpRequest(Config.WebhookURL, function() end, 'POST', json.encode({
            username = "Mevsim Sistemi",
            embeds = {{
                title = title,
                description = description,
                color = 3447003
            }}
        }), { ['Content-Type'] = 'application/json' })
    end
end

function saveForecastToDB()
    for i, f in ipairs(weeklyForecast) do
        MySQL.update('REPLACE INTO seasonal_forecast (day_index, day_weather, night_weather, season) VALUES (?, ?, ?, ?)', {
            i, f.day, f.night, currentSeason
        })
    end
end

function loadForecastFromDB()
    local result = MySQL.query.await('SELECT * FROM seasonal_forecast WHERE season = ?', { currentSeason })
    weeklyForecast = {}
    for _, row in ipairs(result) do
        weeklyForecast[row.day_index] = {
            day = row.day_weather,
            night = row.night_weather
        }
    end
    debugLog("SQL Forecast", "Veriler SQL'den yüklendi.")
end

function generateWeeklyForecast()
    weeklyForecast = {}
    for i = 1, 7 do
        table.insert(weeklyForecast, {
            day = getRandomWeatherFromSeason(currentSeason),
            night = getRandomWeatherFromSeason(currentSeason)
        })
    end
    debugLog("Hava Tahmini", "Yeni haftalık hava tahmini oluşturuldu.")
    saveForecastToDB()
end

function nextSeason()
    currentSeasonIndex = (currentSeasonIndex % #seasons) + 1
    currentSeason = seasons[currentSeasonIndex]
    currentDay = 1
    generateWeeklyForecast()
    updateTimeCycle()
    sendDiscordLog("🌀 Yeni Mevsim Başladı!", "Yeni mevsim: **" .. currentSeason .. "**")
    debugLog("Mevsim Geçişi", "Geçilen mevsim: " .. currentSeason)
end

function updateTimeCycle()
    local season = Config.Seasons[currentSeason]
    local total = season.dayTime + season.nightTime
    local hourLength = (24 * 60 * 1000) / total
    TriggerClientEvent('seasonalweather:updateTimeCycle', -1, season.dayTime, season.nightTime, hourLength)
end

function loadSavedSeason()
    local savedSeason = GetResourceKvpString(seasonKey)
    local savedDay = tonumber(GetResourceKvpString(dayKey))

    if savedSeason and Config.Seasons[savedSeason] then
        currentSeason = savedSeason
        for i, s in ipairs(seasons) do
            if s == savedSeason then currentSeasonIndex = i break end
        end
    end

    if savedDay then
        currentDay = savedDay
    end

    loadForecastFromDB()
    print("🔁 Kayıt Yüklendi >> Mevsim: " .. currentSeason .. ", Gün: " .. currentDay)
end

function saveCurrentSeason()
    SetResourceKvp(seasonKey, currentSeason)
    SetResourceKvp(dayKey, tostring(currentDay))
end

CreateThread(function()
    loadSavedSeason()
    updateTimeCycle()

    while true do
        Wait(5 * 60 * 1000)
        currentDay = currentDay + 1

        debugLog("Oyun Günü", "Yeni gün: " .. currentDay)

        if currentDay > Config.SeasonDuration then
            nextSeason()
        end

        saveCurrentSeason()
    end
end)

CreateThread(function()
    while true do
        local hour = tonumber(os.date('%H'))
        local isDay = hour >= 6 and hour < 20
        local dayIndex = ((currentDay - 1) % 7) + 1
        local forecast = weeklyForecast[dayIndex]
        local weather = isDay and forecast.day or forecast.night

        if forecast then
            TriggerClientEvent('seasonalweather:updateWeather', -1, weather)
            sendDiscordLog('⛅ Güncellenen Hava', 'Bugünkü hava: **' .. weather .. '**')
            debugLog('Hava Güncellemesi', 'Uygulanan hava: ' .. weather)
        end

        Wait(15 * 60 * 1000)
    end
end)

RegisterCommand("mevsim_degistir", function(source, args)
    local newSeason = args[1]
    if not newSeason or not Config.Seasons[newSeason] then
        notifyPlayer(source, "Hatalı kullanım. Örnek: /mevsim_degistir yaz")
        return
    end

    currentSeason = newSeason
    for i, s in ipairs(seasons) do
        if s == newSeason then currentSeasonIndex = i break end
    end
    currentDay = 1
    generateWeeklyForecast()
    updateTimeCycle()
    saveCurrentSeason()

    sendDiscordLog("🌀 Elle Mevsim Değiştirildi", "Yeni mevsim: **" .. currentSeason .. "**")
    debugLog("Mevsim Değiştirildi", "Admin tarafından: " .. currentSeason)
end, true)

RegisterCommand("mevsim", function(src)
    local kalan = Config.SeasonDuration - currentDay
    notifyPlayer(src, "Mevsim: ^2" .. currentSeason .. "^7 | Kalan gün: ^3" .. kalan)
end)

RegisterCommand("takvim", function(src)
    notifyPlayer(src, "Oyun günü: ^3" .. currentDay .. " / " .. Config.SeasonDuration)
end)

RegisterCommand("hava_durumu", function(src)
    notifyPlayer(src, "^2Haftalık Hava Tahmini:")
    for i, day in ipairs(weeklyForecast) do
        notifyPlayer(src, ("Gün %d - Gündüz: %s | Gece: %s"):format(i, day.day, day.night))
    end
end)

RegisterCommand("hava_degistir", function(source, args)
    local newWeather = args[1]
    if not newWeather then
        notifyPlayer(source, "Geçerli bir hava durumu girin. Örn: /hava_degistir CLEAR")
        return
    end

    TriggerClientEvent('seasonalweather:updateWeather', -1, newWeather)
    sendDiscordLog("☁️ Elle Hava Değiştirildi", "Yeni hava: **" .. newWeather .. "**")
    debugLog("Manuel Hava", "Yeni hava uygulandı: " .. newWeather)
end, true)

RegisterCommand("rv", function(src, args)
    if args[1] == "help" then
        notifyPlayer(src, "🛠️ [RV Weather Yardım]")
        notifyPlayer(src, "/mevsim → Şu anki mevsimi ve kalan günü gösterir")
        notifyPlayer(src, "/takvim → Oyun içi gün sayısını gösterir")
        notifyPlayer(src, "/hava_durumu → Haftalık hava durumunu listeler")
        notifyPlayer(src, "/mevsim_degistir [mevsim] → Mevsimi manuel değiştirir")
        notifyPlayer(src, "/hava_degistir [hava] → Anlık hava durumunu değiştirir")
    end
end)
