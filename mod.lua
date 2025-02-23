-- Various mod-specific game states.
-- (it's probably a good idea to not split everything into their
-- own states)
---@alias WiiStates
---| "HealthAndSafety" # The "warning - health and safety" screen that is seen on boot

---@type table<WiiStates, table>
Mod.States = {}

Mod.Shaders = {}

Mod.wiiwares = {
    ["wii_food"] = "channels/food",
    ["wii_rtk"] = "channels/kristal",
    ["wii_mii"] = "channels/vii_maker"
}

Mod.Themes = {
	["DEFAULT"] = {
		["CLOCK"] = {155/255, 155/255, 155/255},
		["CLOCK_TEXT"] = {52/255, 192/255, 237/255},
		["BG_LOWER"] = Utils.hexToRgb("#CDCFD7"),
		["BG"] = Utils.hexToRgb("#F2F2F2"),
		["BORDER"] = {52/255, 192/255, 237/255},
		["DATE"] = {130/255, 130/255, 130/255},
		["TEXT"] = {0/255, 0/255, 0/255},
		["MESSAGE_TITLE"] = {1, 1, 1},
		["MESSAGE_TEXT"] = {0.4, 0.4, 0.4},
	},
	["DETERMINATION"] = {
		["CLOCK"] = {155/255, 155/255, 155/255},
		["CLOCK_TEXT"] = {255/255, 62/255, 48/255},
		["BG_LOWER"] = Utils.hexToRgb("#CDCFD7"),
		["BG"] = Utils.hexToRgb("#F2F2F2"),
		["BORDER"] = {255/255, 33/255, 18/255},
		["DATE"] = {130/255, 130/255, 130/255},
		["TEXT"] = {0/255, 0/255, 0/255},
		["MESSAGE_TITLE"] = {1, 1, 1},
		["MESSAGE_TEXT"] = {0.4, 0.4, 0.4},
	},
	["SD_CARD"] = {
		["CLOCK"] = {252/255, 248/255, 249/255},
		["CLOCK_TEXT"] = {52/255, 192/255, 237/255},
		["BG_LOWER"] = Utils.hexToRgb("#D0D3DA"),
		["BG"] = Utils.hexToRgb("#242424"),
		["BORDER"] = {52/255, 192/255, 237/255},
		["DATE"] = {130/255, 130/255, 130/255},
		["TEXT"] = {0/255, 0/255, 0/255},
		["MESSAGE_TITLE"] = {1, 1, 1},
		["MESSAGE_TEXT"] = {0.4, 0.4, 0.4},
	},
	-- ["KRISTAL"] = {
		-- ["CLOCK"] = {255/255, 229/255, 0/255},
		-- ["CLOCK_TEXT"] = {255/255, 229/255, 0/255},
		-- ["BG_LOWER"] = Utils.hexToRgb("#007EA3"),
		-- ["BG"] = Utils.hexToRgb("#059AA3"),
		-- ["BORDER"] = {255/255, 229/255, 0/255},
		-- ["DATE"] = {130/255, 130/255, 130/255},
		-- ["TEXT"] = {0/255, 0/255, 0/255},
		-- ["MESSAGE_TITLE"] = {1, 1, 1},
		-- ["MESSAGE_TEXT"] = {0.4, 0.4, 0.4},
	-- }, -- Don't uncomment this. It was a lot better in my head. - AcousticJamm
	["DEOXYNN"] = {
		["CLOCK"] = {253/255, 190/255, 219/255},
		["CLOCK_TEXT"] = {253/255, 190/255, 219/255},
		["BG_LOWER"] = Utils.hexToRgb("#7C7C7C"),
		["BG"] = Utils.hexToRgb("#FFF0FF"),
		["BORDER"] = {253/255, 190/255, 219/255},
		["DATE"] = {235/255, 235/255, 235/255},
		["TEXT"] = {0/255, 0/255, 0/255},
		["MESSAGE_TITLE"] = {0.4, 0.4, 0.4},
		["MESSAGE_TEXT"] = {0.4, 0.4, 0.4},
	},
	["LEGEND"] = {
		["CLOCK"] = {255/255, 255/255, 255/255},
		["CLOCK_TEXT"] = {255/255, 255/255, 255/255},
		["BG_LOWER"] = Utils.hexToRgb("#4A290B"),
		["BG"] = Utils.hexToRgb("#643214"),
		["BORDER"] = {192/255, 130/255, 38/255},
		["DATE"] = {255/255, 255/255, 255/255},
		["TEXT"] = {0/255, 0/255, 0/255},
		["MESSAGE_TITLE"] = {1, 1, 1},
		["MESSAGE_TEXT"] = {0.4, 0.4, 0.4},
	},
	["SNEO"] = {
		["CLOCK"] = {225/255, 242/255, 0/255},
		["CLOCK_TEXT"] = {225/255, 242/255, 0/255},
		["BG_LOWER"] = Utils.hexToRgb("#6711A1"),
		["BG"] = Utils.hexToRgb("#C04385"),
		["BORDER"] = {1/255, 128/255, 1/255},
		["DATE"] = {255/255, 174/255, 201/255},
		["TEXT"] = {0/255, 0/255, 0/255},
		["MESSAGE_TITLE"] = {1, 1, 1},
		["MESSAGE_TEXT"] = {0.4, 0.4, 0.4},
	},
	["UT_BATTLE"] = {
		["CLOCK"] = {255/255, 255/255, 255/255},
		["CLOCK_TEXT"] = {255/255, 255/255, 255/255},
		["BG_LOWER"] = Utils.hexToRgb("#141414"),
		["BG"] = Utils.hexToRgb("#141414"),
		["BORDER"] = {60/255, 178/255, 78/255},
		["DATE"] = {251/255, 255/255, 41/255},
		["TEXT"] = {255/255, 127/255, 39/255},
		["MESSAGE_TITLE"] = {1, 1, 1},
		["MESSAGE_TEXT"] = {0.4, 0.4, 0.4},
	},
}

