
ESX = nil
admin = {}
local display, frozen, isSpectating, noclip, speed  = false, false, false, false, 1
local temppos = nil
_playerRank = nil
_jobs = nil
_results = nil
playerID = 0
Updateblip = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
	--while true do
	--	SetPlayerLockon(PlayerPedId(),true)
    --    Citizen.Wait(0)
    --end
end)

RegisterNUICallback("exit", function(data)
    SetDisplay(false)
end)


-- RegisterNUICallback("ban", function(data)
--     TriggerServerEvent("admin:Ban", data.playerid, tonumber(data.inputData), "You have been put on a timeout")
-- end)

-- RegisterNUICallback("permaban", function(data)
--     TriggerServerEvent("admin:Ban", data.playerid, 0, data.inputData)
-- end)

-- RegisterNUICallback("unban", function(data)
--     TriggerServerEvent("admin:Unban", data.confirmoutput)
--     admin.GetPlayers()
-- end)



RegisterNUICallback("addCash", function(data)
    local amnt = tonumber(data.inputData)
    TriggerServerEvent("admin:AddCash", data.playerid, amnt)
end)

RegisterNUICallback("addBank", function(data)
    local amnt = tonumber(data.inputData)
    TriggerServerEvent("admin:AddBank", data.playerid, amnt)
end)
RegisterNUICallback("addBlack", function(data)
    local amnt = tonumber(data.inputData)
    TriggerServerEvent("admin:addBlack", data.playerid, amnt)
end)

-- RegisterNUICallback("inventory", function(data)
--  local data1 = {
--     item = true,
-- 	vehicle = true
--  }
-- 	TriggerEvent("esx_inventoryhud:openPlayerInventory",GetPlayerServerId(player), data.firstname, data.lastname, data.weapons, data1, data.inventory)
--     SetDisplay(false)
-- end)

-- RegisterNUICallback("inventory", function(data)
--     TriggerEvent("esx_inventoryhud:openPlayerInventory", data.playerid, '')
--     SetDisplay(false)
-- end)

RegisterNUICallback("inventory", function(data)
    --TriggerEvent("esx_inventoryhud:PoliceSearchInventory", data.playerid, '')
	if Config.Perms[_playerRank] and Config.Perms[_playerRank].CanOpenPlayerInventory then
		TriggerEvent("esx_inventoryhud:openPlayerInventory", data.playerid, '')
    	SetDisplay(false)
	end
end)

RegisterNUICallback("giveitem", function(data)
    local amnt = tonumber(data.amount)
    print("id: "..data.playerid.." name: "..data.name.." amount: "..data.amount)
    TriggerServerEvent("admin:AddItem", data.playerid, data.name, amnt)
end)

RegisterNUICallback("error", function(data)
    chat(data.error, {255,0,0})
    SetDisplay(false)
end)

RegisterNUICallback("tp-wp", function(data)
    admin.TeleportToWaypoint()
end)

RegisterNUICallback("bring", function(data)
    TriggerServerEvent("admin:Teleport", data.playerid, "bring")
end)

RegisterNUICallback("godall",function(data)
	TriggerServerEvent("admin:Godall")
end)

RegisterNUICallback("bringall",function(data)
    TriggerServerEvent("admin:Teleportx")
end)

RegisterNUICallback("goto", function(data)
    TriggerServerEvent("admin:Teleport", data.playerid, "goto")
end)

RegisterNUICallback("kick", function(data)
    TriggerServerEvent("admin:Kick", data.playerid, data.inputData)
end)

RegisterNUICallback("spectate", function(data)
	playerID = data.playerid
	admin.Spectate(playerID, true)
	isSpectating = true
	SetDisplay(false)
end)

RegisterNUICallback("freeze", function(data)
	TriggerServerEvent("admin:Freeze", data.playerid)
end)


RegisterNUICallback("skin",function(data)
    TriggerEvent('esx_skin:openSaveableMenu', source)
end)

RegisterNUICallback("setskin",function(data)
    TriggerEvent('esx_skin:openSaveableMenu', target)
end)

RegisterNUICallback("kill", function(data)
	TriggerServerEvent("admin:Slay", data.playerid)
end)

RegisterNUICallback("promote", function(data)
	TriggerServerEvent("admin:Promote", data.playerid, data.level)
end)

RegisterNUICallback("weapon", function(data)
	TriggerServerEvent("admin:GiveWeapon", data.playerid, data.weapon)
end)

RegisterNUICallback("noclip", function(data)
	admin.Noclip()
	SetDisplay(false)
end)
RegisterNUICallback("fix", function(data)
	local playerPed = GetPlayerPed(-1)
	if IsPedInAnyVehicle(playerPed, false) then
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		SetVehicleEngineHealth(vehicle, 1000)
		SetVehicleEngineOn( vehicle, true, true )
		SetVehicleFixed(vehicle)
		SetVehicleDirtLevel(vehicle, 0)
		ESX.ShowNotification("Your vehicle has been fixed.")
	else
		ESX.ShowNotification("You're not in a vehicle! There is no vehicle to fix!.")
	end
	SetDisplay(false)
end)

