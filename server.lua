--[[
    Universal Shop v2.0
    Author: choda
]]

Framework = { Name = 'standalone', Object = nil }

if GetResourceState('es_extended') == 'started' then
    Framework.Name = 'esx'
    Framework.Object = exports['es_extended']:getSharedObject()
elseif GetResourceState('qbx-core') == 'started' then
    Framework.Name = 'qbx'
    Framework.Object = exports['qbx-core']:GetCoreObject()
elseif GetResourceState('qb-core') == 'started' then
    Framework.Name = 'qbcore'
    Framework.Object = exports['qb-core']:GetCoreObject()
end

if Framework.Name == 'standalone' then
    print('^1[shop]^7 No supported framework (ESX/QBX/QBCore) detected - this resource requires one of them.')
end

local function GetPlayer(src)
    if Framework.Name == 'esx' then
        return Framework.Object.GetPlayerFromId(src)
    elseif Framework.Name == 'qbcore' or Framework.Name == 'qbx' then
        return Framework.Object.Functions.GetPlayer(src)
    end
    return nil
end

local function GetMoney(xPlayer)
    if Framework.Name == 'esx' then
        return xPlayer.getMoney()
    else
        return xPlayer.PlayerData.money['cash'] or 0
    end
end

local function RemoveMoney(xPlayer, amount)
    if Framework.Name == 'esx' then
        xPlayer.removeMoney(amount)
    else
        xPlayer.Functions.RemoveMoney('cash', amount)
    end
end

local function AddItem(xPlayer, item, count)
    if Framework.Name == 'esx' then
        xPlayer.addInventoryItem(item, count)
    else
        xPlayer.Functions.AddItem(item, count)
    end
end

local function HasShopAccess(src, shop)
    if not Config.UsePermissions or not shop.permission then return true end
    return IsPlayerAceAllowed(src, shop.permission)
end

-- Looks up a shop + item entry from Config by name, so price is always
-- authoritative server-side and never trusted from the client.
local function FindItem(shopLabel, itemName)
    for _, shop in ipairs(Config.Shops) do
        if shop.label == shopLabel then
            for _, entry in ipairs(shop.items) do
                if entry.item == itemName then
                    return entry, shop
                end
            end
            return nil
        end
    end
    return nil
end

RegisterNetEvent('shop:requestAllowed')
AddEventHandler('shop:requestAllowed', function()
    local src = source
    local allowed = {}
    for _, shop in ipairs(Config.Shops) do
        if HasShopAccess(src, shop) then
            allowed[#allowed + 1] = shop.label
        end
    end
    TriggerClientEvent('shop:setAllowed', src, allowed)
end)

RegisterNetEvent('shop:buyItem')
AddEventHandler('shop:buyItem', function(shopLabel, itemName)
    local src = source
    if Framework.Name == 'standalone' then return end

    local xPlayer = GetPlayer(src)
    if not xPlayer then return end

    local entry, shop = FindItem(shopLabel, itemName)
    if not entry or not shop then
        TriggerClientEvent('shop:notify', src, 'That item is not available here.')
        return
    end

    if not HasShopAccess(src, shop) then
        TriggerClientEvent('shop:notify', src, 'You do not have permission to buy from this shop.')
        return
    end

    if GetMoney(xPlayer) < entry.price then
        TriggerClientEvent('shop:notify', src, 'You don\'t have enough money.')
        return
    end

    RemoveMoney(xPlayer, entry.price)
    AddItem(xPlayer, entry.item, 1)
    TriggerClientEvent('shop:notify', src, ('Bought %s for $%d.'):format(entry.label, entry.price))
end)
