local enemy_data = require "enemy_data"
local turret_types = require "turret_types"

local turret_data = {}

local turrets = {}

turret_data.load = function()
  turrets = {}
end

turret_data.update = function(dt)
  for i, v in ipairs(turrets) do
    if v.cooldown > 0 then
      v.cooldown = v.cooldown - dt
    else
      local type_info = turret_types[v.type]
      v.target = turret_data.select_target(i, v)
      if v.target then
        v.target.health = v.target.health - 1
        v.cooldown = type_info.cooldown
      end
    end
  end
end

turret_data.draw = function()
  love.graphics.setColor(.2, .2, 1)
  for i, v in ipairs(turrets) do
    love.graphics.rectangle("fill", v.x*tile_size, v.y*tile_size, tile_size, tile_size)
  end
end

turret_data.add = function(type, x, y)
  turrets[#turrets+1] = {type = type, x = x, y = y, target = false, cooldown = 0}
end

turret_data.get_list = function()
  return turrets
end

turret_data.select_target = function(i, v)
  return turret_data.behavior[turret_types[v.type].behavior](i, v)
end

turret_data.behavior = {}

turret_data.behavior[1] = function(i, v)
  local type_info = turret_types[v.type]
  local closest = {ref = false, distance = math.huge}
  local x, y = enemy_data.tile_to_pos(v.x, v.y)
  for k, w in pairs(enemy_data.get_list()) do
    local distance = (w.x-x)*(w.x-x)+(w.y-y)*(w.y-y)
    if distance <= type_info.range*type_info.range*tile_size*tile_size and distance < closest.distance then
      closest.ref = w
      closest.distance = distance
    end
  end
  return closest.ref
end

turret_data.behavior[2] = function(i, v)
  local type_info = turret_types[v.type]
  local farthest = {ref = false, step = 0}
  local x, y = enemy_data.tile_to_pos(v.x, v.y)
  for k, w in pairs(enemy_data.get_list()) do
    if v.step > farthest.step then
      if (w.x-x)*(w.x-x)+(w.y-y)*(w.y-y) <= type_info.range*type_info.range*tile_size*tile_size then
        farthest.ref = w
        farthest.step = v.step
      end
    end
  end
  return farthest.ref
end

turret_data.behavior[3] = function(i, v)
  local type_info = turret_types[v.type]
  local healthiest = {ref = false, health = 0}
  local x, y = enemy_data.tile_to_pos(v.x, v.y)
  for k, w in pairs(enemy_data.get_list()) do
    if v.health > healthiest.health then
      if (w.x-x)*(w.x-x)+(w.y-y)*(w.y-y) <= type_info.range*type_info.range*tile_size*tile_size then
        healthiest.ref = w
        healthiest.health = health
      end
    end
  end
  return healthiest.ref
end

return turret_data