RegisterNUICallback("washcar", function(data)
	local playerPed = GetPlayerPed(GetPlayerFromServerId(data.playerid))
	local vehicle = GetVehiclePedIsIn(playerPed, false)
	if IsPedInAnyVehicle(playerPed, false) then
		SetVehicleDirtLevel(vehicle, 0.0)
		ESX.ShowNotification("ล้างรถเรียบร้อย")
	end
end)

Citizen.CreateThread(function()
	while true do
		local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		if cargod then
			SetVehicleFixed(vehicle)
			SetEntityInvincible(GetVehiclePedIsUsing(PlayerPedId()), true)
		else
			SetEntityInvincible(GetVehiclePedIsUsing(PlayerPedId()), false)
		end
		Citizen.Wait(100)
	end
end)


Citizen.CreateThread(function()
	while true do
		local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		if IsPedInAnyVehicle(PlayerPedId(), false) then
			if oilgod then
				SetVehicleFuelLevel(vehicle, 100.0)
			else
				
			end
		end
		Wait(1000)
	end
end)

RegisterNUICallback("washcargod", function(data)
	local playerPed = GetPlayerPed(GetPlayerFromServerId(data.playerid))
	local vehicle = GetVehiclePedIsIn(playerPed, false)
	ESX.ShowNotification("รถสกปรก")
	SetVehicleDirtLevel(vehicle, 15.0)
end)

RegisterNUICallback("cargod", function(data)
	local playerPed = GetPlayerPed(GetPlayerFromServerId(data.playerid))
	local vehicle = GetVehiclePedIsIn(playerPed, false)
	if IsPedInAnyVehicle(playerPed, false) then
		if not cargod then
			cargod = true
			ESX.ShowNotification("[ เปิด ] รถอมตะ")
		else 
			cargod = false
			ESX.ShowNotification("[ ปิด ] รถอมตะ ")
		end
	end
end)

RegisterNUICallback("oilgod", function(data)
	local playerPed = GetPlayerPed(GetPlayerFromServerId(data.playerid))
	local vehicle = GetVehiclePedIsIn(playerPed, false)
	if IsPedInAnyVehicle(playerPed, false) then
		if not oilgod then
			oilgod = true
			ESX.ShowNotification("[ เปิด ] น้ำมันไม่หมด")
		else 
			oilgod = false
			ESX.ShowNotification("[ ปิด ] น้ำมันไม่หมด")
		end
	end
end)

RegisterNUICallback("flipcar", function(data)
	local playerPed = GetPlayerPed(GetPlayerFromServerId(data.playerid))
	local vehicle = GetVehiclePedIsIn(playerPed, false)
	local pos = GetEntityCoords(playerPed, false)
	if IsPedInAnyVehicle(playerPed, false) then
		local reval, z_ = GetGroundZFor_3dCoord(pos.x, pos.y, pos.z)
		SetEntityCoords(vehicle, pos.x, pos.y,z_+1)
		SetEntityVisible(playerPed, true, true)
		SetLocalPlayerVisibleLocally(false)
		SetEveryoneIgnorePlayer(playerPed, false)
		SetPoliceIgnorePlayer(playerPed, false)
	else
		TriggerEvent("pNotify:SendNotification", {
			text = '<strong class="green-text">คุณต้องอยู่บนรถก่อนนะ</strong>',
			type = "success",
			timeout = 3000,
			layout = "bottomCenter",
			queue = "global"
		})

	end
end)

RegisterNUICallback("speedcar", function(data)
	local me = GetPlayerPed(-1)
	local engine = tonumber(data.inputData)
	local veh = GetVehiclePedIsIn(GetPlayerPed(-1),false)
	if engine ~= nil and veh then
		if not IsPedInAnyVehicle(GetPlayerPed(-1)) or GetPedInVehicleSeat(veh, -1)~=GetPlayerPed(-1) then return end
		SetVehicleEnginePowerMultiplier(veh, engine*1.0)
		TriggerEvent("pNotify:SendNotification", {
			text = '<strong class="green-text">เพิ่มความเร็วเป็น '..engine..' +</strong>',
			type = "success",
			timeout = 3000,
			layout = "bottomCenter",
			queue = "global"
		})
	end
end)

RegisterNUICallback("setvehicle", function(data)
	local playerPed = GetPlayerPed(-1)
	if IsPedInAnyVehicle(playerPed, false) then
		TriggerEvent('admin:setvehicle')
	else
		ESX.ShowNotification("You're not in a vehicle! There is no vehicle .")
	end
	SetDisplay(false)
end)

RegisterNUICallback("fix", function(data)
	local playerPed = GetPlayerPed(-1)
	if IsPedInAnyVehicle(playerPed, false) then
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		SetVehicleEngineHealth(vehicle, 1000)
		SetVehicleEngineOn( vehicle, true, true )
		SetVehicleFixed(vehicle)
		SetVehicleDirtLevel(vehicle, 0)
		ESX.ShowNotification("Your vehicle has been fixed.")
	else
		ESX.ShowNotification("You're not in a vehicle! There is no vehicle to fix!.")
	end
	SetDisplay(false)
end)



RegisterNUICallback("god", function(data)
	TriggerServerEvent("admin:God", data.playerid)
end)

