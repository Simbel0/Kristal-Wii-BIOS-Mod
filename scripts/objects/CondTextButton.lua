local CondTextButton, super = Class("TextButtonInApp")

function CondTextButton:init(x, y, text, ss, func)
	super:init(self, x, y, text, func)
	
	self.ss = ss
end

function CondTextButton:draw()
	if self.ss == Game.wii_menu.substate then
		super:draw(self)
	end
end

function CondTextButton:canClick()
	return Game.wii_menu.cooldown <= 0
end
function CondTextButton:canHover() return super:canHover(self) and (self.ss == Game.wii_menu.substate) end

return CondTextButton