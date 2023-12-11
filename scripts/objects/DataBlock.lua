---@class DataBlock : Object
local DataBlock, super = Class(Object)

function DataBlock:init(index, mod_id)
	super.init(self, 0, 0, 72, 72)

	self.block = Assets.getTexture("settings/block")
	
	self.slot_x = index%5
	if self.slot_x == 0 then
		self.slot_x = 5
	end -- If anyone can think of a better way to do this, let me know. -AcousticJamm
	
	self.slot_y = index%15
	if self.slot_y == 0 then
		self.slot_y = 15
	end -- Again, if anyone can think of a better way to do this, let me know.
	self.slot_y = math.ceil(self.slot_y/5)
	
	self.x = 60 + (113 * (self.slot_x - 1))
	self.y = 80 + (110 * (self.slot_y - 1))
	
	self.mod_id = mod_id
	
	if self.mod_id then
		self.mod = Kristal.Mods.getMod(self.mod_id)
		self.icon = self.mod.icon and self.mod.icon[1] or Assets.getTexture("settings/default_icon")
		self.name = self.mod.name
	end
end

function DataBlock:getDebugInfo()
	local info = super.getDebugInfo(self)
	if self.mod then
		table.insert(info, "Mod: " .. self.name)
	end
	table.insert(info, "Index: ("..self.slot_x..", "..self.slot_y..")")
	return info
end

function DataBlock:update()
	super:update(self)
	
	local mx, my = love.mouse.getPosition()
	local screen_x, screen_y = self:getScreenPos()
	screen_x, screen_y = screen_x-self.width/2, screen_y-self.height/2
	if not self.pressed and self:canHover() then
		if (mx / Kristal.getGameScale() > self.x) and (mx / Kristal.getGameScale() < (self.x + self.width)) and (my / Kristal.getGameScale() > self.y) and (my / Kristal.getGameScale() < (self.y + self.height)) then
			if self:canClick() then
				if love.mouse.isDown(1) and Game.wii_menu.cooldown <= 0 then
					if self.name then
						Game.wii_menu.popUp = popUp("Are you sure you would\nlike to delete the\nsave file for\n" .. self.name .. "?", {"Yes", "No"}, function(clicked)
							Game.wii_menu.popUp = nil
							
							local function tablefind(tab,el)
								for index, value in pairs(tab) do
									if value == el then
										return index
									end
								end
							end
							
							if clicked == 1 then
								love.filesystem.remove("saves/"..self.mod_id.."/file_0.json")
								local index = tablefind(Game.wii_menu.mod_files,self.mod_id)
								table.remove(Game.wii_menu.mod_files, index)
								
								for k,v in pairs(Game.wii_menu.mod_files) do
									print(k .. ": " .. v)
								end
								
								Game.wii_menu.save_count = #Game.wii_menu.mod_files
								
								Game.wii_menu.page = 1
								
								for i=1, 15 do
									if Game.wii_menu.mod_files[i + 15*(Game.wii_menu.page-1)] then
										Game.wii_menu.blocks[i]:updateMod(Game.wii_menu.mod_files[i + 15*(Game.wii_menu.page-1)])
									else
										Game.wii_menu.blocks[i]:updateMod()
									end
								end
							end
						end)
						Game.wii_menu.screen_helper:addChild(Game.wii_menu.popUp)
					end
				end
			end
		end
	end
end

function DataBlock:draw()
	super:draw(self)
	
	if self.icon then
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.draw(self.icon, self.x + 6, self.y + 6, 0, 2, 2)
	end
	
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(self.block, self.x, self.y, 0, 2, 2)
end

function DataBlock:updateMod(mod_id)
	self.mod_id = mod_id
	
	if mod_id then
		self.mod = Kristal.Mods.getMod(mod_id)
		self.icon = self.mod.icon and self.mod.icon[1] or Assets.getTexture("settings/default_icon")
		self.name = self.mod.name
	else
		self.mod = nil
		self.icon = nil
		self.name = nil
	end
end

function DataBlock:canClick() return Game.wii_menu.substate == "DATA" end
function DataBlock:canHover() return not Game.wii_menu.popUp end

return DataBlock