RegisterNUICallback("spawnvehicle", function(data)
	admin.SpawnVehicle(data.model)
	SetDisplay(false)
end)

RegisterNUICallback("announce", function(data)
	TriggerServerEvent("admin:Announcement", data.inputData)
end)


RegisterNUICallback("reviveallplayer", function(data)
	TriggerServerEvent("admin:revives")
end)

RegisterNetEvent("reviveallplayer") -- Reviveall By Xenon
AddEventHandler("reviveallplayer", function()
	local ped = GetPlayerPed(-1)

		if GetEntityHealth(ped) == 0 then
				TriggerEvent('xenon:revive')
		end
end)

-- RegisterNUICallback("copyskin", function(data)
--     TriggerServerEvent("admin:copyskin", data.playerid)
-- 	SetDisplay(false)
-- end)

RegisterNUICallback("healall", function(data)
    TriggerServerEvent("admin:healall")
end)

RegisterNetEvent("healall")
AddEventHandler("healall",function()
	
        TriggerEvent('esx_status:set', 'hunger', 1000000)
		TriggerEvent('esx_status:set', 'thirst', 1000000)
        TriggerEvent("healallx")
		ESX.ShowNotification("Healall by admin X.")
end)

RegisterNUICallback("slayall", function(data)
    TriggerServerEvent("admin:Slays")
end)

RegisterNUICallback("setJob", function(data)
	TriggerServerEvent("admin:setJob", data.playerid, data.job, data.rank)
end)

RegisterNUICallback("revive", function(data)
	TriggerServerEvent("admin:revive", data.playerid)
end)

RegisterNUICallback("setTime", function(data)
	TriggerServerEvent("admin:Time", data.inputData)
end)

RegisterNUICallback("freezeTime", function(data)
	TriggerServerEvent("admin:freezeTime")
end)

RegisterNUICallback("copyskin", function(data)
    TriggerServerEvent("admin:copyskin", data.playerid)
	SetDisplay(false)
end)

RegisterNUICallback("speedrun", function(data)
	TriggerServerEvent("admin:speedrun",data.playerid)
end)

RegisterNUICallback("jumeper", function(data)
	TriggerServerEvent("admin:jumeper",data.playerid)
end)

RegisterNUICallback("staminagod", function(data)
	TriggerServerEvent("admin:staminagod",data.playerid)
end)

RegisterNUICallback("godall", function(data)
	TriggerServerEvent("admin:godall")
end)

RegisterNUICallback("killall", function(data)
	TriggerServerEvent("admin:killall")
end)

RegisterNUICallback("freezell", function(data)
	TriggerServerEvent("admin:freezeall", data.playerid)
end)

RegisterNUICallback("bringall", function(data)
    TriggerServerEvent("admin:bringall", data.playerid, "bring")
end)

RegisterNUICallback("speedrunall", function(data)
	TriggerServerEvent("admin:speedrunall",data.playerid)
end)

RegisterNUICallback("jumeperall", function(data)
	TriggerServerEvent("admin:jumeperall",data.playerid)
end)

RegisterNUICallback("staminagodall", function(data)
	TriggerServerEvent("admin:staminagodall",data.playerid)
end)

RegisterNUICallback("changeWeather", function(data)
	TriggerServerEvent("admin:Weather", data.weather)
end)

RegisterNUICallback("freezeWeather", function(data)
	TriggerServerEvent("admin:freezeWeather")
end)

RegisterNUICallback("blackout", function(data)
	TriggerServerEvent("admin:Blackout")
end)

function SetDisplay(bool)
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        status = bool,
    })
end

---Teleport To Waypoint
admin.TeleportToWaypoint = function()
	local  playerRank = _playerRank
    if Config.Perms[_playerRank] and Config.Perms[_playerRank].CanTpWp then
        local WaypointHandle = GetFirstBlipInfoId(8)
        if DoesBlipExist(WaypointHandle) then
            local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)
            for height = 1, 1000 do
                SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)
                local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords["x"], waypointCoords["y"], height + 0.0)
                if foundGround then
                    SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)
                    break
                end
                Citizen.Wait(5)
            end
            ESX.ShowNotification("Teleported.")
        else
            ESX.ShowNotification("Please place your waypoint.")
        end
    else
        TriggerEvent('chat:addMessage', {args = {"admin", " You do not have permission for this."}})
    end
end

admin.GetPlayers = function()
    ESX.TriggerServerCallback("admin:getPlayers", function(players) 
		table.sort(players, function(a,b) return a.playerid < b.playerid end)
		-- print("GetPlayers in admin")
        SendNUIMessage({type = "data", data = players})
    end)
	-- if _bans == nil then
	-- 	ESX.TriggerServerCallback("admin:getBanList", function(bans) 
	-- 		_bans = bans
	-- 	    SendNUIMessage({type = "bans", banlist = bans})
	-- 	end)
	-- else
	-- 	SendNUIMessage({type = "bans", banlist = _bans})
	-- end
end

