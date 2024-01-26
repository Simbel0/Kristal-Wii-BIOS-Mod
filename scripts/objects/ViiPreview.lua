local ViiPreview, super = Class(Object)

function ViiPreview:init(x, y)
	super:init(self, x, y)
	
	self.width = 152
	self.height = 336
end

function ViiPreview:update() 
	super.update(self)
end

function ViiPreview:draw()
	super:draw(self)
	
	if Game.wii_menu.mii then
		love.graphics.push()
		
		local hair = Assets.getTexture("vii_channel/hair_" .. Game.wii_menu.mii.head)
		local head = Assets.getTexture("vii_channel/head_" .. Game.wii_menu.mii.head)
		local outline = Assets.getTexture("vii_channel/bod_out_" .. Game.wii_menu.mii.body)
		local hands = Assets.getTexture("vii_channel/hands_" .. Game.wii_menu.mii.body)
		local mainbod = Assets.getTexture("vii_channel/bod_main_" .. Game.wii_menu.mii.body)
		local stripes = Assets.getTexture("vii_channel/stripes_" .. Game.wii_menu.mii.body)
		local legs = Assets.getTexture("vii_channel/leg_" .. (Game.wii_menu.mii.legs_left and "left" or "right"))
		
		love.graphics.scale(8, 8)
		
		love.graphics.setColor(Game.wii_menu.mii.hair_color)
		love.graphics.draw(hair, 0, 0)
		love.graphics.setColor(Game.wii_menu.mii.skin_color)
		love.graphics.draw(head, 0, 0)
		
		love.graphics.setColor(Game.wii_menu.mii.hair_color)
		love.graphics.draw(outline, 1, 17)
		love.graphics.setColor(Game.wii_menu.mii.skin_color)
		love.graphics.draw(hands, 1, 17)
		love.graphics.setColor(Game.wii_menu.mii.shirt_color_1)
		love.graphics.draw(mainbod, 1, 17)
		love.graphics.setColor(Game.wii_menu.mii.shirt_color_2)
		love.graphics.draw(stripes, 1, 17)
		
		love.graphics.setColor(Game.wii_menu.mii.hair_color)
		love.graphics.draw(legs, 3, 30)

		love.graphics.pop()
	end
end

return ViiPreview
