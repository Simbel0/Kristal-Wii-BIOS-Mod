local EnableButton, super = Class("Button")

function EnableButton:init(x, y, enable)
	super:init(self, x, y, "bar")
	
	self.text = enable and "Enable" or "Disable"
	self.font = Assets.getFont("main_mono")
	
	self.enable = enable
end

function EnableButton:draw()
	if Game.wii_menu.substate == "SETTING" and Utils.containsValue({"autoload", "american", "military", "timestamp"}, Game.wii_menu.reason) then
		super:draw(self)
		
		love.graphics.setColor(Mod.Themes[Game.wii_data["theme"]]["TEXT"], 1)
		
		love.graphics.setFont(self.font)
		
		love.graphics.printf(self.text, 0, self.height/4, self.width, "center", 0, self.scale_x, self.scale_y)
		
		love.graphics.setColor(1, 1, 1, 1)
	end
end

function EnableButton:update() 
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
	
	if Game.wii_menu.reason == "timestamp" then
		self.text = self.enable and "Left" or "Right"
	else
		self.text = self.enable and "Enable" or "Disable"
	end
end

function EnableButton:onClick()
	super:onClick(self)
	
	if Game.wii_menu.reason == "autoload" then
		Game.wii_data["load_early"] = self.enable
	elseif Game.wii_menu.reason == "american" then
		Game.wii_data["american"] = not self.enable
	elseif Game.wii_menu.reason == "timestamp" then
		Game.wii_data["am_right"] = not self.enable
	else
		Game.wii_data["military"] = not self.enable
	end
	
	love.filesystem.write("wii_settings.json", JSON.encode(Game.wii_data))
	
	Game.wii_menu.cooldown = 0.25

	self.pressed = false
end

function EnableButton:canClick()
	return Game.wii_menu.cooldown <= 0
end

function EnableButton:canHover()
	return Game.wii_menu.substate == "SETTING" and Utils.containsValue({"autoload", "american", "military", "timestamp"}, Game.wii_menu.reason)
end

return EnableButton