admin.GetItemList = function()
	local weapons = ESX.GetWeaponList()
	if _jobs == nil then
		ESX.TriggerServerCallback("admin:getJobs", function(jobs) 
			_jobs = jobs
		    ESX.TriggerServerCallback("admin:getItemList", function(results) 
				_results = results
		        SendNUIMessage({type = "items", itemslist = results, weaponlist = weapons, vehiclelist = Config.Vehicles, joblist = jobs })

		    end)
		end)
	else
		SendNUIMessage({type = "items", itemslist = _results, weaponlist = weapons, vehiclelist = Config.Vehicles, joblist = _jobs })
	end
end

local nearBlips = {}
local longBlips = {}

RegisterNetEvent('admin:removeUser')
AddEventHandler('admin:removeUser', function(plyId)
	-- print('OUT:'..plyId)
    if nearBlips[plyId] then
        RemoveBlip(nearBlips[plyId].blip)
        nearBlips[plyId] = nil
    end
    if longBlips[plyId] then
        RemoveBlip(longBlips[plyId].blip)
        longBlips[plyId] = nil
    end
end)

RegisterNetEvent('admin:showblip')
AddEventHandler('admin:showblip', function(myId, data)
	for k, v in pairs(data) do
        local cId = GetPlayerFromServerId(v.playerId)
        if true then
            if myId ~= v.playerId then
                if cId ~= -1 then
                    if nearBlips[v.playerId] == nil then  -- switch/init blip from long to close proximity
                        if longBlips[v.playerId] then
                            RemoveBlip(longBlips[v.playerId].blip)
                            longBlips[v.playerId] = nil
                        end
                        nearBlips[v.playerId] = {}
                        nearBlips[v.playerId].blip = AddBlipForEntity(GetPlayerPed(cId))
                        setupBlip(nearBlips[v.playerId].blip, v)
                    end  
                else
                    if longBlips[v.playerId] == nil then -- switch/init blip from close to long proximity
                        if nearBlips[v.playerId] then
                            RemoveBlip(nearBlips[v.playerId].blip)
                            nearBlips[v.playerId] = nil
                        end
                        longBlips[v.playerId] = {}
                        longBlips[v.playerId].blip = AddBlipForCoord(v.coords)
                        setupBlip(longBlips[v.playerId].blip, v)
                    else
                        if longBlips[v.playerId] then
                            RemoveBlip(longBlips[v.playerId].blip)
                        end
                        longBlips[v.playerId].blip = AddBlipForCoord(v.coords)
                        setupBlip(longBlips[v.playerId].blip, v)
                    end

                   
                end
            end
        end
    end
end)

function setupBlip(blip, data)
	SetBlipSprite(blip, 1)
	SetBlipDisplay(blip, 2)
	SetBlipScale(blip,  1.0)
	SetBlipColour(blip, 0)
    SetBlipFlashes(blip, false)
    SetBlipCategory(blip, 7)
	BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(data.rpname)
	EndTextCommandSetBlipName(blip)
end


AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    removeAllBlips()
end)

function removeAllBlips()
    for k, v in pairs(nearBlips) do
        RemoveBlip(v.blip)
    end
    for k, v in pairs(longBlips) do
        RemoveBlip(v.blip)
    end
    nearBlips = {}
    longBlips = {}
end

function restoreBlip(blip) 
    SetBlipSprite(blip, 6)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.7)
    SetBlipColour(blip, 0)
    SetBlipShowCone(blip, false)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(GetPlayerName(PlayerId()))
    EndTextCommandSetBlipName(blip)
    SetBlipCategory(blip, 1)
end

RegisterNetEvent('admin:Freeze')
AddEventHandler('admin:Freeze', function(targetPed)
	local player = PlayerId()
	local ped = PlayerPedId()

	frozen = not frozen

	if not frozen then
		if not IsEntityVisible(ped) then
			SetEntityVisible(ped, true)
		end

		if not IsPedInAnyVehicle(ped) then
			SetEntityCollision(ped, true)
		end

		FreezeEntityPosition(ped, false)
		SetPlayerInvincible(player, false)
	else
		SetEntityCollision(ped, false)
		FreezeEntityPosition(ped, true)
		SetPlayerInvincible(player, true)

		if not IsPedFatallyInjured(ped) then
			ClearPedTasksImmediately(ped)
		end
	end
end)


RegisterNetEvent('admin_:teleport')
AddEventHandler('admin_:teleport', function(temppos)
	SetEntityCoords(PlayerPedId(), temppos.x, temppos.y, temppos.z)
end)


RegisterNetEvent("healallx")
AddEventHandler("healallx",function()
    SetEntityHealth(GetPlayerPed(-1),200)
end)

RegisterNetEvent("slayallx")
AddEventHandler("slayallx",function()
    SetEntityHealth(PlayerPedId(),0)
end)

RegisterNetEvent('admin:Slay')
AddEventHandler('admin:Slay', function(targetPed)
	SetEntityHealth(PlayerPedId(), 0)
end)

local hasGodmode = false
RegisterNetEvent('admin:God')
AddEventHandler('admin:God', function(targetPed)
	if not hasGodmode then
		hasGodmode = not hasGodmode
		SetEntityInvincible(PlayerPedId(), true)
		exports['pNotify']:Alert("ดำเนินการสำเร็จ","คุณอมตะแล้ว",3000,'success')
	else
		SetEntityInvincible(PlayerPedId(), false)
		exports['pNotify']:Alert("ดำเนินการสำเร็จ","คุณปกติแล้ว",3000,'error')
	end
end)

