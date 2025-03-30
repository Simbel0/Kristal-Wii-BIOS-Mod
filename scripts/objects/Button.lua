local Button, super = Class(Object)

function Button:init(x, y, image)
	super:init(self, x, y, 0, 0)
	
	if image then
		self.path = "button/" .. image
		if love.filesystem.getInfo(Kristal.Mods.getMod("wii_kristal").path .. "/assets/sprites/button/" .. Game.wii_data["theme"] .. "/" .. image .. ".png") then
			self.path = "button/" .. Game.wii_data["theme"] .. "/" ..image
		end
		
		self.sprite = Sprite(self.path)
		self:addChild(self.sprite)
		
		self:setOrigin(0.5,0.5)
		
		self.width = self.sprite.width
		self.height = self.sprite.height
	end

	self.played_sound = false
end

function Button:update() 
	super.update(self)

	local mx, my = love.mouse.getPosition()
	local screen_x, screen_y = self:getScreenPos()
	screen_x, screen_y = screen_x-self.width/2, screen_y-self.height/2
	if not self.pressed then
		if (mx / Kristal.getGameScale() > screen_x) and (mx / Kristal.getGameScale() < (screen_x + self.width)) and (my / Kristal.getGameScale() > screen_y) and (my / Kristal.getGameScale() < (screen_y + self.height)) and self:canHover() then
			if self:canClick() then
				if self.scale_x < 1.15 then
					self.scale_x = self.scale_x + 0.1*DTMULT
					self.scale_y = self.scale_y + 0.1*DTMULT
				end
				if not self.played_sound then
					self.played_sound = true
					Assets.playSound("wii/hover")
				end
				if not self.pressed and Input.mousePressed(1) then
					self.pressed = true
					self:onClick()
				end
			end
		else
			if self.scale_x > 1 then
				self.scale_x = self.scale_x - 0.1*DTMULT
				self.scale_y = self.scale_y - 0.1*DTMULT
			end
			self.played_sound = false
		end
	else
		if self.flash and not self.flash.parent then
			self.buttonPressed = true
		end
	end
end

function Button:draw() super:draw(self) end

function Button:onClick()
	Assets.playSound("wii/button_pressed")
	self.flash = FlashFade(self.sprite.texture, 0, 0)
    self.flash.layer = self.layer+10 -- TODO: Unhardcode?
    self.sprite:addChild(self.flash)
end

function Button:canClick() return not Mod.popup_on end
function Button:canHover() return true end

return Button
