local Player = class('Player')

local Screen = require 'screen'

--TODO: Stop allowing double jump after sliding off a platform.
--TODO: Fix wall sticking.

function Player:initialize(name, game)
  self.jump_sound = love.audio.newSource("sounds/Jump14.wav", "static")
  self.hurt_sound = love.audio.newSource("sounds/Hit_Hurt11.wav", "static")
  self.pickup_sound = love.audio.newSource("sounds/Pickup_Coin6.wav", "static")

  self.game = game

  self.name = name

  self.l = 50
  self.t = 50
  self.w = 32
  self.h = 32

  self.start_l = self.l
  self.start_t = self.t

  self.xVelocity = 0
  self.yVelocity = 0

  self.state = "on_ground"

  self.jump_vel = -750
  self.run_vel = 300

  self.alive = true
  self.health = 3
  self.maxhealth = 3

  self.colour = {0, 255, 0}

  self.over_screen = false
  self.screen = Screen:new(self.game)
end

function Player:checkbelowDeathLevel()
  if self.t >= window_height then
    self:kill()
  end
end

function Player:checkOverScreen()
  if self.l >= house_screen.x and
    self.l <= house_screen.x + house_screen.width then
    if self.t >= house_screen.y and
      self.t <= house_screen.y + house_screen.height then
      return true
    end

  end
end

function Player:update(dt)
  self.colour = {0, 255, 0}
  self:checkbelowDeathLevel()

  -- Check if player is over screen
  if self:checkOverScreen() then
    self.over_screen = true
  else
    self.over_screen = false
  end
  -- print("over screen: " .. inspect(self.over_screen))

  if love.keyboard.isDown('right') then
    self.xVelocity = self.run_vel * dt
  elseif love.keyboard.isDown('left') then
    self.xVelocity = -self.run_vel * dt
  end

  if got_joystick then
    if joystick_01:isDown(13) then
      self.xVelocity = self.run_vel * dt
    elseif joystick_01:isDown(12) then
      self.xVelocity = -self.run_vel * dt
    end
  end

  if (self.state == "on_ground" or self.state == "hurting") and love.keyboard.isDown('x') then
    self.yVelocity = self.jump_vel * dt
    self.state = "jump"
    self.jump_sound:play()

  end

  if got_joystick then
    -- TODO: check whether to use isDown/pressed/released to fine tune
    if (self.state == "on_ground" or self.state == "hurting") and joystick_01:isDown(2) then
      self.yVelocity = self.jump_vel * dt
      self.state = "jump"
      self.jump_sound:play()
    end
  end

  -- apply gravity
  self.yVelocity = self.yVelocity + (gravity * dt)

  -- update the player's position and check for collisions
  if self.xVelocity ~= 0 or self.yVelocity ~= 0 then
    local future_l, future_t = self.l + self.xVelocity, self.t + self.yVelocity

    local cols, len = world:check(self, future_l, future_t)
    if len == 0 then
      self.l, self.t = future_l, future_t
      world:move(self, future_l, future_t)
    else -- there was a collision
      -- local col, tl, tt, sl, st
      local col, tl, tt, nx, ny, sl, st
      while len > 0 do
        col = cols[1]

        other = self:getOther(col)


        -- tl,tt,_,_,sl,st = col:getSlide()
        tl, tt, nx, ny, sl, st = col:getSlide()

        -- print("nx: " .. nx .. " ny: " .. ny)

        self.l, self.t = tl, tt
        world:move(self, tl, tt)

        cols, len = world:check(self, sl, st)
        if len == 0 then
          self.l, self.t = sl, st
          world:move(self, sl, st)

          self.yVelocity = 0
          if ny == -1 and self.state ~= "hurting" then
            self.state = "on_ground"
          end
        end
      end
    end
  end
end

function Player:getOther(col)
  other = col.other
  -- print("other:\n")
  -- print(inspect(other))

  if other.tiled_type == "water" or other.tiled_type == "lava" or other.tiled_type == "spikes" then
    if self.state ~= "hurting" then
      self:takeDamage(1)
    end
    self.state = "hurting"
    self.hurt_sound:play()
    self.colour = {255, 0, 0}
  end

  if other.tiled_type == "ham" then
    self.pickup_sound:play()
    other:kill()
    gamestate.switch(require("win")())
  end

  if other.tiled_type == "health" then
    self.pickup_sound:play()
    other:kill()

    if self.health ~= self.maxhealth then
      self.health = self.health + 1
    end
  end
end

function Player:drawScreen()
  self.screen:draw()
end

function Player:draw()
  -- Draw player fill
  love.graphics.setColor(unpack(self.colour))
  love.graphics.rectangle("fill", self.l, self.t, self.w, self.h)

  -- Draw player hitbox
  drawBox(self, unpack(self.colour))

  -- self.over_screen = true
  if self.over_screen and self.screen.alive then
    self:drawScreen()
  end
end

function Player:takeDamage(damage)
  self.health = self.health - damage

  if self.health <= 0 then
    self:kill()
  end
end

function Player:kill()
  self.alive = false
  -- self.colour = {255, 0, 0, 255} -- make red
  gamestate.switch(require("game_over")())
end

function Player:keyreleased(key)
  if (key == "right") or (key == "left") then
    self.xVelocity = 0
  end
end

function Player:joystickreleased(joystick, button)
  if joystick == joystick_01 then
    if (button == 13) or (button == 12) then
      self.xVelocity = 0
    end
  end
end

return Player
