local WarningScreen, super = Class(Object)

function WarningScreen:init()
	super.init(self, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)

	self.font_big = Assets.getFont("wii_font", 28)
	self.font_small = Assets.getFont("wii_font", 16)
	self.font = Assets.getFont("wii_font", 24)
	self.font:setLineHeight( 1.25 )

	self.confirm_alpha = 0
	self.siner = 0.5

	self.state = "IDLE"
	self.out_timer = 0

	Game.stage.timer:after(2, function()
		self.show_confirm = true
	end)

	self.widths = {
		Text("WARNING-HEALTH AND SAFETY", 0, 0, {font_size=28}):getTextWidth()/2
	}
end

function WarningScreen:update()
	super.update(self)
	if self.show_confirm then
		self.siner = self.siner + DTMULT/25

		if Input.pressed("confirm") and self.state == "IDLE" then
			self.state = "TRANSITIONING"
			Assets.playSound("wii/click")
		end

		if self.state == "TRANSITIONING" then
			self.out_timer = self.out_timer + DTMULT
			if self.alpha > 0 then
				self.alpha = 1 - (self.out_timer*4)/100
			end
			if self.out_timer >= 60 then
				self:remove()
			end
		end
	end
end

function WarningScreen:onRemoveFromStage()
	-- Commented because it crashes both Kristal and LÖVE otherwise if the BIOS doesn't exist
	--Mod.bios_menu = BIOS()
	--Game.stage:addChild(Mod.bios_menu)
end

function WarningScreen:draw()
	love.graphics.setColor(0, 0, 0, self.alpha)
	love.graphics.rectangle("fill", 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)

	love.graphics.setFont(self.font_big)
	love.graphics.setColor(1, 1, 1, self.alpha)
	love.graphics.print("WARNING-HEALTH AND SAFETY", (SCREEN_WIDTH/2)-self.widths[1]-75, 60)

	love.graphics.setFont(self.font)
	love.graphics.printf("BEFORE PLAYING, READ YOUR OPERATIONS MANUAL FOR IMPORTANT INFORMATION ABOUT YOUR HEALTH AND SAFETY", 0, 150, SCREEN_WIDTH - 10, "center")
	--ve.graphics.printf("THIS MOD LOADER")

	love.graphics.setFont(self.font_small)
	love.graphics.printf("Report bugs at", 0, 280, SCREEN_WIDTH, "center")
	--love.graphics.setFont(self.font)
	love.graphics.setColor(0.5, 0.7, 1, self.alpha)
	love.graphics.printf("https://discord.gg/8ZGuKXJE2C", 0, 315, SCREEN_WIDTH, "center")

	love.graphics.setFont(self.font)
	love.graphics.setColor(1, 1, 1, self.show_confirm and (math.cos((self.siner*5)) * 1)*self.alpha or 0)
	love.graphics.printf("Press "..Input.getText("confirm").." to continue.", 0, 380, SCREEN_WIDTH, "center")

	super.draw(self)
end

return WarningScreen