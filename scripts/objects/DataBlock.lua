---@class DataBlock : Object
local DataBlock, super = Class(Object)

function DataBlock:init(index, mod_id)
	super.init(self, 0, 0, 72, 72)

	self.block = Assets.getTexture("settings/block")
	
	self.slot_x = index%5
	if self.slot_x == 0 then
		self.slot_x = 5
	end -- If anyone can think of a better way to do this, let me know. -AcousticJamm
	
	self.slot_y = index%15
	if self.slot_y == 0 then
		self.slot_y = 15
	end -- Again, if anyone can think of a better way to do this, let me know.
	self.slot_y = math.ceil(self.slot_y/5)
	
	self.x = 60 + (113 * (self.slot_x - 1))
	self.y = 80 + (110 * (self.slot_y - 1))
	
	if mod_id then
		self.mod = Kristal.Mods.getMod(mod_id)
		self.icon = self.mod.icon and self.mod.icon[1] or Assets.getTexture("settings/default_icon")
	end
end

function DataBlock:getDebugInfo()
	local info = super.getDebugInfo(self)
	if self.mod then
		table.insert(info, "Mod: "..self.mod.name)
	end
	table.insert(info, "Index: ("..self.slot_x..", "..self.slot_y..")")
	return info
end

function DataBlock:update()
	super:update(self)
end

function DataBlock:draw()
	super:draw(self)
	
	if self.icon then
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.draw(self.icon, self.x + 6, self.y + 6, 0, 2, 2)
	end
	
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(self.block, self.x, self.y, 0, 2, 2)
end

function DataBlock:updateMod(mod_id)
	self.mod = Kristal.Mods.getMod(mod_id)
	self.icon = self.mod.icon or {Assets.getTexture("settings/default_icon")}
end

return DataBlock
