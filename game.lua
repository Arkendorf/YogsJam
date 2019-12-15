local intro = require "intro"
local map = require "map"
local place = require "place"
local wave = require "wave"
local wave_end = require "wave_end"
local enemy_data = require "enemy_data"
local turret_data = require "turret_data"
local effects = require "effects"

local game = {}

game_state = "intro"
score = 0
health = 0
max_dt = .1

speed = 1

text_color = {193/255, 217/255, 242/255}

game.load = function()
  local start_x, start_y = (window_w-176) / 2, window_h-32
  gui.add_button(0, start_x, start_y, 48, 32, "Pause", game.set_speed, {0})
  gui.add_button(1, start_x+48, start_y, 32, 32, "1x", game.set_speed, {1})
  gui.add_button(2, start_x+48+32, start_y, 32, 32, "2x", game.set_speed, {2})
  gui.add_button(4, start_x+48+32*2, start_y, 32, 32, "4x", game.set_speed, {4})
  gui.add_button(8, start_x+48+32*3, start_y, 32, 32, "8x", game.set_speed, {8})

  game_state = "intro"
  score = 0
  health = 100
  speed = 1
  gui.highlight_button(1)

  map.load()
  intro.load()
  wave.load()
  enemy_data.load()
  turret_data.load()
  effects.load()
end

game.update = function(dt)
  if dt > max_dt then
    dt = max_dt
  end
  dt = dt * speed
  map.update(dt)
  effects.update(dt)
  if game_state == "intro" then
    intro.update(dt)
  elseif game_state == "place" then
    place.update(dt)
  elseif game_state == "wave" then
    wave.update(dt)
  elseif game_state == "wave_end" then
    wave_end.update(dt)
  end
  if health <= 0 then
    state = "game_over"
  end
end

game.draw = function()
  map.draw()
  effects.draw()

  if game_state == "intro" then
    intro.draw()
  elseif game_state == "place" then
    place.draw()
  elseif game_state == "wave" then
    wave.draw()
  elseif game_state == "wave_end" then
    wave_end.draw()
  end

  love.graphics.setColor(text_color)
  love.graphics.print("Homes Defended: " .. tostring(score), 2, 2)
  love.graphics.print("Factory Integrity: " .. tostring(health), 2, 12)
  love.graphics.print("Alien Wave: " .. tostring(current_wave), 2, 22)
end

game.mousepressed = function(x, y, button)
  if game_state == "place" then
    place.mousepressed(x, y, button)
  end
end

game.set_speed = function(args)
  gui.unhighlight_button(speed)
  speed = args[1]
  gui.highlight_button(speed)
end

return game
