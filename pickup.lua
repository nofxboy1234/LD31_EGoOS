local Pickup = class('Pickup')

--TODO: Stop allowing double jump after sliding off a platform.
--TODO: Fix wall sticking.

function Pickup:initialize(name, colour)
  print("pickup name: " .. inspect(name))
  local tiled_object = self:getTiledObject(name)

  self.tiled_type = tiled_object.type
  self.name = name

  self.l = tiled_object.x
  self.t = tiled_object.y
  self.w = tiled_object.width
  self.h = tiled_object.height

  self.state = "on_ground"

  self.alive = true

  self.colour = colour

  world:add(self, self.l, self.t, self.w, self.h)
end

function Pickup:getTiledObject(name)
  local pickupsLayer = map.layers["pickups"]
  print("pickupsLayer: " .. inspect(pickupsLayer))
  pickupsLayer.visible = false

  for _, tiled_object in ipairs(pickupsLayer.objects) do
    print("tiled_object.name: " .. inspect(tiled_object.name))
    print("name: " .. inspect(name))
    if tiled_object.name == name then
      return tiled_object
    end
  end
end

function Pickup:update(dt)

end

function Pickup:draw()
  -- Only draw the pickup iof it is alive
  if self.alive then
    -- Draw Pickup fill
    love.graphics.setColor(unpack(self.colour))
    love.graphics.rectangle("fill", self.l, self.t, self.w, self.h)
    -- love.graphics.circle("fill", self.l, self.t, self.w/2, 100)

    -- Draw Pickup hitbox
    drawBox(self, unpack(self.colour))
  end
end

function Pickup:kill()
  self.alive = false
  world:remove(self)
end

return Pickup
