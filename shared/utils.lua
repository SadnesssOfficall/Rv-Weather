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

function notifyPlayer(src, msg)
    local n = Config.Notify
    if n.system == "chat" then
        TriggerClientEvent("chat:addMessage", src, { args = { n.prefix .. msg } })
    elseif n.system == "mythic" then
        TriggerClientEvent("mythic_notify:SendAlert", src, { type = "inform", text = msg })
    elseif n.system == "okok" then
        TriggerClientEvent("okokNotify:Alert", src, "Mevsim Sistemi", msg, 5000, "info")
    end
end
