local preview = {}

preview.hide_background = true

function preview:init(mod, _, _)
    self.bg = love.graphics.newImage(mod.path .. "/preview/bg.png")

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

    self.stripes_grad_from = Utils.hexToRgb("#E0F4FF", 1)
    self.stripes_grad_to = Utils.hexToRgb("#66CBFF", 1)

    self.canvas = love.graphics.newCanvas(self.stripes_w, self.stripes_h)

    self.init_time = Kristal.getTime()
end

function preview:draw()
    if self.fade > 0 then
        love.graphics.setColor(1, 1, 1, self.fade)
        love.graphics.rectangle("fill", 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
        love.graphics.draw(self.bg)

        Draw.pushCanvas(self.canvas)
        love.graphics.clear(COLORS.white)
        love.graphics.setColor(1, 1, 1, 0.1)
        local stripes_num_v_anim = math.floor(
            self.stripes_num_v_base
            + ((self.stripes_num_v - self.stripes_num_v_base) * math.sin((Kristal.getTime() - self.init_time)*0.8))
        )
        for i = 0, stripes_num_v_anim do
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
        love.graphics.setColor(1, 1, 1, self.fade)
        Draw.drawPart(self.canvas,
            self.stripes_x, self.stripes_y + crop_y,
            0, crop_y,
            self.stripes_w, real_h
        )
        love.graphics.setShader(prev_shader)

        love.graphics.setColor(0.25, 0.25, 0.25, self.fade * 0.2)
        love.graphics.rectangle("fill", 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
    end
end

function preview:update() end

return preview