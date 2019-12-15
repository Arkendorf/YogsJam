love.graphics.setDefaultFilter("nearest", "nearest")
love.graphics.setLineStyle("rough")

gui = require "gui"
local home = require "home"
local game = require "game"
local game_over = require "game_over"
local map = require "map"
local effects = require "effects"

state = "home"
highscore = 0

scale = 2
canvas = false

love.load = function()
  math.randomseed(os.time())

  if love.filesystem.getInfo("highscore.txt") then
    local text = love.filesystem.read("highscore.txt")
    highscore = tonumber(text)
  end
  love.window.setMode(960, 768)
  window_w = math.floor(love.graphics.getWidth()/scale)
  window_h = math.floor(love.graphics.getHeight()/scale)
  canvas = love.graphics.newCanvas(window_w, window_h)

  map.load_tiles()
  effects.load_quads()

  love.graphics.setBackgroundColor(41/255, 50/255, 104/255)

  font = love.graphics.newImageFont("font.png",
  " abcdefghijklmnopqrstuvwxyz" ..
  "ABCDEFGHIJKLMNOPQRSTUVWXYZ0" ..
  "123456789.,!?-+/():;%&`'*#=[]\"_", 1)
  love.graphics.setFont(font)

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
  love.graphics.setCanvas(canvas)
  love.graphics.clear()
  if state == "home" then
    home.draw()
  elseif state == "game" then
    game.draw()
  elseif state == "game_over" then
    game_over.draw()
  end
  gui.draw()
  love.graphics.setCanvas()
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(canvas, 0, 0, 0, scale, scale)
end

love.mousepressed = function(x, y, button)
  x, y = get_mouse_pos()
  if not gui.mousepressed(x, y, button) then
    if state == "game" then
      game.mousepressed(x, y, button)
    end
  end
end

love.quit = function()
  love.filesystem.write("highscore.txt", tostring(highscore))
end

get_mouse_pos = function()
  x, y = love.mouse.getPosition()
  return x / scale, y / scale
end
