---@class popUp : Object
local MessagePopUp, super = Class(Object)

function MessagePopUp:init(data, buttons, callback, game_message)
	super.init(self, 50, 30, SCREEN_WIDTH-100, SCREEN_HEIGHT-60)

	self.message = data
	self.text = self.message["message"]
	self.layer = 9999

	self.icon = nil
	local mod = Kristal.Mods.getMod(self.message["mod"])
	if mod then
		local icon_paths = {
			Kristal.Mods.getMod(self.message["mod"]).path.."/icon.png",
			Kristal.Mods.getMod(self.message["mod"]).path.."/preview/icon.png",
			Kristal.Mods.getMod(self.message["mod"]).path.."/preview/icon_1.png",
			Kristal.Mods.getMod(self.message["mod"]).path.."/preview/icon_01.png"
		}

		for i,path in ipairs(icon_paths) do
			if love.filesystem.getInfo(path) then
				self.icon = love.graphics.newImage(path)
				break
			end
		end
		if not self.icon then
			self.icon = Assets.getTexture("kristal/mod_icon")
		end
	end
	print(self.icon)

	self.y_dest = 0
	self.bg_alpha = 0

	self.state = "IDLE"

	self.font = Assets.getFont("maintenance")

	local suffix = game_message and "" or "_pt"
	self.top = Assets.getTexture("memo/top"..suffix)
	self.middle = Assets.getTexture("memo/middle"..suffix)
	self.bottom = Assets.getTexture("memo/bottom"..suffix)
	
	if love.filesystem.getInfo(Kristal.Mods.getMod("wii_kristal").path .. "/assets/sprites/memo/" .. Game.wii_data["theme"] .. "/top" .. suffix .. ".png") then
		self.top = Assets.getTexture("memo/" .. Game.wii_data["theme"] .. "/top"..suffix)
	end
	
	if love.filesystem.getInfo(Kristal.Mods.getMod("wii_kristal").path .. "/assets/sprites/memo/" .. Game.wii_data["theme"] .. "/middle" .. suffix .. ".png") then
		self.middle = Assets.getTexture("memo/" .. Game.wii_data["theme"] .. "/middle"..suffix)
	end
	
	if love.filesystem.getInfo(Kristal.Mods.getMod("wii_kristal").path .. "/assets/sprites/memo/" .. Game.wii_data["theme"] .. "/bottom" .. suffix .. ".png") then
		self.bottom = Assets.getTexture("memo/" .. Game.wii_data["theme"] .. "/bottom"..suffix)
	end

	self:setScale(0)

	self.timer = 0
	if type(buttons) == "number" then
		self.max_timer = buttons
	else
		self.buttons = buttons
	end
	
	self.clickables = {}

	if self.buttons then
		self.start_x = 265 - ((#self.buttons - 1) * 100)
		for i=1, #self.buttons do
			local button = TextButton(self.start_x + (200 * (i-1)), 340, self.buttons[i])
			button.layer = self.layer + 10
			self:addChild(button)
			table.insert(self.clickables, button)
		end
	end
	
	self.callback = callback
	
	self.y_offset = game_message and 23 or 0
	self.lines = {}
	local printmessage = "[BIOS]"
    for line in self.text:gmatch("[^\r\n]+") do
        table.insert(self.lines, line)
		printmessage = printmessage .. " " .. line
    end
	print(printmessage)
end

function MessagePopUp:onAdd()
	Mod.popup_on = true
	Assets.playSound("wii/warn")
end

function MessagePopUp:onRemove()
	Mod.popup_on = false
end

function MessagePopUp:update()
	self.timer = self.timer + DTMULT

	if self.timer <= 10 then
		if self.state ~= "TRANSITION" then
			print(self.y_dest)
			self:setScale(Utils.ease(0, 1, self.timer/10, "linear"), Utils.ease(0, 1, self.timer/10, "linear"))
			--self.bg_alpha = Utils.ease(0, 0.5, self.timer/10, "linear")
			for k,v in pairs(self.clickables) do
				v.y = Utils.ease(v.init_y+640, v.init_y, self.timer/10, "linear")
			end
			-- if self.button then
				-- self.button.y = Utils.ease(self.button.init_y+640, self.button.init_y, self.timer/20, "out-cubic")
			-- end
		else
			self:setScale(Utils.ease(1, 0, self.timer/10, "linear"), Utils.ease(0, 1, self.timer/10, "linear"))
			--self.bg_alpha = Utils.ease(0.5, 0, self.timer/20, "out-cubic")
			for k,v in pairs(self.clickables) do
				v.y = Utils.ease(v.init_y, v.init_y-640, self.timer/20, "out-cubic")
			end
			-- if self.button then
				-- self.button.y = Utils.ease(self.button.init_y, self.button.init_y-640, self.timer/20, "out-cubic")
			-- end
		end
	end

	if self.state == "TRANSITION" and self.timer > 20 then
		if self.callback then
			print("[BIOS] Callback detected")
			self.callback(self.clicked)
		end
		self:remove()
	end

	-- Temporary while waiting for the buttons object
	for k,v in pairs(self.clickables) do
		if v.buttonPressed then
			self.clicked = k
			break
		end
	end
	
	if (self.max_timer and self.max_timer <= self.timer + 20) or (self.clicked and self.state ~= "TRANSITION") then
		self.state = "TRANSITION"
		self.timer = 0
	end

	super.update(self)
end

function MessagePopUp:draw()
	--love.graphics.setColor(0.5, 0.5, 0.5, self.bg_alpha)
	--love.graphics.rectangle("fill", -50, -30, self.width+100, self.height+60)

	--[[love.graphics.setColor(1, 1, 1, 1)
	love.graphics.rectangle("fill", 0, self.y_dest, self.width, self.height)

	love.graphics.setColor(0.8, 0.8, 0.8, 1)
	love.graphics.rectangle("fill", 0, self.y_dest, self.width, 15)
	love.graphics.rectangle("fill", 0, self.y_dest+self.height-15, self.width, 15)]]

	love.graphics.draw(self.top, 0, self.y_dest, 0, 1.06, 1)
	for i=1,#self.lines do
		love.graphics.draw(self.middle, 0, (self.middle:getHeight()*(i-1))+self.top:getHeight(), 0, 1.06, 1)
	end
	love.graphics.draw(self.bottom, 0, self.top:getHeight()+(self.middle:getHeight()*#self.lines), 0, 1.06, 1)

	love.graphics.setFont(self.font)

	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.print(self.message["title"], ((self.width) - self.font:getWidth(self.message["title"])) / 2, 30-self.font:getHeight()/4)

	love.graphics.setColor(0.4, 0.4, 0.4, 1)

	if self.icon then
		love.graphics.draw(self.icon, 25, 80, 0, 2, 2)
	end

    local lineHeight = self.font:getHeight()*0.7
    local totalTextHeight = #self.lines * lineHeight

    local textY = 130+self.y_offset

    for i, line in ipairs(self.lines) do
        local textX = ((self.width) - self.font:getWidth(line)) / 2
        love.graphics.print(line, 45, textY+40*(i-1))
    end

    super.draw(self)
end

function MessagePopUp:onWheelMoved(x, y)
end

return MessagePopUp
