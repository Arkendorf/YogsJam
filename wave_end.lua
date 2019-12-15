local place = require "place"
local turret_types = require "turret_types"
local effects = require "effects"

local wave_end = {}

local turret_type = ""

local box_img = love.graphics.newImage("turret_box.png")
local base_img = love.graphics.newImage("turret_base.png")

local target_types = {"Nearest", "First", "Healthiest"}

wave_end.load = function(turret_override)
  gui.disable_button(0)
  gui.disable_button(1)
  gui.disable_button(2)
  gui.disable_button(4)
  gui.disable_button(8)
  gui.add_button("give_away", menu_pos.x + 117, menu_pos.y+108, 96, 18, "Give Away", wave_end.button_give_away)
  gui.add_button("keep", menu_pos.x + 117, menu_pos.y+128, 96, 18, "Keep", wave_end.button_keep)

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
  wave_end.draw_menu(wave_end.turret_text(turret_type), turret_type)
end

wave_end.draw_menu = function(text, turret)
  love.graphics.draw(menu_img, menu_pos.x, menu_pos.y)
  love.graphics.draw(box_img, menu_pos.x+75, menu_pos.y+107)
  love.graphics.draw(base_img, menu_pos.x+79, menu_pos.y+111)
  love.graphics.draw(turret_types[turret].img, menu_pos.x+79, menu_pos.y+111)
  love.graphics.setColor(text_color)
  love.graphics.printf(text, menu_pos.x+8, menu_pos.y+12, 272)
end

wave_end.button_give_away = function()
  effects.add_turret(menu_pos.x+79, menu_pos.y+111, turret_type)
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
  local highest = 0
  local options = {}
  for k, v in pairs(turret_types) do
    if v.score > highest then
      highest = v.score
    end
    if v.score <= max_score then
      options[#options+1] = k
    end
  end
  local type = options[math.random(1, #options)]
  return type
end

wave_end.turret_text = function(turret)
  local info = turret_types[turret]
  local text = info.name .. "\n"
  text = text .. "Range: " .. info.range .. " - "
  text = text .. "Damage: " .. info.damage .. " - "
  text = text .. "Cooldown: " .. info.cooldown .. "s\n"
  text = text .. "Target: " .. target_types[info.behavior] .. "\n\n"
  text = text .. info.desc
  return text
end

return wave_end
