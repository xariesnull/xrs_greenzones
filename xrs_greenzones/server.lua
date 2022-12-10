RegisterNetEvent("xaG$changeBucket")
AddEventHandler("xaG$changeBucket", function(bckt)
    local player = source
    local ped = GetPlayerPed(player)
    local veh = GetVehiclePedIsIn(ped, false)
    local routingVeh = false
    if veh ~= 0 then
        routingVeh = true
    end
    if bckt == "random" then
        local rndm = math.random(111111111,999999999)
        SetPlayerRoutingBucket(player,rndm)
        if routingVeh then
            SetEntityRoutingBucket(veh, rndm)
        end
        return;
    end
    if type(bckt) == "number" then
        SetPlayerRoutingBucket(player,bckt)
        if routingVeh then
            SetEntityRoutingBucket(veh, bckt)
        end
        return;
    end
end)