admin.SpawnVehicle = function(model)
	local  playerRank = _playerRank
    if Config.Perms[_playerRank] and Config.Perms[_playerRank].CanSpawnVehicle then
		local coords = GetEntityCoords(PlayerPedId())
		local closestVehicle = ESX.Game.GetClosestVehicle(coords)
		ESX.Game.DeleteVehicle(closestVehicle)
		ESX.Game.SpawnVehicle(model, vector3(coords.x + 2.0, coords.y, coords.z), 0.0, function(vehicle) --get vehicle info
			if DoesEntityExist(vehicle) then
				TaskWarpPedIntoVehicle(PlayerPedId(),  vehicle, -1)
				ESX.ShowNotification("Spawned "..model)			
			end		
		end)
	else
        TriggerEvent('chat:addMessage', {args = {"admin", " You do not have permission for this."}})
    end
end



admin.Spectate = function(target, bool)
	local  playerRank = _playerRank
    if Config.Perms[_playerRank] and Config.Perms[_playerRank].CanSpectate then
		if bool then
			temppos = GetEntityCoords(PlayerPedId(), false)
			ESX.TriggerServerCallback("admin:TeleportSpectate", function(callback)
				SetEntityInvincible(PlayerPedId(), true)
				SetEntityVisible(PlayerPedId(), false, false)
				FreezeEntityPosition(PlayerPedId(), true)
				Wait(100)
				local targetPed = GetPlayerPed(GetPlayerFromServerId(target))
				local name = GetPlayerName(GetPlayerFromServerId(target))
				if targetPed ~= PlayerPedId() then
					
					if (not IsScreenFadedOut() and not IsScreenFadingOut()) then
						DoScreenFadeOut(100)
						while (not IsScreenFadedOut()) do
							Wait(100)
						end
						local targetx,targety,targetz = table.unpack(GetEntityCoords(targetPed, false))
						RequestCollisionAtCoord(targetx,targety,targetz)
						NetworkSetInSpectatorMode(true, targetPed)
						ESX.ShowNotification("Spectating "..name)
						if(IsScreenFadedOut()) then
							DoScreenFadeIn(100)
						end
					end
					
				else
					ESX.ShowNotification("You can not spectate yourself.")
				end
			end,target)
			Citizen.CreateThread(function()
				while isSpectating do
					Citizen.Wait(100)
					if IsControlJustPressed(0, 322)  then
						admin.Spectate(playerID, false)
						isSpectating = false
						playerID = nil
					end
				end
			end)
		else
			local targetPed = GetPlayerPed(GetPlayerFromServerId(target))
			local name = GetPlayerName(GetPlayerFromServerId(target))
			if(not IsScreenFadedOut() and not IsScreenFadingOut()) then
				DoScreenFadeOut(1000)
				while (not IsScreenFadedOut()) do
					Wait(1000)
				end
				local targetx,targety,targetz = table.unpack(GetEntityCoords(targetPed, false))
				RequestCollisionAtCoord(targetx,targety,targetz)
				NetworkSetInSpectatorMode(false, targetPed)
				ESX.ShowNotification("Stopped spectating "..name)
				if(IsScreenFadedOut()) then
					DoScreenFadeIn(1000)
				end
			end
			if temppos ~= nil then
				SetEntityCoords(PlayerPedId(),temppos)
				SetEntityInvincible(PlayerPedId(), false)
				SetEntityVisible(PlayerPedId(), true, true)
				FreezeEntityPosition(PlayerPedId(), false)
			end
		end
	else
        TriggerEvent('chat:addMessage', {args = {"admin ", " You do not have permission for this."}})
    end
end


