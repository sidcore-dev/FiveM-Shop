# ESX Shop v1.0

Marker-based general store resource for [es_extended](https://github.com/esx-framework/esx_core) (ESX legacy). Walk up to a shop, press **E**, buy items with the built-in `esx_menu_default` list.

**Author:** choda

## Features

- Multiple shop locations, each with its own item list and prices, fully config-driven
- Green marker + blip at each shop, only rendered/checked near the player for performance
- Purchases validated entirely server-side — the item and price are looked up from `Config.Shops` by name, the client can't spoof a price
- Uses standard ESX legacy exports: `xPlayer.getMoney()`, `xPlayer.removeMoney()`, `xPlayer.addInventoryItem()`

## Requirements

- A running FiveM server with [es_extended](https://github.com/esx-framework/esx_core) installed and started
- `esx_menu_default` (ships with most ESX legacy installs) for the shop list UI

## Installation

1. Copy the `esxshop` folder into your server's `resources` directory.
2. In `server.cfg`, make sure ESX and its menu resource start first:
   ```
   ensure es_extended
   ensure esx_menu_default
   ensure esxshop
   ```
3. Restart your server (or run `refresh` + `ensure esxshop`).

## Usage

Walk within range of a shop marker, press **E**, pick an item from the menu. Money is deducted and the item is added to your inventory immediately; you'll get an on-screen notification either way (success or "not enough money").

## Configuration

All settings live in [`config.lua`](config.lua).

| Setting | Type | Default | Description |
|---|---|---|---|
| `Config.MarkerColor` | table | `{ r=50, g=200, b=50 }` | RGB color of the shop marker. |
| `Config.MarkerRadius` | number | `1.2` | Marker radius. |
| `Config.InteractDistance` | number | `2.0` | Distance at which the "Press E" prompt appears and E is accepted. |
| `Config.DrawDistance` | number | `15.0` | Distance at which a shop starts being tracked/drawn at all. |
| `Config.Shops` | table | see below | List of shops: coords, blip, and items. |

### Adding a shop

```lua
Config.Shops = {
    {
        label = 'General Store - Legion Square',
        coords = vector3(215.0, -800.0, 30.5),
        blip = { sprite = 52, color = 2, scale = 0.8 }, -- set to nil to hide the blip
        items = {
            { item = 'bread', label = 'Bread', price = 4 },
            -- item must match a valid item name in your es_extended `items` table
        },
    },
}
```

## File structure

```
esxshop/
├── fxmanifest.lua   Resource manifest (declares es_extended dependency)
├── config.lua        Shop locations, items, prices, marker settings
├── client.lua         Marker rendering, blips, shop menu
└── server.lua         Authoritative price lookup, money/inventory handling
```
