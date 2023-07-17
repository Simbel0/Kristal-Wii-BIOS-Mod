---@class Monitor : Object
local Monitor, super = Class(Object)

function Monitor:init(x, y)
	super.init(self, x, y)

	self.edge = Assets.getTexture("menu/IplTopMaskEgde4x3")
end

function Monitor:draw(alpha)
	super.draw(self)

	love.graphics.setColor(1, 1, 1, alpha)
	love.graphics.draw(self.edge, self.x, self.y, 0, 1.15, 1.1, 0.5, 0.5)
	love.graphics.draw(self.edge, self.x, self.y, math.rad(90), 1.15, 1.1, 0.5, 0.5)
	love.graphics.draw(self.edge, self.x, self.y, math.rad(180), 1.15, 1.1, 0.5, 0.5)
	love.graphics.draw(self.edge, self.x, self.y, math.rad(270), 1.15, 1.1, 0.5, 0.5)
end

return Monitor