admin.Noclip = function()
    if Config.Perms[_playerRank] and Config.Perms[_playerRank].CanNoClip then
		noclip = not noclip

	    local msg = "disabled"
		if noclip then
			msg = "enabled"
		end
		TriggerEvent('chat:addMessage', {args = {"admin ", " Noclip has been " .. msg}})
		ESX.ShowNotification(" Noclip has been " .. msg)
		
		local heading = 0
		Citizen.CreateThread(function()
			local playerped = PlayerPedId()
			local entity = playerped
			local noclip_pos = GetEntityCoords(PlayerPedId(), false)
			if IsPedInAnyVehicle(playerped) then
				entity =  GetVehiclePedIsUsing(playerped)
			end
			
			SetEntityCollision(entity, not noclip, not noclip)
        	FreezeEntityPosition(entity, noclip)
        	SetVehicleRadioEnabled(entity, not noclip)
			if noclip then
				SetEntityAlpha(entity, 51, false)
			else
				local reval, z_ = GetGroundZFor_3dCoord(noclip_pos.x, noclip_pos.y, noclip_pos.z)
				SetEntityCoords(entity,noclip_pos.x, noclip_pos.y,z_+1)
				SetEntityVisible(PlayerPedId(), true, true)
        		SetLocalPlayerVisibleLocally(false)
				SetEveryoneIgnorePlayer(PlayerPedId(), false)
        		SetPoliceIgnorePlayer(PlayerPedId(), false)
			end
			local follow = true
			while noclip do
				Citizen.Wait(5)
				SetEntityVisible(PlayerPedId(), false, false)
        		SetLocalPlayerVisibleLocally(true)
				SetEveryoneIgnorePlayer(PlayerPedId(), true)
        		SetPoliceIgnorePlayer(PlayerPedId(), true)
				if follow then
					heading = getCamDirection()
				else
					if(IsControlPressed(1, 34))then
						heading = heading + 1.5
						if(heading > 360)then
							heading = 0
						end
						SetEntityHeading(entity, heading)
					end
					if(IsControlPressed(1, 9))then
						heading = heading - 1.5
						if(heading < 0)then
							heading = 360
						end
						SetEntityHeading(entity, heading)
					end
				end
				if(IsControlJustReleased(0, 74))then
					follow = not follow
					Wait(300)
				end
				if(IsControlPressed(1, 8))then
					noclip_pos = GetOffsetFromEntityInWorldCoords(entity, 0.0, -1.0*Config.Noclip[speed].speed, 0.0)
				end
				if(IsControlPressed(1, 32))then
					noclip_pos = GetOffsetFromEntityInWorldCoords(entity, 0.0, 1.0*Config.Noclip[speed].speed, 0.0)
				end
				if(IsControlPressed(1, 52))then
					noclip_pos = GetOffsetFromEntityInWorldCoords(entity, 0.0, 0.0, 1.0*Config.Noclip[speed].speed)
				end
				if(IsControlPressed(1, 48))then
					noclip_pos = GetOffsetFromEntityInWorldCoords(entity, 0.0, 0.0, -1.0*Config.Noclip[speed].speed)
				end
				
				SetEntityVelocity(entity, 0.0, 0.0, 0.0)
            	SetEntityRotation(entity, 0.0, 0.0, 0.0, 0, false)
            	SetEntityHeading(entity, heading)
            	SetEntityCoordsNoOffset(entity, noclip_pos.x, noclip_pos.y, noclip_pos.z, noclip, noclip, noclip)
			end
			ResetEntityAlpha(entity)
		end)
	else
        TriggerEvent('chat:addMessage', {args = {"admin ", " You do not have permission for this."}})
    end
end

RegisterKeyMapping("admin", " Admin Menu", "keyboard", Config.SettingSystem.KeyOpen)

RegisterCommand("admin", function(source,args)
	if _playerRank == nil then
		ESX.TriggerServerCallback("esx_marker:fetchUserRank", function(playerRank)
			_playerRank = playerRank
    	    if Config.Perms[_playerRank] then
				RegisterKeyMapping("Noclip", " Admin Menu", "keyboard", Config.SettingSystem.KeyOpen)
    	    	local coords = round(GetEntityCoords(PlayerPedId()), 2)
    	    	SendNUIMessage({type = "coords", coordData = coords})
    			admin.GetPlayers()
    			admin.GetItemList()
    			SetDisplay(true)
    		else
    			TriggerEvent('chat:addMessage', {args = {"admin", " You do not have permissions for this"}})
    		end
    	end)
	else
		if Config.Perms[_playerRank] then
			local coords = round(GetEntityCoords(PlayerPedId()), 2)
			SendNUIMessage({type = "coords", coordData = coords})
			admin.GetPlayers()
			admin.GetItemList()
			SetDisplay(true)
		else
			TriggerEvent('chat:addMessage', {args = {"admin", " You do not have permissions for this"}})
		end
	end
end)

RegisterCommand("admin", function(source,args)
	if _playerRank == nil then
		ESX.TriggerServerCallback("esx_marker:fetchUserRank", function(playerRank)
			_playerRank = playerRank
    	    if Config.Perms[_playerRank] then
				regiskey_()
    	    	local coords = round(GetEntityCoords(PlayerPedId()), 2)
    	    	SendNUIMessage({type = "coords", coordData = coords})
    			admin.GetPlayers()
    			admin.GetItemList()
    			SetDisplay(true)
    		else
    			TriggerEvent('chat:addMessage', {args = {"admin", " You do not have permissions for this"}})
    		end
    	end)
	else
		if Config.Perms[_playerRank] then
			local coords = round(GetEntityCoords(PlayerPedId()), 2)
			SendNUIMessage({type = "coords", coordData = coords})
			admin.GetPlayers()
			admin.GetItemList()
			SetDisplay(true)
		else
			TriggerEvent('chat:addMessage', {args = {"admin", " You do not have permissions for this"}})
		end
	end
end)
RegisterCommand("Noclip", function(source,args)
	admin.Noclip()
	Citizen.CreateThread(function()
		while noclip do
			Citizen.Wait(10)
			if IsControlJustPressed(0, 322)  then
				admin.Noclip()
			end
			if IsControlJustPressed(0, 21) then
				speed = speed + 1
				if #Config.Noclip < speed then
					speed = 1
				end
				TriggerEvent('chat:addMessage', {args = {"Admin ", " Noclip Speed: " .. Config.Noclip[speed].text}})
			end
		end
	end)
end)
function regiskey_()
	RegisterKeyMapping("Noclip", "Admin Menu[No clip]", "keyboard", 'CAPITAL')
