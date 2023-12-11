---@class NameText : Object
local NameText, super = Class(Object)

function NameText:init(x, y)
	super.init(self, x, y, 376, 72)
end

function NameText:update()
	super:update(self)
	
	local mx, my = love.mouse.getPosition()
	local screen_x, screen_y = self:getScreenPos()
	screen_x, screen_y = screen_x-self.width/2, screen_y-self.height/2
	if not self.pressed and self:canHover() then
		if (mx / Kristal.getGameScale() > self.x) and (mx / Kristal.getGameScale() < (self.x + self.width)) and (my / Kristal.getGameScale() > self.y) and (my / Kristal.getGameScale() < (self.y + self.height)) then
			if self:canClick() then
				if love.mouse.isDown(1) and Game.wii_menu.cooldown <= 0 then
					Game.wii_menu.stage.timer:script(function(wait)
						Game.wii_menu.clickable = false
						
						local keyboard = GonerKeyboard(12, "default", function(text)
							Game.wii_data["name"] = text
							Game.wii_menu.clickable = true
							love.filesystem.write("wii_settings.json", JSON.encode(Game.wii_data))
						end, function(key, x, y, namer)
							if namer.text .. key == "GASTER" then
								love.audio.stop()
								self.stage.timescale = 0
								for _,child in ipairs(self.stage.children) do
									child.active = false
								end
								love.event.quit("restart")
							end
						end)
						keyboard.y = keyboard.y + 120
						Game.wii_menu.screen_helper:addChild(keyboard)
					end)
				end
			end
		end
	end
end

function NameText:draw()
	if Game.wii_menu.substate == "SETTING" and Game.wii_menu.reason == "name" then
		super:draw(self)
		
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.rectangle("fill", 0, 0, 376, 72)
		
		love.graphics.setFont(Assets.getFont("maintenance", 56))
		love.graphics.setColor(0, 0, 0, 1)
		love.graphics.printf(Game.wii_data["name"], 0, 0, 376, "center")
	end
end

function NameText:canClick() return Game.wii_menu.substate == "SETTING" and Game.wii_menu.reason == "name" end
function NameText:canHover() return Game.wii_menu.clickable end

return NameText
