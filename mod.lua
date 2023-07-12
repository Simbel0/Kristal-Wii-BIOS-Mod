---@alias WiiStates
---| "HealthAndSafety" # The "warning - health and safety" screen seen when you first enter System Menu

---@type table<WiiStates, table>
Mod.States = {}

modRequire("_luals_annonations/getComputerRegion")

function Mod:init()
    Mod.States = {
        ["HealthAndSafety"] = HealthAndSafetyScreen
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