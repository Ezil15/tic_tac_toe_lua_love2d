Menu = {}

local BUTTON_HEIGHT = 32

function newButton(text, func, color, hover_color)
      return {
            text = text,
            func = func,
            color = color,
            hover_color = hover_color,
            pressed = false,
      }
end


function Menu:loadNewMenu(buttons)
      Menu.buttons = buttons
      Menu.font = love.graphics.newFont(15)
end

function Menu:drawMenu()
      local win_w = love.graphics.getWidth()
      local win_h = love.graphics.getHeight()
      
      local button_width = win_w * (1/3) + 15
      local margin = 3

      local total_height = (BUTTON_HEIGHT + margin) * #self.buttons
      local y_offset = -40

      for i, button in ipairs(self.buttons) do

            local bx = (win_w * 0.5) - (button_width * 0.5)
            local by = (win_h * 0.5) - (total_height * 0.5) + y_offset

            local mx, my = love.mouse.getPosition()

            local is_hover = mx > bx and mx < bx + button_width and my > by and my < by + BUTTON_HEIGHT
            local button_color = {0.5, 0.5, 0.5, 1}
            local button_hover_color = {0.8, 0.8, 0.8, 1}
            local color = button_color
            if is_hover then
                  color = button_hover_color
            end

            love.graphics.setColor(unpack(color))
            love.graphics.rectangle(
                  "fill",
                  bx,
                  by,
                  button_width, 
                  BUTTON_HEIGHT
            )
            
            local textW = self.font:getWidth(button.text)
            local textH = self.font:getHeight()

            love.graphics.setColor(0, 0, 0, 1)
            love.graphics.print(
                  button.text,
                  self.font,
                  (win_w * 0.5) - textW * 0.5,
                  by + textH * 0.5
            )

            y_offset = y_offset + (BUTTON_HEIGHT * margin)
            if is_hover and love.mouse.isDown(1) and not Mouse.pressed then
                  Mouse.pressed = true
                  button.func()
            end
      end
end