Mod.invalid_mods = {
    prefix = {},
    json = {}
}

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
        ["MainMenu"] = MainMenu,
        ["SettingsMenu"] = SettingsMenu,
        ["Pregame"] = Pregame,
        ["MiiChannel"] = MiiChannel
    }

    self._mouse_sprite_bak = MOUSE_SPRITE
    MOUSE_SPRITE = nil
    Utils.hook(Kristal, "showCursor", function()
        MOUSE_VISIBLE = true

        love.mouse.setVisible(false)
    end)
    Utils.hook(Kristal, "hideCursor", function()
        MOUSE_VISIBLE = false

        love.mouse.setVisible(false)
    end)
    Utils.hook(Kristal, "updateCursor", function()
        if MOUSE_VISIBLE then
            Kristal.showCursor()
        elseif not MOUSE_VISIBLE then
            Kristal.hideCursor()
        end

        love.mouse.setVisible(false)
    end)
	Kristal.showCursor()
    ---@diagnostic disable-next-line: redundant-return-value
    Utils.hook(Game, "save", function() return {} end)

    -- Don't uncomment, it's not working nicely
    --[[love.audio.setEffect("base_reverb", {type="reverb"})

    Utils.hook(Assets, "playSound", function(orig, self, sound, vol, pitch)
        local source = orig(self, sound, vol, pitch)

        --source:setEffect("base_reverb")
        return source
    end)]]

    self.cursor_1_tex = Assets.getTexture("cursor/cursor_1")
    self.cursor_1t_tex = Assets.getTexture("cursor/cursor_t")
    self.cursor_2_tex = Assets.getTexture("cursor/cursor_2")
end

function Mod:unload()
    MOUSE_SPRITE = self._mouse_sprite_bak

    if MOUSE_VISIBLE then
        Kristal.showCursor()
    else
        Kristal.hideCursor()
    end

    if not Kristal.Config["systemCursor"] then
        love.mouse.setVisible(false)
    elseif Kristal.Config["alwaysShowCursor"] then
        love.mouse.setVisible(true)
    end
end

