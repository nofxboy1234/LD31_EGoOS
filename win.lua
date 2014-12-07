local Win = class('Win')

function Win:initialize()

end

function Win:draw()

  love.graphics.setColor(255, 255, 0)

  love.graphics.print("Congratulations! You have found the magical ham!\nThanks for playing :)", window_width/2 - 150, window_height/2)

  love.graphics.setColor(255, 255, 255)

end

function Win:keypressed(key, isrepeat)
  if key == "return" then
    -- if playMusic then
    --   self.music:stop()
    -- end
    gamestate.switch(require("game")())
  end

end

function Win:joystickpressed(joystick, button)
  if button == 1 then
    -- if playMusic then
    --   self.music:stop()
    -- end
    gamestate.switch(require("game")())
  end
end

return Win