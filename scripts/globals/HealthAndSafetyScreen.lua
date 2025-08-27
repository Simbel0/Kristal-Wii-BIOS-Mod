---@class HealthAndSafetyScreen
local HealthAndSafetyScreen = {}

function HealthAndSafetyScreen:init()
	self.timer = LibTimer.new()

	-- For some reason, USA Wii consoles are the only ones where the warning screen
	-- was all white instead of colored
	local america_fuck_yeah = Game.wii_data["american"]
	self.warning = Assets.getTexture(america_fuck_yeah and "health_and_safety/warning_usa" or "health_and_safety/warning")

	self.font_continue = Assets.getFont("main_mono")
	
	Kristal.load_wii = true
end

function HealthAndSafetyScreen:enter()
	self.alpha = 0
	self.siner = 0
	self.maintenance_timer = 0

	self.state = "IDLE"
	self.show_confirm = false

	Kristal.hideCursor()

	self.timer:after(0.5, function()
		self.timer:tween(0.5, self, { alpha = 1 }, "linear", function()
			self.timer:after(1, function()
				self.show_confirm = true
			end)
		end)
	end)
end

function HealthAndSafetyScreen:leave()
	Kristal.showCursor()
end

function HealthAndSafetyScreen:update(dt)
	self.timer:update(dt)

	if self.show_confirm then
		self.siner = self.siner + DTMULT / 25

		if Input.mousePressed(1) and self.state == "IDLE" then
			self.state = "TRANSITIONING"
			self.timer:tween(0.5, self, { alpha = 0 }, "linear")
			self.timer:after(3, function() Mod:setState("MainMenu", false) end)
			Assets.playSound("wii/click")
		end

		if Input.mousePressed(3) and self.state == "IDLE" then
			self.maintenance_timer = self.maintenance_timer + DTMULT

			if self.maintenance_timer >= 180 then
				self.state = "TRANSITIONING"
				self.timer:tween(0.5, self, { alpha = 0 }, "linear")
				self.timer:after(3, function() Mod:setState("MainMenu", true) end)
				Assets.playSound("wii/click")
			end
		else
			self.maintenance_timer = 0
		end
	end
end

function HealthAndSafetyScreen:draw()
    love.graphics.clear(0, 0, 0, 1)
    love.graphics.push()

	love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle("fill", 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)

	love.graphics.setColor(1, 1, 1, self.alpha)
	love.graphics.draw(self.warning)

	love.graphics.setFont(self.font_continue)
	love.graphics.setColor(1, 1, 1, self.show_confirm and math.sin(self.siner * 5) * self.alpha or 0)
	local press_w = 355
	-- TODO: controller button icon support
	love.graphics.printf("Press LMB to continue.", SCREEN_WIDTH/2-press_w/2, 390, press_w, "center")

    love.graphics.pop()
end

return HealthAndSafetyScreen
