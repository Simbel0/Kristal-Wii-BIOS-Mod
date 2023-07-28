---@class SettingsMenu : GamestateState
local SettingsMenu = {}

function SettingsMenu:init()
	self.stage = Stage()

	Game.wii_menu = self
end

function SettingsMenu:enter(_, maintenance)
	self.alpha = 0

	self.state = "TRANSITIONIN"
	
	self.substate = "MAIN" -- MAIN, DATA, SETTINGS, SETTING
	self.setting = ""
	self.page = 1

	self.offset_moni = 0

	self.maintenance = maintenance
	
	self.background = Assets.getTexture("settings/settings")
	self.background_data = Assets.getTexture("settings/data")
	self.logo = Assets.getTexture("kristal")
	
	self.settings_button = WiiSettingsButton(SCREEN_WIDTH - 160, 220)
	self.stage:addChild(self.settings_button)
	
	self.data_button = DataButton(160, 220)
	self.stage:addChild(self.data_button)
	
	self.back_button = BackButton(100, 440, true)
	self.stage:addChild(self.back_button)
	
	self.mod_files = {}
	self.save_count = 0
	for index,mod in ipairs(Game.wii_data["channels"]) do
		if not Utils.containsValue(Utils.getKeys(Mod.wiiwares), mod) then
			local full_path = "saves/"..mod.."/file_wii.json"
			if love.filesystem.getInfo(full_path) then
				table.insert(self.mod_files, mod)
				self.save_count = self.save_count + 1
			end
		end
	end
	
	self.font = Assets.getFont("main_mono")
	
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

	self.stage:update()
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
	else
		love.graphics.draw(self.background, 0, 0, 0, 2, 2)
		love.graphics.draw(self.logo, 540, 36)
		
		if self.substate == "MAIN" then
			self.settings_button:draw()
			self.data_button:draw()
			self.back_button:draw()
		end
	end

    love.graphics.pop()

    love.graphics.push()
    Kristal.callEvent("postDraw")
    love.graphics.pop()
end

return SettingsMenu
