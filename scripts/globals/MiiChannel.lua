---@class MiiChannel : GamestateState
local MiiChannel = {}

function MiiChannel:init()
	self.stage = Stage()

	Game.wii_menu = self
	
	self.substate = "HEAD" -- HEAD, BODY, INFO

	self.screen_helper = ScreenHelper()
	self.stage:addChild(self.screen_helper)
	
	self.bg = Assets.getTexture("vii_channel/bg")
end

function MiiChannel:enter(_, maintenance)
	Game.wii_menu = self

	self.alpha = 0
	
	self.state = "TRANSITIONIN" -- TRANSITIONIN, INTRO, CREATE, TRANSITIONOUT
	
	if not Game.musicplay then
		Game.musicplay = Music("mii")
	end
	
	Kristal.showCursor()
end

function MiiChannel:update()
	if self.state == "TRANSITIONIN" then
		if self.alpha < 1 then
			self.alpha = self.alpha + 0.05
		else
			self.mii = self:getMii()
			if not self.mii then
				self.state = "INTRO"
				self.popUp = popUp("Use the Vii Channel to create\na digital vessel called a\nVii. You can only create one\nVii at a time.", {"Ok"}, function(clicked) self:setState("CREATE") end)
				self.screen_helper:addChild(self.popUp)
			else
				
			end
		end
	end
	
	self.screen_helper:update()
	
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
	love.graphics.setColor(1, 1, 1, self.alpha)
	love.graphics.draw(self.bg, 0, 0)
	
	self.screen_helper:draw()
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
