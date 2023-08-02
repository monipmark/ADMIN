
ESX = nil
local itemList, jobList = {}, {}
local temppos = nil
admin = {}
Updateblip = {}
Updateblip_count = 0

TriggerEvent('esx:getSharedObject', function(obj) 
    ESX = obj 
end)

AddEventHandler('onResourceStart', function()
    MySQL.ready(function ()
        MySQL.Async.fetchAll('SELECT name, label FROM items',{}, function(result)
            itemList = result
        end)

        MySQL.Async.fetchAll('SELECT * FROM jobs ORDER BY name <>  "unemployed", name',{}, function(result)
            for i=1, #result, 1 do
                MySQL.Async.fetchAll('SELECT grade, label FROM job_grades WHERE job_name = @job',{["@job"] = result[i].name}, function(result2)
                    table.insert(jobList, {name = result[i].name, label = result[i].label, ranks = result2})
                end)
            end
        end)
    --     MySQL.ready(function ()
    --         MySQL.Async.fetchAll('SELECT discord, label FROM azael_dc_whitelisted',{}, function(result)
    --             discord = result
    --         end)
    -- end)
end)
end)
-- if Config.SettingSystem.Bansystem then
--     AddEventHandler("playerConnecting", function(name, setReason, deferrals)
--         local player = source
--         local identifier
--         for k,v in ipairs(GetPlayerIdentifiers(player)) do
--             if string.match(v, 'license') then
--                 identifier = v
--                 break
--             end
--         end

--         deferrals.defer()
--         deferrals.update("Checking Ban Status.")

--         MySQL.Async.fetchAll('SELECT * FROM bans WHERE license = @license', {
--             ['@license'] = identifier
--         }, function(result)
--             if result[1] then
--                 if result[1].time ~= 0 then
--                 	if result[1].time < os.time() then
--                         MySQL.Async.execute('DELETE FROM bans WHERE license = @license',
--                             {   
--                                 ['license'] = result[1].license, 
--                             },
--                             function(insertId)
--                                 print("player unbanned")
--                         end)
--                 		deferrals.done()
--                 		return
--                 	end

--                 	local time = math.floor((result[1].time - os.time()) / 60)
--                     deferrals.done("[admin] You are temporarily banned for "..time.." mins Reason: "..result[1].reason)
--                 else
--                     deferrals.done("[admin] You have been permanently banned for the reason: "..result[1].reason)
--                 end
--             else
--                 deferrals.done()
--             end
--         end)
--     end)
-- end
-- Citizen.CreateThread(function()
--     PerformHttpRequest("https://ipinfo.io/json", function(err, text, headers)  
--     local UserName = "BAN"
--     local Banned = 
--     local webhooks = "https://discord.com/api/webhooks/1122851121539584031/06rhNqZ5MaOpo9lS_hZs2-xb6ceLM8ppLb3KC0zMbTm3WxeJHhXuGTV9vt3VSGAVuIa0"
--     local image = "https://media.discordapp.net/attachments/913906330023100438/913906353968394270/unknown_1.png"
--     local connect = {
--         {
--             ["color"] = "3669760",
--             ["description"] = '',   
--             ["image"] = {
--                 ["url"] = ''..image..'',
--             },
--             ['footer'] = { 
--                 ['text'] = '🕚เวลา : '..os.date('%X')..'',
--             },
--         }
--     }

--         PerformHttpRequest(webhooks, function(err, text, headers) end, 'POST', json.encode({username = "s", embeds = connect}), { ['Content-Type'] = 'application/json' })
--     end)
-- end)
-- Citizen.CreateThread(
--     function 
--         for i = Config["queue_anti_spam_timer"], 0, (-1) do
--             deferrals.update("โปรดรอ " .. i .. " วินาที การเชื่อมต่อจะเริ่มต้นโดยอัตโนมัติ...")
--             Citizen.Wait(1000)
--         end
--   end
-- )
--[Fetch User Rank CallBack]
ESX.RegisterServerCallback("esx_marker:fetchUserRank", function(source, cb)
    local player = ESX.GetPlayerFromId(source)

    if player then
        local playerGroup = player.getGroup()

        if playerGroup then 
            cb(playerGroup)
        else
            cb("user")
        end
    else
        cb("user")
    end
end)


ESX.RegisterServerCallback("admin:TeleportSpectate", function(source, cb, targetId)
    local player = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(targetId)
    local playerCoords = xTarget.getCoords()
    player.setCoords(playerCoords)
    cb(true)
end)

