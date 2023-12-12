local SettingsButton, super = Class("Button")

function SettingsButton:init(x, y)
	super:init(self, x, y, "settings")
	self.cd = 0
end

function SettingsButton:onClick()
	super:onClick(self)
	
	Game.wii_menu.state = "TRANSITIONOUT"
	Game.wii_menu.reason = "SettingsMenu"
	
	self.cd = 0.25

	self.pressed = false
end

function SettingsButton:update()
	super:update(self)
	
	self.sprite.alpha = Game.wii_menu.alpha
	
	self.cd = self.cd - DT
end

function SettingsButton:draw()
	super:draw(self)
end

function SettingsButton:canHover()
	return not Game.wii_menu.tvSheet.page_debounce and self.cd <= 0 and Game.wii_menu.substate == "MAIN"
end

return SettingsButton