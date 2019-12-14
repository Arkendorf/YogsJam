local turret_data = require "turret_data"
local turret_types = require "turret_types"

local place = {}

local turret_type = ""

local current_tile = {x = 1, y = 1}
local valid_color = {.2, 1, .2}
local invalid_color = {1, .2, .2}

place.load = function(turret)
  if turret ~= "" then
    turret_type = turret
  else
    game_state = "wave"
  end
end

place.update = function(dt)
  local mx, my = love.mouse.getPosition()
  current_tile.x = math.floor(mx/tile_size)
  if current_tile.x < 1 then
    current_tile.x = 1
  elseif current_tile.x > #grid[1] then
    current_tile.x = #grid[1]
  end

  current_tile.y = math.floor(my/tile_size)
  if current_tile.y < 1 then
    current_tile.y = 1
  elseif current_tile.y > #grid then
    current_tile.y = #grid
  end
end

place.draw = function()
  if place.is_valid() then
    love.graphics.setColor(valid_color)
    local type_info = turret_types[turret_type]
    love.graphics.circle("line", (current_tile.x+.5)*tile_size, (current_tile.y+.5)*tile_size, type_info.range*tile_size)
  else
    love.graphics.setColor(invalid_color)
  end
  love.graphics.rectangle("line", current_tile.x*tile_size, current_tile.y*tile_size, tile_size, tile_size)
end

place.mousepressed = function(x, y, button)
  if place.is_valid() then
    turret_data.add(turret_type, current_tile.x, current_tile.y)
    game_state = "wave"
  end
end

place.is_valid = function()
  return grid[current_tile.y][current_tile.x] == 1
end

return place
