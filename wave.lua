local wave_end = require "wave_end"
local enemy_data = require "enemy_data"
local enemy_types = require "enemy_types"
local turret_data = require "turret_data"

local wave = {}

local new_wave = true
current_wave = 0

local max_total_cost = 0
local individual_cost = 0

local current_total_cost = 0

local spawn_delay = 0
local max_spawn_delay = 0

wave.load = function()
  new_wave = true
  current_wave = 0
  wave.set_limits()
end

wave.update = function(dt)
  if new_wave == true then -- start another wave
    new_wave = false

    current_wave = current_wave + 1
    wave.set_limits()
  end

  turret_data.update(dt)
  enemy_data.update(dt)

  if current_total_cost < max_total_cost then
    if spawn_delay <= 0 then
      wave.new_enemy()
    else
      spawn_delay = spawn_delay - dt
    end
  elseif enemy_data.num() <= 0 then
    wave.wave_end()
  end
end

wave.draw = function()
end

wave.wave_end = function()
  game_state = "wave_end"
  new_wave = true
  wave_end.load()
end

wave.set_limits = function()
  individual_cost = math.max(current_wave *.5, 1)
  max_total_cost = current_wave * 10

  current_total_cost = 0

  max_spawn_delay = 1.5 / current_wave
end

wave.new_enemy = function()
  local available_cost = max_total_cost - current_total_cost
  if available_cost > 0 then
    if available_cost >= individual_cost then
      wave.add_enemy(individual_cost)
    else
      wave.add_enemy(available_cost)
    end
    spawn_delay = math.random(max_spawn_delay/4, max_spawn_delay)
  end
end

wave.add_enemy = function(max_cost)
  local options = {}
  for k, v in pairs(enemy_types) do
    if v.cost <= max_cost then
      options[#options+1] = k
    end
  end
  local type = options[math.random(1, #options)]
  local cost = enemy_data.add(type)
  current_total_cost = current_total_cost + cost
end

return wave
