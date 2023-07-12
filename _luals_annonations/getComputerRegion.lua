-- For some reason, USA Wii consoles are the only ones where the warning screen was all white instead of colored
function Mod:isAmerican()
  local locale
  if love.system.getOS() == "Windows" then
    locale = os.setlocale("")
    local start = locale:find("_")
    local end_str = locale:find("%.", start+1)
    return locale:sub(start+1, end_str-1) == "United States"
  end

  locale = os.getenv("LC_ALL") or os.getenv("LANG")
  return locale:match("%a%a.(%a%a)") == "US"
end 