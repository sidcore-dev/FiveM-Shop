Config = {}

Config.MarkerColor = { r = 50, g = 200, b = 50 }
Config.MarkerRadius = 1.2
Config.InteractDistance = 2.0
Config.DrawDistance = 15.0

-- Master switch for shop-level access restrictions. If false, every shop
-- is open to everyone and `permission` fields below are ignored.
Config.UsePermissions = false

-- Each shop: a coord to stand near, a blip, an optional ace permission
-- to restrict who can browse it at all, and a list of items it sells.
-- `item` must match a valid item name in your framework's item table.
Config.Shops = {
    {
        label = 'General Store - Legion Square',
        coords = vector3(215.0, -800.0, 30.5),
        blip = { sprite = 52, color = 2, scale = 0.8 },
        permission = nil, -- open to everyone regardless of Config.UsePermissions
        items = {
            { item = 'bread',    label = 'Bread',    price = 4 },
            { item = 'water',    label = 'Water',     price = 3 },
            { item = 'sandwich', label = 'Sandwich',  price = 6 },
            { item = 'phone',    label = 'Phone',     price = 500 },
        },
    },
    {
        label = 'General Store - Sandy Shores',
        coords = vector3(1961.7, 3739.9, 32.3),
        blip = { sprite = 52, color = 2, scale = 0.8 },
        permission = nil,
        items = {
            { item = 'bread',   label = 'Bread',   price = 4 },
            { item = 'water',   label = 'Water',    price = 3 },
            { item = 'bandage', label = 'Bandage',  price = 15 },
        },
    },
    {
        label = 'Black Market - Storm Drain',
        coords = vector3(970.0, -2144.0, 30.5),
        blip = nil, -- unlisted on the map
        permission = 'shop.blackmarket', -- only checked if Config.UsePermissions = true
        items = {
            { item = 'lockpick', label = 'Lockpick', price = 250 },
        },
    },
}
