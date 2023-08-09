local WiiSettingsButton, super = Class("Button")

function WiiSettingsButton:init(x, y)
	super:init(self, x, y, "wii_settings")
	self.sprite:setOrigin(0.5,0.5)
	self.sprite:setPosition(x, y)
end

function WiiSettingsButton:onClick()
	super:onClick(self)
end

return WiiSettingsButton