local game = require "game"

local home = {}

home.load = function()
  gui.add_button("new_game", 0, 0, 128, 32, "New Game", home.button_new_game)
  gui.add_button("quit", 0, 36, 128, 32, "Quit", home.button_quit)
end

home.update = function(dt)
end

home.draw = function()
  love.graphics.setColor(1, 1, 1)
  love.graphics.print("Highscore: " .. tostring(score), 0, 100)
end

home.button_new_game = function()
  state = "game"
  gui.remove_button("new_game")
  gui.remove_button("quit")
  game.load()
end

home.button_quit = function()
  love.event.quit()
end

return home
