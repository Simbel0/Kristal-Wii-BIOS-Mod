local BackButton, super = Class("Button")

function BackButton:init(x, y, gray)
	if gray then
		super:init(self, x, y, "back_gray")
	else
		super:init(self, x, y, "back")
	end
	self.sprite:setOrigin(0.5,0.5)
	self.sprite:setPosition(x, y)
	self.cd = 0
end

function BackButton:onClick()
	super:onClick(self)
	
	if Game.wii_menu.substate == "MAIN" then
		Game.wii_menu.state = "TRANSITIONOUT"
		Game.wii_menu.reason = "MainMenu"
	elseif Game.wii_menu.substate == "DATA" or Game.wii_menu.substate == "SETTINGS" then
		Game.wii_menu.substate = "MAIN"
		self.cd = 1
	end

	self.pressed = false
end

function BackButton:update()
	super:update(self)
	self.cd = self.cd - DT
end

function BackButton:canClick()
	return self.cd <= 0
end

return BackButton