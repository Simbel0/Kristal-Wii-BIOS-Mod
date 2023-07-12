---@meta
-- https://hump.readthedocs.io/en/latest/gamestate.html

---@class GamestateState
-- A gamestate encapsulates independent data and behaviour in a single table. \
-- A typical game could consist of a menu-state, a level-state and a game-over-state.
GamestateState = {}

-- Called once, and only once, before entering the state the first time. See `Gamestate.switch()`.
function GamestateState:init() end

-- Called every time when entering the state. See `Gamestate.switch()`.
---@param previous GamestateState
function GamestateState:enter(previous, ...) end

-- Called when leaving a state. See `Gamestate.switch()` and `Gamestate.pop()`.
function GamestateState:leave() end

-- Called when re-entering a state by `Gamestate.pop()`-ing another state.
function GamestateState:resume() end

-- Update the game state. Called every frame.
---@param dt number
function GamestateState:update(dt) end

-- Draw on the screen. Called every frame.
function GamestateState:draw() end

-- Called if the window gets or loses focus.
---@param focus boolean
function GamestateState:focus(focus) end

-- Triggered when a key is pressed.
---@param key love.KeyConstant
---@param scancode love.Scancode
---@param isrepeat boolean
function GamestateState:keypressed(key, scancode, isrepeat) end

-- Triggered when a key is released.
---@param key love.KeyConstant
---@param scancode love.Scancode
function GamestateState:keyreleased(key, scancode) end

-- Triggered when a mouse button is pressed.
---@param x number
---@param y number
---@param button number
---@param istouch boolean
---@param presses number
function GamestateState:mousepressed(x, y, button, istouch, presses) end

-- Triggered when a mouse button is released.
---@param x number
---@param y number
---@param button number
---@param istouch boolean
---@param presses number
function GamestateState:mousereleased(x, y, button, istouch, presses) end

-- Triggered when a joystick button is pressed.
---@param joystick love.Joystick
---@param button number
function GamestateState:joystickpressed(joystick, button) end

-- Triggered when a joystick button is released.
---@param joystick love.Joystick
---@param button number
function GamestateState:joystickreleased(joystick, button) end

-- Called on quitting the game. Only called on the active gamestate.
function GamestateState:quit() end

---@class GamestateManager
Gamestate = {}

-- **Deprecated: Use the table constructor instead (see example)** \
-- Declare a new gamestate (just an empty table). A gamestate can define several callbacks.
---@return table state # An empty table.
function Gamestate.new() end

-- Switch to a gamestate, with any additional arguments passed to the new state. \
-- Switching a gamestate will call the `leave()` callback on the current gamestate, replace the current gamestate with `to`, call the `init()` function if, and only if, the state was not yet inialized and finally call `enter(old_state, ...)` on the new gamestate.
---@param to GamestateState # Target gamestate.
---@param ... any # Additional arguments to pass to `to:enter(current, ...)`.
---@return any # The results of `to:enter(current, ...)`.
function Gamestate.switch(to, ...) end

-- Returns the currently activated gamestate.
---@return GamestateState state # The active gamestate.
function Gamestate.current() end

-- Pushes the `to` on top of the state stack, i.e. makes it the active state. Semantics are the same as `switch(to, ...)`, except that `leave()` is not called on the previously active state. \
-- Useful for pause screens, menus, etc.
---@param to GamestateState # Target gamestate.
---@param ... any # Additional arguments to pass to `to:enter(current, ...)`.
---@return any # The results of `to:enter(current, ...)`.
function Gamestate.push(to, ...) end

-- Calls `leave()` on the current state and then removes it from the stack, making the state below the current state and calls `resume(...)` on the activated state. Does *not* call `enter()` on the activated state.
---@return any # The results of `new_state:resume(...)`.
function Gamestate.pop(...) end

-- TODO: Gamestate.<callback>(...)

-- Overwrite love callbacks to call `Gamestate.update()`, `Gamestate.draw()`, etc. automatically. `love` callbacks (e.g. `love.update()`) are still invoked as usual.
-- This is by done by overwriting the love callbacks, e.g.:
---@param callbacks? table # Names of the callbacks to register. If omitted, register all love callbacks (optional).
function Gamestate.registerEvents(callbacks) end