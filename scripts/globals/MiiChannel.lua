---@class MiiChannel : GamestateState
local MiiChannel = {}

function MiiChannel:init()
	self.stage = Stage()

	Game.wii_menu = self
	
	self.substate = "HEAD" -- HEAD, BODY, LEGS, INFO

	self.screen_helper = ScreenHelper()
	self.stage:addChild(self.screen_helper)
	
	self.bg = Assets.getTexture("vii_channel/bg")
	
	self.tabs = {}
	
	self.tab1 = Tab(0, -10, "vii_channel/head_tab")
	table.insert(self.tabs, self.tab1)
	self.screen_helper:addChild(self.tab1)
	
	self.tab2 = Tab(60, -10, "vii_channel/body_tab")
	table.insert(self.tabs, self.tab2)
	self.screen_helper:addChild(self.tab2)
end

function MiiChannel:enter(_, maintenance)
	Game.wii_menu = self

	self.alpha = 0
	
	self.state = "TRANSITIONIN" -- TRANSITIONIN, INTRO, CREATE, TRANSITIONOUT
	
	if not Game.musicplay then
		Game.musicplay = Music("mii")
	end
	
	Kristal.showCursor()
	
	self.cooldown = 0
end

function MiiChannel:update()
	if self.state == "TRANSITIONIN" then
		if self.alpha < 1 then
			self.alpha = self.alpha + 0.05
		else
			self.mii = self:getMii()
			if not self.mii then
				self:setState("INTRO")
				self.popUp = popUp("Use the Vii Channel to create\na digital vessel called a\nVii. You can only create one\nVii at a time.", {"OK"}, function(clicked) self:setState("CREATE") end)
				self.screen_helper:addChild(self.popUp)
				self.mii = {
					head = 1,
					body = 1,
					legs_left = true,
					skin_color = {195/255, 195/255, 195/255},
					hair_color = {61/255, 18/255, 14/255},
					shade_color = {73/255, 73/255, 73/255},
					shirt_color_1 = {127/255, 127/255, 127/255},
					shirt_color_2 = {1, 1, 1},
					name = "VESSEL",
					food = 1,
					blood = 1,
					color = 1,
					gift = 1,
					feel = 1
				}
			else
				self:setState("CREATE")
			end
		end
	end
	
	self.cooldown = self.cooldown - DT
	
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
    love.graphics.clear(0, 0, 0, 1)
    love.graphics.push()
	
	love.graphics.setColor(1, 1, 1, self.alpha)
	love.graphics.draw(self.bg, 0, 0)
	
	self.screen_helper:draw()

    love.graphics.pop()

    love.graphics.push()
    Kristal.callEvent("postDraw")
    love.graphics.pop()
end

function MiiChannel:getMii()
	if Game.wii_data["vii"] then
		return Game.wii_data["vii"]
	end
	return false
end

function MiiChannel:setState(state)
	self:onStateChange(self.state, state)
	self.state = state
end

function MiiChannel:onStateChange(from, to)
	if to == "CREATE" then
	
	end
end

function MiiChannel:setSubstate(substate)
	self.substate = substate
end

return MiiChannel
