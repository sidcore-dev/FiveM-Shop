--[[
    ESX Shop v1.0
    Author: choda
]]

local ESX = exports['es_extended']:getSharedObject()

-- Looks up a shop + item entry from Config by name, so price is always
-- authoritative server-side and never trusted from the client.
local function FindItem(shopLabel, itemName)
    for _, shop in ipairs(Config.Shops) do
        if shop.label == shopLabel then
            for _, entry in ipairs(shop.items) do
                if entry.item == itemName then
                    return entry
                end
            end
            return nil
        end
    end
    return nil
end

RegisterServerEvent('esxshop:buyItem')
AddEventHandler('esxshop:buyItem', function(shopLabel, itemName)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    local entry = FindItem(shopLabel, itemName)
    if not entry then
        TriggerClientEvent('esxshop:notify', src, 'That item is not available here.')
        return
    end

    if xPlayer.getMoney() < entry.price then
        TriggerClientEvent('esxshop:notify', src, 'You don\'t have enough money.')
        return
    end

    xPlayer.removeMoney(entry.price)
    xPlayer.addInventoryItem(entry.item, 1)
    TriggerClientEvent('esxshop:notify', src, ('Bought %s for $%d.'):format(entry.label, entry.price))
end)
