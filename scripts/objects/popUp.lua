---@class popUp : Object
local popUp, super = Class(Object)

function popUp:init(text, buttons, callback)
	super.init(self, 50, 30, SCREEN_WIDTH-100, SCREEN_HEIGHT-60)
	self.text = text
	self.layer = 9999

	self.y_dest = -640
	self.bg_alpha = 0

	self.state = "IDLE"

	self.font = Assets.getFont("main_mono")

	self.timer = 0
	if type(buttons) == "number" then
		self.max_timer = buttons
	else
		self.buttons = buttons
	end

	self.button = Button(265, 340, "button/back")
	self.button.layer = self.layer + 10
	self:addChild(self.button)
	
	self.callback = callback
	
	self.lines = {}
	local printmessage = "[BIOS]"
    for line in self.text:gmatch("[^\r\n]+") do
        table.insert(self.lines, line)
		printmessage = printmessage .. " " .. line
    end
	print(printmessage)
end

function popUp:onAdd()
	Mod.popup_on = true
	Assets.playSound("wii/warn")
end

function popUp:onRemove()
	Mod.popup_on = false
end

function popUp:update()
	self.timer = self.timer + DTMULT

	if self.timer <= 20 then
		if self.state ~= "TRANSITION" then
			self.y_dest = Utils.ease(640, 0, self.timer/20, "out-cubic")
			self.bg_alpha = Utils.ease(0, 0.5, self.timer/20, "out-cubic")
			self.button.y = Utils.ease(self.button.init_y+640, self.button.init_y, self.timer/20, "out-cubic")
		else
			self.y_dest = Utils.ease(0, -640, self.timer/20, "out-cubic")
			self.bg_alpha = Utils.ease(0.5, 0, self.timer/20, "out-cubic")
			self.button.y = Utils.ease(self.button.init_y, self.button.init_y-640, self.timer/20, "out-cubic")
		end
	end

	if self.state == "TRANSITION" and self.timer > 20 then
		if self.callback then
			print("[BIOS] Callback detected")
			self.callback()
		end
		self:remove()
	end

	-- Temporary while waiting for the buttons object
	if self.button.buttonPressed and self.state ~= "TRANSITION" then
		self.state = "TRANSITION"
		self.timer = 0
	end

	super.update(self)
end

function popUp:draw()
	love.graphics.setColor(0, 0, 0, self.bg_alpha)
	love.graphics.rectangle("fill", -50, -30, self.width+100, self.height+60)

	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.rectangle("fill", 0, self.y_dest, self.width, self.height)

	love.graphics.setColor(0.8, 0.8, 0.8, 1)
	love.graphics.rectangle("fill", 0, self.y_dest, self.width, 15)
	love.graphics.rectangle("fill", 0, self.y_dest+self.height-15, self.width, 15)

	love.graphics.setFont(self.font)
	love.graphics.setColor(0.2, 0.2, 0.2, 1)

    local lineHeight = self.font:getHeight()*1.2
    local totalTextHeight = #self.lines * lineHeight

    local textY = ((self.height-130) - totalTextHeight) / 2

    for i, line in ipairs(self.lines) do
        local textX = ((self.width) - self.font:getWidth(line)) / 2
        love.graphics.print(line, textX, self.y_dest+textY + (i - 1) * lineHeight)
    end

    super.draw(self)
end

return popUp
