---@class MiiChannel : GamestateState
local MiiChannel = {}

function MiiChannel:init()
	self.stage = Stage()

	Game.wii_menu = self
	
	self.substate = "HEAD" -- HEAD, BODY, NAME, FOOD, BLOOD, COLOR, GIFT, FEEL

	self.screen_helper = ScreenHelper()
	self.stage:addChild(self.screen_helper)
	
	self.bg = Assets.getTexture("vii_channel/bg")
	
	
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
	
	self:initButtons()
	
	self.vii = ViiPreview(50, 80)
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
	if self.panel then
		self.panel.alpha = self.alpha
	end
	
	if Input.pressed("right", false) then
		if Game.wii_menu.substate == "HEAD" then
			if self.mii.head == 8 then
				self.mii.head = 1
			else
				self.mii.head = self.mii.head + 1
			end
		elseif Game.wii_menu.substate == "BODY" then
			if self.mii.body == 6 then
				self.mii.body = 1
			else
				self.mii.body = self.mii.body + 1
			end
		end
    end
	
	if Input.pressed("left", false) then
		if Game.wii_menu.substate == "HEAD" then
			if self.mii.head == 1 then
				self.mii.head = 8
			else
				self.mii.head = self.mii.head - 1
			end
		elseif Game.wii_menu.substate == "BODY" then
			if self.mii.body == 1 then
				self.mii.body = 6
			else
				self.mii.body = self.mii.body - 1
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
    love.graphics.clear(0, 0, 0, 1)
    love.graphics.push()
	
	love.graphics.setColor(1, 1, 1, self.alpha)
	love.graphics.draw(self.bg, 0, 0)
	
	self.screen_helper:draw()
	
	love.graphics.setColor(0, 0, 0, self.alpha)
	if self.substate == "HEAD" then
		love.graphics.printf("< Head " .. self.mii.head .. " >", 255, 70, 354, "center")
		love.graphics.printf("SKIN COLOR", 255, 125, 354, "center")
		love.graphics.printf("HAIR COLOR", 255, 340, 354, "center")
	elseif self.substate == "BODY" then
		love.graphics.printf("< Body " .. self.mii.body .. " >", 255, 70, 354, "center")
		love.graphics.printf("MAIN COLOR", 255, 125, 354, "center")
		love.graphics.printf("STRIPE COLOR", 255, 300, 354, "center")
	end

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

