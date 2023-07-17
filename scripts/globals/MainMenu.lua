---@class MainMenu : GamestateState
local MainMenu = {}

function MainMenu:init()
	self.tvSheet = MenuTVSheet()
	self.tvSheet_y = 330

	self.monitor_back = Assets.getTexture("monitors")
	-- We'll add calculations to add more pages
	self.monitor_sets = 4

	self.music = Music("wiimenu")
	Assets.playSound("wii/start")
end

function MainMenu:enter()
	self.alpha = 0

	self.state = "TRANSITIONIN"

	self.offset_moni = 0
end

function MainMenu:update()
	if self.state == "TRANSITIONIN" then
		if self.alpha < 1 then
			self.alpha = self.alpha + 0.05
		else
			self.state = "IDLE"
		end
	end

	self.tvSheet.clock:update()
end

function MainMenu:draw()
    love.graphics.clear(0, 0, 0, 1)
    love.graphics.push()

	local r, g, b = Utils.unpack(Utils.hexToRgb("#CDCFD7"))
	love.graphics.setColor(r, g, b, self.alpha)
	love.graphics.rectangle("fill", 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)

	love.graphics.setColor(130/255, 130/255, 130/255, self.alpha)
	love.graphics.print(Utils.titleCase(Utils.sub(os.date("%a"), 1, 3)), 230, 400, 0, 1.25, 1.25)
	love.graphics.print(os.date("%d").."/"..os.date("%m"), 320, 400, 0, 1.25, 1.25)

	self.tvSheet:draw(self.alpha)

	love.graphics.setColor(1, 1, 1, self.alpha)

	for i=1, self.monitor_sets do
		love.graphics.draw(self.monitor_back, 55 + (540 * (i-1)) - self.offset_moni, 20)
	end

    love.graphics.pop()

    love.graphics.push()
    Kristal.callEvent("postDraw")
    love.graphics.pop()
end

return MainMenu
