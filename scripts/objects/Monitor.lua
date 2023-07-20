---@class Monitor : Object
local Monitor, super = Class(Object)

function Monitor:init(x, y, mod_id, index)
	super.init(self, x, y)

	self.edge = Assets.getTexture("menu/IplTopMaskEgde4x3")
	
	self.mod_id = mod_id
	self.path = Kristal.Mods.getMod(self.mod_id).path .. "assets/sprites/wii_channel"
	if love.filesystem.exists(self.path) then
		-- Get the sprite at the path
	else
		self.icon = Assets.getTexture("channels/wii_disc")
	end
	
	self.slot_x = index%4
	if self.slot_x == 0 then
		self.slot_x = 4
	end -- If anyone can think of a better way to do this, let me know. -AcousticJamm
	
	self.slot_y = index%12
	if self.slot_y == 0 then
		self.slot_y = 12
	end -- Again, if anyone can think of a better way to do this, let me know.
	self.slot_y = math.ceil(self.slot_y/4)
	
	self.page = math.ceil(index/12)
end

function Monitor:draw(alpha)
	super.draw(self)
	local last_shader = love.graphics.getShader()
	love.graphics.setShader(Mod.Shaders["RemoveColor"])

	love.graphics.setColor(155/255, 155/255, 155/255, alpha)
	love.graphics.draw(self.edge, self.x, self.y, 0, 1.15, 1.1, 0.5, 0.5)
	love.graphics.draw(self.edge, self.x+self.edge:getWidth()*2.15, self.y, math.rad(90), 1.15, 1.1, 0.5, 0.5)
	love.graphics.draw(self.edge, self.x+self.edge:getWidth()*2.15, self.y+self.edge:getHeight()*1.65, math.rad(180), 1.15, 1.1, 0.5, 0.5)
	love.graphics.draw(self.edge, self.x, self.y+self.edge:getHeight()*1.65, math.rad(270), 1.15, 1.1, 0.5, 0.5)

	love.graphics.setShader(last_shader)
end

return Monitor
