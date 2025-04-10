RegisterNetEvent("seasonalweather:updateWeather", function(weatherType)
    ClearOverrideWeather()
    ClearWeatherTypePersist()
    SetWeatherTypeOverTime(weatherType, 15.0)
    Wait(15000)
    SetWeatherTypeNowPersist(weatherType)
    SetWeatherTypeNow(weatherType)
    SetOverrideWeather(weatherType)

    local ped = PlayerPedId()

    if IsPedInAnyVehicle(ped, false) then
        return 
    end

    if not Config or not Config.WeatherEffects then return end

    for _, effect in pairs(Config.WeatherEffects) do
        for _, weather in ipairs(effect.weatherTypes) do
            if weather == weatherType then
                TriggerEvent("chat:addMessage", {
                    args = { "^1[RP Etkisi]: ^7" .. effect.message }
                })
                break
            end
        end
    end
end)

RegisterNetEvent("seasonalweather:updateTimeCycle", function(dayHours, nightHours, hourMs)
    if Config and Config.Debug then
        print(("[Zaman Güncellemesi] Gündüz: %d saat | Gece: %d saat | Oyun saati süresi: %dms")
            :format(dayHours, nightHours, hourMs))
    end
end)
