local effects = {}

local shots = {}
local shot_fade_time = .5
local shot_color = {1, 1, 1}

effects.load = function()
  shots = {}
end

effects.update = function(dt)
  for k, v in pairs(shots) do
    if v.t > 0 then
      v.t = v.t - dt
      v.a = v.t/shot_fade_time
    else
      effects.remove_shot(k)
    end
  end
end

effects.draw = function()
  for k, v in pairs(shots) do
    love.graphics.setLineWidth(v.w)
    love.graphics.setColor(shot_color[1], shot_color[2], shot_color[3], v.a)
    love.graphics.line(v.x1-tile_size, v.y1-tile_size, v.x2-tile_size, v.y2-tile_size)
  end
  love.graphics.setLineWidth(1)
end

effects.add_shot = function(x1, y1, x2, y2, w)
  shots[#shots+1] = {x1 = x1, y1 = y1, x2 = x2, y2 = y2, t = shot_fade_time, a = 1, w = w}
end

effects.remove_shot = function(k)
  shots[k] = nil
end

return effects
