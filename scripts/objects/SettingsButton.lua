local SettingsButton, super = Class("Button")

function SettingsButton:init(x, y)
	super.init(self, x, y, "button/settings")
	self.sprite:setOrigin(0.5,0.5)
	self.sprite:setPosition(x, y)
end

return SettingsButton