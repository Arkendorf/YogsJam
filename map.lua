local turret_data = require "turret_data"
local enemy_data = require "enemy_data"

local map = {}

grid = require "grid"
tile_size = 16

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
      if tile == 1 then
        love.graphics.rectangle("fill", x*tile_size, y*tile_size, tile_size, tile_size)
      end
    end
  end
  turret_data.draw()
  enemy_data.draw()
end

return map
