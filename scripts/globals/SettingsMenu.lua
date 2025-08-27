---@class SettingsMenu
local SettingsMenu = {}

function SettingsMenu:init()
	self.stage = Stage()
	
	self.cooldown = 0

	self.background = Assets.getTexture("settings/settings")
	self.background_data = Assets.getTexture("settings/data")
	self.logo = Assets.getTexture("kristal")
	
	self.clickable = true

	self.font = Assets.getFont("main_mono")
	
	self.settings_names = {
		["name"] = "Save Name",
		["theme"] = "Wii BIOS Theme (Reload required)",
		["autoload"] = "Autoload Wii Menu",
		["american"] = "Colored H&S",
		["military"] = "12-Hour Time",
		["timestamp"] = "AM/PM Position"
	}
	
	self.settings_button = WiiSettingsButton(SCREEN_WIDTH - 160, 220)
	self.stage:addChild(self.settings_button)
	
	self.data_button = DataButton(160, 220)
	self.stage:addChild(self.data_button)
	
	self.back_button = BackButton(100, 440, true)
	self.stage:addChild(self.back_button)
	
	self.screen_helper = ScreenHelper()
	self.stage:addChild(self.screen_helper)
	
	self.name_button = ISettingButton(320, 105, "Save Name", "name", 1)
	self.screen_helper:addChild(self.name_button)
	
	self.theme_button = ISettingButton(320, 185, "Wii BIOS Theme", "theme", 1)
	self.screen_helper:addChild(self.theme_button)
	
	self.load_button = ISettingButton(320, 265, "Autoload Wii Menu", "autoload", 1)
	self.screen_helper:addChild(self.load_button)
	
	self.has_button = ISettingButton(320, 345, "Colored H&S", "american", 1)
	self.screen_helper:addChild(self.has_button)
	
	self.time_button = ISettingButton(320, 105, "12-Hour Time", "military", 2)
	self.screen_helper:addChild(self.time_button)
	
	self.stamp_button = ISettingButton(320, 185, "AM/PM Position", "timestamp", 2)
	self.screen_helper:addChild(self.stamp_button)
	
	self.enable_button = EnableButton(320, 185, true)
	self.screen_helper:addChild(self.enable_button)
	
	self.disable_button = EnableButton(320, 265, false)
	self.screen_helper:addChild(self.disable_button)
	
	self.default_theme = ThemeButton(70, 116, "DEFAULT")
	self.screen_helper:addChild(self.default_theme)
	
	self.dt_theme = ThemeButton(150, 116, "DETERMINATION")
	self.screen_helper:addChild(self.dt_theme)
	
	self.sd_theme = ThemeButton(230, 116, "SD_CARD")
	self.screen_helper:addChild(self.sd_theme)
	
	self.deoxynn_theme = ThemeButton(310, 116, "DEOXYNN")
	self.screen_helper:addChild(self.deoxynn_theme)
	
	self.legend_theme = ThemeButton(390, 116, "LEGEND")
	self.screen_helper:addChild(self.legend_theme)
	
	self.sneo_theme = ThemeButton(470, 116, "SNEO")
	self.screen_helper:addChild(self.sneo_theme)
	
	self.ut_theme = ThemeButton(550, 116, "UT_BATTLE")
	self.screen_helper:addChild(self.ut_theme)
	
	self.name_text = NameText(80, 100)
	self.screen_helper:addChild(self.name_text)
end

function SettingsMenu:enter(_, maintenance)
	Game.wii_menu = self

	self.alpha = 0

	self.state = "TRANSITIONIN"
	
	self.substate = "MAIN" -- MAIN, DATA, SETTINGS, SETTING
	self.setting = ""
	self.page = 1

	self.offset_moni = 0

	self.maintenance = maintenance
	
	self.mod_files = {}
	self.save_count = 0
	for index,mod in ipairs(Game.wii_data["channels"]) do
		if not Utils.containsValue(Utils.getKeys(Mod.wiiwares), mod) then
			local full_path = "saves/"..mod.."/file_0.json"
			if love.filesystem.getInfo(full_path) then
				table.insert(self.mod_files, mod)
				self.save_count = self.save_count + 1
			end
		end
	end
	
	self.blocks = {}
	for i=1, 15 do
		local block
		if self.mod_files[i] then
			block = DataBlock(i, self.mod_files[i])
		else
			block = DataBlock(i)
		end
		table.insert(self.blocks, block)
		self.stage:addChild(block)
	end
