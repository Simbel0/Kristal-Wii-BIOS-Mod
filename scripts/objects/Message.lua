---@class Message : Object
local Message, super = Class(Object)

function Message:init(index, message)
	super.init(self, 0, 0, 144, 96)

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
	
	self.sprite = Sprite(self.path)
	self:addChild(self.sprite)
	
	self.slot_x = index%4
	self.slot_y = math.floor(index/4)
	
	self.x = 170 + (150 * (self.slot_x - 1))
	self.y = 106 + (104	* (self.slot_y - 1))
end

function Message:update()
	super.update(self)

	if Mod.popup_on then return end
	
	local mx, my = love.mouse.getPosition()
	local screen_x, screen_y = self:getScreenPos()
	screen_x, screen_y = screen_x-self.width/2, screen_y-self.height/2
	if not self.pressed and self:canHover() then
		if (mx / Kristal.getGameScale() > self.x) and (mx / Kristal.getGameScale() < (self.x + self.width)) and (my / Kristal.getGameScale() > self.y) and (my / Kristal.getGameScale() < (self.y + self.height)) then
			if self:canClick() then
				if Input.mousePressed(1) and not Game.wii_menu.popUp then
					print(self.message["message"], self.parent)
					Game.wii_menu.popUp = MessagePopUp(self.message, nil, nil, true)
					Game.wii_menu.screen_helper_low:addChild(Game.wii_menu.popUp)
					Game.wii_menu.stage.timer:tween(0.5, Game.wii_menu.message_out_button, {x = Game.wii_menu.message_out_button.x + 210}, "out-sine")
					Game.wii_menu.message_out_button.cd = 0.5
				end
			end
		end
	end
end

function Message:draw()
	if Game.wii_menu.state ~= "TRANSITIONIN" and Game.wii_menu.state ~= "TRANSITIONOUT" then
		super.draw(self)
	end
end

function Message:canClick() return not Game.wii_menu.message_loaded end
function Message:canHover() return Game.wii_menu.substate == "MESSAGE" end

function Message:getDebugInfo()
    local info = super.getDebugInfo(self)
    table.insert(info, "X: " .. self.slot_x)
    table.insert(info, "Y: " .. self.slot_y)
	return info
end

return Message
