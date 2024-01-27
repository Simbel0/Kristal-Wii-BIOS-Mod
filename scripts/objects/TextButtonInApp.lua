local TextButtonInApp, super = Class("ButtonInApp")

function TextButtonInApp:init(x, y, text, func)
	super:init(self, x, y, "button/blank_button")
	
	self.text = text
	self.font = Assets.getFont("main_mono")
	
	self.func = func
end

function TextButtonInApp:draw()
	super:draw(self)
	
	love.graphics.setColor(0, 0, 0, 1)
	
	love.graphics.setFont(self.font)
	
	love.graphics.printf(self.text, 0, self.height / self.scale_y / 4, self.width / self.scale_x, "center", 0, self.scale_x, self.scale_y)
	
	love.graphics.setColor(1, 1, 1, 1)
end

function TextButtonInApp:canClick()
	return Game.wii_menu.cooldown <= 0
end
function TextButtonInApp:canHover() return (not Game.wii_menu.popUp or (Game.wii_menu.popUp and Game.wii_menu.popUp:isRemoved())) end

function TextButtonInApp:onClick()
	super:onClick(self)
	self.pressed = false
	Game.wii_menu.cooldown = 0.5
	if self.func then
		self.func()
	end
end

return TextButtonInApp