---@class Message : Object
local Message, super = Class(Object)

function Message:init(index, message)
	super:init(self, 0, 0, 144, 96)

	self.message = message
	
	self.path = "memo/envelope"
	if message["opened"] then
		self.path = "memo/envelope_opened"
		if love.filesystem.getInfo(Kristal.Mods.getMod("wii_kristal").path .. "/assets/sprites/memo/" .. Game.wii_data["theme"] .. "/envelope_opened.png") then
			self.path = "memo/" .. Game.wii_data["theme"] .. "/envelope_opened"
		end
	elseif love.filesystem.getInfo(Kristal.Mods.getMod("wii_kristal").path .. "/assets/sprites/memo/" .. Game.wii_data["theme"] .. "/envelope.png") then
		self.path = "memo/" .. Game.wii_data["theme"] .. "/envelope"
	end
	
	self.slot_x = index%2
	self.slot_y = math.floor(index/2)
	
	self.x = 60 + (150 * (self.slot_x - 1))
	self.y = 80 + (104 * (self.slot_y - 1))
end

function Message:update()
	super:update(self)
	
	local mx, my = love.mouse.getPosition()
	local screen_x, screen_y = self:getScreenPos()
	screen_x, screen_y = screen_x-self.width/2, screen_y-self.height/2
	if not self.pressed and self:canHover() then
		if (mx / Kristal.getGameScale() > self.x) and (mx / Kristal.getGameScale() < (self.x + self.width)) and (my / Kristal.getGameScale() > self.y) and (my / Kristal.getGameScale() < (self.y + self.height)) then
			if self:canClick() then
				if love.mouse.isDown(1) then
					print(self.message["message"])
				end
			end
		end
	end
end

function Message:draw() super:draw(self) end

function Message:canClick() return not Game.wii_menu.message_loaded end
function Message:canHover() return Game.wii_menu.substate == "MESSAGE" end

return Message
