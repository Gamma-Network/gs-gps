local QBCore = exports['qb-core']:GetCoreObject()
local PlayerData, playerCoordsData, blips, activeBlips, carBlips = {}, {}, {}, {}, {}
local activeGps, activeCarBlip, policeBlip = false, false, false
local lastGpsText = ""

local playerCoordsData = {}



exports("GetPlayerCoordsData", function()
    return playerCoordsData
end)

RegisterNetEvent("gs-gps:update")
AddEventHandler("gs-gps:update", function(data)
    playerCoordsData = data
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
end)

RegisterNetEvent("gs-gps:update")
AddEventHandler("gs-gps:update", function(data)
	playerCoordsData = data
end)

AddEventHandler('gs:playerdead', function(dead)
	if activeGps and dead then 
		TriggerServerEvent("gs-gps:closegps", true)
	end
end)

RegisterNetEvent('gs-emerhencyblips:forceClose')
AddEventHandler('gs-emerhencyblips:forceClose', function()
	if activeGps then 
		TriggerServerEvent("gs-gps:closegps", false)
	end
end)

RegisterNetEvent('gs-gps:updateAllData')
AddEventHandler('gs-gps:updateAllData', function(pData, cData)
	blips = pData
	carBlips = cData
end)

RegisterNetEvent('gs-gps:removePlayerGps')
AddEventHandler('gs-gps:removePlayerGps', function(src, pData, cData)
	blips = pData
	carBlips = cData
	Citizen.Wait(500)
	RemoveBlip(activeBlips[tostring(src)])
end)

RegisterNetEvent('gs-gps:toggle')
AddEventHandler('gs-gps:toggle', function(active, data, policeBlipData)
	policeBlip = policeBlipData
	lastGpsText = data
	activeGps = active
	if not activeGps then
		SetBlipDisplay(GetMainPlayerBlipId(), 4)
		for src, blipData in pairs(activeBlips) do
			RemoveBlip(blipData)
		end
		activeBlips = {}
	else
		SetBlipDisplay(GetMainPlayerBlipId(), 1)
	end
end)

RegisterNetEvent('gs-closest-police')
AddEventHandler('gs-closest-police', function(cb) 
	local closestPolice = 0
	local policeCount = 0
	for src, info in pairs(blips) do
		if info.blipColor == 29 then
			policeCount = policeCount + 1
			local playerIndex = GetPlayerFromServerId(src)
			if playerIndex ~= -1 then
				if #(GetEntityCoords(GetPlayerPed(playerIndex)) - GetEntityCoords(PlayerPedId())) < 250 then
					closestPolice = closestPolice + 1
				end
			end
		end
	end
	cb({closestPolice = closestPolice, policeCount = policeCount}) 
end)

CreateThread(function()
    while true do
        Wait(1000)
    local hasItem = exports['qb-inventory']:HasItem('gps', 1)
        if activeGps then
            if not hasItem then
		TriggerServerEvent('gs-gps:closegps', false)
            end
        end
    end
end)

Citizen.CreateThread(function()
	while true do
		if activeGps then
			local allBlips = exports["gs-gps"]:GetPlayerCoordsData()
			for src, info in pairs(blips) do
				local playerid = GetPlayerFromServerId(PlayerPedId())
				local ped = GetPlayerPed(playerid)
				local playerBlips = allBlips[src]
				if playerBlips then
					if DoesBlipExist(activeBlips[src]) then
						SetBlipCoords(activeBlips[src], playerBlips.x, playerBlips.y, playerBlips.z)
						if GetBlipSprite(activeBlips[src]) ~= info.blipType then
							SetBlipSprite(activeBlips[src], info.blipType or 2)
						end						
						SetBlipColour(activeBlips[src], info.blipColor)
						SetBlipScale(activeBlips[src], info.blipScale)
						BeginTextCommandSetBlipName("STRING")
						if info.carBlip then
							AddTextComponentString(carBlips[info.carPlate].text)
						else
							AddTextComponentString(info.blipText)
						end
						EndTextCommandSetBlipName(activeBlips[src])
					else
						if info.blipText ~= "Don't Know" then
							local blip = AddBlipForCoord(playerBlips.x, playerBlips.y, playerBlips.z)
							SetBlipSprite(blip, info.blipType or 2)
							SetBlipColour(blip, info.blipColor)
							SetBlipAsShortRange(blip, true)
							SetBlipScale(blip, info.blipScale)
							SetBlipDisplay(blip, 4)
							SetBlipShowCone(blip, true)
							BeginTextCommandSetBlipName("STRING")
							AddTextComponentString(info.blipText)
							EndTextCommandSetBlipName(blip)
							activeBlips[tostring(src)] = blip
						end
					end
				end

			end
		end
		Citizen.Wait(100)
	end
end)

