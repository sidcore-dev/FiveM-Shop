Config = {}

Config.MarkerColor = { r = 50, g = 200, b = 50 }
Config.MarkerRadius = 1.2
Config.InteractDistance = 2.0
Config.DrawDistance = 15.0

-- Each shop: a coord to stand near, a blip, and a list of items it sells.
-- `item` must match a valid item name in your es_extended `items` table.
Config.Shops = {
    {
        label = 'General Store - Legion Square',
        coords = vector3(215.0, -800.0, 30.5),
        blip = { sprite = 52, color = 2, scale = 0.8 },
        items = {
            { item = 'bread',  label = 'Bread',       price = 4 },
            { item = 'water',  label = 'Water',        price = 3 },
            { item = 'sandwich', label = 'Sandwich',   price = 6 },
            { item = 'phone',  label = 'Phone',        price = 500 },
        },
    },
    {
        label = 'General Store - Sandy Shores',
        coords = vector3(1961.7, 3739.9, 32.3),
        blip = { sprite = 52, color = 2, scale = 0.8 },
        items = {
            { item = 'bread',  label = 'Bread',       price = 4 },
            { item = 'water',  label = 'Water',        price = 3 },
            { item = 'bandage', label = 'Bandage',     price = 15 },
        },
    },
}
