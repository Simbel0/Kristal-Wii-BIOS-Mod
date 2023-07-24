---@class Monitor : Object
local Monitor, super = Class(Object)

function Monitor:init(mod_id, index)
	super.init(self)

	self.edge = Assets.getTexture("menu/IplTopMaskEgde4x3")

	self.width = 0+self.edge:getWidth()*2.15
	self.height = 0+self.edge:getHeight()*1.65
	
	self.mod_id = mod_id
	local mod_data = Kristal.Mods.getMod(self.mod_id)
	if mod_data then
		self.path = mod_data.path .. "/assets/sprites/wii_channel.png"
	end

	if Utils.containsValue(Utils.getKeys(Mod.wiiwares), self.mod_id) then
		self.icon = Mod.wiiwares[mod_id]
	elseif love.filesystem.getInfo(self.path) then
		-- Get the sprite at the path
		self.icon = love.graphics.newImage(mod_data.path .. "/assets/sprites/wii_channel.png")
	else
		-- TODO: check for the library
		self.icon = "channels/gc_disc"
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
	
	self.x = 50 + (135 * (self.slot_x - 1)) + (540 * (self.page - 1))
	self.y = 15+ (101 * (self.slot_y - 1))

	self.sprite_mask = Sprite("channels/channel_mask", 5, 5)
	self.sprite_mask.visible = false
	self:addChild(self.sprite_mask)

	self.mask = MonitorMask(self)
	self:addChild(self.mask)

	self.sprite = Sprite(self.icon, 5, 5)
	Utils.hook(self.sprite, "canDebugSelect", function()
		return false
	end)
	self.mask:addChild(self.sprite)
end

function Monitor:getDebugInfo()
	local info = super.getDebugInfo(self)
	if not Utils.startsWith(self.mod_id, "wii_") then
		table.insert(info, "Mod: "..Kristal.Mods.getMod(self.mod_id).name.." ("..self.mod_id..")")
	else
		table.insert(info, "Wiiware: "..self.mod_id)
	end
	return info
end

function Monitor:draw()
	super.draw(self)
	local last_shader = love.graphics.getShader()
	love.graphics.setShader(Mod.Shaders["RemoveColor"])

	love.graphics.setColor(155/255, 155/255, 155/255, 1)
	love.graphics.draw(self.edge, 0, 0, 0, 1.15, 1.1, 0.5, 0.5)
	love.graphics.draw(self.edge, self.edge:getWidth()*2.15, 0, math.rad(90), 1.15, 1.1, 0.5, 0.5)
	love.graphics.draw(self.edge, self.edge:getWidth()*2.15, self.edge:getHeight()*1.65, math.rad(180), 1.15, 1.1, 0.5, 0.5)
	love.graphics.draw(self.edge, 0, self.edge:getHeight()*1.65, math.rad(270), 1.15, 1.1, 0.5, 0.5)

	love.graphics.setShader(last_shader)
end

return Monitor
