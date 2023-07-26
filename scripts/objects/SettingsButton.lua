local SettingsButton, super = Class("Button")

function SettingsButton:init(x, y)
	super:init(self, x, y, "button/settings")
end

return SettingsButton