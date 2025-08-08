local inSafeZone = false
local currentZone = nil
local player = PlayerPedId()

-- Function
local function SetTransparent(ped, enabled)
    if enabled then
        SetEntityAlpha(ped, 150, false)
        SetEntityInvincible(ped, true)
    else
        ResetEntityAlpha(ped)
        SetEntityInvincible(ped, false)
    end
end

local function SetEntityTransparency(ent, enabled)
    if not DoesEntityExist(ent) then return end
    if enabled then
        SetEntityAlpha(ent, 150, false)
    else
        ResetEntityAlpha(ent)
    end
end

-- SafeZone detection
CreateThread(function()
    while true do
        Wait(1000)
        player = PlayerPedId()
        local playerCoords = GetEntityCoords(player)

        local inZone = false

        for _, zone in pairs(Config.SafeZonesList) do
            local dist = #(playerCoords - zone.coords)
            if dist <= zone.radius then
                inZone = true
                currentZone = zone
                break
            end
        end

        if inZone and not inSafeZone then
            inSafeZone = true
            if Config.EnabledPVP == false then
                SetCurrentPedWeapon(player, `WEAPON_UNARMED`, true)
                DisablePlayerFiring(player, true)
            end
            SetTransparent(player, true)
            if Config.ShowTextUI then
                lib.showTextUI('[SAFEZONE] ' .. (currentZone.name or 'You are in the safe zone.'), {
                    position = "top-center",
                    icon = 'shield',
                    style = {
                        borderRadius = 8,
                        backgroundColor = '#228B22',
                        color = 'white'
                    }
                })
            end
        elseif not inZone and inSafeZone then
            inSafeZone = false
            currentZone = nil
            SetTransparent(player, false)
            if Config.ShowTextUI then
                lib.hideTextUI()
            end
        end
    end
end)

-- PVP Blocations
CreateThread(function()
    while true do
        Wait(0)
        if inSafeZone and not Config.EnabledPVP then
            DisablePlayerFiring(player, true)
            DisableControlAction(0, 24, true) -- Mouse click
            DisableControlAction(0, 69, true)
            DisableControlAction(0, 92, true)
            DisableControlAction(0, 142, true)
            DisableControlAction(0, 106, true)
            DisableControlAction(0, 45, true) -- R key
        else
            Wait(500)
        end
    end
end)

-- Markers
if Config.ShowMarker then
    CreateThread(function()
        while true do
            Wait(0)
            for _, zone in pairs(Config.SafeZonesList) do
                DrawMarker(
                    1,
                    zone.coords.x, zone.coords.y, zone.coords.z - 1.0,
                    0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                    zone.radius * 2.0, zone.radius * 2.0, 2.0,
                    zone.color.r, zone.color.g, zone.color.b, 100,
                    false, true, 2, nil, nil, false
                )
            end
        end
    end)
end

-- Blips
if Config.ShowBlips then
    CreateThread(function()
        for _, zone in pairs(Config.SafeZonesList) do
            local blip = AddBlipForRadius(zone.coords.x, zone.coords.y, zone.coords.z, zone.radius)
            SetBlipHighDetail(blip, true)
            SetBlipColour(blip, 2)
            SetBlipAlpha(blip, 128)
        end
    end)
end

CreateThread(function()
    while true do
        Wait(2000)
        if inSafeZone then
            local pCoords = GetEntityCoords(player)

            -- Vehicles
            for _, veh in pairs(GetGamePool("CVehicle")) do
                local vCoords = GetEntityCoords(veh)
                if #(pCoords - vCoords) < (currentZone.radius + 15.0) then
                    SetEntityTransparency(veh, true)
                else
                    SetEntityTransparency(veh, false)
                end
            end

            -- NPC
            for _, ped in pairs(GetGamePool("CPed")) do
                if not IsPedAPlayer(ped) then
                    local pedCoords = GetEntityCoords(ped)
                    if #(pCoords - pedCoords) < (currentZone.radius + 15.0) then
                        SetEntityTransparency(ped, true)
                    else
                        SetEntityTransparency(ped, false)
                    end
                end
            end
        end
    end
end)

-- No-collision vehicles
CreateThread(function()
    while true do
        Wait(1000)
        if inSafeZone then
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)

            SetPedCanRagdoll(playerPed, false)
            SetEntityProofs(playerPed, true, true, true, true, true, true, true, true)

            for _, veh in pairs(GetGamePool("CVehicle")) do
                local vehCoords = GetEntityCoords(veh)
                if #(vehCoords - playerCoords) < (currentZone.radius + 15.0) then
                    SetEntityNoCollisionEntity(playerPed, veh, true)
                    SetEntityNoCollisionEntity(veh, playerPed, true)
                end
            end
        else
            local playerPed = PlayerPedId()
            SetPedCanRagdoll(playerPed, true)
            SetEntityProofs(playerPed, false, false, false, false, false, false, false, false)
        end
    end
end)