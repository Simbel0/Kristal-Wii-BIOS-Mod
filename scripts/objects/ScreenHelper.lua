---@class ScreenHelper : Object
local ScreenHelper, super = Class(Object)

function ScreenHelper:init()
	super.init(self, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
end

return ScreenHelper