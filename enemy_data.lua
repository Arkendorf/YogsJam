local grid_path = require "grid_path"
local enemy_types = require "enemy_types"

local enemy_data = {}

local enemies = {}
local start_v = {x = 0, y = 0}
local num = 0

enemy_data.load = function()
  start_v.x = grid_path[2].x - grid_path[1].x
  start_v.y = grid_path[2].y - grid_path[1].y
  num = 0
  enemies = {}
end

enemy_data.update = function(dt)
  for k, v in pairs(enemies) do
    local type_info = enemy_types[v.type]
    if v.health <= 0 then
      enemy_data.remove(k)
    else
      v.xv = v.xv + (v.goal_xv-v.xv) * dt * (2+type_info.speed*2)
      v.yv = v.yv + (v.goal_yv-v.yv) * dt * (2+type_info.speed*2)
      v.x = v.x + v.xv * type_info.speed * dt * 12
      v.y = v.y + v.yv * type_info.speed * dt * 12

      if v.step <= #grid_path then
        if math.floor(v.x/tile_size) == grid_path[v.step].x and math.floor(v.y/tile_size) == grid_path[v.step].y then
          local x, y = enemy_data.pos_to_tile(v.x, v.y, type_info.w, type_info.h)
          v.goal_xv = (grid_path[math.min(v.step+1, #grid_path)].x-x)
          v.goal_yv = (grid_path[math.min(v.step+1, #grid_path)].y-y)

          v.step = v.step + 1
        end
      else
        enemy_data.remove(k)
        health = health - v.health
      end
    end
  end
end

enemy_data.draw = function()
  love.graphics.setColor(1, .2, .2)
  for k, v in pairs(enemies) do
    local type_info = enemy_types[v.type]
    love.graphics.rectangle("fill", v.x-type_info.w/2, v.y-type_info.h/2, type_info.w, type_info.h)
  end
end

enemy_data.add = function(type)
  local type_info = enemy_types[type]
  local x, y = enemy_data.tile_to_pos(grid_path[1].x, grid_path[1].y, type_info.w, type_info.h)
  enemies[#enemies+1] = {type = type, x = x, y = y, xv = start_v.x, yv = start_v.y, goal_xv = start_v.x, goal_yv = start_v.y, step = 2, health = type_info.health}
  num = num + 1
  return type_info.cost
end

enemy_data.remove = function(k)
  enemies[k] = nil
  num = num - 1
end

enemy_data.get_list = function()
  return enemies
end

enemy_data.tile_to_pos = function(x, y)
  return (x+.5)*tile_size, (y+.5)*tile_size
end

enemy_data.pos_to_tile = function(x, y)
  return x/tile_size-.5, y/tile_size-.5
end

enemy_data.num = function()
  return num
end

return enemy_data
