local turret_types = require "turret_types"

local effects = {}

local shots = {}
local shot_fade_time = .5
local shot_color = {193/255, 217/255, 242/255}

local flashes = {}
local flash_fade_time = .05
local flash_img = love.graphics.newImage("flash.png")
local flash_quad = {}

local turrets = {}
local base_img = love.graphics.newImage("turret_base.png")
local turret_goal = {x = 0, y = 0}

local explosions = {}
local explosion_img = love.graphics.newImage("explosion.png")
local explosion_quad = {}
local explosion_speed = 12

local splats = {}
local splat_fade_time = 10
local splat_img = love.graphics.newImage("splat.png")

effects.load_quads = function()
  flash_quad = effects.load_quad(flash_img)
  explosion_quad = effects.load_quad(explosion_img)
  turret_goal.x = 0
  turret_goal.y = window_h
end

effects.load = function()
  shots = {}
  flashes = {}
end

effects.update = function(dt)
  for k, v in pairs(shots) do
    if effects.fade(k, v, dt) then
      effects.remove_shot(k)
    end
  end
  for k, v in pairs(flashes) do
    if effects.fade(k, v, dt) then
      effects.remove_flash(k)
    end
  end
  for k, v in pairs(splats) do
    if effects.fade(k, v, dt) then
      effects.remove_splat(k)
    end
  end
  for k, v in pairs(turrets) do
    v.x = v.x + v.xv * v.speed * dt
    v.y = v.y + v.yv * v.speed * dt
    v.speed = v.speed + 6
    local dist = math.sqrt((turret_goal.x-v.x)*(turret_goal.x-v.x)+(turret_goal.y-v.y)*(turret_goal.y-v.y))
    v.size = math.min(1, dist*.01)
    if v.x < turret_goal.x or v.y > turret_goal.y then
      effects.remove_turret(k)
    end
  end
  for k, v in pairs(explosions) do
    v.frame = v.frame + dt * explosion_speed
    if v.frame > #explosion_quad + 1 then
      effects.remove_explosion(k)
    end
  end
end

effects.draw_bottom = function()
  for k, v in pairs(splats) do
    love.graphics.setColor(1, 1, 1, v.a)
    love.graphics.draw(splat_img, v.x-tile_size, v.y-tile_size, v.angle, v.size, v.size, 8, 8)
  end
end

effects.draw = function()
  for k, v in pairs(shots) do
    love.graphics.setLineWidth(v.w)
    love.graphics.setColor(shot_color[1], shot_color[2], shot_color[3], v.a)
    love.graphics.line(v.x1-tile_size, v.y1-tile_size, v.x2-tile_size, v.y2-tile_size)
  end
  love.graphics.setLineWidth(1)
  love.graphics.setColor(1, 1, 1)
  for k, v in pairs(flashes) do
    love.graphics.draw(flash_img, flash_quad[v.type], v.x-tile_size, v.y-tile_size, v.angle, 1, 1, 0, 8)
  end
  for k, v in pairs(turrets) do
    love.graphics.draw(base_img, v.x, v.y, 0, v.size, v.size, tile_size/2, tile_size/2)
    love.graphics.draw(turret_types[v.type].img, v.x, v.y, 0, v.size, v.size, tile_size/2, tile_size/2)
  end
  for k, v in pairs(explosions) do
    love.graphics.draw(explosion_img, explosion_quad[math.min(math.floor(v.frame), #explosion_quad)], v.x-tile_size, v.y-tile_size, v.angle, 1, 1, 16, 16)
  end
end

effects.add_shot = function(x1, y1, x2, y2, w)
  shots[#shots+1] = {x1 = x1, y1 = y1, x2 = x2, y2 = y2, t = shot_fade_time, a = 1, w = w}
end

effects.remove_shot = function(k)
  shots[k] = nil
end

effects.add_flash = function(x, y, angle)
  flashes[#flashes+1] = {x = x, y = y, angle = angle, t = flash_fade_time, type = math.random(1, 4)}
end

effects.remove_flash = function(k)
  flashes[k] = nil
end

effects.add_turret = function(x, y, type)
  x = x - tile_size/2
  y = y - tile_size/2
  local x_dist = turret_goal.x - x
  local y_dist = turret_goal.y - y
  local angle = math.atan2(y_dist, x_dist)
  turrets[#turrets+1] = {x = x, y = y, type = type, speed = 0, xv = math.cos(angle), yv = math.sin(angle), size = 1}
end

effects.remove_turret = function(k)
  turrets[k] = nil
end

effects.add_explosion = function(x, y)
  explosions[#explosions+1] = {x = x + math.random(-tile_size/4, tile_size/4), y = y + math.random(-tile_size/4, tile_size/4), frame = 1, angle = math.random(0, 2*math.pi)}
end

effects.remove_explosion = function(k)
  explosions[k] = nil
end

effects.add_splat = function(x, y, w)
  local size = w/16
  splats[#splats+1] = {x = x, y = y, angle = math.random(0, 2*math.pi), t = splat_fade_time, size = size, a = 1}
end

effects.remove_splat = function(k)
  splats[k] = nil
end

effects.load_quad = function(img)
  quad = {}
  local height = img:getHeight()
  local width = img:getWidth()
  for i = 0, math.floor(width/height)-1 do
    quad[i+1] = love.graphics.newQuad(i*height, 0, height, height, width, height)
  end
  return quad
end

effects.fade = function(k, v, dt)
  if v.t > 0 then
    v.t = v.t - dt
    v.a = v.t/shot_fade_time
    return false
  else
    return true
  end
end

return effects
