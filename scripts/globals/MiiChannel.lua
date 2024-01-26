---@class MiiChannel : GamestateState
local MiiChannel = {}

function MiiChannel:init()
	self.stage = Stage()

	Game.wii_menu = self
	
	self.substate = "HEAD" -- HEAD, BODY, NAME, FOOD, BLOOD, COLOR, GIFT, FEEL

	self.screen_helper = ScreenHelper()
	self.stage:addChild(self.screen_helper)
	
	self.bg = Assets.getTexture("vii_channel/bg")
	
	self.tabs = {}
	
	self.headtab = Tab(0, -10, "vii_channel/head_tab", "HEAD")
	table.insert(self.tabs, self.headtab)
	self.screen_helper:addChild(self.headtab)
	
	self.bodytab = Tab(60, -10, "vii_channel/body_tab", "BODY")
	table.insert(self.tabs, self.bodytab)
	self.screen_helper:addChild(self.bodytab)
	
	self.foodtab = Tab(120, -10, "vii_channel/food_tab", "FOOD")
	table.insert(self.tabs, self.foodtab)
	self.screen_helper:addChild(self.foodtab)
	
	self.bloodtab = Tab(180, -10, "vii_channel/blood_tab", "BLOOD")
	table.insert(self.tabs, self.bloodtab)
	self.screen_helper:addChild(self.bloodtab)
	
	self.colortab = Tab(240, -10, "vii_channel/color_tab", "COLOR")
	table.insert(self.tabs, self.colortab)
	self.screen_helper:addChild(self.colortab)
	
	self.gifttab = Tab(300, -10, "vii_channel/gift_tab", "GIFT")
	table.insert(self.tabs, self.gifttab)
	self.screen_helper:addChild(self.gifttab)
	
	self.feeltab = Tab(360, -10, "vii_channel/feel_tab", "FEEL")
	table.insert(self.tabs, self.feeltab)
	self.screen_helper:addChild(self.feeltab)
	
	self.nametab = Tab(420, -10, "vii_channel/name_tab", "NAME")
	table.insert(self.tabs, self.nametab)
	self.screen_helper:addChild(self.nametab)
	
	self.lfb = LegFlipButton(541, 28)
	self.screen_helper:addChild(self.lfb)
	
	self.mii = {
		head = 1,
		body = 1,
		legs_left = true,
		skin_color = {195/255, 195/255, 195/255},
		hair_color = {61/255, 18/255, 14/255},
		shirt_color_1 = {127/255, 127/255, 127/255},
		shirt_color_2 = {1, 1, 1},
		name = "VESSEL",
		food = 1,
		blood = 1,
		color = 1,
		gift = 1,
		feel = 1
	}
	
	self.vii = ViiPreview(80, 80)
	self.screen_helper:addChild(self.vii)
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
	
	self.mii = self:getMii()
end

function MiiChannel:update()
	if self.state == "TRANSITIONIN" then
		if self.alpha < 1 then
			self.alpha = self.alpha + 0.05
		else
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
	self.lfb:update()
	
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
	
end

function MiiChannel:setSubstate(substate)
	self.substate = substate
end

return MiiChannel
