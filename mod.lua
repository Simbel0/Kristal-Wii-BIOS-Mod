-- Various mod-specific game states.
-- (it's probably a good idea to not split everything into their
-- own states)
---@alias WiiStates
---| "HealthAndSafety" # The "warning - health and safety" screen that is seen on boot

---@type table<WiiStates, table>
Mod.States = {}

Mod.Shaders = {}

Mod.Shaders["RemoveColor"] = love.graphics.newShader([[
    vec4 effect( vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords )
    {
        vec4 pixel = Texel(tex, texture_coords);

        float transparency = 0.0 + pixel.r;
        
        vec4 final_color = vec4(color.r, color.g, color.b, (transparency-0.1)*color.a);

        return final_color;
    }
]])

function Mod:init()
    Mod.States = {
        ["HealthAndSafety"] = HealthAndSafetyScreen,
        ["MainMenu"] = MainMenu
    }

    ---@diagnostic disable-next-line: redundant-return-value
    Utils.hook(Game, "save", function() return {} end)
end

function Mod:postInit()
    Game.state = nil
	
    
    local mods = Kristal.Mods.getMods()

	if not love.filesystem.getInfo("wii_settings.json") then
		Game.wii_data = {
			["american"] = self:isAmerican(),
			["theme"] = "default",
			["channels"] = {},
			["military"] = not self:isAmerican(),
			["messages"] = {},
			["am_right"] = not self:isJapanese()
		}

        --Put the channels in the table
        for i,mod in ipairs(mods) do
            table.insert(Game.wii_data["channels"], mod.id)
            print("[BIOS] Initialize channels, adding "..mod.name)
        end

		love.filesystem.write("wii_settings.json", JSON.encode(Game.wii_data))
	else
		Game.wii_data = JSON.decode(love.filesystem.read("wii_settings.json"))

        --Check if there's any new mods in the mod list
        local new_mods = Utils.filter(mods, function(mod)
            return not Utils.containsValue(Game.wii_data["channels"], mod.id)
        end)

        local removed_mods = Utils.filter(Game.wii_data["channels"], function(mod_id)
            return not Utils.containsValue(mods, Kristal.Mods.getMod(mod_id))
        end)

        if #new_mods>0 then
            for i,mod in ipairs(new_mods) do
                table.insert(Game.wii_data["channels"], mod.id)
                print("[BIOS] New mod detected, adding "..mod.name)
            end
            love.filesystem.write("wii_settings.json", JSON.encode(Game.wii_data))
        else
            print("[BIOS] No new mods.")
        end

        if #removed_mods>0 then
            for i,mod_id in ipairs(removed_mods) do
                Utils.removeFromTable(Game.wii_data["channels"], mod_id)
                print("[BIOS] Mod with id "..mod_id.." not found! Removing it.")
            end
            love.filesystem.write("wii_settings.json", JSON.encode(Game.wii_data))
        end
	end
	
    self:setState("HealthAndSafety")
	
	if love.math.random(1,50) == 50 then
		Game.cursor_troll = true
	end
end

--- Switches the Gamestate to the given one.
---@param state table|WiiStates The gamestate to switch to.
---@param ... any Arguments passed to the gamestate.
function Mod:setState(state, ...)
    if type(state) == "string" then
        Gamestate.switch(Mod.States[state] or Kristal.States[state], ...)
    else
        Gamestate.switch(state, ...)
    end
end

-- Whether to use US-ENG-style HAS screen or not.
-- For some reason, USA Wii consoles are the only ones where the warning screen
-- was all white instead of colored
function Mod:isAmerican()
    local locale
    if love.system.getOS() == "Windows" then
        -- On MS-Win LOCALE is probably not set normally
        locale = os.setlocale("")
        local start = locale:find("_")
        local end_str = locale:find("%.", start+1)
        return locale:sub(start+1, end_str-1) == "United States"
    end

    locale = os.getenv("LC_ALL") or os.getenv("LANG")
    return locale:match("%a%a.(%a%a)") == "US"
end

function Mod:isJapanese()
    local locale
    if love.system.getOS() == "Windows" then
        -- On MS-Win LOCALE is probably not set normally
        locale = os.setlocale("")
        local start = locale:find("_")
        local end_str = locale:find("%.", start+1)
        return locale:sub(start+1, end_str-1) == "Japan"
    end

    locale = os.getenv("LC_ALL") or os.getenv("LANG")
    return locale:match("%a%a.(%a%a)") == "JP"
end

function Mod:getModIDs()
	local a = {}
	for i,mod in ipairs(Kristal.Mods.getMods()) do
		table.insert(a, mod.id)
	end
	
	return a
end
