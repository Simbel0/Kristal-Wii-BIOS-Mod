---@class InputMenu : Object
local InputMenu, super = Class(Object)

function InputMenu:init(length)
    self.input_len = length or 8
    super.init(self, SCREEN_WIDTH/2, SCREEN_HEIGHT/2, 36 * self.input_len, 40)

    self:setParallax(0, 0)
    self:setOrigin(0.5, 0.5)

    self.draw_children_below = 0
    self.box = UIBox(0, 0, self.width, self.height)
    self.box.layer = -1
    self.box.debug_select = false
    self:addChild(self.box)

    self.font = Assets.getFont("maintenance")
    self.char_w = 32
    self.char_h = self.char_w
    self.char_spacing = 2

    self.input = {Game.wii_data["name"]}
	
	Assets.playSound("wii/warn")

    TextInput.attachInput(self.input, {
        multiline = false,
        enter_submits = true,
        text_restriction = function(c)
            if utf8.len(self.input[1]) == self.input_len then return false end
            if Utils.containsValue({" ", "{", "}", "[", "]", "<", ">", ",", ".", "?", "/", ":", ";", "\"", "'", "|", "\\", "!", "@", "#", "$", "%", "^", "&", "*", "(", ")", "_", "+", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "=", "~", "`"}, c) then return false end
			Assets.playSound("wii/type")
            return c:upper()
        end
    })
    TextInput.text_callback = function()
        self.input[1] = Utils.sub(self.input[1], 1, self.input_len)
    end
    TextInput.submit_callback = function()
        if self.finish_cb then
            self.finish_cb(self.input[1])
        end
        self:remove()
    end
end

function InputMenu:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(self.font)

    local draw_x = 0
    local draw_y = 0
    local actual_input_len = utf8.len(self.input[1])
    assert(actual_input_len <= self.input_len)
    for i = 1, self.input_len do
        if actual_input_len >= i then
            local char = Utils.sub(self.input[1], i, i)
            love.graphics.printf(char, draw_x, draw_y, self.char_w, "center")
        end

        if i ~= math.min(TextInput.cursor_x + 1, self.input_len) or TextInput.flash_timer < 0.5 then
            local line_y = draw_y + self.char_h + 2
            love.graphics.line(draw_x, line_y, draw_x + self.char_w, line_y)
        end

        draw_x = draw_x + self.char_w + self.char_spacing
    end

    super.draw(self)
end

function InputMenu:onRemove()
    TextInput.endInput()
end

return InputMenu