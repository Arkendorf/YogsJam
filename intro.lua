local wave_end = require "wave_end"

local intro = {}

local text = "Humanity has settled on a new planet in the outer rim, unwittingly in the middle of disputed territory. Now, aliens are invading the planet. Your factory produces autonomous defense turrets, which you've been distributing to civilians in need of protection from the alien attack. However, alien intelligence has recently discovered the location of your factory. You're now faced with a dilemma: will you keep the turrets you produce to protect yourself, or give them to civilians in need?"

intro.load = function()
  wave_end.load("mk1") -- pass name of starting turret
  gui.disable_button("give_away")
end

intro.update = function(dt)
end

intro.draw = function()
  wave_end.draw_menu(text, "mk1")
end

return intro
