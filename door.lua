local Door = class('Door')

--TODO: Stop allowing double jump after sliding off a platform.
--TODO: Fix wall sticking.

function Door:initialize(name, colour)
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

function Door:getTiledObject(name)
  local platformsLayer = map.layers["platforms"]
  platformsLayer.visible = false

  for _, tiled_object in ipairs(platformsLayer.objects) do
    if tiled_object.name == name then
      return tiled_object
    end
  end
end

function Door:update(dt)

end

function Door:draw()
  -- Only draw the Door iof it is alive
  if self.alive then
    -- Draw Door fill
    love.graphics.setColor(unpack(self.colour))
    love.graphics.rectangle("fill", self.l, self.t, self.w, self.h)

    -- Draw Door hitbox
    drawBox(self, unpack(self.colour))
  end
end

function Door:kill()
  self.alive = false
  world:remove(self)
end

return Door
