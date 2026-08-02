--[[
    Universal Shop v2.0
    Author: choda
]]

Framework = { Name = 'standalone', Object = nil }

if GetResourceState('es_extended') == 'started' then
    Framework.Name = 'esx'
    TriggerEvent('esx:getSharedObject', function(obj) Framework.Object = obj end)
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

local function Notify(msg)
    if Framework.Name == 'esx' and Framework.Object then
        Framework.Object.ShowNotification(msg)
    elseif (Framework.Name == 'qbcore' or Framework.Name == 'qbx') and Framework.Object then
        Framework.Object.Functions.Notify(msg, 'primary')
    else
        BeginTextCommandThefeedPost('STRING')
        AddTextComponentSubstringPlayerName(msg)
        EndTextCommandThefeedPostTicker(false, false)
    end
end

-- Populated from the server on load: labels of shops this player is
-- allowed to see at all (see Config.UsePermissions / shop.permission).
local allowedShops = {}

RegisterNetEvent('shop:setAllowed', function(labels)
    allowedShops = {}
    for _, label in ipairs(labels) do
        allowedShops[label] = true
    end
end)

CreateThread(function()
    TriggerServerEvent('shop:requestAllowed')
end)

local function OpenShopMenu(shop)
    if Framework.Name == 'esx' then
        local menuItems = {}
        for _, entry in ipairs(shop.items) do
            menuItems[#menuItems + 1] = { label = ('%s - $%d'):format(entry.label, entry.price), value = entry.item }
        end

        Framework.Object.UI.Menu.CloseAll()
        Framework.Object.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_buy', {
            title = shop.label,
            align = 'top-left',
            elements = menuItems,
        }, function(data, menu)
            TriggerServerEvent('shop:buyItem', shop.label, data.current.value)
        end, function(data, menu)
            menu.close()
        end)
    else -- qbcore / qbx (qb-menu)
        local menu = { { header = shop.label, isMenuHeader = true } }
        for _, entry in ipairs(shop.items) do
            menu[#menu + 1] = {
                header = ('%s - $%d'):format(entry.label, entry.price),
                params = { event = 'shop:client:buy', args = { shopLabel = shop.label, item = entry.item } },
            }
        end
        exports['qb-menu']:openMenu(menu)
    end
end

RegisterNetEvent('shop:client:buy', function(data)
    TriggerServerEvent('shop:buyItem', data.shopLabel, data.item)
end)

CreateThread(function()
    while true do
        Wait(0)
        local playerCoords = GetEntityCoords(PlayerPedId())
        local nearestShop, nearestDist = nil, Config.DrawDistance

        for _, shop in ipairs(Config.Shops) do
            if allowedShops[shop.label] then
                local dist = #(playerCoords - shop.coords)
                if dist < nearestDist then
                    nearestShop, nearestDist = shop, dist
                end
            end
        end

        if nearestShop then
            DrawMarker(
                2, nearestShop.coords.x, nearestShop.coords.y, nearestShop.coords.z - 0.9,
                0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                Config.MarkerRadius, Config.MarkerRadius, 0.6,
                Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 150,
                false, true, 2, false, nil, nil, false
            )

            if nearestDist < Config.InteractDistance then
                BeginTextCommandDisplayHelp('STRING')
                AddTextComponentSubstringPlayerName('Press ~INPUT_CONTEXT~ to browse the shop')
                EndTextCommandDisplayHelp(0, false, true, -1)

                if IsControlJustReleased(0, 38) then -- E
                    OpenShopMenu(nearestShop)
                end
            end
        else
            Wait(500)
        end
    end
end)

CreateThread(function()
    for _, shop in ipairs(Config.Shops) do
        if shop.blip then
            local blip = AddBlipForCoord(shop.coords.x, shop.coords.y, shop.coords.z)
            SetBlipSprite(blip, shop.blip.sprite)
            SetBlipColour(blip, shop.blip.color)
            SetBlipScale(blip, shop.blip.scale)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentSubstringPlayerName(shop.label)
            EndTextCommandSetBlipName(blip)
        end
    end
end)

RegisterNetEvent('shop:notify', function(msg)
    Notify(msg)
end)
