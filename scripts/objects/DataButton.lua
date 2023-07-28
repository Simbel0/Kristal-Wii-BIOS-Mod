local DataButton, super = Class("Button")

function DataButton:init(x, y)
	super:init(self, x, y, "button/data_management")
	self.sprite:setOrigin(0.5,0.5)
	self.sprite:setPosition(x, y)
end

function DataButton:onClick()
	super:onClick(self)
end

return DataButton