end

function SettingsMenu:update()
	if self.state == "TRANSITIONIN" then
		if self.alpha < 1 then
			self.alpha = self.alpha + 0.05
		else
			self.state = "IDLE"
		end
	end
	
	self.screen_helper:update()
	
	if Input.pressed("right", false) then
		if self.substate == "SETTINGS" then
			if self.cooldown <= 0 then
				if self.page < 2 then -- our current page number is 2
					self.page = self.page + 1
					Assets.playSound("wii/wsd_select")
					self.cooldown = 0.25
				end
			end
		end
		if self.substate == "DATA" then
			if self.cooldown <= 0 then
				if self.page < math.ceil(#self.mod_files/15) then
					self.page = self.page + 1
					Assets.playSound("wii/wsd_select")
					self.cooldown = 0.25
					for i=1, 15 do
						if self.mod_files[i + 15*(self.page-1)] then
							Game.wii_menu.blocks[i]:updateMod(Game.wii_menu.mod_files[i + 15*(self.page-1)])
						else
							Game.wii_menu.blocks[i]:updateMod()
						end
					end
				end
			end
		end
	end
	
	if Input.pressed("left", false) then
		if self.substate == "SETTINGS" or self.substate == "DATA" then
			if self.cooldown <= 0 then
				if self.page > 1 then
					self.page = self.page - 1
					Assets.playSound("wii/wsd_select")
					self.cooldown = 0.25
					if self.substate == "DATA" then
						for i=1, 15 do
							if self.mod_files[i + 15*(self.page-1)] then
								Game.wii_menu.blocks[i]:updateMod(Game.wii_menu.mod_files[i + 15*(self.page-1)])
							else
								Game.wii_menu.blocks[i]:updateMod()
							end
						end
					end
				end
			end
		end
	end

	self.stage:update()
	if self.state == "TRANSITIONOUT" then
		if self.alpha > 0 then
			self.alpha = self.alpha - 0.05
		else
			Mod:setState(self.reason, self.maintenance)
		end
	end
	
	self.cooldown = self.cooldown - DT
end

function SettingsMenu:draw()
    love.graphics.clear(0, 0, 0, 1)
    love.graphics.push()
	love.graphics.setColor(1, 1, 1, self.alpha)
	
	if self.substate == "DATA" then
		love.graphics.draw(self.background_data, 0, 0, 0, 2, 2)
		
		self.back_button:draw()
		for i=1, #self.blocks do
			self.blocks[i]:draw()
		end
		
		love.graphics.setFont(self.font)
		love.graphics.printf("Save Files: " .. self.save_count, 300, 420, 300, "center")
		love.graphics.print("Page " .. self.page .. "/" .. math.ceil(#self.mod_files/15), 440, 26)
	elseif self.substate == "MAIN" then
		love.graphics.draw(self.background, 0, 0, 0, 2, 2)
		love.graphics.draw(self.logo, 540, 36)
		
		self.settings_button:draw()
		self.data_button:draw()
		self.back_button:draw()
	elseif self.substate == "SETTINGS" then
		love.graphics.draw(self.background, 0, 0, 0, 2, 2)
		love.graphics.print("Ver. " .. Mod.info.version, 500, 26)
		love.graphics.print(self.page .. "/2", 580, 440)
		love.graphics.print("Wii Settings", 30, 26)
		
		self.back_button:draw()
	elseif self.substate == "SETTING" then
		love.graphics.draw(self.background, 0, 0, 0, 2, 2)
		love.graphics.print("Ver. " .. Mod.info.version, 500, 26)
		love.graphics.print(self.settings_names[self.reason], 30, 26)
		
		self.back_button:draw()
	end
	
	self.screen_helper:draw()

    love.graphics.pop()

    love.graphics.push()
    Kristal.callEvent("postDraw")
    love.graphics.pop()
end

return SettingsMenu
