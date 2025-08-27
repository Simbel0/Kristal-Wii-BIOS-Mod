local ColorButton, super = Class("ButtonInApp")

function ColorButton:init(x, y, substate, color, part)
	super.init(self, x, y, "vii_channel/color_button")
	self.sprite:setOrigin(0.5,0.5)
	self.sprite:setPosition(35, 35)
	self.cd = 0
	
	self.substate = substate
	self.color = color
	self.part = part
end

function ColorButton:onClick()
	super.onClick(self)
	
	Game.wii_menu.cooldown = 0.5

	self.pressed = false
	
	if self.part == "skin" then
		Game.wii_menu.mii.skin_color = self.color
	elseif self.part == "hair" then
		Game.wii_menu.mii.hair_color = self.color
	elseif self.part == "main" then
		Game.wii_menu.mii.shirt_color_1 = self.color
	elseif self.part == "stripe" then
		Game.wii_menu.mii.shirt_color_2 = self.color
	end
end

function ColorButton:update()
	super.update(self)
	self.cd = self.cd - DT
end

function ColorButton:draw()
	if self.substate == Game.wii_menu.substate then
		super.draw(self)
	
		love.graphics.push()
		
		love.graphics.setColor(self.color)
		love.graphics.rectangle("fill", 15, 15, 40, 40)
		
		love.graphics.pop()
	end
end

function ColorButton:canClick()
	return Game.wii_menu.cooldown <= 0
end
function ColorButton:canHover() return (not Game.wii_menu.popUp or (Game.wii_menu.popUp and Game.wii_menu.popUp:isRemoved())) and self.substate == Game.wii_menu.substate end

return ColorButton