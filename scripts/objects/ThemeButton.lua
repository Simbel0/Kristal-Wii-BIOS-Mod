local ThemeButton, super = Class("Button")

function ThemeButton:init(x, y, theme)
	super.init(self, x, y, 0, 0)
	
	self.path = "button/settings"
	if theme ~= "DEFAULT" and love.filesystem.getInfo(Kristal.Mods.getMod("wii_kristal").path .. "/assets/sprites/button/" .. theme .. "/settings.png") then
		self.path = "button/" .. theme .. "/settings"
	end
	
	self.theme = theme
	
	self.sprite = Sprite(self.path)
	self:addChild(self.sprite)
	
	self:setOrigin(0.5,0.5)
	
	self.width = self.sprite.width
	self.height = self.sprite.height

	self.played_sound = false
end

function ThemeButton:onClick()
	super.onClick(self)
	
	self.wii_data = Game.wii_data
	self.wii_data["theme"] = self.theme
	
	love.filesystem.write("wii_settings.json", JSON.encode(self.wii_data))
	
	Game.wii_menu.cooldown = 0.25

	self.pressed = false
end

function ThemeButton:draw()
	if Game.wii_menu.substate == "SETTING" and Game.wii_menu.reason == "theme" then
		super.draw(self)
	end
end

function ThemeButton:canClick()
	return Game.wii_menu.cooldown <= 0
end

function ThemeButton:canHover()
	return Game.wii_menu.substate == "SETTING" and Game.wii_menu.reason == "theme"
end

return ThemeButton