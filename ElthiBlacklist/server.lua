ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('elthilista:dclog')
AddEventHandler('elthilista:dclog', function(text)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    dclog(xPlayer, text)
end)

function dclog(xPlayer, text)
    local playerName = Sanitize(xPlayer.getName())
    
    for k, v in ipairs(GetPlayerIdentifiers(xPlayer.source)) do
        if string.match(v, 'discord:') then
            identifierDiscord = v
        end
        if string.match(v, 'ip:') then
            identifierIp = v
        end
        if string.match(v, "steam:") then
            identifiersteam = v
        end
    end
	
	local discord_webhook = GetConvar('discord_webhook', Config.DiscordWebhook)
	if discord_webhook == '' then
	  return
	end
	local headers = {
	  ['Content-Type'] = 'application/json'
	}
	local data = {
	  ['username'] = Config.WebhookName,
	  ['avatar_url'] = Config.WebhookAvatarUrl,
	  ['embeds'] = {{
		['author'] = {
          ['name'] = 'Elthi - BLACKLIST',
          ['icon_url'] = 'https://cdn.discordapp.com/attachments/865336794005897237/1010152177236459540/unknown.png'
        },
        ['footer'] = {
            ['text'] = 'https://github.com/Elthini'
        },
		['color'] = 16714796,
		['timestamp'] = os.date('!%Y-%m-%dT%H:%M:%SZ')
	  }}
    }
    text = '**Description:** ' ..text..'\n**ID**: '..tonumber(xPlayer.source)..'\n **Nick:** '..xPlayer.getName()..'\n**License:** '..xPlayer.identifier
    if identifierDiscord ~= nil then
        text = text..'\n**Discord:** <@'..string.sub(identifierDiscord, 9)..'>'
        identifierDiscord = nil
    end
    if identifiersteam ~= nil then
        text = text..'\n**SteamID:** '..string.sub(identifiersteam, 6)
        identifiersteam = nil
    end
    if identifierIp ~= nil then
      text = text..'\n**IP Adress:** '..string.sub(identifierIp, 4)
      identifierIp = nil
  end
    data['embeds'][1]['description'] = text
	PerformHttpRequest(discord_webhook, function(err, text, headers) end, 'POST', json.encode(data), headers)
end


function Sanitize(str)
	local replacements = {
		['&' ] = '&amp;',
		['<' ] = '&lt;',
		['>' ] = '&gt;',
		['\n'] = '<br/>'
	}

	return str
		:gsub('[&<>\n]', replacements)
		:gsub(' +', function(s)
			return ' '..('&nbsp;'):rep(#s-1)
		end)
end


