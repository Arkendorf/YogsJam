local game = require "game"
local map = require "map"

local home = {}

menu_pos = {x = 0, y = 0}
menu_img = love.graphics.newImage("menu.png")
text_color = {193/255, 217/255, 242/255}

local logo_img = love.graphics.newImage("logo.png")

home.load = function()
  menu_pos.x = math.floor((window_w-menu_img:getWidth())/2)
  menu_pos.y = math.floor((window_h-menu_img:getHeight()-tile_size)/2)

  gui.add_button("new_game", menu_pos.x+144-128-1, menu_pos.y+141-20, 128, 20, "New Game", home.button_new_game)
  gui.add_button("quit", menu_pos.x+144+1, menu_pos.y+141-20, 128, 20, "Quit", home.button_quit)
end

home.update = function(dt)
end

home.draw = function()
  love.graphics.setColor(1, 1, 1)

  map.draw()

  love.graphics.draw(menu_img, menu_pos.x, menu_pos.y)
  love.graphics.draw(logo_img, menu_pos.x+18, menu_pos.y+18)

  love.graphics.setColor(text_color)
  love.graphics.printf("Highscore: " .. tostring(highscore), menu_pos.x+144-128-1, menu_pos.y+141-20-10, 128, "center")
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
