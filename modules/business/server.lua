Players = {}

function GetPlayer(source, createIfEmpty)
    if Players[source] then 
        return Players[source]
    elseif createIfEmpty then 
        Players[source] = {}
        return Players[source]
    end
end

function SetDutyStatus(source, businessID, bool)
    local player = GetPlayer(source, true)
    Players[source].BUSINESS = businessID
    Players[source].DUTY = bool
    TriggerClientEvent("pickle_taxijob:onDutyUpdate", source, businessID, bool)
end

RegisterNetEvent("pickle_taxijob:setDutyStatus", function(businessID, bool) 
    if type(businessID) ~= "boolean" then 
        local cfg = Config.Businesses[businessID]
        if CanAccessGroup(cfg.groups) then
            SetDutyStatus(source, businessID, bool)
            ShowNotification(source, _L("duty_toggle", bool and "on" or "off", cfg.info.label))
        else
            ShowNotification(source, _L("no_access"))
        end
    else
        SetDutyStatus(source, nil, false)
        ShowNotification(source, _L("duty_forceoff"))
    end
end)