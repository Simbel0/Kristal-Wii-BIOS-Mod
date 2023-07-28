local BackButton, super = Class("Button")

function BackButton:init(x, y, gray)
	if gray then
		super:init(self, x, y, "button/back_gray")
	else
		super:init(self, x, y, "button/back")
	end
	self.sprite:setOrigin(0.5,0.5)
	self.sprite:setPosition(x, y)
end

function BackButton:onClick()
	super:onClick(self)
end

return BackButton