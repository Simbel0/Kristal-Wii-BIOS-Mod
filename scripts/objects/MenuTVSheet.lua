---@class MenuTVSheet : Object
local MenuTVSheet, super = Class(Object)

function MenuTVSheet:init()
	super.init(self)

	self.shader = Mod.Shaders["RemoveColor"]

	self.wrap_texture_y = true

	self.lines = Sprite("menu/my_TVSheet_b")
	self.lines:setWrap(true)

	self.monitor_back = Assets.getTexture("monitors")
	self.monitor_sets = 4
	self.offset_moni = 0

	self.lower_background = Assets.getTexture("menu/my_TVSheet_e")
	self.lower_border = Assets.getTexture("menu/my_TVSheet_f")
	self.lower_shadow = Assets.getTexture("menu/my_TVSheet_g")

	self.clock = MenuClock(232, 337)

	self.monitor = Monitor("testmod", 3)
end

function MenuTVSheet:draw(alpha)
	local r, g, b = Utils.unpack(Utils.hexToRgb("#F2F2F2"))
	love.graphics.setColor(r, g, b, alpha)
	love.graphics.rectangle("fill", 0, 0, SCREEN_WIDTH, 331)

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
		love.graphics.draw(self.monitor_back, 55 + (540 * (i-1)) - self.offset_moni, 20)
	end
	
	love.graphics.setShader(self.shader)

	love.graphics.setColor(r, g, b, alpha)
	love.graphics.draw(self.lower_background, 0, 330, 0, 1.25, 1.1)
	love.graphics.setColor(0.3, 0.3, 0.3, alpha)
	love.graphics.draw(self.lower_shadow, 0, 330, 0, 1.25, 1.1)
	love.graphics.setColor(52/255, 192/255, 237/255)
	love.graphics.draw(self.lower_border, 0, (330)+2, 0, 1.25, 1.1)

	love.graphics.setColor(r, g, b, alpha)
	love.graphics.draw(self.lower_background, SCREEN_WIDTH, 330, 0, -1.25, 1.1)
	love.graphics.setColor(0.3, 0.3, 0.3, alpha)
	love.graphics.draw(self.lower_shadow, SCREEN_WIDTH, 330, 0, -1.25, 1.1)
	love.graphics.setColor(52/255, 192/255, 237/255)
	love.graphics.draw(self.lower_border, SCREEN_WIDTH, (330)+2, 0, -1.25, 1.1)

	love.graphics.setShader(last_shader)

	self.clock:draw(alpha)

	love.graphics.setColor(r, g, b, alpha)
	self.monitor:draw(self.alpha)
end

return MenuTVSheet