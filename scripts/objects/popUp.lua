---@class popUp : Object
local popUp, super = Class(Object)

function popUp:init(text, buttons)
	super.init(self, 50, 30, SCREEN_WIDTH-100, SCREEN_HEIGHT-60)
	self.text = text
	self.layer = 9999

	self.y_dest = -640
	self.bg_alpha = 0

	self.font = Assets.getFont("main_mono")

	self.timer = 0
	if type(buttons) == "number" then
		self.max_timer = buttons
	else
		self.buttons = buttons
	end
end

function popUp:update()
	self.timer = self.timer + DTMULT

	if self.timer <= 20 then
		self.y_dest = Utils.ease(640, 0, self.timer/20, "out-cubic")
		self.bg_alpha = Utils.ease(0, 0.5, self.timer/20, "out-cubic")
	end
end

function popUp:draw()
	super.draw(self)
	love.graphics.setColor(0, 0, 0, self.bg_alpha)
	love.graphics.rectangle("fill", -50, -30, self.width+100, self.height+60)

	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.rectangle("fill", 0, self.y_dest, self.width, self.height)

	love.graphics.setColor(0.8, 0.8, 0.8, 1)
	love.graphics.rectangle("fill", 0, self.y_dest, self.width, 15)
	love.graphics.rectangle("fill", 0, self.y_dest+self.height-15, self.width, 15)

	love.graphics.setColor(0, 0, 0, 1)
	local lines = {}
    for line in self.text:gmatch("[^\r\n]+") do
        table.insert(lines, line)
    end

    local lineHeight = self.font:getHeight()
    local totalTextHeight = #lines * lineHeight

    local textY = ((self.height-15) - totalTextHeight) / 2

    for i, line in ipairs(lines) do
        local textX = ((self.width) - self.font:getWidth(line)) / 2
        love.graphics.print(line, textX, self.y_dest+textY + (i - 1) * lineHeight)
    end
end

return popUp