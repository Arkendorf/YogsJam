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
max_health = 100
health = max_health

max_dt = .1
speed = 1

local start_x, start_y = 0

game.load = function()
  start_x, start_y = (window_w-130) / 2, window_h-20
  gui.add_button(0, start_x, start_y, 48, 18, "Pause", game.set_speed, {0})
  gui.add_button(1, start_x+50, start_y, 18, 18, "1x", game.set_speed, {1})
  gui.add_button(2, start_x+50+20, start_y, 18, 18, "2x", game.set_speed, {2})
  gui.add_button(4, start_x+50+20*2, start_y, 18, 18, "4x", game.set_speed, {4})
  gui.add_button(8, start_x+50+20*3, start_y, 18, 18, "8x", game.set_speed, {8})

  game_state = "intro"
  score = 0
  health = max_health
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
  love.graphics.printf("Speed: ", start_x, 354, 130, "center")

  love.graphics.print("Civilians Defended: " .. tostring(score), 2, 354)
  love.graphics.print("Factory Integrity: " .. tostring(math.floor(health/max_health*100)).. "%", 2, 364)
  love.graphics.print("Alien Wave: " .. tostring(current_wave), 2, 374)
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
