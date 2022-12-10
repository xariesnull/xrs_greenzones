settings = {
    greenzone = nil,
    dist = nil,
    ingz = false,
    check = false,
    ped = nil,
    coords = nil,
    player = nil
}

local entityEnumerator = {
    __gc = function(enum)
      if enum.destructor and enum.handle then
        enum.destructor(enum.handle)
      end
      enum.destructor = nil
      enum.handle = nil
    end
}

settings.EnumerateEntities = function(initFunc, moveFunc, disposeFunc)
    return coroutine.wrap(function()
        local iter, id = initFunc()
        if not id or id == 0 then
        disposeFunc(iter)
        return
        end
        
        local enum = {handle = iter, destructor = disposeFunc}
        setmetatable(enum, entityEnumerator)
        
        local next = true
        repeat
        coroutine.yield(id)
        next, id = moveFunc(iter)
        until not next
        
        enum.destructor, enum.handle = nil, nil
        disposeFunc(iter)
    end)
end


settings.EnumeratePeds = function()
    return settings.EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end
settings.EnumerateObjects = function()
    return settings.EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end
settings.EnumerateVehicles = function()
    return settings.EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

CreateThread(function()
    Wait(1500)
    for k,v in pairs(xaries.config.greenzones) do
        if v.blip then
            if v.blipType == "radius" then
                local blip = AddBlipForRadius(v.coords.x,v.coords.y,v.coords.z,v.blipRadius)
                SetBlipColour(blip,v.blipColor)
                SetBlipAlpha(blip,v.blipAlpha)
            else
                local blip = AddBlipForCoord(v.coords.x,v.coords.y,v.coords.z)
                SetBlipSprite(blip, v.blipSprite)
                SetBlipColour(blip,v.blipColor)
                SetBlipAlpha(blip,v.blipAlpha)
                SetBlipAsShortRange(blip, true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString(v.blipName)
                EndTextCommandSetBlipName(blip)
            end
        end
    end
    while true do
        Wait(400)
        settings.greenzone = nil
        settings.ped = PlayerPedId()
        settings.coords = GetEntityCoords(PlayerPedId())
        settings.player = PlayerId()
        for k,v in pairs(xaries.config.greenzones) do
            if v.coords then
                local dist = #(settings.coords - v.coords)
                if dist < v.radius then
                    settings.dist = {dist = dist, coords = v.coords, colors = v.colors, radius = v.radius}
                    settings.greenzone = {dist = dist, coords = v.coords, changeBucket = v.changeBucket, routingBucket = v.routingBucket}
                end
            end
        end
        if not settings.greenzone then
            for vehx in settings.EnumerateVehicles() do
                SetEntityAlpha(vehx, 255, false)
            end
            for _, player in pairs(GetActivePlayers()) do
                if player ~= PlayerId() then
                    local ped = PlayerPedId()
                    local ped2 = GetPlayerPed(player)
                    local veh = GetVehiclePedIsIn(ped, false)
                    local veh2 = GetVehiclePedIsIn(ped2, false)
                    SetEntityAlpha(ped2, 255, false)
                    if veh ~= 0 then
                        SetEntityAlpha(veh, 255, false)
                    end
                    if veh2 ~= 0 then
                        SetEntityAlpha(veh2, 255, false)
                    end
                end
            end
        end
    end
end)


CreateThread(function()
    while true do
        Wait(0)
        if settings.greenzone then
            if not settings.check then
                xaries.config.callback("join")
                settings.check = true
                settings.ingz = true
                TriggerEvent("xaries:zones$hh", "in")
                if settings.greenzone.changeBucket then
                    if settings.greenzone.routingBucket ~= 0 then
                        TriggerServerEvent("xaG$changeBucket", settings.greenzone.routingBucket)
                    end
                end
            end
            settings.ingz = true
            local coords = settings.greenzone.coords
            for k,v in pairs(xaries.config.blockedKeys) do
                DisableControlAction(0,v,true)
            end
            if xaries.config.disableCollison then
                for vehx in settings.EnumerateVehicles() do
                    local ped = PlayerPedId()
                    local veh = GetVehiclePedIsIn(ped,false)
                    if veh ~= 0 then
                        SetEntityNoCollisionEntity(ped,vehx,true)
                        SetEntityNoCollisionEntity(vehx,ped,true)
                        SetEntityNoCollisionEntity(veh,vehx,true)
                        SetEntityNoCollisionEntity(vehx,veh,true)
                    else
                        SetEntityNoCollisionEntity(ped,vehx,true)
                        SetEntityNoCollisionEntity(vehx,ped,true)
                    end
                end
                for _, player in pairs(GetActivePlayers()) do
                    if player ~= PlayerId() then
                        local ped = PlayerPedId()
                        local ped2 = GetPlayerPed(player)
                        local veh = GetVehiclePedIsIn(ped, false)
                        local veh2 = GetVehiclePedIsIn(ped2,false)
                        SetEntityAlpha(ped2, 51, false)
                        if veh2 ~= 0 then
                            if veh ~= 0 then
                                SetEntityAlpha(veh, 51, false)
                                SetEntityNoCollisionEntity(veh,veh2,true)
                                SetEntityNoCollisionEntity(veh2,veh,true)
                            end
                            SetEntityAlpha(veh2, 51, false)
                            SetEntityNoCollisionEntity(ped,veh2,true)
                            SetEntityNoCollisionEntity(veh2,ped,true)
                        else
                            SetEntityNoCollisionEntity(ped,ped2,true)
                            SetEntityNoCollisionEntity(ped2,ped,true)
                        end
                    end
                end
            end
        else
            if settings.check and settings.ingz then
                xaries.config.callback("leave")
                settings.check = false
                settings.ingz = false
                TriggerEvent("xaries:zones$hh", "out")
                TriggerServerEvent("xaG$changeBucket", 0)
                for vehx in settings.EnumerateVehicles() do
                    SetEntityAlpha(vehx, 255, false)
                end
                for _, player in pairs(GetActivePlayers()) do
                    if player ~= PlayerId() then
                        local ped = PlayerPedId()
                        local ped2 = GetPlayerPed(player)
                        local veh = GetVehiclePedIsIn(ped, false)
                        local veh2 = GetVehiclePedIsIn(ped2, false)
                        SetEntityAlpha(ped2, 255, false)
                        if veh ~= 0 then
                            SetEntityAlpha(veh, 255, false)
                        end
                        if veh2 ~= 0 then
                            SetEntityAlpha(veh2, 255, false)
                        end
                    end
                end
            end
        end
        if settings.dist then
            if settings.dist.dist < (settings.dist.radius + 40.0) then
                local c = settings.dist.coords
                local colors = settings.dist.colors
                DrawSphere(c.x,c.y,c.z, settings.dist.radius, colors.r,colors.g,colors.b,colors.a)
            elseif (settings.dist.dist > (settings.dist.radius + 40.0)) then
                Wait(500)
            end
        end
    end
end)

exports("isPlayerInGreenzone", function()
    return settings.greenzone
end)

AddEventHandler("xaries:zones$hh", function(s)
    if s == "out" then
        if xaries.config.wait then
            Wait(xaries.config.waitSeconds)
            if not settings.ingz then
                ResetEntityAlpha(settings.ped)
                SetCanAttackFriendly(settings.ped,true,false)
                NetworkSetFriendlyFireOption(true)
            end
            return
        end
        if not settings.ingz then
            ResetEntityAlpha(settings.ped)
            SetCanAttackFriendly(settings.ped,true,false)
            NetworkSetFriendlyFireOption(true)
            return
        end
    end
    if s == "in" then
        Wait(250)
        ResetEntityAlpha(settings.ped)
        SetCanAttackFriendly(settings.ped,false,false)
        NetworkSetFriendlyFireOption(false)
    end
end)
