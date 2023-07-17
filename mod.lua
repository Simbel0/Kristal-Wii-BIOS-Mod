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

    self._mouse_sprite_bak = MOUSE_SPRITE
    MOUSE_SPRITE = nil
    ---@diagnostic disable-next-line: redundant-return-value
    Utils.hook(Game, "save", function() return {} end)

    self.cursor_1_tex = Assets.getTexture("cursor/cursor_1")
    self.cursor_1t_tex = Assets.getTexture("cursor/cursor_t")
    self.cursor_2_tex = Assets.getTexture("cursor/cursor_2")
end

function Mod:unload()
    MOUSE_SPRITE = self._mouse_sprite_bak
end

function Mod:postInit()
    Game.state = nil

    -- FIXME: its not like other mods cant access mods/wii_kristal
	if not love.filesystem.getInfo("wii_settings.json") then
		Game.wii_data = {
			["american"] = self:localeIs("US"),
			["theme"] = "default",
			["channels"] = {},
			["military"] = not self:localeIs("US"),
			["messages"] = {},
			["am_right"] = not self:localeIs("JP")
		}
		love.filesystem.write("wii_settings.json", JSON.encode(Game.wii_data))
	else
		Game.wii_data = JSON.decode(love.filesystem.read("wii_settings.json"))
	end

	if love.math.random(1,50) == 50 then
		self.cursor_troll = true
	end

    self:setState("HealthAndSafety")
end

function Mod:postDraw()
    love.graphics.setColor(1, 1, 1)
    if (not Kristal.Config["systemCursor"]) and (Kristal.Config["alwaysShowCursor"] or MOUSE_VISIBLE) and love.window
        and (Input.usingGamepad() or love.window.hasMouseFocus()) then
        local x, y
        if Input.usingGamepad() then
            x = Input.gamepad_cursor_x
            y = Input.gamepad_cursor_y
        else
            x, y = love.mouse.getPosition()
            x, y = x / Kristal.getGameScale(), y / Kristal.getGameScale()
        end
        local cursor_tex = self.cursor_1_tex
        if self.cursor_troll then
            cursor_tex = self.cursor_1t_tex
        end
        --[[if love.mouse.isDown(1) then
            cursor_tex = self.cursor_2_tex
        end]]
        love.graphics.draw(cursor_tex, x - 10, y)
    end
end

--- Switches the gamestate to the given one.
---@param state table|WiiStates|string The gamestate to switch to.
---@param ... any Arguments passed to the gamestate.
function Mod:setState(state, ...)
    if type(state) == "string" then
        Gamestate.switch(Mod.States[state] or Kristal.States[state], ...)
    else
        Gamestate.switch(state, ...)
    end
end

function Mod:localeIs(short_name, long_name)
    long_name = long_name or ({
        ["US"] = "United States",
        ["JP"] = "Japan",
    })[short_name]

    local locale
    if love.system.getOS() == "Windows" then
        -- On MS-Win LOCALE is probably not set normally
        locale = os.setlocale("")
        local start = locale:find("_")
        local end_str = locale:find("%.", start+1)
        return locale:sub(start+1, end_str-1) == long_name
    end

    locale = os.getenv("LC_ALL") or os.getenv("LANG")
    return locale:match("%a%a.(%a%a)") == short_name
end