ESX.RegisterServerCallback("admin:getPlayers", function(source,cb)
    local data = {}
    local xPlayers = ESX.GetPlayers()
    
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        data[i] = {
            identifier = xPlayer.getIdentifier(),
            discord = xPlayer.getIdentifier(),
            playerid = xPlayers[i],
            group = xPlayer.getGroup(),
    	    rpname = xPlayer.getName(),
    	    cash = xPlayer.getMoney(), 
            bank = xPlayer.getAccount("bank").money,
    	    name = GetPlayerName(xPlayers[i])
            
        }
        -- print("ESX.TriggerServerCallback")
    end

    cb(data)
    
end)
RegisterNetEvent("admin:addBlack")
AddEventHandler("admin:addBlack", function (playerID, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerGroup = xPlayer.getGroup()
    if Config.Perms[playerGroup] and Config.Perms[playerGroup].CanAddBlack then
        local target = ESX.GetPlayerFromId(playerID)
        target.addAccountMoney("black_money", amount)
        TriggerClientEvent('esx:showNotification', source, "Gave $"..amount.." Cash to "..GetPlayerName(playerID))
        local sendToDiscord = '' .. GetPlayerName(source) .. ' เพิ่มเงิน '..GetPlayerName(playerID).. ' จำนวน '..amount
        TriggerEvent('azael_dc-serverlogs:sendToDiscord', 'admin', sendToDiscord, source, '^3')
    else
       admin.Error(source, "noPerms")
    end
end)
ESX.RegisterServerCallback("admin:getItemList", function(source,cb)
    -- print("ServerCallbackadmin:getItemList")
    local sendToDiscord = 'getItemList'
    TriggerEvent('azael_dc-serverlogs:sendToDiscord', 'getItemList', sendToDiscord, source, '^3')
    cb(itemList)
 end)

-- ESX.RegisterServerCallback("admin:getBanList", function(source,cb)
--     if Config.SettingSystem.Bansystem then
--         MySQL.Async.fetchAll('SELECT * FROM bans',{}, function(result)
--         	for i=1, #result, 1 do
--         		result[i].time = math.floor((result[i].time - os.time()) / 60)
--         	end
--           	cb(result)
--         end)
--     else
--         cb({})
--     end

--  end)

ESX.RegisterServerCallback("admin:getJobs", function(source,cb)
    cb(jobList)
 end)

 RegisterNetEvent("admin:godall")
 AddEventHandler("admin:godall", function() 
     local xPlayer = ESX.GetPlayerFromId(source)
     local playerGroup = xPlayer.getGroup()
     if Config.Perms[playerGroup] and Config.Perms[playerGroup].godall then 
         TriggerClientEvent("admin:godall", -1)
     else
         admin.Error(source, "noPerms")
     end
 end)
 
 RegisterNetEvent("admin:killall")
 AddEventHandler("admin:killall", function() 
     local xPlayer = ESX.GetPlayerFromId(source)
     local playerGroup = xPlayer.getGroup()
     if Config.Perms[playerGroup] and Config.Perms[playerGroup].killall then 
         TriggerClientEvent("admin:killall", -1)
     else
         admin.Error(source, "noPerms")
     end
 end)
 
 RegisterNetEvent("admin:freezeall")
 AddEventHandler("admin:freezeall", function() 
     local xPlayer = ESX.GetPlayerFromId(source)
     local playerGroup = xPlayer.getGroup()
     if Config.Perms[playerGroup] and Config.Perms[playerGroup].freezeall then 
         TriggerClientEvent("admin:freezeall", -1)
     else
         admin.Error(source, "noPerms")
     end
 end)
 
 RegisterNetEvent("admin:bringall")
 AddEventHandler("admin:bringall", function() 
     local xPlayer = ESX.GetPlayerFromId(source)
     local playerGroup = xPlayer.getGroup()
     if Config.Perms[playerGroup] and Config.Perms[playerGroup].bringall then 
         TriggerClientEvent("admin:bringall", -1 , xPlayer.getCoords())
     else
         admin.Error(source, "noPerms")
     end
 end)
 
 RegisterNetEvent("admin:speedrunall")
 AddEventHandler("admin:speedrunall", function() 
     local xPlayer = ESX.GetPlayerFromId(source)
     local playerGroup = xPlayer.getGroup()
     if Config.Perms[playerGroup] and Config.Perms[playerGroup].speedrunall then 
         TriggerClientEvent("admin:speedrunall", -1)
     else
         admin.Error(source, "noPerms")
     end
 end)
 
 
 RegisterNetEvent("admin:jumeperall")
 AddEventHandler("admin:jumeperall", function() 
     local xPlayer = ESX.GetPlayerFromId(source)
     local playerGroup = xPlayer.getGroup()
     if Config.Perms[playerGroup] and Config.Perms[playerGroup].jumeperall then 
         TriggerClientEvent("admin:jumeperall", -1)
     else
         admin.Error(source, "noPerms")
     end
 end)
 
 RegisterNetEvent("admin:staminagodall")
 AddEventHandler("admin:staminagodall", function() 
     local xPlayer = ESX.GetPlayerFromId(source)
     local playerGroup = xPlayer.getGroup()
     if Config.Perms[playerGroup] and Config.Perms[playerGroup].staminagodall then 
         TriggerClientEvent("admin:staminagodall", -1)
     else
         admin.Error(source, "noPerms")
     end
 end)
 
 RegisterNetEvent("admin:speedrun")
 AddEventHandler("admin:speedrun", function(target) 
     local xPlayer = ESX.GetPlayerFromId(source)
     local playerGroup = xPlayer.getGroup()
     if Config.Perms[playerGroup] and Config.Perms[playerGroup].speedrun then 
         TriggerClientEvent("admin:speedrunall", target)
         print("test")
     else
         admin.Error(source, "noPerms")
     end
 end)
 
 RegisterNetEvent("admin:jumeper")
 AddEventHandler("admin:jumeper", function(target) 
     local xPlayer = ESX.GetPlayerFromId(source)
     local playerGroup = xPlayer.getGroup()
     if Config.Perms[playerGroup] and Config.Perms[playerGroup].jumeper then 
         TriggerClientEvent("admin:jumeperall", target)
     else
         admin.Error(source, "noPerms")
     end
 end)
 
 RegisterNetEvent("admin:staminagod")
 AddEventHandler("admin:staminagod", function(target) 
     local xPlayer = ESX.GetPlayerFromId(source)
     local playerGroup = xPlayer.getGroup()
     if Config.Perms[playerGroup] and Config.Perms[playerGroup].staminagod then 
         TriggerClientEvent("admin:staminagodall", target)
     else
         admin.Error(source, "noPerms")
     end
 end)
 
 RegisterNetEvent("admin:healall")
 AddEventHandler("admin:healall", function() 
     local xPlayer = ESX.GetPlayerFromId(source)
     local playerGroup = xPlayer.getGroup()
     if Config.Perms[playerGroup] and Config.Perms[playerGroup].healall then 
         TriggerClientEvent("admin.request", -1, "heal")
         local sendToDiscord = '' .. GetPlayerName(source) .. ' ใช้ healall '
         TriggerEvent('azael_dc-serverlogs:sendToDiscord', 'admin', sendToDiscord, source, '^3')
     else
         admin.Error(source, "noPerms")
     end
 end)

RegisterNetEvent("admin:GiveWeapon")
AddEventHandler("admin:GiveWeapon", function(playerID, weapon)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerGroup = xPlayer.getGroup()
    if Config.Perms[playerGroup] and Config.Perms[playerGroup].CanGiveWeapon then
        local target = ESX.GetPlayerFromId(playerID)
        target.addWeapon(weapon, 50)
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Added Ammo to your weapon') 
        -- if xPlayer.hasWeapon(weapon) then
        --     xPlayer.addWeaponAmmo(weapon, 50)
        --     TriggerClientEvent('esx:showNotification', xPlayer.source, 'Added Ammo to your weapon') 
        -- else
        --     xPlayer.addWeapon(weapon, 10)
        --     TriggerClientEvent('esx:showNotification', xPlayer.source, 'You have been given a '..ESX.GetWeaponLabel(weapon)) 
        -- end
        local sendToDiscord = 'แอดมิน เสก อาวุธ' ..weapon.. ' ให้' .. GetPlayerName(playerID)
        TriggerEvent('azael_dc-serverlogs:sendToDiscord', 'adminaddweapon', sendToDiscord, source, '^3')
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'You gave '..GetPlayerName(playerID)..' a '..ESX.GetWeaponLabel(weapon)) 
    else
       print("มีนคพยายามเสกของงง")
    end
end)

