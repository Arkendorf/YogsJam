local wave_end = require "wave_end"

local intro = {}

intro.load = function()
  wave_end.load("mk1") -- pass name of starting turret
  gui.disable_button("give_away")
end

intro.update = function(dt)
end

intro.draw = function()
end

return intro
