local grid_path = require "grid_path"
local enemy_types = require "enemy_types"
local effects = require "effects"

local enemy_data = {}

local enemies = {}
local start_v = {x = 0, y = 0}
local num = 0

local shadow_color = {107/255, 116/255, 178/255}

local explosion_sfx = love.audio.newSource("explosion.wav", "static")

enemy_data.load = function()
  start_v.x = grid_path[2].x - grid_path[1].x
  start_v.y = grid_path[2].y - grid_path[1].y
  num = 0
  enemies = {}

  for k, v in pairs(enemy_types) do
    v.quad = {}
    local height = v.img:getHeight()
    local width = v.img:getWidth()
    v.w = height
    v.h = height
    for i = 0, math.floor(width/height)-1 do
      v.quad[i+1] = love.graphics.newQuad(i*height, 0, height, height, width, height)
    end
  end
end

enemy_data.update = function(dt)
  for k, v in pairs(enemies) do
    local type_info = enemy_types[v.type]
    if v.health <= 0 or v.x < 1*tile_size or v.x > #grid[1]*tile_size or v.y < 1*tile_size or v.y > #grid*tile_size then
      effects.add_splat(v.x, v.y, type_info.w)
      enemy_data.remove(k)
    else
      v.xv = enemy_data.lerp(v.xv, v.goal_xv, dt * (2+type_info.speed*2))
      v.yv = enemy_data.lerp(v.yv, v.goal_yv, dt * (2+type_info.speed*2))
      v.x = v.x + v.xv * type_info.speed * dt * 12
      v.y = v.y + v.yv * type_info.speed * dt * 12
      v.angle = math.atan2(v.yv, v.xv)

      if v.step <= #grid_path then
        if math.floor(v.x/tile_size) == grid_path[v.step].x and math.floor(v.y/tile_size) == grid_path[v.step].y then
          local x, y = enemy_data.pos_to_tile(v.x, v.y, type_info.w, type_info.h)
          v.goal_xv = (grid_path[math.min(v.step+1, #grid_path)].x-x)
          v.goal_yv = (grid_path[math.min(v.step+1, #grid_path)].y-y)

          v.step = v.step + 1
        end
      else
        effects.add_explosion(v.x, v.y)
        add_sfx(explosion_sfx)
        enemy_data.remove(k)
        health = health - v.health
      end
    end

    v.frame = v.frame + dt * 4
    if v.frame > #type_info.quad+1 then
      v.frame = 1
    end
  end
end

enemy_data.draw = function()
  love.graphics.setColor(shadow_color)
  for k, v in pairs(enemies) do
    if v.step > 2 then
      local type_info = enemy_types[v.type]
      love.graphics.circle("fill", v.x-tile_size+2, v.y-tile_size+2, type_info.w/2)
    end
  end
  love.graphics.setColor(1, 1, 1)
  for k, v in pairs(enemies) do
    local type_info = enemy_types[v.type]
    love.graphics.draw(type_info.img, type_info.quad[math.min(math.floor(v.frame), #type_info.quad)], v.x-tile_size, v.y-tile_size, v.angle, 1, 1, type_info.w/2, type_info.h/2)
  end
end

enemy_data.add = function(type)
  local type_info = enemy_types[type]
  local x, y = enemy_data.tile_to_pos(grid_path[1].x, grid_path[1].y, type_info.w, type_info.h)
  enemies[#enemies+1] = {type = type, x = x, y = y, xv = start_v.x, yv = start_v.y, goal_xv = start_v.x, goal_yv = start_v.y, step = 2, health = type_info.health, frame = 1, angle = 0}
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

enemy_data.lerp = function(start, goal, dt)
  return start + (goal-start) * dt
end

return enemy_data
