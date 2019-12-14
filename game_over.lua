local home = require "home"
local game = require "game"

local game_over = {}

local start = true

game_over.load = function()
  gui.add_button("home", 0, 0, 128, 32, "Main Menu", game_over.button_home)
  gui.add_button("again", 0, 36, 128, 32, "Play Again", game_over.button_again)
  if score > highscore then
    highscore = score
  end
end

game_over.update = function(dt)
  if start == true then
    game_over.load()
    start = false
  end
end

game_over.draw = function()
  love.graphics.setColor(1, 1, 1)
  love.graphics.print("Homes Defended: " .. tostring(score), 0, 100)
end

game_over.button_home = function()
  state = "home"
  game_over.leave()
  home.load()
end

game_over.button_again = function()
  state = "game"
  game_over.leave()
  game.load()
end

game_over.leave = function()
  start = true
  gui.remove_button("home")
  gui.remove_button("again")
end

return game_over
