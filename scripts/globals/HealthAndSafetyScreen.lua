---@class HealthAndSafetyScreen : GamestateState
local HealthAndSafetyScreen = {}

function HealthAndSafetyScreen:init()
	local america_fuck_yeah = Game.wii_data["american"]
	self.warning = Assets.getTexture(america_fuck_yeah and "health_and_safety/warning_usa" or "health_and_safety/warning")

	self.font_continue = Assets.getFont("main_mono")

	self.timer = LibTimer.new()

	self.r = Mod:isAmerican()
	print(america_fuck_yeah, Mod:isAmerican())
end

function HealthAndSafetyScreen:enter()
	self.alpha = 0
	self.siner = 0

	self.state = "IDLE"
	self.show_confirm = false

	self.timer:after(0.5, function()
		self.timer:tween(0.5, self, { alpha = 1 }, "linear", function()
			self.timer:after(1, function()
				self.show_confirm = true
			end)
		end)
	end)
end

function HealthAndSafetyScreen:update(dt)
	self.timer:update(dt)

	if self.show_confirm then
		self.siner = self.siner + DTMULT / 25

		if love.mouse.isDown(1) and self.state == "IDLE" then
			self.state = "TRANSITIONING"
			self.timer:tween(0.5, self, { alpha = 0 }, "linear")
			self.timer:after(3, function() Mod:setState("MainMenu") end)
			Assets.playSound("wii/click")
		end
	end
end

function HealthAndSafetyScreen:draw()
	love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle("fill", 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)

	love.graphics.setColor(1, 1, 1, self.alpha)
	love.graphics.draw(self.warning)

	love.graphics.setFont(self.font_continue)
	love.graphics.setColor(1, 1, 1, self.show_confirm and math.sin(self.siner * 5) * self.alpha or 0)
	local press_w = 355
	-- TODO: controller button icon support
	love.graphics.printf("Press LMB to continue.", SCREEN_WIDTH/2-press_w/2, 390, press_w, "center")
end

return HealthAndSafetyScreen