function Mod:postInit()
    Game.state = nil

    local mods = Kristal.Mods.getMods()
	if not love.filesystem.getInfo("wii_settings.json") then
		Game.wii_data = {
			["american"] = self:localeIs("US"),
			["theme"] = "DEFAULT",
			["channels"] = {},
			["military"] = not self:localeIs("US"),
			["messages"] = {},
			["am_right"] = not self:localeIs("JP"),
			["name"] = "Wii",
			["load_early"] = false
		}

        --Put the channels in the table
        for i,mod in ipairs(mods) do
            if not Utils.startsWith(mod.id, "wii_") then
                if not Utils.getKey(Mod.wiiwares, mod.id) then
                    table.insert(Game.wii_data["channels"], mod.id)
                    print("[BIOS] Initialize channels, adding "..mod.name)
                else
                    print("[BIOS] Mod id of "..mod.name.." is equal to a default channel ("..mod.id.."). Ignoring it.")
                end
            else
                if mod.id ~= Mod.info.id then
                    table.insert(Mod.invalid_mods["prefix"], mod.name or mod.id)
                    print("[BIOS] Invalid mod: "..mod.name or mod.id)
                end
            end
        end

        for i,v in ipairs(Mod.wiiwares) do
            table.insert(Game.wii_data["channels"], mod.id)
            print("[BIOS] Adding WiiWare channel with id "..mod.id)
        end

		love.filesystem.write("wii_settings.json", JSON.encode(Game.wii_data))
	else
		Game.wii_data = JSON.decode(love.filesystem.read("wii_settings.json"))
		
		if (not Game.wii_data["name"]) then
			Game.wii_data["name"] = "WII"
			love.filesystem.write("wii_settings.json", JSON.encode(Game.wii_data))
		end

        --Check if there's any new mods in the mod list
        local new_mods = Utils.filter(mods, function(mod)
            return not Utils.containsValue(Game.wii_data["channels"], mod.id) and mod.id ~= Mod.info.id
        end)
        for i,mod in ipairs(new_mods) do
            print(Utils.startsWith(mod.id, "wii_"), mod.id)
            if Utils.startsWith(mod.id, "wii_") then
                local mod = Utils.removeFromTable(mod)
                table.insert(Mod.invalid_mods["prefix"], mod.name or mod.id)
                print("[BIOS] Invalid mod: "..mod.name or mod.id)
            end
        end

        local removed_mods = Utils.filter(Game.wii_data["channels"], function(mod_id)
            return not Utils.containsValue(mods, Kristal.Mods.getMod(mod_id)) and not Utils.startsWith(mod_id, "wii_")
        end)

        -- Same thing but for Wiiwares
        for id,icon in pairs(Mod.wiiwares) do
            if not Utils.containsValue(Game.wii_data["channels"], id) then
                table.insert(new_mods, {id=id, name=id:sub(5, -1)})
            end
        end

        for i,id in ipairs(Game.wii_data["channels"]) do
            if Utils.startsWith(id, "wii_") and Utils.getKey(Mod.wiiwares, id)==false then
                table.insert(removed_mods, id)
            end
        end

        if #new_mods>0 then
            for _,mod in ipairs(new_mods) do
                table.insert(Game.wii_data["channels"], mod.id)
                print("[BIOS] New mod/Wiiware detected, adding "..mod.name)
            end
            love.filesystem.write("wii_settings.json", JSON.encode(Game.wii_data))
        else
            print("[BIOS] No new mods.")
        end

        if #removed_mods>0 then
            for _,mod_id in ipairs(removed_mods) do
                Utils.removeFromTable(Game.wii_data["channels"], mod_id)
                print("[BIOS] Mod/Wiiware with id "..mod_id.." not found! Removing it.")
            end
            love.filesystem.write("wii_settings.json", JSON.encode(Game.wii_data))
        end
	end

	if love.math.random(1,50) == 50 then
		self.cursor_troll = true
	end

	if Kristal.load_wii_mod then
		self:setState("MainMenu")
	else
		self:setState("HealthAndSafety")
	end
end

function Mod:postDraw()
    love.graphics.setColor(1, 1, 1)
    if (Kristal.Config["alwaysShowCursor"] or MOUSE_VISIBLE) and love.window
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
        state = Mod.States[state] or Kristal.States[state]
    end
    local current = Gamestate.current()
    assert(
        not current == Mod.States["Pregame"]
        or not (current.loading_mod ~= nil and Utils.containsValue(Mod.States, state)),
        "cannot exit from mod-loading Pregame to other BIOS-scoped states"
    )
    Gamestate.switch(state, ...)
end

function Mod:localeIs(short_name, long_name)
    long_name = long_name or ({
        ["US"] = "United States",
        ["JP"] = "Japan",
    })[short_name]

    local locale
    if love.system.getOS() == "Windows" then
        locale = os.setlocale("")
        local start = locale:find("_")
        local end_str = locale:find("%.", start+1)
        return locale:sub(start+1, end_str-1) == long_name
    end

    locale = os.getenv("LC_ALL") or os.getenv("LANG")
    return locale:match("%a%a.(%a%a)") == short_name
end

function Mod:getModIDs()
	local a = {}
	for i,mod in ipairs(Kristal.Mods.getMods()) do
		table.insert(a, mod.id)
	end
	
	return a
end
