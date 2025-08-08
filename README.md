<img width="1617" height="999" alt="image" src="https://github.com/user-attachments/assets/9bc1d21f-3467-4726-aa4d-61d8da10b3c2" /># Safe Zones Script

## Description
This script creates customizable safe zones (protected areas) in your game environment where PvP is disabled and players receive visual/UI feedback.

## Features
- 🛡️ Configurable safe zones with radius control
- 🎨 Customizable marker colors for each zone
- ℹ️ Optional UI notifications when entering/exiting zones
- 📍 Map blips showing zone locations
- 👥 Player/NPC transparency effects in zones
- 🚗 Vehicle collision disablement in zones

## Installation
1. Add `config.lua` and `client.lua` to your resources
2. Configure zones in `config.lua`
3. Ensure required dependencies (like lib) are installed

## Configuration
Edit `config.lua` to:
- Enable/disable PvP in zones
- Toggle markers, UI elements and blips
- Define your safe zones with:
  - Name
  - Center coordinates 
  - Radius
  - RGB color values

```lua
Config.SafeZonesList = {
    {
        name = "Hospital Area",
        coords = vector3(272.51, -580.33, 43.17),
        radius = 50.0,
        color = {r = 0, g = 255, b = 0}
    }
    -- Add more zones as needed
}
```

## Dependencies
- [lib](https://overextended.dev/) (for UI elements)

## Support
For issues or feature requests, please open an issue on GitHub.

<img width="1617" height="999" alt="image" src="https://github.com/user-attachments/assets/60079bce-0556-496e-907a-c38224e9ebe9" />

