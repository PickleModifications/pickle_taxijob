if GetResourceState('es_extended') ~= 'started' then return end

ESX = exports.es_extended:getSharedObject()

function ShowNotification(text)
	ESX.ShowNotification(text)
end

function ShowHelpNotification(text)
	ESX.ShowHelpNotification(text)
end

function ServerCallback(name, cb, ...)
    ESX.TriggerServerCallback(name, cb,  ...)
end

function GetPlayersInArea(coords, maxDistance)
    return ESX.Game.GetPlayersInArea(coords, maxDistance)
end

function CanAccessGroup(data)
    if not data then return true end
    local pdata = ESX.GetPlayerData()
    for k,v in pairs(data) do 
        if (pdata.job.name == k and pdata.job.grade >= v) then return true end
    end
    return false
end 

function AccessBossMenu(businessID)
    local cfg = Config.Businesses[businessID]
    if not CanAccessGroup(cfg.bossgroups) then 
        return ShowNotification(_L("no_access"))
    end
    TriggerEvent('esx_society:openBossMenu', cfg.info.society, function(data, menu)
        menu.close()
    end, {
        withdraw = false,
        deposit = false,
        wash = true,
        employees = true,
        grades = false
    })
end

RegisterNetEvent(GetCurrentResourceName()..":showNotification", function(text)
    ShowNotification(text)
end)