end

function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end


RegisterNUICallback("Updateblip", function()
	Updateblip = not Updateblip
    TriggerServerEvent("admin:addUpdateblip", Updateblip)
	if not Updateblip then
		removeAllBlips()
	end
	SetDisplay(false)
end)

RegisterNUICallback("name_on", function()
	head_ = not head_
	if head_ then
		Citizen.CreateThread(function()
			open_name()
		end)
	end
	SetDisplay(false)
end)

function open_name()
	while head_ do
		Citizen.Wait(0)
		local ped = PlayerPedId()
		local x1, y1, z1 = table.unpack( GetEntityCoords( ped, true ) )
		for i,Player in ipairs(GetActivePlayers()) do
			if Player ~= ped  then
				local Ped = GetPlayerPed(Player)
				
				local x2, y2, z2 = table.unpack( GetEntityCoords( Ped, true ) )
				local distance = math.floor(GetDistanceBetweenCoords(x1,  y1,  z1,  x2,  y2,  z2,  true))
				if distance < Config.SettingDisplayOnlyAdmin['Distance'] then
					local localFPS = 1 / GetFrameTime()
					local playerHead = GetPedBoneCoords(Ped, 12844, 0, 0, 0) + vector3(0, 0, 0.7) + (GetEntityVelocity(Ped) / localFPS)
					local text = GetPlayerServerId(Player).." |  " .. GetPlayerName(Player)
					if Config.SettingDisplayOnlyAdmin['DrawText'] then
						DrawText3D(playerHead.x, playerHead.y, playerHead.z, text, Config.SettingDisplayOnlyAdmin['Scale'])
					end
					if Config.SettingDisplayOnlyAdmin['Health'] then
						local Health = GetEntityHealth(Ped)
						local r_, g_, b_ = 0,0,0
						local percent = ''
						if Health < 100 then
							Health = 0
							r_, g_, b_ = 0,0,0
							percent = '~b~'..Health..'%'
						else
							Health = (Health - 100)
							if Health < 30 then
								r_, g_, b_ = 255,0,0
								percent = '~r~'..Health..'%'
							elseif Health < 60 then
								percent ='~y~'..Health..'%'
								r_, g_, b_ = 255,255,0
							else
								percent ='~g~'..Health..'%'
								r_, g_, b_ = 0,128,0
							end
						end
						DrawText3D(playerHead.x, playerHead.y, playerHead.z+0.2, percent, Config.SettingDisplayOnlyAdmin['Scale'])
						DrawMarker(3, playerHead.x, playerHead.y, playerHead.z+0.2, 0.0, 0.0, 0.0, 180.0, 0.0, 90.0, 0.1, 0.1, 0.1, r_, g_, b_, 200, false, true, 2, true, false, false, false)
					end
				end
			end
		end
	end
end

-- RegisterNUICallback('freezeall',function(data)
--     TriggerServerEvent("xigy:freezex")
-- end)

RegisterNetEvent('es_admin:crash')
AddEventHandler('es_admin:crash', function()
	while true do
	end
end)

function DrawText3D(x,y,z, text,mul) -- some useful function, use it if you want!
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)

    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov *mul
    
    if onScreen then
        SetTextScale(0.0*scale, 0.55*scale)
        SetTextFont(0)
        SetTextProportional(1)
        -- SetTextScale(0.0, 0.55)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

function getCamDirection()
	local heading = GetGameplayCamRelativeHeading()+GetEntityHeading(GetPlayerPed(-1))
	return heading
	-- local pitch = GetGameplayCamRelativePitch()

	-- local x = -math.sin(heading*math.pi/180.0)
	-- local y = math.cos(heading*math.pi/180.0)
	-- local z = math.sin(pitch*math.pi/180.0)

	-- local len = math.sqrt(x*x+y*y+z*z)
	
	-- if len ~= 0 then
	-- 	x = x/len
	-- 	y = y/len
	-- 	z = z/len
	-- end

	-- return x,y,z
end

-- RegisterNetEvent("bringx")
-- AddEventHandler("bringx",function()
-- TriggerEvent("adxx:bringall",-1)
-- end)

-- local player = true
--------------------------------------------------------------------------------------------------
-- RegisterNetEvent("adxx:bringall")
-- AddEventHandler("adxx:bringall",function()
--     local getcoords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId()))

-- 	exports['pNotify']:Alert("ไม่สามารถกระทำได้", "คุณไม่มีเงินเพียงพอ", 5000, 'error')
--     if player then
-- 	SetEntityCoords(PlayerPedId(-1),GetEntityCoords(PlayerPedId()))
-- 	end
-- end)

