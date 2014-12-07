local Game_Over = class('Game_Over')

function Game_Over:initialize()
  -- print("Game_Over:initialize()")



end

function Game_Over:draw()
  -- love.graphics.draw(self.title_img, 0, 0)

  love.graphics.setColor(255, 0, 0)

  love.graphics.print("Game Over", window_width/2, window_height/2)

  love.graphics.setColor(255, 255, 255)

end

function Game_Over:keypressed(key, isrepeat)
  if key == "return" then
    -- if playMusic then
    --   self.music:stop()
    -- end
    gamestate.switch(require("game")())
  end

end

function Game_Over:joystickpressed(joystick, button)
  if button == 1 then
    -- if playMusic then
    --   self.music:stop()
    -- end
    gamestate.switch(require("game")())
  end
end

return Game_Over