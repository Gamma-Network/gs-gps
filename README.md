# FiveM GPS Script

## Description

A FiveM GPS script that provides functionality for navigation and location tracking. It allows police and medical staff to manage and view GPS blips on the map, including car blips.

## Features

- **GPS Management**: Enable and disable GPS with commands.
- **Blip Handling**: Add, update, and remove blips for players and vehicles.
- **Department-Specific Blips**: Customizable blip colors and text for police and EMS.
- **Inventory Integration**: Check for GPS item availability before enabling GPS.
- **Dynamic Updates**: Real-time updates of player and vehicle locations.

## Installation

1. **Download or clone** this repository.
2. **Place** the `gs-gps` folder in your `resources` directory.
3. **Add** `start gs-gps` to your `server.cfg` file.

## Configuration

The configuration is done via `config.lua` and includes:

- **Locales**: Customizable text for GPS-related messages.
- **Blip Settings**: Different scales for various blip types.
- **Departments**: Configure police and EMS departments.

### Example Configuration

```lua
Config = {}

Config.Locales = {
    gps_item_check = "GPS item:",
    input_header = "GPS Number and Department Selection",
    submit_text = "Submit",
    gps_number_prompt = "Enter GPS Number",
    department_prompt = "Select Department",
    select_department = "Select Your Department",
    not_police_or_doctor = "You are not a Police Officer or Doctor",
    no_gps = "No GPS found!",
    gpsOpen = "GPS Opened",
    gpsClose = "GPS Closed",
    gpsError = "GPS Couldn't Open",
    jobDutyMessage = "You were taken off duty because you were injured"
}

Config.BlipSettings = {
    normal_blip_scale = 0.85,
    flashing_blip_scale = 0.6,
    dead_blip_scale = 1.0,
    police_blip_scale = 0.3
}

Config.PoliceDepartments = {
    { value = "pd", text = "LSPD" },
    { value = "sd", text = "BCSO" }
}

Config.EMSDepartment = {
    { value = "ems", text = "EMS" }
}
```

## Usage

1. **Add GPS Item**: Ensure the GPS item is added to your QBcore inventory. The item must be configured in your QBcore inventory system for this script to function correctly.

2. **Open GPS**: Use the `/setgps` command to open the GPS interface. You need to have the GPS item in your inventory to use this feature.

3. **Close GPS**: Use the `/closegps` command to close the GPS. You must have the GPS item to close it.

## Contributing

Contributions are welcome! Feel free to fork the repository and submit pull requests for any improvements or bug fixes.

## Legal Note

This code is open for improvements and personal usage. Any contributions that enhance functionality are highly encouraged.
<p align="center">
<img src="https://ziadoua.github.io/m3-Markdown-Badges/badges/LicenceCCBYNCND/licenceccbyncnd1.svg">
</p>

