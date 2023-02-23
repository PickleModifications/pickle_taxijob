if GetResourceState('es_extended') ~= 'started' then return end

ESX = exports.es_extended:getSharedObject()

function RegisterCallback(name, cb)
    ESX.RegisterServerCallback(name, cb)
end

function RegisterUsableItem(...)
    ESX.RegisterUsableItem(...)
end

function ShowNotification(target, text)
	if Config.UseOxNotify == true then
	TriggerClientEvent('ox_lib:notify', target, {description = text})
	else
	TriggerClientEvent(GetCurrentResourceName()..":showNotification", target, text)
end

function Search(source, name)
    local xPlayer = ESX.GetPlayerFromId(source)
    if (name == "money") then
        return xPlayer.getMoney()
    elseif (name == "bank") then
        return xPlayer.getAccount('bank').money
    else
        local item = xPlayer.getInventoryItem(name)
        if item ~= nil then 
            return item.count
        else
            return 0
        end
    end
end

function AddItem(source, name, amount, metadata)
    local xPlayer = ESX.GetPlayerFromId(source)
    if (name == "money") then
        return xPlayer.addMoney(amount)
    elseif (name == "bank") then
        return xPlayer.addAccountMoney('bank', amount)
    else
        return exports.ox_inventory:AddItem(source, name, amount, metadata)
    end
end

function RemoveItem(source, name, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    if (name == "money") then
        return xPlayer.removeMoney(amount)
    elseif (name == "bank") then
        return xPlayer.removeAccountMoney('bank', amount)
    else
        return xPlayer.removeInventoryItem(name, amount)
    end
end

function CanAccessGroup(source, data)
    if not data then return true end
    local pdata = ESX.GetPlayerFromId(source)
    for k,v in pairs(data) do 
        if (pdata.job.name == k and pdata.job.grade >= v) then return true end
    end
    return false
end 

function GetIdentifier(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    return xPlayer.identifier
end

-- REMOVE BELOW IF NOT USING ESX SOCIETY

for i=1, #Config.Businesses do 
    local cfg = Config.Businesses[i]
    local society = cfg.info.society
    TriggerEvent('esx_society:registerSociety', society, society, 'society_'..society, 'society_'..society, 'society_'..society, {type = 'public'})
end
