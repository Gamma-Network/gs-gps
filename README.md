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

## Commands

- **/setgps [number] [department]**: Set a GPS location for police.
- **/setgps [number]**: Set a GPS location for EMS.
- **/closegps**: Close the GPS if you have the GPS item.

## Usage

1. **Open GPS**: Use the `/setgps` command to open the GPS interface and enter the required information.
2. **Close GPS**: Use the `/closegps` command to close the GPS.

## Screenshots

![GPS Screenshot](link_to_screenshot)

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository.
2. Create a new branch for your feature or fix.
3. Submit a pull request with a description of your changes.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
