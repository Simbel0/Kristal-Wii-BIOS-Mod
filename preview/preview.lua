local preview = {}

preview.hide_background = true

preview.Themes = {
	["DEFAULT"] = {
		["from"] = Utils.hexToRgb("#E0F4FF", 1),
		["to"] = Utils.hexToRgb("#66CBFF", 1),
		["button"] = Utils.hexToRgb("#99DCFF", 1),
		["favorite"] = Utils.hexToRgb("#66CBFF", 1),
		["bg"] = {1,1,1},
		["bg_fade"] = {176/255,208/255,228/255}
	},
	["DETERMINATION"] = {
		["from"] = Utils.hexToRgb("#FFE0E0", 1),
		["to"] = Utils.hexToRgb("#FF6666", 1),
		["button"] = Utils.hexToRgb("#FF9999", 1),
		["favorite"] = Utils.hexToRgb("#FF6666", 1),
		["bg"] = {1,1,1},
		["bg_fade"] = {228/255,176/255,176/255}
	},
	["SD_CARD"] = {
		["from"] = Utils.hexToRgb("#E0E0E0"),
		["to"] = Utils.hexToRgb("#242424", 1),
		["button"] = Utils.hexToRgb("#606060", 1),
		["favorite"] = Utils.hexToRgb("#D0D0D0", 1),
		["bg"] = {1,1,1},
		["bg_fade"] = {176/255,208/255,228/255}
	},
	["DEOXYNN"] = {
		["from"] = Utils.hexToRgb("#FFE0FD", 1),
		["to"] = Utils.hexToRgb("#FF66EB", 1),
		["button"] = Utils.hexToRgb("#FC99FF", 1),
		["favorite"] = Utils.hexToRgb("#FF66F2", 1),
		["bg"] = {225/255,240/255,227/255},
		["bg_fade"] = {228/255,176/255,218/255}
	},
	["LEGEND"] = {
		["from"] = Utils.hexToRgb("#D6CEC7", 1),
		["to"] = Utils.hexToRgb("#D86500", 1),
		["button"] = Utils.hexToRgb("#874914", 1),
		["favorite"] = Utils.hexToRgb("#BC671C", 1),
		["bg"] = {1,1,1},
		["bg_fade"] = {226/255,195/255,177/255}
	},
	["SNEO"] = {
		["from"] = Utils.hexToRgb("#FFF9E0", 1),
		["to"] = Utils.hexToRgb("#FFF266", 1),
		["button"] = Utils.hexToRgb("#B600FF", 1),
		["favorite"] = Utils.hexToRgb("#FFFF00", 1),
		["bg"] = {1,1,1},
		["bg_fade"] = {195/255,177/255,226/255}
	},
	["UT_BATTLE"] = {
		["from"] = Utils.hexToRgb("#E5FFE0", 1),
		["to"] = Utils.hexToRgb("#8EFF66", 1),
		["button"] = Utils.hexToRgb("#874914", 1),
		["favorite"] = Utils.hexToRgb("#BC671C", 1),
		["bg"] = {1,1,1},
		["bg_fade"] = {184/255,255/255,178/255}
	},
}

function preview:init(mod, button, _)
	local theme = "DEFAULT"
	if love.filesystem.getInfo("wii_settings.json") then
		local wii_data = JSON.decode(love.filesystem.read("wii_settings.json"))
		theme = wii_data["theme"]
		if Kristal.load_wii == nil then
			Kristal.load_wii = wii_data["load_early"]
		end
	end
	
	if Kristal.load_wii then
		Kristal.loadMod(mod.id)
		return
	end

    button:setColor(preview.Themes[theme]["button"])
    button:setFavoritedColor(preview.Themes[theme]["favorite"])

    self.bg = love.graphics.newImage(mod.path .. "/preview/bg.png")
	self.bg_col = preview.Themes[theme]["bg"]
	self.bg_fade = preview.Themes[theme]["bg_fade"]

    self.stripe = love.graphics.newImage(mod.path .. "/preview/stripe.png")
    self.stripe_w = self.stripe:getWidth()
    self.stripe_h = self.stripe:getHeight()

    self.stripes_x = 0
    self.stripes_w = SCREEN_WIDTH
    self.stripes_num_h = math.ceil(self.stripes_w / self.stripe_w)
    self.stripes_num_v_base = 32
    self.stripes_num_v = 36
    self.stripes_h = self.stripe_h * self.stripes_num_v
    self.stripes_y = SCREEN_HEIGHT - self.stripes_h

    self.stripes_grad_from = preview.Themes[theme]["from"]
    self.stripes_grad_to = preview.Themes[theme]["to"]

    self.canvas = love.graphics.newCanvas(self.stripes_w, self.stripes_h)

    self.init_time = Kristal.getTime()
end

function preview:draw()
    if self.fade > 0 then
        love.graphics.setColor(self.bg_col[1], self.bg_col[2], self.bg_col[3], self.fade)
        love.graphics.rectangle("fill", 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
        love.graphics.setColor(self.bg_fade[1], self.bg_fade[2], self.bg_fade[3], self.fade)
        love.graphics.draw(self.bg)

        Draw.pushCanvas(self.canvas)
        love.graphics.clear(COLORS.white)
        love.graphics.setColor(self.bg_col[1], self.bg_col[2], self.bg_col[3], 0.1)
        local stripes_num_v_anim = self.stripes_num_v_base
            + ((self.stripes_num_v - self.stripes_num_v_base) * math.sin((Kristal.getTime() - self.init_time)*0.8))
        for i = 0, math.ceil(stripes_num_v_anim) do
            local cur_y = self.stripes_h - self.stripe_h * i
            for j = 0, self.stripes_num_h do
                local cur_x = self.stripe_w * j
                love.graphics.draw(self.stripe, cur_x, cur_y)
            end
        end
        Draw.popCanvas()

        local prev_shader = love.graphics.getShader()
        local shader = Kristal.Shaders.GradientV
        love.graphics.setShader(shader)
        shader:sendColor("from", self.stripes_grad_from)
        shader:sendColor("to", self.stripes_grad_to)
        local real_h = self.stripe_h * stripes_num_v_anim
        local crop_y = self.stripes_h - real_h
        love.graphics.setColor(self.bg_col[1], self.bg_col[2], self.bg_col[3], self.fade)
        Draw.drawPart(self.canvas,
            self.stripes_x, self.stripes_y + crop_y,
            0, crop_y,
            self.stripes_w, real_h
        )
        love.graphics.setShader(prev_shader)

        love.graphics.setColor(self.bg_col[1]/4, self.bg_col[2]/4, self.bg_col[3]/4, self.fade * 0.2)
        love.graphics.rectangle("fill", 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
    end
end

function preview:update() end

return preview
