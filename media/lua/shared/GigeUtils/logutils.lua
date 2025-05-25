local logutils = {}

function logutils.ensureDirectory(path)
  if luautils and luautils.directoryExists and luautils.createDirectory then
    if not luautils.directoryExists(path) then
      luautils.createDirectory(path)
    end
  end
end

function logutils.fileExists(path)
  return fileExists and fileExists(path)
end

function logutils.writeLogLine(path, line)
  local file = getFileWriter(path, true, false)
  file:write(line)
  file:close()
end

return logutils
