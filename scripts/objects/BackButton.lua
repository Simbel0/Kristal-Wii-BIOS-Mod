local BackButton, super = Class("Button")

function BackButton:init(x, y, gray)
	if gray then
		super:init(self, x, y, "back_gray")
	else
		super:init(self, x, y, "back")
	end
	self.sprite:setOrigin(0.5,0.5)
	self.sprite:setPosition(x, y)
end

function BackButton:onClick()
	super:onClick(self)
	
	if Game.wii_menu.substate == "MAIN" then
		Game.wii_menu.state = "TRANSITIONOUT"
		Game.wii_menu.reason = "MainMenu"
	end

	self.pressed = false
end

return BackButton