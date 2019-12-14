gui = require "gui"
local home = require "home"
local game = require "game"
local game_over = require "game_over"

state = "home"
highscore = 0

love.load = function()
  math.randomseed(os.time())
  home.load()
end

love.update = function(dt)
  gui.update(dt)
  if state == "home" then
    home.update(dt)
  elseif state == "game" then
    game.update(dt)
  elseif state == "game_over" then
    game_over.update(dt)
  end
end

love.draw = function()
  if state == "home" then
    home.draw()
  elseif state == "game" then
    game.draw()
  elseif state == "game_over" then
    game_over.draw()
  end
  gui.draw()
end

love.mousepressed = function(x, y, button)
  if not gui.mousepressed(x, y, button) then
    if state == "game" then
      game.mousepressed(x, y, button)
    end
  end
end
