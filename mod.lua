---@alias WiiStates
---| "HealthAndSafety" # The "warning - health and safety" screen seen when you first enter System Menu

---@type table<WiiStates, table>
Mod.States = {}

modRequire("_luals_annonations/getComputerRegion")

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
    self:setState("HealthAndSafety")
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