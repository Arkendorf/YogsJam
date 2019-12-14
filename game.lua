local intro = require "intro"
local map = require "map"
local place = require "place"
local wave = require "wave"
local wave_end = require "wave_end"
local enemy_data = require "enemy_data"
local turret_data = require "turret_data"

local game = {}

game_state = "intro"
score = 0
health = 100

game.load = function()
  game_state = "intro"
  score = 0
  health = 2

  map.load()
  intro.load()
  wave.load()
  enemy_data.load()
  turret_data.load()
end

game.update = function(dt)
  if love.keyboard.isDown("space") then
    dt = dt * 4
  end
  map.update(dt)
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

  love.graphics.setColor(1, 1, 1)
  love.graphics.print("Homes Defended: " .. tostring(score))
  love.graphics.print("Factory Integrity: " .. tostring(health), 0, 12)
  love.graphics.print("Alien Wave: " .. tostring(current_wave), 0, 24)

  if game_state == "intro" then
    intro.draw()
  elseif game_state == "place" then
    place.draw()
  elseif game_state == "wave" then
    wave.draw()
  elseif game_state == "wave_end" then
    wave_end.draw()
  end
end

game.mousepressed = function(x, y, button)
  if game_state == "place" then
    place.mousepressed(x, y, button)
  end
end

return game
