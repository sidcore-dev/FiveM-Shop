# Universal Shop v2.0

Marker-based store resource that auto-detects **ESX**, **QBX** (`qbx-core`), or **QBCore** (`qb-core`) and adapts its money/inventory/menu calls to whichever is running. Walk up to a shop, press **E**, buy items from the list.

**Author:** choda

## Features

- Multiple shop locations, each with its own item list, prices, and (optionally) an access-restricted "black market" style shop, fully config-driven
- Green marker + blip at each shop, only rendered/checked near the player for performance
- Purchases validated entirely server-side — the item and price are looked up from `Config.Shops` by name, the client can't spoof a price
- **Permission-gated shops** — any shop can require an ace permission to even see it (see [Permissions](#permissions)); off by default so every shop is public
- Framework bridge auto-picks the right money/inventory calls (ESX `xPlayer.getMoney()`/`addInventoryItem()` vs QBCore/QBX `Functions.RemoveMoney()`/`Functions.AddItem()`) and the right menu (`esx_menu_default` vs `qb-menu`)

## Requirements

- A running FiveM server with one of: [es_extended](https://github.com/esx-framework/esx_core), [qbx-core](https://github.com/Qbox-project/qbx_core), or [qb-core](https://github.com/qbcore-framework/qb-core)
- The matching menu resource: `esx_menu_default` for ESX, or `qb-menu` for QBX/QBCore (both ship with their respective framework installs)

## Installation

1. Copy the `shop` folder into your server's `resources` directory.
2. In `server.cfg`, make sure your framework (and its menu resource) starts first, e.g. for QBCore:
   ```
   ensure qb-core
   ensure qb-menu
   ensure shop
   ```
   or for ESX:
   ```
   ensure es_extended
   ensure esx_menu_default
   ensure shop
   ```
3. Restart your server (or run `refresh` + `ensure shop`).

## Usage

Walk within range of a shop marker, press **E**, pick an item from the menu. Money is deducted and the item is added to your inventory immediately; you'll get an on-screen notification either way (success or "not enough money"). Shops you don't have permission for simply won't show a marker or respond to E.

## Permissions

Each shop can optionally require an ace permission to browse it at all — useful for a black-market or job-restricted shop. This is a simple on/off gate per shop (not tiered like the Admin Menu), controlled by `Config.UsePermissions`:

```
add_ace group.smuggler shop.blackmarket allow
add_principal identifier.license:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx group.smuggler
```

Set `Config.UsePermissions = true` and give a shop a `permission` string (see `Config.Shops` below) to restrict it; leave `permission = nil` on any shop to keep it public regardless of the master switch.

## Configuration

All settings live in [`config.lua`](config.lua).

| Setting | Type | Default | Description |
|---|---|---|---|
| `Config.MarkerColor` | table | `{ r=50, g=200, b=50 }` | RGB color of the shop marker. |
| `Config.MarkerRadius` | number | `1.2` | Marker radius. |
| `Config.InteractDistance` | number | `2.0` | Distance at which the "Press E" prompt appears and E is accepted. |
| `Config.DrawDistance` | number | `15.0` | Distance at which a shop starts being tracked/drawn at all. |
| `Config.UsePermissions` | boolean | `false` | Master switch for shop-level access restrictions. |
| `Config.Shops` | table | see below | List of shops: coords, blip, optional permission, and items. |

### Adding a shop

```lua
Config.Shops = {
    {
        label = 'General Store - Legion Square',
        coords = vector3(215.0, -800.0, 30.5),
        blip = { sprite = 52, color = 2, scale = 0.8 }, -- set to nil to hide the blip
        permission = nil, -- or e.g. 'shop.blackmarket' to restrict it
        items = {
            { item = 'bread', label = 'Bread', price = 4 },
            -- item must match a valid item name in your framework's item table
        },
    },
}
```

## File structure

```
shop/
├── fxmanifest.lua   Resource manifest
├── config.lua        Shop locations, items, prices, permissions, marker settings
├── client.lua         Framework bridge, marker rendering, blips, shop menu (ESX/QBX/QBCore)
├── server.lua         Framework bridge, authoritative price lookup, permission checks, money/inventory
├── LICENSE            MIT license
├── CHANGELOG.md        Version history
└── .gitignore          OS/editor clutter
```
