--[[
    FRG Mods - Door Pop Script
    Standalone FiveM vehicle door keybind script
]]

local Config = {}

Config.SearchDistance = 6.0

-- You can change these default keys here.
-- Players can also change them in FiveM Keybind Settings.
Config.Doors = {
    {
        command = "pop_lfdoor",
        description = "Pop Left Front Door",
        defaultKey = "NUMPAD4",
        doorIndex = 0,
        message = "Left front door popped"
    },
    {
        command = "pop_rfdoor",
        description = "Pop Right Front Door",
        defaultKey = "NUMPAD6",
        doorIndex = 1,
        message = "Right front door popped"
    },
    {
        command = "pop_lrdoor",
        description = "Pop Left Rear Door",
        defaultKey = "NUMPAD7",
        doorIndex = 2,
        message = "Left rear door popped"
    },
    {
        command = "pop_rrdoor",
        description = "Pop Right Rear Door",
        defaultKey = "NUMPAD9",
        doorIndex = 3,
        message = "Right rear door popped"
    },
    {
        command = "pop_hood",
        description = "Pop Hood",
        defaultKey = "NUMPAD8",
        doorIndex = 4,
        message = "Hood popped"
    },
    {
        command = "pop_trunk",
        description = "Pop Trunk",
        defaultKey = "NUMPAD5",
        doorIndex = 5,
        message = "Trunk popped"
    }
}

local function ShowGameMessage(message)
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(message)
    EndTextCommandThefeedPostTicker(false, false)
end

local function GetClosestVehicleToPlayer()
    local ped = PlayerPedId()

    if IsPedInAnyVehicle(ped, false) then
        return GetVehiclePedIsIn(ped, false)
    end

    local coords = GetEntityCoords(ped)
    local vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, Config.SearchDistance, 0, 70)

    if vehicle ~= 0 and DoesEntityExist(vehicle) then
        return vehicle
    end

    return nil
end

local function PopDoor(doorIndex, message)
    local vehicle = GetClosestVehicleToPlayer()

    if not vehicle then
        ShowGameMessage("No vehicle nearby")
        return
    end

    if GetVehicleDoorAngleRatio(vehicle, doorIndex) > 0.1 then
        SetVehicleDoorShut(vehicle, doorIndex, false)
        ShowGameMessage(message:gsub("popped", "closed"))
        return
    end

    SetVehicleDoorOpen(vehicle, doorIndex, false, false)
    ShowGameMessage(message)
end

for _, door in ipairs(Config.Doors) do
    RegisterCommand(door.command, function()
        PopDoor(door.doorIndex, door.message)
    end, false)

    RegisterKeyMapping(door.command, door.description, "keyboard", door.defaultKey)
end
