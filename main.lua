class = require "lib.middleclass.middleclass"
bump = require 'lib.bump.bump'
bump_debug = require 'bump_debug'
gamestate = require 'lib.hump.gamestate'
inspect = require 'lib.inspect.inspect'

playMusic = false

gravity = 40

window_width = love.graphics.getWidth()
window_height = love.graphics.getHeight()

-- helper function
function drawBox(box, r, g, b)
  love.graphics.setColor(r,g,b)
  love.graphics.rectangle("line", box.l, box.t, box.w, box.h)
end


function love.load()

  got_joystick = get_joystick()
  print("Controller available: " .. tostring(got_joystick))

  gamestate.registerEvents()
  gamestate.switch(require("game")())
end


function get_joystick()
  joysticks = love.joystick.getJoysticks()

  if #joysticks ~= 0 then
    joystick_01 = love.joystick.getJoysticks()[1]
    return true
  else
    return false
  end
end