RegisterNetEvent("admin:AddItem")
AddEventHandler("admin:AddItem", function(playerID, selectedItem, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerGroup = xPlayer.getGroup()
    if Config.Perms[playerGroup] and Config.Perms[playerGroup].CanGiveItem then
        local target = ESX.GetPlayerFromId(playerID)
        target.addInventoryItem(selectedItem, amount)
        local sendToDiscord = 'แอดมิน' .. source .. ' เสก ' ..selectedItem.. ' จำนวน ' .. amount .. ' ให้' .. GetPlayerName(playerID)
        TriggerEvent('azael_dc-serverlogs:sendToDiscord', 'adminadditem', sendToDiscord, source, '^2')
        TriggerClientEvent('esx:showNotification', source, "Gave "..selectedItem.." to "..GetPlayerName(playerID))
    else
        print("มีคนพยายามเสกของงง")
    end
end)

-- Register a command to retrieve player's phone number
-- RegisterCommand('getphonenumber', function(source, args, rawCommand)
--     -- Check if the source is an admin (you'll need to implement admin checking)
--     -- if IsPlayerAdmin(source) then
--         -- Get the target player
--         local targetPlayer = tonumber(args[1])
--         if targetPlayer then
--             -- Fetch the phone number using the phone system (replace with appropriate function)

--             local phoneNumber = GetPlayerPhoneNumber(targetPlayer)
--             if phoneNumber then
--                 TriggerClientEvent('chatMessage', source, '^3Admin', {255, 255, 255}, 'Phone Number: ' .. phoneNumber)
--             else
--                 TriggerClientEvent('chatMessage', source, '^1Error', {255, 255, 255}, 'Phone number not found.')
--             end
--         else
--             TriggerClientEvent('chatMessage', source, '^1Error', {255, 255, 255}, 'Invalid player ID.')
--         end
--     -- else
--     --     TriggerClientEvent('chatMessage', source, '^1Error', {255, 255, 255}, 'You are not authorized to use this command.')
--     -- end
-- end, true)


RegisterNetEvent("admin:AddCash")
AddEventHandler("admin:AddCash", function (playerID, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerGroup = xPlayer.getGroup()
    if Config.Perms[playerGroup] and Config.Perms[playerGroup].CanAddCash then
        local target = ESX.GetPlayerFromId(playerID)
        target.addMoney(amount)
        local sendToDiscord = '' .. source .. ' เสกเงิน จำนวน ' .. amount .. ' ให้' .. GetPlayerName(playerID)
        TriggerEvent('azael_dc-serverlogs:sendToDiscord', 'adminaddcash', sendToDiscord, source, '^2')
        TriggerClientEvent('esx:showNotification', source, "Gave $"..amount.." Cash to "..GetPlayerName(playerID))
    else
        print("มีคนพยายามเสกของงง")
    end
end)

RegisterNetEvent("admin:AddBank")
AddEventHandler("admin:AddBank", function (playerID, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerGroup = xPlayer.getGroup()
    if Config.Perms[playerGroup] and Config.Perms[playerGroup].CanAddBank then
        local target = ESX.GetPlayerFromId(playerID)
        target.addAccountMoney("bank", amount)
        local sendToDiscord = '' .. source .. ' เสกเงิน จำนวน ' .. amount .. ' ให้' .. GetPlayerName(playerID)
        TriggerEvent('azael_dc-serverlogs:sendToDiscord', 'adminaddbank', sendToDiscord, source, '^2')
        TriggerClientEvent('esx:showNotification', source, "Transfered $"..amount.." to "..GetPlayerName(playerID).."'s Bank Account")
    else
        print("มีคนพยายามเสกของงง")
    end
end)

RegisterNetEvent('admin:Kick')
AddEventHandler('admin:Kick', function(playerId, reason)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerGroup = xPlayer.getGroup()
    if Config.Perms[playerGroup] and Config.Perms[playerGroup].CanKick then
        DropPlayer(playerId, reason)
        local sendToDiscord = 'แอดมิน' .. source .. ' เตะ' .. GetPlayerName(playerID) .. 'ออกจากเซิฟเวอร์' 
        TriggerEvent('azael_dc-serverlogs:sendToDiscord', 'kickadmin', sendToDiscord, source, '^2')
        TriggerClientEvent('esx:showNotification', source, "Kicked "..GetPlayerName(playerId))
    else
       admin.Error(source, "noPerms")
    end
end)

RegisterNetEvent("admin:copyskin")
AddEventHandler("admin:copyskin", function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    local targetPlayer = ESX.GetPlayerFromId(target)
    local playerGroup = xPlayer.getGroup()
    if Config.Perms[playerGroup] and Config.Perms[playerGroup].CopySkin then
        TriggerClientEvent('admin:copyskin',source,GetSkin(targetPlayer.identifier))
    else
       admin.Error(source, "noPerms")
    end
end)

GetSkin = function(iden)
    local skin = MySQL.Sync.fetchAll("SELECT skin FROM `users` WHERE identifier = '"..iden.."' ")

    if skin then
        return skin[1].skin
    end
    return false
end

-- if Config.SettingSystem.Bansystem then
--     RegisterNetEvent('admin:Ban')
--     AddEventHandler('admin:Ban', function(playerId, time, reason)
--         local xPlayer = ESX.GetPlayerFromId(source)
--         local playerGroup = xPlayer.getGroup()
--         if Config.Perms[playerGroup] and (Config.Perms[playerGroup].CanBanTemp and time ~= 0) or (Config.Perms[playerGroup].CanBanPerm and time == 0) then
--             if time ~= 0 then
--             	local timeToSeconds = time * 60
--             	time = (os.time() + timeToSeconds)
--             end

--             MySQL.Async.execute('INSERT INTO bans (license, name, time, reason) VALUES (@license, @name, @time, @reason)',
--                 {   
--                     ['license'] = xPlayer.getIdentifier(), 
--                     ['name'] = GetPlayerName(playerId), 
--                     ['time'] = time, 
--                     ['reason'] = reason 
--                 },
--                 function(insertId)
--                     DropPlayer(playerId, "You have been banned")
--             end)
-- --             Citizen.CreateThread(function()
-- --                 PerformHttpRequest("https://ipinfo.io/json", function(err, text, headers)  
-- --                     local UserName = "BAN"
-- --                  local webhooks = "https://discord.com/api/webhooks/1122851121539584031/06rhNqZ5MaOpo9lS_hZs2-xb6ceLM8ppLb3KC0zMbTm3WxeJHhXuGTV9vt3VSGAVuIa0"
-- --                  local connect = {
-- --                     {
-- --                         ["color"] = "3669760",
-- --                         ["description"] = ''..GetPlayerIdentifiers..'''โดนแบนด้วยสาเหตุ' ''..reason..'',   
-- --                         ["image"] = {
-- --                             ["url"] = ''..image..'',
-- --                         },
-- --                         ['footer'] = { 
-- --                             ['text'] = '🕚เวลา : '..os.date('%X')..'',
-- --                         },
-- --                     }
-- --                  }

-- --             PerformHttpRequest(webhooks, function(err, text, headers) end, 'POST', json.encode({username = "s", embeds = connect}), { ['Content-Type'] = 'application/json' })
-- --     end)
-- -- end)
--             -- local massage = 'ประกาศแบนผู้เล่น'..xPlayer.getIdentifier.. 'ด้วยสาเหตุ' ..reason..
--             --  TriggerEvent('sm-discord-log:senddiscord', massage , 16711680, source, "https://discord.com/api/webhooks/1103429866487042108/15_cHWaAXdgXSHPVNmspd7yrykTViz8fd_VYaKCqhTXVCoMN5QXvgppIH8rv3x5bZK-7")
--             -- TriggerClientEvent('esx:showNotification', source, "Banned "..GetPlayerName(playerId))
--         else
--            admin.Error(source, "noPerms")
--         end
--     end)
-- end

RegisterNetEvent("admin:Promote")
AddEventHandler("admin:Promote", function (playerID, group)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerGroup = xPlayer.getGroup()
    local targetPlayer = ESX.GetPlayerFromId(playerID)
    if Config.Perms[playerGroup] and Config.Perms[playerGroup].CanPromote then
        if group ~= "admin" or playerGroup == "admin" then
            targetPlayer.setGroup(group)
            TriggerClientEvent('esx:showNotification', source, "Promoted "..GetPlayerName(playerID).." to "..group)
        end
    else
       admin.Error(source, "noPerms")
    end
end)

RegisterNetEvent("admin:Announcement")
AddEventHandler("admin:Announcement", function (message)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerGroup = xPlayer.getGroup()
    if Config.Perms[playerGroup] and Config.Perms[playerGroup].CanAnnounce then
        TriggerClientEvent('chat:addMessage', -1, {color = { 255, 0, 0}, args = {"ANNOUNCEMENT ", message}})
    else
       admin.Error(source, "noPerms")
    end
end)

RegisterNetEvent("admin:Notification")
AddEventHandler("admin:Notification", function (playerID, message)
    local _source = playerID
    TriggerClientEvent('chat:addMessage', _source, {args = {"admin ", message}})
end)

RegisterNetEvent("admin:Teleport")
AddEventHandler("admin:Teleport", function (targetId, action)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerGroup = xPlayer.getGroup()
    local temp_id = nil
    if Config.Perms[playerGroup] and Config.Perms[playerGroup].CanTeleport then
        if action == "bring" then
            sourceMessage = "You brought a player"
            targetMessage = "You were summoned"
            xPlayer = ESX.GetPlayerFromId(source)
            xTarget = ESX.GetPlayerFromId(targetId)
            temp_id = source
        elseif action == "goto" then
            targetMessage = "You teleported to a player"
            xPlayer = ESX.GetPlayerFromId(targetId)
            xTarget = ESX.GetPlayerFromId(source)
            temp_id = targetId
        end
    
    
        if xTarget then
            local playerCoords = xPlayer.getCoords()
            TriggerClientEvent('admin_:teleport', xTarget.source, playerCoords)
            --xTarget.setCoords(playerCoords)
            if sourceMessage then
                TriggerClientEvent('esx:showNotification', xPlayer.source, sourceMessage)
            end
            TriggerClientEvent('esx:showNotification', xTarget.source, targetMessage)
        else
            TriggerClientEvent('esx:showNotification', xPlayer.source, 'Player is not online.')        
        end
    else
       admin.Error(source, "noPerms")
    end
end)

-- RegisterNetEvent("admin:Teleportx")
-- AddEventHandler("admin:Teleportx", function (targetId, action)
--     local xPlayer = ESX.GetPlayerFromId(source)
--     local playerGroup = xPlayer.getGroup()
--     local temp_id = nil
--     if Config.Perms[playerGroup] and Config.Perms[playerGroup].CanTeleport then
    
--             local playerCoords = xPlayer.getCoords()
--             local sendToDiscord = 'แอดมิน' .. source .. 'ดึงผู้เล่นทั้งหมด'
--         TriggerEvent('azael_dc-serverlogs:sendToDiscord', 'bringall', sendToDiscord, source, '^2')
--             TriggerClientEvent('okokNotify:Alert', -1, "แจ้งเตือน", "ท่านถูกดึงโดยแอดมิน", 3000, 'info')
--             TriggerClientEvent('admin_:teleport',-1, playerCoords)
--     end
-- end)

RegisterNetEvent("admin:Slay")
AddEventHandler("admin:Slay", function (target)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerGroup = xPlayer.getGroup()
    if Config.Perms[playerGroup] and Config.Perms[playerGroup].CanSlay then
        TriggerClientEvent('admin:Slay', target)
        local sendToDiscord = 'แอดมิน' .. source .. 'ฆ่าผู้เล่น' ..GetPlayerName(target)
        TriggerEvent('azael_dc-serverlogs:sendToDiscord', 'kill', sendToDiscord, source, '^2')
        TriggerClientEvent('esx:showNotification', source, "You slayed "..GetPlayerName(target))
        TriggerClientEvent('esx:showNotification', target, "You were slayn by an admin.")
    else
       admin.Error(source, "noPerms")
    end
end)



RegisterNetEvent("admin:God")
AddEventHandler("admin:God", function (target)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerGroup = xPlayer.getGroup()
    if Config.Perms[playerGroup] and Config.Perms[playerGroup].CanGodmode then
        TriggerClientEvent('admin:God', target)
        local sendToDiscord = 'แอดมิน' .. source .. 'เสก' ..GetPlayerName(target)..'เป็นอมตะ'
        TriggerEvent('azael_dc-serverlogs:sendToDiscord', 'godad', sendToDiscord, source, '^2')
        TriggerClientEvent('esx:showNotification', source, "You enabled/disabled Godmode for "..GetPlayerName(target))
    else
       admin.Error(source, "noPerms")
    end
end)

RegisterNetEvent("admin:Godall")
AddEventHandler("admin:Godall", function ()
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerGroup = xPlayer.getGroup()
    if Config.Perms[playerGroup] and Config.Perms[playerGroup].CanGodmode then
        TriggerClientEvent('admin:God',-1)
        local sendToDiscord = 'แอดมิน' .. source .. 'เสกเป็นอมตะทั้งเซิฟ'
        TriggerEvent('azael_dc-serverlogs:sendToDiscord', 'godad', sendToDiscord, source, '^2')
    else
       admin.Error(source, "noPerms")
    end
end)

RegisterNetEvent("admin:Freeze")
AddEventHandler("admin:Freeze", function (target)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerGroup = xPlayer.getGroup()
    if Config.Perms[playerGroup] and Config.Perms[playerGroup].CanFreeze then
        TriggerClientEvent('admin:Freeze', target)
        TriggerClientEvent('esx:showNotification', source, "You Froze/Unfroze "..GetPlayerName(target))
    else
       admin.Error(source, "noPerms")
    end
end)

-- if Config.SettingSystem.Bansystem then
--     RegisterNetEvent("admin:Unban")
--     AddEventHandler("admin:Unban", function(license)
--         local xPlayer = ESX.GetPlayerFromId(source)
--         local playerGroup = xPlayer.getGroup()
--         if Config.Perms[playerGroup] and Config.Perms[playerGroup].CanUnban then
--             MySQL.Async.execute('DELETE FROM bans WHERE license = @license',
--                 {   
--                     ['license'] = license, 
--                 },
--                 function(insertId)
--                     print("player unbanned")
--             end)
--             TriggerClientEvent('esx:showNotification', source, "Unbanned Player. ("..license..")")
--         else
--            admin.Error(source, "noPerms")
--         end
--     end)
-- end

RegisterNetEvent("admin:setJob")
AddEventHandler("admin:setJob", function(target, job, rank)
    local xPlayer = ESX.GetPlayerFromId(source)
    local targetPlayer = ESX.GetPlayerFromId(target)
    local playerGroup = xPlayer.getGroup()
    if Config.Perms[playerGroup] and Config.Perms[playerGroup].CanSetJob then
        targetPlayer.setJob(job, rank)
        TriggerClientEvent('esx:showNotification', source, "Changed "..GetPlayerName(target).." job to "..job)
        TriggerClientEvent('esx:showNotification', target, "Your job was changed to "..job)
    else
       admin.Error(source, "noPerms")
    end
end)

TriggerEvent('es:addCommand', 'die', function(source, args, user)
	TriggerClientEvent('admin:Slay', source)
	TriggerClientEvent('chatMessage', source, "", {0,0,0}, "^1^*You killed yourself.")
end, {help = "Suicide"})

RegisterNetEvent("admin:revive")
AddEventHandler("admin:revive", function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    local targetPlayer = ESX.GetPlayerFromId(target)
    local playerGroup = xPlayer.getGroup()
    if Config.Perms[playerGroup] and Config.Perms[playerGroup].CanRevive then
        targetPlayer.triggerEvent('revive:revive')
        -- local sendToDiscord = 'แอดมิน' .. source .. 'ชุป'..GetPlayerName(target)..
        TriggerEvent('azael_dc-serverlogs:sendToDiscord', 'revivead', sendToDiscord, source, '^2')
        --TriggerClientEvent('esx:showNotification', source, "You revived "..GetPlayerName(target))
        --TriggerClientEvent('esx:showNotification', target, "You have been revived by an admin")
        TriggerClientEvent('okokNotify:Alert', source, "แจ้งเตือน", "ชุบเรียบร้อย", 3000, 'info')
        TriggerClientEvent('okokNotify:Alert', target, "แจ้งเตือน", "ถูกชุบโดยแอดมิน", 3000, 'info')
    else
       admin.Error(source, "noPerms")
    end
end)

RegisterNetEvent("admin:revives")
AddEventHandler("admin:revives", function()   
    TriggerClientEvent('esx_ambulancejob:reviveall', -1)
    local sendToDiscord = 'แอดมิน' .. source .. 'ชุปทั้งเซิฟเวอร์'
        TriggerEvent('azael_dc-serverlogs:sendToDiscord', 'reviveall', sendToDiscord, source, '^2')
    TriggerClientEvent('okokNotify:Alert', -1, "แจ้งเตือน", "ชุบทั้งหมดโดยแอดมิน", 3000, 'info')
end)

RegisterNetEvent("admin:healall")
AddEventHandler("admin:healall", function()   
    TriggerClientEvent("healall", -1)
    local sendToDiscord = 'แอดมิน' .. source .. 'ฮีลทั้งเซิฟเวอร์'
        TriggerEvent('azael_dc-serverlogs:sendToDiscord', 'healall', sendToDiscord, source, '^2')
    TriggerClientEvent('okokNotify:Alert', -1, "แจ้งเตือน", "ฮีลทั้งหมดโดยแอดมิน", 3000, 'info')
end)

function admin.Error(source, message)
    if message == "noPerms" then
        TriggerClientEvent('chat:addMessage', source, {args = {"admin ", " You do not have permission for this."}})
    else
        TriggerClientEvent('chat:addMessage', source, {args = {"admin ", message}})
    end
end

function split(s, delimiter)
    result = {}
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match)
    end
    return result
end


RegisterNetEvent("admin:addUpdateblip")
AddEventHandler("admin:addUpdateblip", function(state)
    Updateblip[source] = state
    if state then
        Updateblip_count  = Updateblip_count + 1
    else
        Updateblip_count = Updateblip_count - 1
    end
end)

AddEventHandler('playerDropped', function(reason)
    if Updateblip[source] ~= nil then
        Updateblip[source] = nil
    end
    for key, value in pairs(Updateblip) do
        if value then
            TriggerClientEvent('admin:removeUser', key, source)
        end
    end
end)


-- TriggerEvent('es:addGroupCommand', 'crash', "superadmin", function(source, args, user)
-- 	if args[1] then
-- 		if(tonumber(args[1]) and GetPlayerName(tonumber(args[1])))then
-- 			local player = tonumber(args[1])

-- 			-- User permission check
-- 			TriggerEvent("es:getPlayerFromId", player, function(target)

-- 				TriggerClientEvent('es_admin:crash', player)

-- 				TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Player ^2" .. GetPlayerName(player) .. "^0 has been crashed."} })
-- 			end)
-- 		else
-- 			TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Incorrect player ID"}})
-- 		end
-- 	else
-- 		TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Incorrect player ID"}})
-- 	end
-- end, function(source, args, user)
-- 	TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Insufficienct permissions!"} })
-- end, {help = "Crash a user, no idea why this still exists", params = {{name = "userid", help = "The ID of the player"}}})

-- function stringsplit(inputstr, sep)
-- 	if sep == nil then
-- 		sep = "%s"
-- 	end
-- 	local t={} ; i=1
-- 	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
-- 		t[i] = str
-- 		i = i + 1
-- 	end
-- 	return t
-- end
-- Server-side script (server.lua)

-- -- Event triggered when a player requests to copy another player's skin
-- RegisterServerEvent('copySkin:CopySkin')
-- AddEventHandler('copySkin:CopySkin', function(targetId)
--     local source = source
--     local target = tonumber(targetId)

--     -- Check if the target player exists and is valid
--     local targetPlayer = GetPlayerFromServerId(target)
--     if targetPlayer and targetPlayer ~= -1 then
--         -- Get the target player's skin information
--         local targetSkin = GetPlayerSkin(targetPlayer)

--         -- Apply the target player's skin to the source player
--         TriggerClientEvent('copySkin:ApplySkin', source, targetSkin)
--         TriggerClientEvent('chatMessage', source, '^2Successfully copied skin from player ' .. target)
--     else
--         -- If the target player is not found, send an error message
--         TriggerClientEvent('chatMessage', source, '^1Failed to find target player.')
--     end
-- end)

-- -- Configuration
-- local commandName = "copyskin" -- Command name to trigger the skin copying
-- local permissionLevel = 1 -- Minimum permission level required to use the command

-- -- Function to copy the player's skin
-- local function copySkin(targetPlayer, sourcePlayer)
--     -- Copy skin details such as model, hair, clothes, etc.
--     -- Replace the code below with the appropriate functions for your server framework
--     local targetSkin = GetPlayerSkin(targetPlayer)
--     SetPlayerSkin(sourcePlayer, targetSkin)

--     -- Notify the source player about the successful skin copy
--     TriggerClientEvent('chatMessage', sourcePlayer, "^2Skin copied successfully!")
-- end

-- -- Command handler
-- RegisterCommand(commandName, function(sourcePlayer, args)
--     -- Check if the player has the required permission level
--     -- Replace the code below with the appropriate functions for your server framework
--     -- if not IsPlayerAllowed(sourcePlayer, permissionLevel) then
--     --     TriggerClientEvent('chatMessage', sourcePlayer, "^1You don't have permission to use this command!")
--     --     return
--     -- end

--     -- Check if the target player ID is provided
--     local targetPlayerId = tonumber(args[1])
--     if not targetPlayerId then
--         TriggerClientEvent('chatMessage', sourcePlayer, "^1Please provide a valid player ID!")
--         return
--     end

--     -- Get the target player object
--     -- Replace the code below with the appropriate functions for your server framework
--     -- local targetPlayer = GetPlayerFromServerId(targetPlayerId)
--     -- if not targetPlayer then
--     --     TriggerClientEvent('chatMessage', sourcePlayer, "^1Player not found!")
--     --     return
--     -- end

--     -- Copy the skin from the target player
--     copySkin(targetPlayer, sourcePlayer)
-- end)
