local gui = {}

local buttons = {}
local button_color = {1, 1, 1}
local hover_color = {.9, .9, 1}
local text_color = {.2, .2, .3}
local disabled_color = {.6, .6, .6}

gui.add_button = function(key, x, y, w, h, text, func, args)
  buttons[key] = {x = x, y = y, w = w, h = h, text = text, func = func, args = args, hover = false, color = {unpack(button_color)}}
end

gui.remove_button = function(key)
  buttons[key] = nil
end

gui.disable_button = function(key)
  buttons[key].disabled = true
end

gui.enable_button = function(key)
  buttons[key].disabled = false
end

gui.update = function(dt)
  local mx, my = love.mouse.getPosition()
  for k, v in pairs(buttons) do
    if not v.disabled then
      if mx >= v.x and mx <= v.x+v.w and my >= v.y and my <= v.y+v.h then
        v.hover = true
        gui.color_lerp(v.color, hover_color, dt)
      else
        v.hover = false
        gui.color_lerp(v.color, button_color, dt)
      end
    end
  end
end

gui.draw = function()
  for k, v in pairs(buttons) do
    if not v.disabled then
      love.graphics.setColor(v.color)
    else
      love.graphics.setColor(disabled_color)
    end
    love.graphics.rectangle("fill", v.x, v.y, v.w, v.h)
    love.graphics.setColor(text_color)
    love.graphics.print(v.text, v.x, v.y)
  end
end

gui.mousepressed = function(x, y, button)
  for k, v in pairs(buttons) do
    if not v.disabled then
      if x >= v.x and x <= v.x+v.w and y >= v.y and y <= v.y+v.h then
        if v.func then
          v.func(v.args)
        end
        return true
      end
    end
  end
end

-- since start_color is a reference to a list, changing it here will change it where its called
gui.color_lerp = function(start_color, goal_color, dt)
  start_color[1] = gui.lerp(start_color[1], goal_color[1], dt)
  start_color[2] = gui.lerp(start_color[2], goal_color[2], dt)
  start_color[3] = gui.lerp(start_color[3], goal_color[3], dt)
end

gui.lerp = function(start, goal, dt)
  return start + (goal-start) * dt * 8
end

return gui
