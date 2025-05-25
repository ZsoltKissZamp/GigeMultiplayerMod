local logutils = require "GigeUtils/logutils"

local LOG_FOLDER = "/home/pzuser/gig_srv/logs"
logutils.ensureDirectory(LOG_FOLDER)

local function createUserLog(username)
    local logFilePath = LOG_FOLDER .. username .. ".log"
    if not logutils.fileExists(logFilePath) then
        logutils.writeLogLine(logFilePath, "Log created for user: " .. username .. "\n")
        logutils.writeLogLine(logFilePath, "Timestamp: " .. os.date() .. "\n")
    end
end

local function logUserAction(username, action, weapon, damage)
    local logFilePath = LOG_FOLDER .. username .. ".log"
    logutils.writeLogLine(logFilePath,
        "[" ..
        os.date() ..
        "] " .. action .. ": " .. username .. " with " .. weapon .. " (Damage: " .. tostring(damage) .. ")\n")
end

local function onPlayerConnect(player)
    local username = player:getUsername()
    createUserLog(username)
end

local function onWeaponHitCharacter(player, target, weapon, damage)
    if instanceof(target, "IsoZombie") then
        local username = player:getUsername()
        if target:isDead() then
            logUserAction(username, "KILL", weapon:getName(), damage)
        else
            logUserAction(username, "HIT", weapon:getName(), damage)
        end
    end
end

if Events and Events.OnPlayerConnect then
    Events.OnPlayerConnect.Add(onPlayerConnect)
end
if Events and Events.OnWeaponHitCharacter then
    Events.OnWeaponHitCharacter.Add(onWeaponHitCharacter)
end
