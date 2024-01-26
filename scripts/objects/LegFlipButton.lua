local LegFlipButton, super = Class("ButtonInApp")

function LegFlipButton:init(x, y, gray)
	super:init(self, x, y, "vii_channel/leg_swap")
end

function LegFlipButton:onClick()
	super:onClick(self)
	
	Game.wii_menu.mii.legs_left = not Game.wii_menu.mii.legs_left
	Game.wii_menu.cooldown = 0.5

	self.pressed = false
end

function LegFlipButton:canClick()
	return Game.wii_menu.cooldown <= 0
end
function LegFlipButton:canHover() return (not Game.wii_menu.popUp or (Game.wii_menu.popUp and Game.wii_menu.popUp:isRemoved())) end

return LegFlipButton