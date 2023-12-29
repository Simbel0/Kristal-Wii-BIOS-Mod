---@class Monitor : Object
local Monitor, super = Class(Object)

function Monitor:init(mod_id, index)
	super.init(self)

	self.edge = Assets.getTexture("menu/IplTopMaskEgde4x3")

	self.width = 0+self.edge:getWidth()*2.15 - 4
	self.height = 0+self.edge:getHeight()*1.65 - 4
	
	self.mod_id = mod_id
	local mod_data = Kristal.Mods.getMod(self.mod_id)
	if mod_data then
		self.path = mod_data.path .. "/assets/sprites/wii_channel.png"
	end

	if Utils.containsValue(Utils.getKeys(Mod.wiiwares), self.mod_id) then
		self.icon = Mod.wiiwares[mod_id]
	elseif love.filesystem.getInfo(self.path) then
		-- Get the sprite at the path
		self.icon = love.graphics.newImage(mod_data.path .. "/assets/sprites/wii_channel.png")
	else
		-- TODO: check for the library
		self.icon = "channels/gc_disc"
		if love.filesystem.getInfo(mod_data.path .. "/libraries/wii_bios_lib") or love.filesystem.getInfo(mod_data.path .. "/libraries/wii_bios_lib.zip") then
			self.icon = "channels/wii_disc"
		end
	end
	if mod_data and love.filesystem.getInfo(mod_data.path .. "/assets/sprites/wii_channel_1.png") then
		self.anim = {}
		local i = 1
		while love.filesystem.getInfo(mod_data.path .. "/assets/sprites/wii_channel_" .. i .. ".png") do
			table.insert(self.anim, love.graphics.newImage(mod_data.path .. "/assets/sprites/wii_channel_" .. i .. ".png"))
			i = i + 1
		end
	end
	
	self.slot_x = index%4
	if self.slot_x == 0 then
		self.slot_x = 4
	end -- If anyone can think of a better way to do this, let me know. -AcousticJamm
	
	self.slot_y = index%12
	if self.slot_y == 0 then
		self.slot_y = 12
	end -- Again, if anyone can think of a better way to do this, let me know.
	self.slot_y = math.ceil(self.slot_y/4)
	
	self.page = math.ceil(index/12)
	
	self.x = 50 + (135 * (self.slot_x - 1)) + (540 * (self.page - 1))
	self.y = 15+ (101 * (self.slot_y - 1))

	self.sprite_mask = Sprite("channels/channel_mask", 5, 5)
	self.sprite_mask.visible = false
	self:addChild(self.sprite_mask)

	self.mask = MonitorMask(self)
	self:addChild(self.mask)

	self.sprite = Sprite(self.icon, 5, 5)
	Utils.hook(self.sprite, "canDebugSelect", function()
		return false
	end)
	self.mask:addChild(self.sprite)
	
	self.hovered = false
	
	self.hover = Assets.newSound("wii/hover")
	
	self.font = Assets.getFont("main")
	
	self.bubble_corner = Assets.getTexture("menu/my_Balloon_a")
	self.bubble_width = Assets.getTexture("menu/my_Beta16x16_a")
	self.cd = 0
	
	self.tick = 0
	self.speed = 1/5
	if self.anim and love.filesystem.getInfo(mod_data.path .. "/preview/wii_preview.lua") then
		local chunk = love.filesystem.load(mod_data.path .. "/preview/wii_preview.lua")
		local success, result = pcall(chunk, mod_data.path)
		if success then
			if result.icon_speed then
				print(result.icon_speed)
				self.speed = result.icon_speed
			end
		else
			Kristal.Console:warn("[BIOS] wii_preview.lua error: " .. result)
		end
	elseif self.anim and love.filesystem.getInfo(mod_data.path .. "/wii_preview.lua") then
		local chunk = love.filesystem.load(mod_data.path .. "/wii_preview.lua")
		local success, result = pcall(chunk, mod_data.path)
		if success then
			if result.icon_speed then
				print(result.icon_speed)
				self.speed = result.icon_speed
			end
		else
			Kristal.Console:warn("[BIOS] wii_preview.lua error: " .. result)
		end
	end
end

