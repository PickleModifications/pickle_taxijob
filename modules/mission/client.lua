local blip
local mission

function Destination(text, coords)
    if blip then 
        RemoveBlip(blip)
    end
    if not text then
        return
    end
    blip = CreateBlip({
        Location = coords,
        Label = text,
        ID = 1,
        Display = 4,
        Color = 5,
        Scale = 0.75
    })
    SetBlipRoute(blip, true)
    SetBlipRouteColour(blip, 5)
    return blip
end

function IsVehicleTaxi(vehicle, list) 
    local model = GetEntityModel(vehicle)
    for i=1, #list do 
        if model == list[i].model then
            return true
        end
    end
end

function StartMission(lastIndex)
    if not STATUS.DUTY then
        return ShowNotification(_L("not_duty"))
    end
    local business = Config.Businesses[STATUS.BUSINESS]
    local cfg = Config.Missions
    mission = {}
    mission.from = GetRandomInt(1, #cfg.locations, lastIndex)
    mission.to = GetRandomInt(1, #cfg.locations, mission.from)
    mission.model = cfg.models[GetRandomInt(1, #cfg.models)]
    mission.ped = nil
    mission.taxi = GetVehiclePedIsIn(PlayerPedId())
    mission.status = "pickup"
    
    if GetPedInVehicleSeat(mission.taxi, 2) ~= 0 then 
        return ShowNotification(_L("taxi_occupied"))
    end

    if GetPedInVehicleSeat(mission.taxi, -1) ~= PlayerPedId() or not IsVehicleTaxi(mission.taxi, business.vehicles) then 
        return ShowNotification(_L("not_driver"))
    end

    if (mission and mission.status == "pickup") then
        local coords, heading = v3(cfg.locations[mission.from])
        local enteringVehicle = false

        ShowNotification(_L("taxi_pickup"))
        Destination(_L("taxi_pickup_blip"), coords)

        while mission and mission.status == "pickup" do 
            local wait = 1000
            local ped = PlayerPedId()
            local pedCoords = GetEntityCoords(ped)
            local dist = #(coords - pedCoords)
            if (not DoesEntityExist(mission.taxi) or GetEntityHealth(mission.taxi) == 0) then 
                mission.status = "fail"
            end
            if (dist < 60.0) then 
                if not mission.ped then
                    enteringVehicle = false
                    mission.ped = CreateNPC(mission.model, coords.x, coords.y, coords.z, heading, true, true)
                else
                    if IsEntityDead(mission.ped) then 
                        mission.status = "fail"
                    end
                    if (dist < 10.0 and not enteringVehicle) then 
                        enteringVehicle = true
                        TaskEnterVehicle(mission.ped, mission.taxi, -1, 2, 2.0, 1, 0)
                    elseif GetVehiclePedIsIn(mission.ped) == mission.taxi then
                        mission.status = "dropoff"
                    end
                end
            elseif mission.ped then
                DeleteEntity(mission.ped)
                mission.ped = nil
            end
            Wait(wait)
        end
    end
    
    if (mission and mission.status == "dropoff") then
        local coords, heading = v3(cfg.locations[mission.to])
        local exitingVehicle = false

        ShowNotification(_L("taxi_dropoff"))
        Destination(_L("taxi_dropoff_blip"), coords)

        while mission and mission.status == "dropoff" do 
            local wait = 1000
            local ped = PlayerPedId()
            local pedCoords = GetEntityCoords(ped)
            local dist = #(coords - pedCoords)

            if (not DoesEntityExist(mission.taxi) or GetEntityHealth(mission.taxi) == 0) then 
                mission.status = "fail"
            end
            if (not exitingVehicle and GetVehiclePedIsIn(mission.ped) ~= mission.taxi) or (not DoesEntityExist(mission.ped) or IsEntityDead(mission.ped)) then 
                mission.status = "fail"
            end
            if (dist < 5.0 and not exitingVehicle) then 
                exitingVehicle = true
                TaskLeaveAnyVehicle(mission.ped, 1, 1)
            elseif exitingVehicle and GetVehiclePedIsIn(mission.ped) ~= mission.taxi then
                mission.status = "success"
            end
            Wait(wait)
        end
    end

    Destination()
    
    if (mission and mission.status == "success") then
        for i=-1, 4 do 
            SetVehicleDoorShut(mission.taxi, i, false)
        end

        ServerCallback("pickle_taxijob:npcMissionComplete", function(result)
            if not result then
                ShowNotification(_L("mission_fail"))
            end
        end, mission.from, mission.to)

        -- for ped animatation to walk away from taxi
        local ped = mission.ped
        TaskWanderStandard(ped, 1, 1)
        SetTimeout(5000, function()
            DeleteEntity(ped)
        end)
        
        -- start a new mission or not
        if cfg.loop then 
            StartMission(mission.to)
        else
            mission = nil
        end

    elseif (mission) then
        for i=-1, 4 do 
            SetVehicleDoorShut(mission.taxi, i, false)
        end
        ShowNotification(_L("mission_fail"))
        if cfg.loop then 
            StartMission(mission.to)
        else
            mission = nil
        end
    end
end

function StopMission()
    local _mission = mission
    mission = nil
    if _mission.ped then
        DeleteEntity(_mission.ped)
    end
    Destination()
    ShowNotification(_L("cancelled_mission"))
end

RegisterCommand("taxijob", function() 
    if mission then
        StopMission()
    else
        StartMission()
    end
end)