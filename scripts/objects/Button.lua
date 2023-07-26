local Button, super = Class(Object)

function Button:init(x, y, image)
	super:init(self, x, y, 0, 0)
	
	self.sprite = Sprite(image, x, y)
	self:addChild(self.sprite)
	
	self:setOrigin(0.5,0.5)
	self.sprite:setOrigin(0.5,0.5)
	
	self.width = self.sprite.width
	self.height = self.sprite.height
end

function Button:update() 
	super.update(self)

	local mx, my = love.mouse.getPosition()
	local screen_x, screen_y = self:getScreenPos()
	screen_x, screen_y = screen_x-self.width/2, screen_y-self.height/2
	if (mx / Kristal.getGameScale() > screen_x) and (mx / Kristal.getGameScale() < (screen_x + self.width)) and (my / Kristal.getGameScale() > screen_y) and (my / Kristal.getGameScale() < (screen_y + self.height)) then
		if self:canClick() then
			print("oh yeeeees")
		end
	end
end

function Button:draw() super:draw(self) end

function Button:onClick() end

function Button:canClick() return true end

return Button