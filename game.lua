local Game = class('Game')
local Player = require 'player'
local Pickup = require 'pickup'

local sti = require "lib.sti"

function table.shallow_copy(t)
  local t2 = {}
  for k,v in pairs(t) do
    t2[k] = v
  end
  return t2
end

function Game:initialize()
  -- print("GAME:initialize()")

  map = sti.new("maps/map")
  -- Get the platforms object layer
  local platformsLayer = map.layers["platforms"]
  -- Turn off visibility property of platforms layer so default draw() doesn't draw them
  platformsLayer.visible = false
  -- Get the collision rectangles from the platforms layer
  self.rectangles = platformsLayer.objects

  -- local pickupsLayer = map.layers["pickups"]
  -- pickupsLayer.visible = false
  -- self.pickups = pickupsLayer.objects
  -- print("self.pickups: " .. inspect(self.pickups))

  -- for _,rect in ipairs(self.rectangles) do
  --   print(rect.x)
  -- end

  self.blocks = {}
  self.pickups = {}

  house_screen = self:getScreen("house_screen")

  -- World creation
  world = bump.newWorld()

  self.player = Player:new('Whiskey', self)
  world:add(self.player, self.player.l, self.player.t, self.player.w, self.player.h)

  pickup_ham = Pickup:new('ham', {255, 0, 128})
  self.pickups[#self.pickups+1] = pickup_ham
  ham_timer = 0
  colour_1 = table.shallow_copy(pickup_ham.colour)
  pickup_ham.colour = colour_1
  colour_2 = {255, 255, 255}

  local health_pickups = self:getHealths()
  for _, pickup_name in ipairs(health_pickups) do
    local health_pickup = Pickup:new(pickup_name, {255, 255, 0})
    self.pickups[#self.pickups+1] = health_pickup
  end

  -- Add the collision rectangle from the platforms layer to the
  -- list of blocks to be drawn, and the bump world, for collision
  for _, rect in ipairs(self.rectangles) do
    self:addBlock(rect.x, rect.y, rect.width, rect.height, rect.type, rect.name)
  end

  self.house_door = self:getHouseDoor()
  print("self.house_door: " .. inspect(self.house_door))

  if playMusic then
    self.music = love.audio.newSource("sounds/04_Kill_U_2wise_Over.mp3", "stream")
    self.music:setLooping(true)
    self.music:setVolume(0.2)
    self.music:play()
  end

end

function Game:getHouseDoor()
  local house_door
  for _, p in ipairs(self.blocks) do
    if p.name == "house_door" then
      house_door = p
      return house_door
    end
  end
end

function Game:getHealths()
  local pickupsLayer = map.layers["pickups"]
  pickupsLayer.visible = false

  local health_pickups = {}
  for _, tiled_object in ipairs(pickupsLayer.objects) do
    if tiled_object.type == "health" then
      health_pickups[#health_pickups+1] = tiled_object.name
    end
  end

  return health_pickups
end

function Game:getScreen(name)
  local screensLayer = map.layers["screens"]
  screensLayer.visible = false

  -- local health_pickups = {}
  for _, tiled_object in ipairs(screensLayer.objects) do
    if tiled_object.name == name then
      return tiled_object
    end
  end
end

function Game:update(dt)
  map:update(dt)

  self:updatePickups(dt)
  self:updateHouseDoor(dt)
  self:updateHam(dt)
  self.player:update(dt)
end

function Game:updateHam(dt)
  ham_timer = ham_timer + dt

  -- local colour_1 = table.shallow_copy(pickup_ham.colour)
  -- local colour_2 = {255, 255, 255}

  if ham_timer >= 1.5 then
    if pickup_ham.colour == colour_1 then
      pickup_ham.colour = colour_2
    else
      if pickup_ham.colour == colour_2 then
      pickup_ham.colour = colour_1
      end
    end

    ham_timer = 0
  end
end

function Game:draw()
  map:draw()
  -- self:drawBlocks() -- draw hitboxes
  self:drawPickups()
  self:drawHouseDoor()
  self.player:draw()

  self:drawHUD()

  if shouldDrawDebug then self:drawDebug() end
  -- self:drawMessage()
end

function Game:updateHouseDoor(dt)
  -- the menu screen is gone, so move door up
  if not self.player.screen.alive then
    if self.house_door.t <= -self.house_door.h - 150 then
      return -- stop moving door up if it is out of the screen (with a bit of extra space)
    end

    self.house_door.t = self.house_door.t - (50 * dt) -- move door up at 5 pixels/second
    world:move(self.house_door, self.house_door.l, self.house_door.t) -- move bump rectangle up
  end
end

function Game:drawHouseDoor()
  love.graphics.setColor(128, 128, 128)
  love.graphics.rectangle("fill", self.house_door.l, self.house_door.t,
                          self.house_door.w, self.house_door.h)
end

function Game:updatePickups(dt)
  for _, pickup in ipairs(self.pickups) do
    pickup:update(dt)
  end
end

function Game:drawPickups()
  for _, pickup in ipairs(self.pickups) do
    pickup:draw()
  end
end

function Game:drawHUD()
love.graphics.setColor(0, 0, 0)
love.graphics.print("health: " .. self.player.health, 10, 10)
end

function Game:keypressed(k, isrepeat)
  -- print("Game:keypressed()")
  if k == "escape" then
    if playMusic then
      self.music:stop()
    end
    -- gamestate.switch(require("menu")())
    love.event.quit()
  end

  if k=="tab"    then shouldDrawDebug = not shouldDrawDebug end
  if k=="delete" then collectgarbage("collect") end

  if self.player.over_screen and self.player.screen.alive then
    self.player.screen:keypressed(k, isrepeat)
  end
end

function Game:keyreleased(key)
  -- print("Game:keyreleased()")
  self.player:keyreleased(key)
end

function Game:joystickpressed(joystick, button)
  -- print("Game:joystickpressed()")
  if (joystick == joystick_01) and (button == 8) then
    if playMusic then
      self.music:stop()
    end
    -- gamestate.switch(require("menu")())
    love.event.quit()
  end

  if self.player.over_screen and self.player.screen.alive then
    self.player.screen:joystickpressed(joystick, button)
  end
end

function Game:joystickreleased(joystick, button)
  -- print("Game:joystickreleased()")
  self.player:joystickreleased(joystick, button)
end

function Game:addBlock(l,t,w,h, tiled_type, name)
  local block = {l=l,t=t,w=w,h=h, tiled_type=tiled_type, name=name}
  self.blocks[#self.blocks+1] = block
  -- print(inspect(block))
  world:add(block, l,t,w,h)
end

function Game:drawBlocks()
  for _,block in ipairs(self.blocks) do
    drawBox(block, 255,0,0)
  end
end

-- Message/debug functions
function Game:drawMessage()
  local msg = self.instructions:format(tostring(shouldDrawDebug))
  love.graphics.setColor(255, 255, 255)
  love.graphics.print(msg, 550, 10)
end

function Game:drawDebug()
  bump_debug.draw(world)

  local statistics = ("fps: %d, mem: %dKB"):format(love.timer.getFPS(), collectgarbage("count"))
  love.graphics.setColor(255, 255, 255)
  love.graphics.print(statistics, 630, 580 )
end

return Game