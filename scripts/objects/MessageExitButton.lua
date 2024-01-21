local MessageExitButton, super = Class("Button")

function MessageExitButton:init(x, y)
	super:init(self, x, y, "back")
	self.sprite:setOrigin(0.5,0.5)
	self.sprite:setPosition(90, 27)
	self.cd = 0
end

function MessageExitButton:onClick()
	super:onClick(self)
	
	Game.wii_menu.popUp.state = "TRANSITION"
	Game.wii_menu.popUp.timer = 0
	Game.wii_menu.stage.timer:tween(0.5, self, {x = self.x - 210}, "in-sine")
	
	self.cd = 0.5

	self.pressed = false
end

function MessageExitButton:update()
	super:update(self)
	self.cd = self.cd - DT/2
end

function MessageExitButton:canClick()
	return self.cd <= 0
end

function MessageExitButton:canHover()
	return Mod.popup_on and Game.wii_menu.popUp
end

return MessageExitButton