function Monitor:getDebugInfo()
	local info = super.getDebugInfo(self)
	if not Utils.startsWith(self.mod_id, "wii_") then
		table.insert(info, "Mod: "..Kristal.Mods.getMod(self.mod_id).name.." ("..self.mod_id..")")
		local icontest = "False"
		if self.icon == "channels/gc_disc" or self.icon == "channels/wii_disc" then
			icontest = "True"
		end
		table.insert(info, "Default Icon: "..icontest)
	else
		table.insert(info, "Wiiware: "..self.mod_id)
	end
	table.insert(info, "Index: ("..self.slot_x..", "..self.slot_y..")")
	table.insert(info, "Page: "..self.page)
	return info
end

function Monitor:update()
	self.cd = self.cd - DT
	self.tick = self.tick + DT
	if Mod.popup_on then return end
	local mx, my = love.mouse.getPosition()
	local screen_x, screen_y = self:getScreenPos()
	
	if self.anim then
		local index = ((math.floor(self.tick/self.speed))%#self.anim)+1
		self.sprite:setSprite(self.anim[index])
	end
	
	if (mx / Kristal.getGameScale() > screen_x) and (mx / Kristal.getGameScale() < (screen_x + self.width)) and (my / Kristal.getGameScale() > screen_y) and (my / Kristal.getGameScale() < (screen_y + self.height)) and Game.wii_menu.tvSheet and self.page == Game.wii_menu.tvSheet.page and self:canHover() then
		if not self.hovered then
			self.hover:play()
			self.hovered = true
			self:setLayer(1)
		end
		if self:canClick() and not self.pressed and love.mouse.isDown(1) then
			Game:setFlag("selected_mod", self.mod_id)
			Assets.playSound("wii/button_pressed")
			Game.musicplay:stop()
			Game.musicplay = nil
			Mod:setState("Pregame", false)
		elseif self:canClick() and not self.pressed and love.mouse.isDown(2) then
			print("Dragging " .. self.mod_id)
		end
	else
		if self.hovered then
			self.hovered = false
			self:setLayer(0)
		end
	end
end

function Monitor:draw()
	super.draw(self)
	local last_shader = love.graphics.getShader()
	love.graphics.setShader(Mod.Shaders["RemoveColor"])

	if self.hovered then
		love.graphics.setColor(Mod.Themes[Game.wii_data["theme"]]["BORDER"], 1)
	else
		love.graphics.setColor(155/255, 155/255, 155/255, 1)
	end
	love.graphics.draw(self.edge, 0, 0, 0, 1.15, 1.1, 0.5, 0.5)
	love.graphics.draw(self.edge, self.edge:getWidth()*2.15, 0, math.rad(90), 1.15, 1.1, 0.5, 0.5)
	love.graphics.draw(self.edge, self.edge:getWidth()*2.15, self.edge:getHeight()*1.65, math.rad(180), 1.15, 1.1, 0.5, 0.5)
	love.graphics.draw(self.edge, 0, self.edge:getHeight()*1.65, math.rad(270), 1.15, 1.1, 0.5, 0.5)

	love.graphics.setShader(last_shader)
	
	if self.hovered then
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.draw(self.bubble_corner, -18, 103)
		love.graphics.draw(self.bubble_corner, -18, 151, math.rad(270))
		local name = ""
		if not Utils.startsWith(self.mod_id, "wii_") then
			name = Kristal.Mods.getMod(self.mod_id).name
		else
			if self.mod_id == "wii_rtk" then
				name = "Return to Kristal"
			elseif self.mod_id == "wii_food" then
				name = "Demae Channel"
			end
		end
		local bubwidth = self.font:getWidth(name)
		love.graphics.draw(self.bubble_corner, 18+bubwidth, 103, math.rad(90))
		love.graphics.draw(self.bubble_corner, 18+bubwidth, 151, math.rad(180))
		love.graphics.rectangle( "fill", 6, 107, bubwidth-12, 40)
		love.graphics.setColor(55/255, 55/255, 55/255, 1)
		love.graphics.setFont(self.font)
		love.graphics.print(name, 0, 111)
	end
end

function Monitor:canClick()
	return self.cd <= 0
end

function Monitor:canHover()
	return ((not Game.wii_menu.tvSheet.popUp) or Game.wii_menu.tvSheet.popUp:isRemoved()) and Game.wii_menu.state == "IDLE"
end

return Monitor
