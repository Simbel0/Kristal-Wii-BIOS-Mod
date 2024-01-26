local TextButtonInApp, super = Class("ButtonInApp")

function TextButtonInApp:init(x, y, text)
	super:init(self, x, y, "button/blank_button")
	
	self.text = text
	self.font = Assets.getFont("main_mono")
end

function TextButtonInApp:draw()
	super:draw(self)
	
	love.graphics.setColor(Mod.Themes[Game.wii_data["theme"]]["TEXT"], 1)
	
	love.graphics.setFont(self.font)
	
	love.graphics.printf(self.text, 0, self.height / self.scale_y / 4, self.width / self.scale_x, "center", 0, self.scale_x, self.scale_y)
	
	love.graphics.setColor(1, 1, 1, 1)
end

function TextButtonInApp:canClick()
	return true
end

return TextButtonInApp