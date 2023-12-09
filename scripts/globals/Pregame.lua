---@class Pregame : GamestateState
local Pregame = {}

function Pregame:init()
	self.timer = LibTimer.new()
	
	self.stage = Stage()

	Game.wii_menu = self
	
	self.substate = "MAIN" -- MAIN, MESSAGE, CHANNEL
	
	self.time = 0
	
	self.first = false
	
	self.second = false
end

function Pregame:enter(_, maintenance)
	self.alpha = 0

	self.screen_helper = ScreenHelper()
	self.stage:addChild(self.screen_helper)
	
	self.first_sprite = Sprite("pregame/pregame_1")
	self.first_sprite.alpha = 0
	self.screen_helper:addChild(self.first_sprite)
	
	self.second_sprite = Sprite("pregame/pregame_2")
	self.second_sprite.alpha = 0
	self.screen_helper:addChild(self.second_sprite)
end

function Pregame:update()
	self.time = self.time + DT
	if not self.first then
		if self.time < 1 then
			self.first_sprite.alpha = self.time
		else
			self.first_sprite.alpha = 1
			self.first = true
		end
	end
	if not self.second then
		if self.time < 6 then
			self.second_sprite.alpha = self.time - 5
		else
			self.second_sprite.alpha = 1
			self.first_sprite.alpha = 0
			self.second = true
		end
	else
		if self.time < 11 then
			self.second_sprite.alpha = 1 - (self.time - 10)
		else
			self.second_sprite.alpha = 0
			if Game:getFlag("selected_mod") == "wii_rtk" then -- All of this is temporary
				Kristal.load_wii_mod = false
				Kristal.load_wii = false
				Kristal.returnToMenu()
			else
				Mod:loadMod(Game:getFlag("selected_mod"))
			end
		end
	end
	
	self.screen_helper:update()

	self.stage:update()
end

function Pregame:draw()
    self.screen_helper:draw()
end

return Pregame
