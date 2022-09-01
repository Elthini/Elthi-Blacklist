local screenshot = nil

CreateThread(function()
    local sleep = 1000
	while true do
        Wait(sleep)
        local playerPed = PlayerPedId()
        local nothing, weapon = GetCurrentPedWeapon(playerPed, true)
        local blacklisted, name = isWeaponBlacklisted(weapon)

		if blacklisted then
            if Config.logizbroni then
                TriggerServerEvent('elthilista:dclog', 'Wyciągnął zablokowaną broń : '..name)
            end
            if Config.blokadabroni then
                RemoveWeaponFromPed(playerPed, weapon)
                exports['screenshot-basic']:requestScreenshotUpload(Config.DiscordWebhook, 'file', function(data)
                    local resp = json.decode(data)
                end)
                sendForbiddenMessage("[ElthiAC] You shouldn't spawn weapon's!?")
            end
		end
	end
end)

function isWeaponBlacklisted(model)
	for _, blacklistedWeapon in pairs(Config.BlacklistedWeapons) do
		if model == GetHashKey(blacklistedWeapon) then
			return true, blacklistedWeapon
		end
	end
	return false, nil
end


function sendForbiddenMessage(message)
	TriggerEvent("chatMessage", "", {0, 0, 0}, "^1" .. message)
end
