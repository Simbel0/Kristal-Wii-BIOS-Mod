---@class MainMenu : GamestateState
local MainMenu = {}

function MainMenu:init()

	self.tvSheet = MenuTVSheet()
	self.tvSheet_y = 330

	self.state = "TRANSITIONIN"

	self.alpha = 0

	Assets.playSound("wii/start")
	self.music = Music("wiimenu")
end

function MainMenu:update()
	if self.state == "TRANSITIONIN" then
		if self.alpha < 1 then
			self.alpha = self.alpha + 0.05
		else
			self.state = "IDLE"
		end
	end
end

function MainMenu:draw()
	local r, g, b = Utils.unpack(Utils.hexToRgb("#CDCFD7"))
	love.graphics.setColor(r, g, b, self.alpha)
	love.graphics.rectangle("fill", 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)

	self.tvSheet:draw(self.alpha)
end

return MainMenu