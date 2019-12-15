local home = require "home"
local game = require "game"
local map = require "map"

local game_over = {}

local start = true

local game_over_img = love.graphics.newImage("game_over.png")

game_over.load = function()
  gui.remove_button(0)
  gui.remove_button(1)
  gui.remove_button(2)
  gui.remove_button(4)
  gui.remove_button(8)
  gui.add_button("home", menu_pos.x+144-128-1, menu_pos.y+141-20, 128, 20, "Main Menu", game_over.button_home)
  gui.add_button("again", menu_pos.x+144+1, menu_pos.y+141-20, 128, 20, "Play Again", game_over.button_again)
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

  map.draw()

  love.graphics.draw(menu_img, menu_pos.x, menu_pos.y)
  love.graphics.draw(game_over_img, menu_pos.x+18, menu_pos.y+18)

  love.graphics.setColor(text_color)
  love.graphics.printf("Civilians Defended: " .. tostring(score), menu_pos.x, menu_pos.y+141-20-30, 288, "center")
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
