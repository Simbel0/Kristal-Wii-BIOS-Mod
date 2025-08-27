local MessageBoardButton, super = Class("Button")

function MessageBoardButton:init(x, y)
	super.init(self, x, y, "message_board")
	self.cd = 0
end

function MessageBoardButton:onClick()
	super.onClick(self)
	
	if not Game.wii_menu.maintenance then
		Game.wii_menu.tvSheet.page_debounce = true
		Game.wii_menu.substate = "MESSAGE"
		Game.wii_menu.stage.timer:tween(0.4, Game.wii_menu.tvSheet, {y = Game.wii_menu.tvSheet.y - 430}, "out-cubic", function()
			Game.wii_menu.tvSheet.page_debounce = false
		end)
		Game.wii_menu.stage.timer:tween(0.4, Game.wii_menu.tvSheet.clock, {y = Game.wii_menu.tvSheet.clock.y - 430}, "out-cubic")
		Game.wii_menu.stage.timer:tween(0.2, Game.wii_menu.settings_button, {y = Game.wii_menu.settings_button.y - 60}, "out-sine", function()
			Game.wii_menu.stage.timer:tween(0.2, Game.wii_menu.settings_button, {y = Game.wii_menu.settings_button.y + 60}, "in-sine")
		end)
		Game.wii_menu.stage.timer:tween(0.4, Game.wii_menu.settings_button, {x = Game.wii_menu.settings_button.x - 120, rotation = Game.wii_menu.settings_button.rotation - math.pi}, "out-sine")
		Game.wii_menu.stage.timer:tween(0.2, self, {y = self.y - 60}, "out-sine", function()
			Game.wii_menu.stage.timer:tween(0.2, self, {y = self.y + 60}, "in-sine")
		end)
		Game.wii_menu.stage.timer:tween(0.4, self, {x = self.x + 120, rotation = self.rotation + math.pi}, "out-sine")
		Game.wii_menu.stage.timer:tween(0.2, Game.wii_menu.message_back_button, {y = Game.wii_menu.message_back_button.y + 60}, "out-sine", function()
			Game.wii_menu.stage.timer:tween(0.2, Game.wii_menu.message_back_button, {y = Game.wii_menu.message_back_button.y - 60}, "in-sine")
		end)
		Game.wii_menu.stage.timer:tween(0.4, Game.wii_menu.message_back_button, {x = Game.wii_menu.message_back_button.x - 120, rotation = Game.wii_menu.message_back_button.rotation + math.pi}, "out-sine")
		for k,v in pairs(Game.wii_menu.tvSheet.monitors) do
			Game.wii_menu.stage.timer:tween(0.4, v, {y = v.y - 430}, "out-cubic")
		end
	else
		Game.wii_menu.tvSheet.popUp = popUp("The system is operating\nin maintenance mode.\nThe Wii Message Board\ncannot be used.", {"Ok"}, function(clicked) print("Called back: " .. clicked) end)
		Game.wii_menu.tvSheet:addChild(Game.wii_menu.tvSheet.popUp)
	end
	
	self.cd = 0.25

	self.pressed = false
end

function MessageBoardButton:update()
	super.update(self)
	
	self.sprite.alpha = Game.wii_menu.alpha
	
	self.cd = self.cd - DT
end

function MessageBoardButton:draw()
	super.draw(self)
end

function MessageBoardButton:canHover()
	return not Game.wii_menu.tvSheet.page_debounce and self.cd <= 0 and Game.wii_menu.substate == "MAIN"
end

return MessageBoardButton