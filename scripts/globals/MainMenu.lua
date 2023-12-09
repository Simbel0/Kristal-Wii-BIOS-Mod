---@class MainMenu : GamestateState
local MainMenu = {}

function MainMenu:init()
	self.stage = Stage()

	Game.wii_menu = self
	
	self.substate = "MAIN" -- MAIN, MESSAGE, CHANNEL
	
	self.did_messages = false
end

function MainMenu:enter(_, maintenance)
	self.alpha = 0

	self.state = "TRANSITIONIN"

	self.offset_moni = 0

	self.maintenance = maintenance

	self.tvSheet = MenuTVSheet()
	self.tvSheet_y = 330
	self.stage:addChild(self.tvSheet)

	self.monitor_back = Assets.getTexture("monitors")
	-- We'll add calculations to add more pages
	self.monitor_sets = 4

	if not Game.first then
		self.music = Music("wiimenu")
		Game.first = true
	end
	Assets.playSound("wii/start")
	
	self.screen_helper = ScreenHelper()
	self.stage:addChild(self.screen_helper)
	
	self.message_date = os.time{year=os.date("%Y"), month=os.date("%m"), day=os.date("%d")}
end

function MainMenu:update()
	if self.state == "TRANSITIONIN" then
		if self.alpha < 1 then
			self.alpha = self.alpha + 0.05
		else
			self.state = "IDLE"
		end
	end
	
	self.screen_helper:update()

	self.stage:update()
	if self.state == "TRANSITIONOUT" then
		if self.alpha > 0 then
			self.alpha = self.alpha - 0.05
		else
			Mod:setState(self.reason, self.maintenance)
			self = nil
		end
	end
end

function MainMenu:draw()
    love.graphics.clear(0, 0, 0, 1)
    love.graphics.push()

	local r, g, b = Utils.unpack(Mod.Themes[Game.wii_data["theme"]]["BG_LOWER"])
	love.graphics.setColor(r, g, b, self.alpha)
	love.graphics.rectangle("fill", 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)

	love.graphics.setColor(Mod.Themes[Game.wii_data["theme"]]["DATE"], self.alpha)
	if self.substate == "MAIN" then
		love.graphics.print(Utils.titleCase(Utils.sub(os.date("%a"), 1, 3)), 230, 400, 0, 1.25, 1.25)
		love.graphics.print(os.date("%d").."/"..os.date("%m"), 320, 400, 0, 1.25, 1.25)
	elseif self.substate == "MESSAGE" then
		local day = os.date("*t", self.message_date)
		if day.day < 10 then
			day.day = "0" .. day.day
		end
		if day.month < 10 then
			day.month = "0" .. day.month
		end
		love.graphics.print(Utils.titleCase(Utils.sub(os.date("%a", self.message_date), 1, 3)), 230, 400, 0, 1.25, 1.25)
		love.graphics.print(day.day.."/"..day.month, 320, 400, 0, 1.25, 1.25)
	end
	
	self.screen_helper:draw()

	self.tvSheet:draw(self.alpha)

    love.graphics.pop()

    love.graphics.push()
    Kristal.callEvent("postDraw")
    love.graphics.pop()
	if self.transition_cover then
		self.transition_cover:draw()
	end
end

return MainMenu
