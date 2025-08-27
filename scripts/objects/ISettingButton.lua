local ISettingButton, super = Class("Button")

function ISettingButton:init(x, y, text, setting, page)
	super.init(self, x, y, "bar")
	
	self.text = text
	self.font = Assets.getFont("main_mono")
	
	self.setting = setting
	self.page = page
	
	
end

function ISettingButton:draw()
	if Game.wii_menu.page == self.page and Game.wii_menu.substate == "SETTINGS" then
		super.draw(self)
		
		love.graphics.setColor(Mod.Themes[Game.wii_data["theme"]]["TEXT"], 1)
		
		love.graphics.setFont(self.font)
		
		love.graphics.printf(self.text, 0, self.height/4, self.width, "center", 0, self.scale_x, self.scale_y)
		
		love.graphics.setColor(1, 1, 1, 1)
	end
end

function ISettingButton:update() 
	super.super.update(self)

	local mx, my = love.mouse.getPosition()
	local screen_x, screen_y = self:getScreenPos()
	screen_x, screen_y = screen_x-self.width/2, screen_y-self.height/2
	if not self.pressed then
		if (mx / Kristal.getGameScale() > screen_x) and (mx / Kristal.getGameScale() < (screen_x + self.width)) and (my / Kristal.getGameScale() > screen_y) and (my / Kristal.getGameScale() < (screen_y + self.height)) and self:canHover() then
			if self:canClick() then
				if not self.played_sound then
					self.played_sound = true
					Assets.playSound("wii/hover")
				end
				if not self.pressed and Input.mousePressed(1) then
					self.pressed = true
					self:onClick()
				end
			end
		else
			self.played_sound = false
		end
	else
		if not self.flash.parent then
			self.buttonPressed = true
		end
	end
end

function ISettingButton:onClick()
	super.onClick(self)
	
	Game.wii_menu.substate = "SETTING"
	Game.wii_menu.reason = self.setting
	Game.wii_menu.savepage = self.page
	
	Game.wii_menu.cooldown = 0.25

	self.pressed = false
end

function ISettingButton:canClick()
	return Game.wii_menu.cooldown <= 0
end

function ISettingButton:canHover()
	return Game.wii_menu.page == self.page and Game.wii_menu.substate == "SETTINGS"
end

return ISettingButton