local lastPlate = ""
local serverDataUpdated = false
local lastBlipType = 1

Citizen.CreateThread(function()
    while true do
        if activeGps and policeBlip then
            local playerPed = PlayerPedId()
            local vehicle = GetVehiclePedIsIn(playerPed)
            local blipType = IsVehicleSirenOn(vehicle) and 42 or 1
            local blipScale = Config.BlipSettings.normal_blip_scale

            if IsPedInAnyVehicle(playerPed) then
                if not QBCore.Functions.GetPlayerData().metadata["isdead"] then
                    local updatedBlip = false

                    if not IsVehicleSirenOn(vehicle) then
                        blipType = 1
                        blipScale = Config.BlipSettings.normal_blip_scale
                    else
                        blipType = 42
                        blipScale = Config.BlipSettings.flashing_blip_scale
                    end

                    TriggerServerEvent("gs-gps:updatePlayerGps", false, 1, true, blipType, blipScale)

                    if not activeCarBlip then
                        lastPlate = QBCore.Shared.Trim(GetVehicleNumberPlateText(vehicle))
                        for carPlate, data in pairs(carBlips) do
                            if lastPlate == carPlate then
                                activeCarBlip = true
                                updatedBlip = true
                                TriggerServerEvent("gs-gps:updatePlayerGps", false, 1, true, blipType, blipScale)
                            end
                        end
                    end

                    if (not updatedBlip and not serverDataUpdated) or lastBlipType ~= blipType then
                        serverDataUpdated = true
                        TriggerServerEvent("gs-gps:updatePlayerGps", false, 1, true, blipType, blipScale)
                    end
                    lastBlipType = blipType
                else
                    blipType = 274
                    blipScale = Config.BlipSettings.dead_blip_scale
                    TriggerServerEvent("gs-gps:updatePlayerGps", false, 1, true, blipType, blipScale)
                end
            else
                if not QBCore.Functions.GetPlayerData().metadata["isdead"] then
                    blipScale = Config.BlipSettings.police_blip_scale
                    TriggerServerEvent("gs-gps:updatePlayerGps", false, 1, true, blipType, blipScale)
                else
                    blipType = 274
                    blipScale = Config.BlipSettings.dead_blip_scale
                    TriggerServerEvent("gs-gps:updatePlayerGps", false, 1, true, blipType, blipScale)
                end
            end
        end
        Citizen.Wait(300)
    end
end)

RegisterNetEvent("gs-gps:open")
AddEventHandler("gs-gps:open", function()
	local PlayerData = QBCore.Functions.GetPlayerData()
    local hasItem = exports['qb-inventory']:HasItem('gps', 1)
    if hasItem then
        if PlayerData.job.name == 'police' then 
            local keyboard = exports['qb-input']:ShowInput({
                header = Config.Locales.input_header,
                submitText = Config.Locales.submit_text,
                inputs = {
                    {
                        type = 'text',
                        isRequired = true,
                        text = Config.Locales.gps_number_prompt,
                        name = 'input',
                    },
                    {
                        text = Config.Locales.department_prompt,
                        name = "someselect",
                        type = "select",
                        options = Config.PoliceDepartments
                    }
                }
            })
            local gpscolor = keyboard.someselect
            if gpscolor == nil then gpscolor = "pd" end
            local number = keyboard.input
            TriggerServerEvent('gs-gps:addcop', number, tostring(gpscolor))
        elseif PlayerData.job.name == 'ambulance' then
            local keyboard = exports['qb-input']:ShowInput({
                header = Config.Locales.input_header,
                submitText = Config.Locales.submit_text,
                inputs = {
                    {
                        type = 'text',
                        isRequired = true,
                        text = Config.Locales.gps_number_prompt,
                        name = 'input',
                    },
                    {
                        text = Config.Locales.select_department,
                        name = "someselect",
                        type = "select",
                        options = Config.EMSDepartment
                    }
                }
            })
            local number = keyboard.input
            TriggerServerEvent('gs-gps:addmedic', number)
        else
            QBCore.Functions.Notify(Config.Locales.not_police_or_doctor, "error")
        end
    else
        QBCore.Functions.Notify(Config.Locales.no_gps)	
    end
end)

RegisterNetEvent("gs-gps:close")
AddEventHandler("gs-gps:close", function()
    local hasItem = exports['qb-inventory']:HasItem('gps', 1) 
    if hasItem then
        TriggerServerEvent('gs-gps:closegps', false)
    else
        QBCore.Functions.Notify(Config.Locales.no_gps, 'error')    
    end
end)
