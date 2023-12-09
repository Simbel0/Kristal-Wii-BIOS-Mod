---@class MenuClock : Object
local MenuClock, super = Class(Object)

function MenuClock:init(x, y)
	super.init(self, x, y)

	self.numbers = Assets.getFrames("menu/my_Clock_a")
	self.seperator = Assets.getTexture("menu/my_Clock_ab")
	self.am = Assets.getTexture("menu/my_Clock_b0")
	self.pm = Assets.getTexture("menu/my_Clock_b1")

	self.width = self.numbers[1]:getWidth()*4
	self.height = self.numbers[1]:getHeight()

	self.alpha = 1

	self.sep_visible = true
	self.sep_alpha = 1

	self.clock_color = Mod.Themes[Game.wii_data["theme"]]["CLOCK"]
	self.wii_text_color = Mod.Themes[Game.wii_data["theme"]]["CLOCK_TEXT"]
	self.font = Assets.getFont("main_mono")

	self.text = true
	self.text_timer = 0
	self.text_faded = false
end

function MenuClock:update()
	local sec = tonumber(os.date("%S"))

	self.sep_visible = not (sec%2==0)

	if not self.sep_visible then
		if self.sep_alpha > 0 then
			self.sep_alpha = self.sep_alpha - 0.5
		end
	else
		if self.sep_alpha < 1 then
			self.sep_alpha = self.sep_alpha + 0.5
		end
	end

	if self.text then
		self.text_timer = self.text_timer + DTMULT
		if self.text_timer >= FRAMERATE*3.5 then
			if not self.text_faded then
				if self.alpha > 0 then
					self.alpha = self.alpha - 0.5
				else
					self.text_faded = true
				end
			else
				if self.alpha < 1 then
					self.alpha = self.alpha + 0.5
				else
					self.text = false
				end
			end
		end
	end
	
	self.alpha = Game.wii_menu.alpha
end

function MenuClock:draw()
	super.draw(self)

	if not self.text_faded then
		love.graphics.setColor(self.wii_text_color[1], self.wii_text_color[2], self.wii_text_color[3], self.alpha)
		love.graphics.setFont(self.font)
		love.graphics.printf("Wii Menu", 20, 5, 130, "center")
	else
		local last_shader = love.graphics.getShader()
		love.graphics.setShader(Mod.Shaders["RemoveColor"])

		local hour = os.date("%H")
		local ampm = tonumber(hour)>=12 and self.pm or self.am
		if not Game.wii_data["military"] then
			if tonumber(hour) > 12 then
				hour = tostring(tonumber(hour-12))
			end
		end
		local min = os.date("%M")

		love.graphics.setColor(self.clock_color[1], self.clock_color[2], self.clock_color[3], self.alpha)

		if #hour==2 then
			love.graphics.draw(self.numbers[tonumber(hour:sub(1, 1))+1])
			love.graphics.draw(self.numbers[tonumber(hour:sub(-1))+1], 30)
		else
			-- love.graphics.draw(self.numbers[1], self.x, self.y) -- DNE
			love.graphics.draw(self.numbers[tonumber(hour)+1], 30)
		end

		love.graphics.setColor(self.clock_color[1], self.clock_color[2], self.clock_color[3], self.sep_alpha*self.alpha)
		love.graphics.draw(self.seperator, 30*2)

		love.graphics.setColor(self.clock_color[1], self.clock_color[2], self.clock_color[3], self.alpha)
		if #min==2 then
			love.graphics.draw(self.numbers[tonumber(min:sub(1, 1))+1], 30*3)
			love.graphics.draw(self.numbers[tonumber(min:sub(-1))+1], 30*4)
		else
			love.graphics.draw(self.numbers[1], 30*3)
			love.graphics.draw(self.numbers[tonumber(min)+1], 30*4)
		end

		if not Game.wii_data["military"] then
			if Game.wii_data["am_right"] then
				love.graphics.draw(ampm, 30*6, 18)
			else
				love.graphics.draw(ampm, -45, 18)
			end
		end

		love.graphics.setShader(last_shader)
	end
end

return MenuClock
