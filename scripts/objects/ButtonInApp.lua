local ButtonInApp, super = Class("Button")

function ButtonInApp:init(x, y, image)
	super.super:init(self, x, y, image)
	
	self.path = image
	
	self.sprite = Sprite(self.path)
	self:addChild(self.sprite)
	
	self:setOrigin(0.5,0.5)
	
	self.width = self.sprite.width
	self.height = self.sprite.height

	self.played_sound = false
end

return ButtonInApp
