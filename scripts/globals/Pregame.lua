---@class Pregame : GamestateState
local Pregame = {}

function Pregame:init()
	Game.wii_menu = self

	self.slides = Utils.copy(Assets.getFrames("pregame/pregame"))
end

Pregame.LOAD_STATUS = {
	["NOT_STARTED"] = nil,
	["WAITING"] = 0,
	["LOADING"] = 1,
	["LOADED"] = 2,
}

function Pregame:enter(_, selection)
	self.selected_mod = selection

	self.wii_data = Utils.copy(Game.wii_data)

	self.loading_mod = nil
	self.going_to_miiware = select(1, Utils.startsWith(self.selected_mod, "wii_"))
	if not self.going_to_miiware then
		assert(Kristal.Mods.data[self.selected_mod], "No mod \""..tostring(self.selected_mod).."\"")
		self.loading_mod = Pregame.LOAD_STATUS["WAITING"]
	end

	self.stage = Stage()

	self.timer = Timer()
	self.stage:addChild(self.timer)

	self.slide = Sprite(self.slides[1], 0, 0)
	self.slide.alpha = 0
	self.slide.crossFadeTo = function(self, texture, time, fade_out, after)
		self:crossFadeToSpeed(texture, (1 / (time or 1)) / 30 * (1 - self.crossfade_alpha), fade_out, after)
	end
	self.stage:addChild(self.slide)
	self.slide_no = 1

	self.mouse_prev = MOUSE_VISIBLE
	Kristal.hideCursor()

    self.state_manager = StateManager("", self, true)
    self.state_manager:addState("INIT", {enter = self.startInit})
    self.state_manager:addState("PRESENTING", {enter = self.startPresenting})
    self.state_manager:addState("FADE", {enter = self.startFade})
    self.state_manager:addState("EXIT", {update = self.enterGame})
    self.state_manager:addState("DONE")
	self.state_manager:setState("INIT")
end

function Pregame:clearModStatePhase1()
	-- Stop music
	Music.clear()

	-- End the current mod
	Kristal.callEvent("unload")
	Mod = nil

	Kristal.clearModHooks()
	Kristal.clearModSubclasses()

	-- Reset global variables
	Registry.restoreOverridenGlobals()

	package.loaded["src.engine.vars"] = nil
	require("src.engine.vars")
	-- Reset Game state
	package.loaded["src.engine.game.game"] = nil
	Kristal.States["Game"] = require("src.engine.game.game")
	Game = Kristal.States["Game"]

	Kristal.Mods.clear()

	-- Restore assets and registry
	Assets.restoreData()
	Registry.initialize()
end

function Pregame:clearModStatePhase2()
	-- Clear disruptive active globals
	Object._clearCache()
	Draw._clearStacks()

	love.window.setIcon(Kristal.icon)
	love.window.setTitle(Kristal.getDesiredWindowTitle())
end

function Pregame:startInit()
	self.slide:fadeTo(1, 1, function() self:setState("PRESENTING") end)
end

function Pregame:startPresenting()
	self.timer:after(5, function() self:setState("FADE") end)
end

function Pregame:startFade()
	self.slide_no = self.slide_no + 1
	if self.slide_no <= #self.slides then
		self.slide:crossFadeTo(self.slides[self.slide_no], 1, false, function()
			self:setState("PRESENTING")
		end)
	else
		self.slide:fadeTo(0, 1, function() self:setState("EXIT") end)
	end
end

function Pregame:enterGame()
	if self.mouse_prev then Kristal.showCursor() end
	if self.going_to_miiware then
		if self.selected_mod == "wii_rtk" then -- All of this is temporary
			Kristal.load_wii_mod = false
			Kristal.load_wii = false
			Kristal.returnToMenu()
		elseif self.selected_mod == "wii_food" then
			love.system.openURL("https://www.dominos.com/en/")
			Mod:setState("MainMenu", false)
		elseif self.selected_mod == "wii_mii" then
			Mod:setState("MiiChannel", false)
		end
	elseif self.loading_mod ~= 2 then
		return
	else
		self:clearModStatePhase2()
		local savemenu_vanilla = SaveMenu
		if Kristal.preInitMod(self.selected_mod) then
			if SaveMenu ~= savemenu_vanilla then
				print("WARNING: SaveMenu is not vanilla")
			end
			if WiiSaveMenu then
				Registry.registerGlobal("SaveMenu", WiiSaveMenu, true)
			else
				Registry.registerGlobal("SaveMenu", SimpleSaveMenu, true)
			end
			Gamestate.switch(Kristal.States["Game"], 0, name)
		end
	end
	self:setState("DONE")
end

function Pregame:update()
	if self.loading_mod == self.LOAD_STATUS["WAITING"] then
		self.loading_mod = self.LOAD_STATUS["LOADING"]
		self:clearModStatePhase1()
		Kristal.load_wii_mod = true

		Kristal.loadAssets("","mods","", function()
			Kristal.loadMod(self.selected_mod, 0, self.wii_data["name"], function()
				self.loading_mod = self.LOAD_STATUS["LOADED"]
			end)
		end)
	end

	self.state_manager:update()
	self.stage:update()
end

function Pregame:setState(...) self.state_manager:setState(...) end

function Pregame:draw()
    love.graphics.clear(0, 0, 0, 1)
    love.graphics.push()
    if Kristal.callEvent("preDraw") then
        love.graphics.pop()
        return
    end
    love.graphics.pop()
    self.stage:draw()
    love.graphics.push()
    Kristal.callEvent("postDraw")
    love.graphics.pop()
end

return Pregame