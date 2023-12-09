local DataButton, super = Class("Button")

function DataButton:init(x, y)
	super:init(self, x, y, "data_management")
	self.sprite:setOrigin(0.5,0.5)
	self.sprite:setPosition(x, y)
end

function DataButton:onClick()
	super:onClick(self)
	Game.wii_menu.substate = "DATA"
	self.pressed = false
end

function DataButton:canHover() return Game.wii_menu.substate == "MAIN" end

return DataButton