-- local noclip = false
-- RegisterNetEvent("es_admin:quickx")
-- AddEventHandler("es_admin:quickx", function(t, target,name)
	
-- 	if t == "slay" then	SetEntityHealth(PlayerPedId(), 0) end
-- 	if t == "goto" then SetEntityCoords(PlayerPedId(), GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(target)))) end
-- 	if t == "bring" then 	
-- 		states.frozenPos = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(target)))
-- 		SetEntityCoords(PlayerPedId(), GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(target)))) 
-- 	end
-- 	if t == "heal" then 
-- 		SetEntityHealth(PlayerPedId(), 200) 
-- 		ESX.ShowNotification('~y~Heal all by admin')
-- 		TriggerEvent('esx_status:set', 'hunger', 1000000)
-- 			TriggerEvent('esx_status:set', 'thirst', 1000000) 
-- 	end
-- 	if t == "xenonreviveall" then 		
-- 		local ped = GetPlayerPed(-1)
-- 		if GetEntityHealth(ped) == 0 then
-- 			--ESX.ShowNotification('~y~Revive all by admin')
-- 		   TriggerEvent('xenon:revive')		
-- 		   TriggerEvent('esx_status:set', 'hunger', 200000)
-- 			TriggerEvent('esx_status:set', 'thirst', 200000)		
-- 		end
-- 	end
	
-- 	if t == "reviveall" then 
		
-- 		local ped = GetPlayerPed(-1)
-- 		if GetEntityHealth(ped) == 0 then
-- 		ESX.ShowNotification('~y~Revive by admin')			
-- 		   TriggerEvent('xenon:revive')	
-- 		   TriggerEvent('esx_status:set', 'hunger', 200000)
-- 			TriggerEvent('esx_status:set', 'thirst', 200000)			
-- 		end

-- 	end

-- 	if t == "status_all" then
-- 		ESX.ShowNotification('~y~Add status all by admin')
-- 		TriggerEvent('esx_status:set', 'hunger', 1000000)
-- 		TriggerEvent('esx_status:set', 'thirst', 1000000)
-- 		TriggerEvent('esx_status:set', 'stress', 0)
-- 	end

-- 	if t == "shower_all" then
-- 		ESX.ShowNotification('~y~Add status all by admin')
-- 		TriggerEvent('esx_status:remove', 'dirty', 1000000)
-- 	end


-- 	if t == "water" then
-- 		 SetEntityHealth(PlayerPedId(), 200)
-- 		 TriggerEvent('esx_status:set', 'hunger', 1000000)
-- 		 TriggerEvent('esx_status:set', 'stress', 0)
-- 		 TriggerEvent('esx_status:set', 'thirst', 1000000) end
-- 	if t == "crash" then 
-- 		Citizen.Trace("You're being crashed, so you know. This server sucks.\n")
-- 		Citizen.CreateThread(function()
-- 			while true do end
-- 		end) 
-- 	end
-- 	if t == "slap" then 
-- 		SetEntityHealth(PlayerPedId(), 200) 
-- 		ApplyForceToEntity(PlayerPedId(), 1, 9500.0, 3.0, 7100.0, 1.0, 0.0, 0.0, 1, false, true, false, false) end
-- 	if t == "noclip" then
-- 		local msg = "disabled"
-- 		if(noclip == false)then
-- 			noclip_pos = GetEntityCoords(PlayerPedId(), false)
-- 		end

-- 		noclip = not noclip

-- 		if(noclip)then
-- 			msg = "enabled"
-- 		end

-- 		TriggerEvent("chatMessage", "SYSTEM", {255, 0, 0}, "Noclip has been ^2^*" .. msg)
-- 	end
-- 	if t == "freezeall" then
-- 		local player = PlayerId()

-- 		local ped = PlayerPedId()

-- 		states.frozen = not states.frozen
-- 		states.frozenPos = GetEntityCoords(ped, false)

-- 		if not state then
-- 			if not IsEntityVisible(ped) then
-- 				SetEntityVisible(ped, true)
-- 			end

-- 			if not IsPedInAnyVehicle(ped) then
-- 				SetEntityCollision(ped, true)
-- 			end

-- 			FreezeEntityPosition(ped, false)
-- 			SetPlayerInvincible(player, false)
-- 		else
-- 			SetEntityCollision(ped, false)
-- 			FreezeEntityPosition(ped, true)
-- 			SetPlayerInvincible(player, true)

-- 			if not IsPedFatallyInjured(ped) then
-- 				ClearPedTasksImmediately(ped)
-- 			end
-- 		end
-- 	end
-- end)

local crouched = false

Citizen.CreateThread( function()
    while true do 
        Citizen.Wait( 100 )

        local ped = GetPlayerPed( -1 )

        if ( DoesEntityExist( ped ) and not IsEntityDead( ped ) ) then 
            DisableControlAction( 0, 36, true ) -- INPUT_DUCK

            if ( not IsPauseMenuActive() ) then 
                if ( IsDisabledControlJustPressed( 0, 36 ) ) then 
                    RequestAnimSet( "move_ped_crouched" )

                    while ( not HasAnimSetLoaded( "move_ped_crouched" ) ) do 
                        Citizen.Wait( 100 )
                    end 

                    if ( crouched == true ) then 
                        ResetPedMovementClipset( ped, 0 )
                        crouched = false 
                    elseif ( crouched == false ) then
                        SetPedMovementClipset( ped, "move_ped_crouched", 0.25 )
                        crouched = true 
                    end 
                end
            end 
        end 
    end
end )

