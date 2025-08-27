---@class ViiNameText : Object
local ViiNameText, super = Class(Object)

function ViiNameText:init(x, y)
	super.init(self, x, y, 238, 36)
end

function ViiNameText:update()
	super.update(self)
	
	local mx, my = Input.getMousePosition()
	local screen_x, screen_y = self:getScreenPos()
	screen_x, screen_y = screen_x-self.width/2, screen_y-self.height/2
	if not self.pressed and self:canHover() then
		if (mx > self.x) and (mx < (self.x + self.width)) and (my > self.y) and (my < (self.y + self.height)) then
			if self:canClick() then
				if Input.mousePressed(1) and Game.wii_menu.cooldown <= 0 then
					Game.wii_menu.stage.timer:script(function(wait)
						Game.wii_menu.clickable = false
						
						local keyboard = ViiInputMenu(12)
						keyboard.finish_cb = function(input)
							Game.wii_menu.clickable = true
							if string.len(input) > 0 then
								Game.wii_menu.mii.name = input
							end
						end
						keyboard.y = keyboard.y - 8
						Game.wii_menu.screen_helper:addChild(keyboard)
					end)
				end
			end
		end
	end
end

function ViiNameText:draw()
	if Game.wii_menu.substate == "NAME" then
		super.draw(self)
		
		love.graphics.push()
		
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.rectangle("fill", 0, 0, 238, 36)
		
		love.graphics.setFont(Assets.getFont("maintenance"))
		love.graphics.setColor(0, 0, 0, 1)
		love.graphics.printf(Game.wii_menu.mii.name, 0, 0, 238, "center")
		
		love.graphics.pop()
	end
end

function ViiNameText:canClick() return Game.wii_menu.substate == "NAME" end
function ViiNameText:canHover() return Game.wii_menu.clickable end

return ViiNameText
