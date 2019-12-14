local place = require "place"
local turret_types = require "turret_types"

local wave_end = {}

local turret_type = ""

wave_end.load = function(turret_override)
  gui.disable_button(0)
  gui.disable_button(1)
  gui.disable_button(2)
  gui.disable_button(4)
  gui.disable_button(8)
  gui.add_button("give_away", 0, 0, 128, 32, "Give Away", wave_end.button_give_away)
  gui.add_button("keep", 0, 36, 128, 32, "Keep", wave_end.button_keep)

  if turret_override then
    turret_type = turret_override
  else
    turret_type = wave_end.pick_turret()
  end
end

wave_end.update = function(dt)
end

wave_end.draw = function()
  love.graphics.setColor(1, 1, 1)
  love.graphics.print(turret_type, 0, 100)
end

wave_end.draw_menu = function(text, turret)
end

wave_end.button_give_away = function()
  score = score + turret_types[turret_type].score
  turret_type = ""
  wave_end.start_place()
end

wave_end.button_keep = function()
  wave_end.start_place()
end

wave_end.start_place = function()
  game_state = "place"
  gui.remove_button("give_away")
  gui.remove_button("keep")
  place.load(turret_type)
end

wave_end.pick_turret = function()
  local max_score = math.max(current_wave *.5, 1)
  local min_score = math.max(max_score-3, 1)
  local options = {}
  for k, v in pairs(turret_types) do
    if v.score >= min_score and v.score <= max_score then
      options[#options+1] = k
    end
  end
  local type = options[math.random(1, #options)]
  return type
end

return wave_end
