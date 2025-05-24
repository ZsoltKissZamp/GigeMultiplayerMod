print("[LogZombieHits] Script loaded (per-user log mode)")

-- Ensure Events table exists (remove or modify this if Events is provided by the environment)
Events = Events or {}
Events.OnWeaponHitCharacter = Events.OnWeaponHitCharacter or { Add = function() end }
Events.OnPlayerDeath = Events.OnPlayerDeath or { Add = function() end }

local LOG_DIR = "~/gig_srv/logs/"
-- Helper to get the log file path for a user
local function getUserLogFile(player)
    local userId = player and player:getUsername() or "unknown"
    return LOG_DIR .. userId .. ".txt"
end

-- Log an action to the user's file
local function logAction(player, actionType, zombieID, weapon, damage)
    local time = os.date("%H:%M:%S-%d:%m")
    local userId = player and player:getUsername() or "unknown"
    local line
    if actionType == "died" then
        line = string.format("died|%s|%s\n", time, userId)
    elseif actionType == "kill" or actionType == "hit" then
        line = string.format("%s|%s|%s|%s|%s|%.2f\n", actionType, time, userId, zombieID or "", weapon or "", damage or 0)
    else
        return
    end
    local file = nil
    if io and io.open then
        file = io.open(getUserLogFile(player), "a")
    end
    if file then
        file:write(line)
        file:close()
    end
end

-- Log hits and kills
local function onWeaponHitCharacter(player, character, weapon, damage)
    if player and character and character:isa("IsoZombie") then
        local zombieID = tostring(character:getOnlineID() or character:getUniqueID() or character)
        local weaponName = weapon and weapon:getName() or "Unknown"
        if character:isDead() then
            logAction(player, "kill", zombieID, weaponName, damage)
        else
            logAction(player, "hit", zombieID, weaponName, damage)
        end
    end
end

-- Log player death
local function onPlayerDeath(player)
    logAction(player, "died")
end

Events.OnWeaponHitCharacter = onWeaponHitCharacter
Events.OnPlayerDeath = onPlayerDeath
print("[LogZombieHits] Event handlers registered (per-user log mode)")
