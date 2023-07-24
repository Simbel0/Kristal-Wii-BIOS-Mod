---@class MonitorMask : Object
local MonitorMask, super = Class(Object)

function MonitorMask:init(monitor)
	super.init(self, 0, 0)

	self.layer = 1
	self.mask = monitor.sprite_mask

	self.mask_fx = MaskFX(self.mask)
	self:addFX(self.mask_fx)
	self.mask_fx.active = true
end

function MonitorMask:fullDraw(...)
    super.fullDraw(self, ...)
end

return MonitorMask