function MiiChannel:initButtons()
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
	
	self.leave_button = TextButtonInApp(90, 453, "Wii Menu", function()
		Game.wii_menu.popUp = popUp("Would you like to save your Vii first?\nIf not, it will reset when you restart\nthe Wii BIOS Mod!", {"Yes", "No"}, function(clicked)
			if clicked == 1 then
				Game.wii_data["vii"] = Game.wii_menu.mii
				love.filesystem.write("wii_settings.json", JSON.encode(Game.wii_data))
				Game.wii_menu.popUp = popUp("Successfully saved your Vii.", {"OK"}, function(clicked)
					self:setState("TRANSITIONOUT")
				end)
				Game.wii_menu.screen_helper:addChild(Game.wii_menu.popUp)
			else
				self:setState("TRANSITIONOUT")
			end
		end)
		Game.wii_menu.screen_helper:addChild(Game.wii_menu.popUp)
	end)
	self.screen_helper:addChild(self.leave_button)
	
	self.panel = Sprite("vii_channel/panel", 241, 60)
	self.screen_helper:addChild(self.panel)
	
	self.screen_helper:addChild(ColorButton(290, 190, "HEAD", {195/255, 195/255, 195/255}, "skin"))
	self.screen_helper:addChild(ColorButton(361, 190, "HEAD", {255/255, 201/255, 14/255},  "skin"))
	self.screen_helper:addChild(ColorButton(432, 190, "HEAD", {243/255, 215/255, 206/255}, "skin"))
	self.screen_helper:addChild(ColorButton(503, 190, "HEAD", {230/255, 187/255, 160/255}, "skin"))
	self.screen_helper:addChild(ColorButton(574, 190, "HEAD", {211/255, 168/255, 123/255}, "skin"))
	self.screen_helper:addChild(ColorButton(361, 261, "HEAD", {198/255, 145/255, 122/255}, "skin"))
	self.screen_helper:addChild(ColorButton(432, 261, "HEAD", {108/255, 43/255,  24/255},  "skin"))
	self.screen_helper:addChild(ColorButton(503, 261, "HEAD", {57/255,  28/255,  24/255},  "skin"))
	
	self.screen_helper:addChild(ColorButton(290, 405, "HEAD", {61/255,  18/255,  14/255},  "hair"))
	self.screen_helper:addChild(ColorButton(361, 405, "HEAD", {0,       0,       0},       "hair"))
	self.screen_helper:addChild(ColorButton(432, 405, "HEAD", {41/255,  20/255,  32/255},  "hair"))
	self.screen_helper:addChild(ColorButton(503, 405, "HEAD", {255/255, 206/255, 50/255},  "hair"))
	self.screen_helper:addChild(ColorButton(574, 405, "HEAD", {54/255,  57/255,  75/255},  "hair"))
	
	self.screen_helper:addChild(ColorButton(290, 190, "BODY", {127/255, 127/255, 127/255}, "main"))
	self.screen_helper:addChild(ColorButton(361, 190, "BODY", {181/255, 230/255, 29/255},  "main"))
	self.screen_helper:addChild(ColorButton(432, 190, "BODY", {229/255, 29/255,  29/255},  "main"))
	self.screen_helper:addChild(ColorButton(503, 190, "BODY", {29/255,  189/255, 229/255}, "main"))
	self.screen_helper:addChild(ColorButton(574, 190, "BODY", {172/255, 29/255,  229/255}, "main"))
	self.screen_helper:addChild(ColorButton(290, 261, "BODY", {38/255,  38/255,  38/255},  "main"))
	self.screen_helper:addChild(ColorButton(361, 261, "BODY", {255/255, 242/255, 0},       "main"))
	self.screen_helper:addChild(ColorButton(432, 261, "BODY", {224/255, 141/255, 69/255},  "main"))
	self.screen_helper:addChild(ColorButton(503, 261, "BODY", {255/255, 0,      203/255},  "main"))
	self.screen_helper:addChild(ColorButton(574, 261, "BODY", {255/255, 255/255, 255/255}, "main"))
	
	self.screen_helper:addChild(ColorButton(290, 365, "BODY", {127/255, 127/255, 127/255}, "stripe"))
	self.screen_helper:addChild(ColorButton(361, 365, "BODY", {181/255, 230/255, 29/255},  "stripe"))
	self.screen_helper:addChild(ColorButton(432, 365, "BODY", {229/255, 29/255,  29/255},  "stripe"))
	self.screen_helper:addChild(ColorButton(503, 365, "BODY", {29/255,  189/255, 229/255}, "stripe"))
	self.screen_helper:addChild(ColorButton(574, 365, "BODY", {172/255, 29/255,  229/255}, "stripe"))
	self.screen_helper:addChild(ColorButton(290, 436, "BODY", {38/255,  38/255,  38/255},  "stripe"))
	self.screen_helper:addChild(ColorButton(361, 436, "BODY", {255/255, 242/255, 0},       "stripe"))
	self.screen_helper:addChild(ColorButton(432, 436, "BODY", {224/255, 141/255, 69/255},  "stripe"))
	self.screen_helper:addChild(ColorButton(503, 436, "BODY", {255/255, 0,      203/255},  "stripe"))
	self.screen_helper:addChild(ColorButton(574, 436, "BODY", {255/255, 255/255, 255/255}, "stripe"))
end

return MiiChannel
