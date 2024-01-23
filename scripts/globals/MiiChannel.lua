---@class MiiChannel : GamestateState
local MiiChannel = {}

function MiiChannel:init()
	self.stage = Stage()

	Game.wii_menu = self
	
	self.substate = "HEAD" -- HEAD, BODY, INFO

	self.screen_helper = ScreenHelper()
	self.stage:addChild(self.screen_helper)
end

function MiiChannel:enter(_, maintenance)
	Game.wii_menu = self

	self.alpha = 0
	
	self.state = "TRANSITIONIN" -- TRANSITIONIN, INTRO, CREATE, TRANSITIONOUT
	
	if not Game.musicplay then
		Game.musicplay = Music("mii")
	end
end

function MiiChannel:update()
	if self.state == "TRANSITIONIN" then
		Kristal.showCursor()
		if self.alpha < 1 then
			self.alpha = self.alpha + 0.05
		else
			self.mii = self:getMii()
			if not self.mii then
				self.state = "INTRO"
			else
				
			end
		end
	end
	
	if self.state == "TRANSITIONOUT" then
		if Game.musicplay then
			Game.musicplay:remove()
			Game.musicplay = nil
		end
		if self.alpha > 0 then
			self.alpha = self.alpha - 0.05
		else
			Mod:setState("MainMenu", false)
		end
	end
end

function MiiChannel:draw()

end

function MiiChannel:getMii()
	return false -- temporary, for testing
end

function MiiChannel:setState(state)
	self.state = state
end

function MiiChannel:setSubstate(substate)
	self.substate = substate
end

return MiiChannel
