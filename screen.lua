local Screen = class('Screen')

function Screen:initialize(game)
  self.game = game

  self.menu_items = {"start game", "quit"}

  -- if playMusic then
  --   self.music = love.audio.newSource("sounds/03_Charging_Katana.mp3", "stream")
  --   self.music:setLooping(true)
  --   self.music:setVolume(0.2)
  --   self.music:play()
  -- end

  self.menu_sound = love.audio.newSource("sounds/Blip_Select22.wav", "static")
  -- self.menu_sound:setVolume(1.0)

  self.menuselection = 1
  self.x = 0
  self.y = 0
  self.width = 400
  self.height = 300

  self.colour = {0, 0, 0, 128}

  self.alive = true
end

function Screen:kill()
  self.alive = false
end

function Screen:draw()
  -- if not self.alive then
  --   return
  -- end

  love.graphics.setColor(unpack(self.colour))

  self.x = (window_width/2) - (self.width/2)
  self.y = (window_height/2) - (self.height/2)

  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)

  local offset = 0
  for i = 1, #self.menu_items do
    -- Set Screen text colour depending on of it is selected
    if self.menuselection == i then
      love.graphics.setColor(0, 255, 0)
    else
      love.graphics.setColor(255, 255, 255)
    end

    love.graphics.print(self.menu_items[i], self.x + 50, self.y + 50 + offset)
    offset = offset + 20
  end
  love.graphics.setColor(255, 255, 255)

end

function Screen:keypressed(key, isrepeat)
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
    -- gamestate.switch(require("game")())

    -- local house_door = self:getDoor("house_door")
    -- -- remove door from bump world
    -- -- world:remove(house_door)
    -- -- stop drawing door hitbox
    -- for k, block in ipairs(self.game.blocks) do
    --   if block.name == "house_door" then
    --     table.remove(self.game.blocks, k)
    --   end
    -- end

    self:kill()

  elseif key == "return" and self.menuselection == 2 then
    love.event.quit()
  end
end

function Screen:getDoor(name)
  for _, door in ipairs(self.game.blocks) do
    if door.name == name then
      return door
    end
  end
end

function Screen:joystickpressed(joystick, button)
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
    -- gamestate.switch(require("game")())

    -- local house_door = self:getDoor("house_door")
    -- -- remove door from bump world
    -- -- world:remove(house_door)
    -- -- stop drawing door hitbox
    -- for k, block in ipairs(self.game.blocks) do
    --   if block.name == "house_door" then
    --     table.remove(self.game.blocks, k)
    --   end
    -- end

    -- self:kill()

  elseif button == 1 and self.menuselection == 2 then
    love.event.quit()
  end

end

return Screen