---@class MenuTVSheet : Object
local MenuTVSheet, super = Class(Object)

function MenuTVSheet:init()
	super.init(self, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)

	self.shader = Mod.Shaders["RemoveColor"]

	self.wrap_texture_y = true

	self.lines = Sprite("menu/my_TVSheet_b")
	self.lines:setWrap(true)

	self.monitor_back = Assets.getTexture("monitors")
	self.monitor_sets = 4
	self.offset_moni = 0
	self.page = 1
	
	self.page_debounce = false

	self.lower_background = Assets.getTexture("menu/my_TVSheet_e")
	self.lower_border = Assets.getTexture("menu/my_TVSheet_f")
	self.lower_shadow = Assets.getTexture("menu/my_TVSheet_g")

	self.clock = MenuClock(232, 337)
	self:addChild(self.clock)

	self.monitors = {}
	for index,mod in ipairs(Game.wii_data["channels"]) do
		local monitor = Monitor(mod, index)
		table.insert(self.monitors, monitor)
		self:addChild(monitor)
	end
	
	self.settings_button = SettingsButton(60, 410)
	self:addChild(self.settings_button)
end

function MenuTVSheet:onAdd()
	if Game.wii_menu.maintenance then
		self.popUp = popUp("The system is operating\nin maintenance mode.\nThe Wii Message Board\ncannot be used.", {"Ok"}, function(clicked) print("Called back: " .. clicked) end)
		self:addChild(self.popUp)
	end
end

function MenuTVSheet:draw(alpha)
	local r, g, b = Utils.unpack(Mod.Themes[Game.wii_data["theme"]]["BG"])
	love.graphics.setColor(r, g, b, alpha)
	love.graphics.rectangle("fill", 0, 0, SCREEN_WIDTH, 331 + self.y)

    local screen_l, screen_u = love.graphics.inverseTransformPoint(0, 0)
    local screen_r, screen_d = love.graphics.inverseTransformPoint(SCREEN_WIDTH, SCREEN_HEIGHT)

    local x1, y1 = math.min(screen_l, screen_r), math.min(screen_u, screen_d)
    local x2, y2 = math.max(screen_l, screen_r), math.max(screen_u, screen_d)

    local x_offset = math.floor(x1 / 608) * 608
    local y_offset = math.floor(y1 / 8) * 8

    local wrap_width = math.ceil((x2 - x_offset) / 608)
    local wrap_height = math.ceil((y2 - y_offset) / 8)

    local last_shader = love.graphics.getShader()

    self.lines.alpha = alpha-0.9
    self.lines:draw()

    love.graphics.setColor(1, 1, 1, alpha)

	for i=1, self.monitor_sets do
		love.graphics.draw(self.monitor_back, 55 + (540 * (i-1)) - self.offset_moni, self.y + 20)
	end
	
	love.graphics.setShader(self.shader)

	love.graphics.setColor(r, g, b, alpha)
	love.graphics.draw(self.lower_background, 0, self.y + 330, 0, 1.25, 1.1)
	love.graphics.setColor(0.3, 0.3, 0.3, alpha)
	love.graphics.draw(self.lower_shadow, 0, self.y + 330, 0, 1.25, 1.1)
	love.graphics.setColor(Mod.Themes[Game.wii_data["theme"]]["BORDER"], alpha)
	love.graphics.draw(self.lower_border, 0, self.y + (330)+2, 0, 1.25, 1.1)

	love.graphics.setColor(r, g, b, alpha)
	love.graphics.draw(self.lower_background, SCREEN_WIDTH, self.y + 330, 0, -1.25, 1.1)
	love.graphics.setColor(0.3, 0.3, 0.3, alpha)
	love.graphics.draw(self.lower_shadow, SCREEN_WIDTH, self.y + 330, 0, -1.25, 1.1)
	love.graphics.setColor(Mod.Themes[Game.wii_data["theme"]]["BORDER"], alpha)
	love.graphics.draw(self.lower_border, SCREEN_WIDTH, self.y + (330)+2, 0, -1.25, 1.1)

	love.graphics.setShader(last_shader)

	love.graphics.setColor(r, g, b, alpha)
	
	self.settings_button:draw()
	super.draw(self)
end

function MenuTVSheet:update()
	super:update(self)

	if Input.pressed("right", false) then
		if Game.wii_menu.substate == "MAIN" and self.page < self.monitor_sets and not self.page_debounce then
			Assets.playSound("wii/wsd_select")
			self.page = self.page + 1
			self.page_debounce = true
			Game.wii_menu.stage.timer:tween(0.4, self, {offset_moni = self.offset_moni + 540}, "out-cubic", function()
				self.page_debounce = false
			end)
			for k,v in pairs(self.monitors) do
				Game.wii_menu.stage.timer:tween(0.4, v, {x = v.x - 540}, "out-cubic")
			end
		elseif Game.wii_menu.substate == "MESSAGE" then
			Assets.playSound("wii/wsd_select")
			Game.wii_menu.message_date = Game.wii_menu.message_date + 86400
		end
    end

    if Input.pressed("left", false) then
		if Game.wii_menu.substate == "MAIN" and self.page > 1 and not self.page_debounce then
			Assets.playSound("wii/wsd_select")
			self.page = self.page - 1
			self.page_debounce = true
			Game.wii_menu.stage.timer:tween(0.4, self, {offset_moni = self.offset_moni - 540}, "out-cubic", function()
				self.page_debounce = false
			end)
			for k,v in pairs(self.monitors) do
				Game.wii_menu.stage.timer:tween(0.4, v, {x = v.x + 540}, "out-cubic")
			end
		elseif Game.wii_menu.substate == "MESSAGE" then
			Assets.playSound("wii/wsd_select")
			Game.wii_menu.message_date = Game.wii_menu.message_date - 86400
		end
    end
	
	if Input.pressed("up", false) and Game.wii_menu.substate == "MAIN" and not self.page_debounce and not Game.wii_menu.maintenance then
		self.page_debounce = true
		Game.wii_menu.substate = "MESSAGE"
		Game.wii_menu.stage.timer:tween(0.4, self, {y = self.y - 430}, "out-cubic", function()
			self.page_debounce = false
		end)
		for k,v in pairs(self.monitors) do
			Game.wii_menu.stage.timer:tween(0.4, v, {y = v.y - 430}, "out-cubic")
		end
	elseif Input.pressed("up", false) and Game.wii_menu.maintenance and ((not self.popUp) or self.popUp:isRemoved()) then
		self.popUp = popUp("The system is operating\nin maintenance mode.\nThe Wii Message Board\ncannot be used.", {"Ok"}, function(clicked) print("Called back: " .. clicked) end)
		self:addChild(self.popUp)
	end
	
	if Input.pressed("down", false) and Game.wii_menu.substate == "MESSAGE" and not self.page_debounce then
		self.page_debounce = true
		Game.wii_menu.substate = "MAIN"
		Game.wii_menu.stage.timer:tween(0.4, self, {y = self.y + 430}, "out-cubic", function()
			self.page_debounce = false
		end)
		for k,v in pairs(self.monitors) do
			Game.wii_menu.stage.timer:tween(0.4, v, {y = v.y + 430}, "out-cubic")
		end
		Game.wii_menu.message_date = os.time{year=os.date("%Y"), month=os.date("%m"), day=os.date("%d")}
	end
end

return MenuTVSheet
