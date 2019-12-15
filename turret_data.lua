local enemy_data = require "enemy_data"
local turret_types = require "turret_types"
local effects = require "effects"

local turret_data = {}

local turrets = {}

local base_img = love.graphics.newImage("turret_base.png")
local shadow_img = love.graphics.newImage("turret_shadow.png")

turret_data.load = function()
  turrets = {}
end

turret_data.update = function(dt)
  for i, v in ipairs(turrets) do
    if v.cooldown > 0 then
      v.cooldown = v.cooldown - dt

    else
      turret_data.select_target(i, v)

      turret_data.shoot(i, v)
    end
  end
end

turret_data.draw = function()
  for i, v in ipairs(turrets) do
    local type_info = turret_types[v.type]
    love.graphics.draw(shadow_img, (v.x-1)*tile_size, (v.y-1)*tile_size)
    love.graphics.draw(base_img, (v.x-1)*tile_size, (v.y-1)*tile_size)
    love.graphics.draw(type_info.img, (v.x-.5)*tile_size, (v.y-.5)*tile_size, v.angle, 1, 1, tile_size/2, tile_size/2)
  end
end

turret_data.add = function(type, x, y)
  turrets[#turrets+1] = {type = type, x = x, y = y, target = false, cooldown = 0, angle = 0, goal_angle = 0, gun = 1}
end

turret_data.remove = function(i)
  table.remove(turrets, i)
end

turret_data.get_list = function()
  return turrets
end

turret_data.shoot = function(i, v)
  if v.target then
    local x, y = enemy_data.tile_to_pos(v.x, v.y)
    v.angle = math.atan2(v.target.y-y, v.target.x-x)

    local type_info = turret_types[v.type]
    local x_offset = type_info.guns[v.gun].x-tile_size/2
    local y_offset = type_info.guns[v.gun].y-tile_size/2
    local shot_x = x + x_offset * math.cos(v.angle) - y_offset * math.sin(v.angle)
    local shot_y = y + y_offset * math.cos(v.angle) + x_offset * math.sin(v.angle)
    effects.add_shot(shot_x, shot_y, v.target.x, v.target.y, type_info.damage)
    effects.add_flash(shot_x, shot_y, v.angle)

    v.gun = v.gun + 1
    if v.gun > #type_info.guns then
      v.gun = 1
    end

    v.target.health = v.target.health - type_info.damage

    v.cooldown = type_info.cooldown
  end
end

turret_data.select_target = function(i, v)
  v.target = turret_data.behavior[turret_types[v.type].behavior](i, v)
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
    if w.step > farthest.step then
      if (w.x-x)*(w.x-x)+(w.y-y)*(w.y-y) <= type_info.range*type_info.range*tile_size*tile_size then
        farthest.ref = w
        farthest.step = w.step
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
    if w.health > healthiest.health then
      if (w.x-x)*(w.x-x)+(w.y-y)*(w.y-y) <= type_info.range*type_info.range*tile_size*tile_size then
        healthiest.ref = w
        healthiest.health = w.health
      end
    end
  end
  return healthiest.ref
end

-- turret_data.rotate = function(i, v, dt)
--   v.angle = v.angle % 360
--   v.goal_angle = v.goal_angle % 360
--   local change = 0
--   local dif =  math.abs(v.angle-v.goal_angle)
--   if v.angle < v.goal_angle then
--     if dif < math.pi then
--       change =  dt
--     else
--       change =  -dt
--     end
--   else
--     if dif < math.pi then
--       change =  -dt
--     else
--       change = dt
--     end
--   end
--
--   if dif > dt then
--     v.angle = v.angle + change
--   else
--     v.angle = v.goal_angle
--   end
-- end

return turret_data
