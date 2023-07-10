function Mod:init()
    print("Loaded "..self.info.name.."!")
end

function Mod:load()
    self.warning_screen = WarningScreen()
    Game.stage:addChild(self.warning_screen)
end