local logutils = require "GigeUtils/logutils"

-- Use the user's Zomboid folder for client logs
local LOG_FOLDER = getCore():getMyDocumentFolder() .. "/Zomboid/GigeMultiplayerLogs/"
logutils.ensureDirectory(LOG_FOLDER)

local function createUserLog()
  local username = getPlayer():getUsername()
  local logFilePath = LOG_FOLDER .. username .. ".log"
  if not logutils.fileExists(logFilePath) then
    logutils.writeLogLine(logFilePath, "Log created for user: " .. username .. "\n")
    logutils.writeLogLine(logFilePath, "Timestamp: " .. os.date() .. "\n")
  end
end

local function logUserAction(action, weapon, damage)
  local username = getPlayer():getUsername()
  local logFilePath = LOG_FOLDER .. username .. ".log"
  logutils.writeLogLine(logFilePath,
    "[" ..
    os.date() .. "] " .. action .. ": " .. username .. " with " .. weapon .. " (Damage: " .. tostring(damage) .. ")\n")
end

local function onGameStart()
  createUserLog()
end

Events.OnGameStart.Add(onGameStart)

-- You can add more client-side hooks if you want, but most combat events are best logged on the server.
