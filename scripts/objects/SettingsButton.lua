local SettingsButton, super = Class("Button")

function SettingsButton:init(x, y)
	super:init(self, x, y, "settings")
	self.sprite:setOrigin(0.5,0.5)
	self.sprite:setPosition(x, y)
end

function SettingsButton:onClick()
	super:onClick(self)
	
	Game.wii_menu.state = "TRANSITIONOUT"
	Game.wii_menu.reason = "SettingsMenu"
end

function SettingsButton:update()
	super:update(self)
	
	self.sprite.alpha = Game.wii_menu.alpha
end

return SettingsButton