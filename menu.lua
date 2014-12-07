local Menu = class('Menu')

function Menu:initialize()
  -- print("MENU:initialize()")

  self.menu_items = {"start game", "credits", "help", "quit"}
  self.title_img = love.graphics.newImage("maps/menu.png")

  if playMusic then
    self.music = love.audio.newSource("sounds/03_Charging_Katana.mp3", "stream")
    self.music:setLooping(true)
    self.music:setVolume(0.2)
    self.music:play()
  end

  self.menu_sound = love.audio.newSource("sounds/Menu_Selection_Click.wav", "static")
  -- menu_sound:setVolume(1.0)

  self.menuselection = 1
end

function Menu:draw()
  love.graphics.draw(self.title_img, 0, 0)
  -- Draw menu
  local center_v_offset = 150
  local offset = 0
  for i = 1, #self.menu_items do
    -- Set menu text colour depending on of it is selected
    if self.menuselection == i then
      love.graphics.setColor(0, 255, 0)
    else
      love.graphics.setColor(255, 255, 255)
    end

    love.graphics.print(self.menu_items[i], window_width/2, window_height/2 + center_v_offset  + offset)
    offset = offset + 20
  end
  love.graphics.setColor(255, 255, 255)

end

function Menu:keypressed(key, isrepeat)
  if key == "escape" then
      love.event.quit()
  end

  if (key == "up") and self.menuselection > 1 then
    self.menuselection = self.menuselection - 1
    self.menu_sound:stop()
    self.menu_sound:play()
  elseif (key == "up") and self.menuselection == 1 then
    self.menuselection = #self.menu_items
    self.menu_sound:stop()
    self.menu_sound:play()
  elseif (key == "down") and self.menuselection < #self.menu_items then
    self.menuselection = self.menuselection + 1
    self.menu_sound:stop()
    self.menu_sound:play()
  elseif (key == "down") and self.menuselection == #self.menu_items then
    self.menuselection = 1
    self.menu_sound:stop()
    self.menu_sound:play()
  end

  if key == "return" and self.menuselection == 1 then
    if playMusic then
      self.music:stop()
    end
    gamestate.switch(require("game")())
  elseif key == "return" and self.menuselection == 4 then
    love.event.quit()
  end
end

function Menu:joystickpressed(joystick, button)
  if (button == 14) and self.menuselection > 1 then
    self.menuselection = self.menuselection - 1
    self.menu_sound:stop()
    self.menu_sound:play()
  elseif (button == 14) and self.menuselection == 1 then
    self.menuselection = #self.menu_items
    self.menu_sound:stop()
    self.menu_sound:play()
  elseif (button == 15) and self.menuselection < #self.menu_items then
    self.menuselection = self.menuselection + 1
    self.menu_sound:stop()
    self.menu_sound:play()
  elseif (button == 15) and self.menuselection == #self.menu_items then
    self.menuselection = 1
    self.menu_sound:stop()
    self.menu_sound:play()
  end

  if button == 1 and self.menuselection == 1 then
    if playMusic then
      self.music:stop()
    end
    gamestate.switch(require("game")())
  elseif button == 1 and self.menuselection == 4 then
    love.event.quit()
  end
end

return Menu