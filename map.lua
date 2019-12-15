local turret_data = require "turret_data"
local enemy_data = require "enemy_data"

local map = {}

grid = require "grid"
tile_size = 32

local tile_img = love.graphics.newImage("tiles.png")
local tile_quad = {}

map.load = function()
  turrets = {}
  enemies = {}
end

map.update = function(dt)
end

map.draw = function()
  love.graphics.setColor(1, 1, 1)
  for y, row in ipairs(grid) do
    for x, tile in ipairs(row) do
      if tile > 0 then
        love.graphics.draw(tile_img, tile_quad[tile], (x-1)*tile_size, (y-1)*tile_size)
      end
    end
  end
  turret_data.draw()
  enemy_data.draw()
end

map.load_tiles = function()
  local width = math.floor(tile_img:getWidth()/tile_size)
  local height = math.floor(tile_img:getHeight()/tile_size)
  for y = 0, height-1 do
    for x = 0, width-1 do
      tile_quad[y*width+x+1] = love.graphics.newQuad(x*tile_size, y*tile_size, tile_size, tile_size, tile_img:getDimensions())
    end
  end
end

return map
