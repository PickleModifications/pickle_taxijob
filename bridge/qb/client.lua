if GetResourceState('qb-core') ~= 'started' then return end

QBCore = exports['qb-core']:GetCoreObject()

function ServerCallback(name, cb, ...)
    QBCore.Functions.TriggerCallback(name, cb,  ...)
end

function ShowNotification(text)
    if Config.UseOxNotify == true then 
        lib.notify({
            description = text
        })
    else
	QBCore.Functions.Notify(text)
end

function ShowHelpNotification(text)
    AddTextEntry('qbHelpNotification', text)
    BeginTextCommandDisplayHelp('qbHelpNotification')
    EndTextCommandDisplayHelp(0, false, false, -1)
end

function GetPlayersInArea(coords, maxDistance)
    return QBCore.Functions.GetPlayersFromCoords(coords, maxDistance)
end

function CanAccessGroup(data)
    if not data then return true end
    local pdata = QBCore.Functions.GetPlayerData()
    for k,v in pairs(data) do 
        if (pdata.job.name == k and pdata.job.grade.level >= v) then return true end
    end
    return false
end 

function AccessBossMenu(businessID)
    local cfg = Config.Businesses[businessID]
    if not CanAccessGroup(cfg.bossgroups) then 
        return ShowNotification(_L("no_access"))
    end
    TriggerEvent('qb-bossmenu:client:OpenMenu')
end

RegisterNetEvent(GetCurrentResourceName()..":showNotification", function(text)
    ShowNotification(text)
end)
