local ffi = require("ffi")

if love.system.getOS() == "Windows" and not ffi.typeof("SETLOCINFOEX") then
  ffi.cdef[[
    typedef struct _setlocaleinfoex {
      int LCType;
      char* lpLCData;
    } SETLOCINFOEX;

    int GetUserDefaultLocaleName(char* lpLocaleName, int cchLocaleName);
    int GetSystemDefaultLocaleName(char* lpLocaleName, int cchLocaleName);
    int SetLocaleInfoEx(const char* lpLocaleName, int LCType, const char* lpLCData);
  ]]
end

-- Helper function to convert a C string to a Lua string
local function cstringToString(cstring)
  if cstring ~= nil then
    return ffi.string(cstring, 11)
  end
  return nil
end

-- Function to get the region using GetUserDefaultLocaleName
function Mod:getRegion()
  local localeName = ffi.new("char[?]", 11)  -- Allocate a buffer to hold the locale name
  local result = ffi.C.GetUserDefaultLocaleName(localeName, 11)  -- Call the WinAPI function

  if result ~= 0 then
    return cstringToString(localeName):gsub("%z", "")
  end

  return nil
end