--[[
    ESX Shop v1.0
    Author: choda
]]

local ESX = nil

CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(0)
    end
end)

local currentShop = nil

local function OpenShopMenu(shop)
    local menuItems = {}
    for _, entry in ipairs(shop.items) do
        menuItems[#menuItems + 1] = {
            label = ('%s - $%d'):format(entry.label, entry.price),
            value = entry.item,
        }
    end

    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'esxshop_buy', {
        title = shop.label,
        align = 'top-left',
        elements = menuItems,
    }, function(data, menu)
        local itemName = data.current.value
        local entry
        for _, e in ipairs(shop.items) do
            if e.item == itemName then entry = e break end
        end
        if entry then
            TriggerServerEvent('esxshop:buyItem', shop.label, entry.item)
        end
    end, function(data, menu)
        menu.close()
    end)
end

CreateThread(function()
    while true do
        Wait(0)
        local playerCoords = GetEntityCoords(PlayerPedId())
        local nearestShop, nearestDist = nil, Config.DrawDistance

        for _, shop in ipairs(Config.Shops) do
            local dist = #(playerCoords - shop.coords)
            if dist < nearestDist then
                nearestShop, nearestDist = shop, dist
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
                currentShop = nearestShop
                BeginTextCommandDisplayHelp('STRING')
                AddTextComponentSubstringPlayerName('Press ~INPUT_CONTEXT~ to browse the shop')
                EndTextCommandDisplayHelp(0, false, true, -1)

                if IsControlJustReleased(0, 38) then -- E
                    OpenShopMenu(nearestShop)
                end
            else
                currentShop = nil
            end
        else
            currentShop = nil
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

RegisterNetEvent('esxshop:notify', function(msg)
    ESX.ShowNotification(msg)
end)
