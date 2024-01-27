local Tab, super = Class(Object)

function Tab:init(x, y, image, substate)
	super:init(self, x+29, y+32, image)
	
	self.path = image
	
	self.sprite = Sprite(self.path)
	self:addChild(self.sprite)
	
	self:setOrigin(0.5,0.5)
	
	self.width = self.sprite.width
	self.height = self.sprite.height

	self.played_sound = false
	
	self.start_y = y+32
	
	self.substate = substate
end

function Tab:update() 
	super.update(self)

	local mx, my = love.mouse.getPosition()
	local screen_x, screen_y = self:getScreenPos()
	screen_x, screen_y = screen_x-self.width/2, screen_y-self.height/2
	if not self.pressed then
		if (mx / Kristal.getGameScale() > screen_x) and (mx / Kristal.getGameScale() < (screen_x + self.width)) and (my / Kristal.getGameScale() > screen_y) and (my / Kristal.getGameScale() < (screen_y + self.height)) and self:canHover() then
			if self:canClick() then
				if not self.played_sound then
					self.played_sound = true
					Assets.playSound("wii/hover")
				end
				if not self.pressed and love.mouse.isDown(1) then
					self.pressed = true
					self:onClick()
				end
			end
		else
			self.played_sound = false
		end
	end
end

function Tab:draw() super:draw(self) end

function Tab:onClick()
	Assets.playSound("wii/button_pressed")
	Game.wii_menu.cooldown = 0.5
	for k,v in pairs(Game.wii_menu.tabs) do
		if v.path == self.path then
			v.y = v.start_y + 10
		else
			v.y = v.start_y
		end
	end
	Game.wii_menu:setSubstate(self.substate)
	self.pressed = false
end

function Tab:canClick()
	return Game.wii_menu.cooldown <= 0
end
function Tab:canHover() return (not Game.wii_menu.popUp or (Game.wii_menu.popUp and Game.wii_menu.popUp:isRemoved())) and Game.wii_menu.clickable end

return Tab
