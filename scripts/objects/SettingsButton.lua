local SettingsButton, super = Class("Button")

function SettingsButton:init(x, y)
	super:init(self, x, y, "button/settings")
	self.sprite:setOrigin(0.5,0.5)
	self.sprite:setPosition(x, y)
end

function SettingsButton:onClick()
	super:onClick(self)
	
	Game.wii_menu.transition_cover = Rectangle(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
	Game.wii_menu.transition_cover.color = {0, 0, 0}
	Game.wii_menu.transition_cover.alpha = 0
	Game.wii_menu.transition_cover:setLayer(1000)
	Game.wii_menu.stage:addChild(Game.wii_menu.transition_cover)
	
	Game.wii_menu.stage.timer:tween(0.5, Game.wii_menu.transition_cover, {alpha = 1}, "linear", function()
		Mod:setState("SettingsMenu")
	end)
end

return SettingsButton
