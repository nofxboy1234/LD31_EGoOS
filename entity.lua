local Entity = class("Entity")

Entity.static.next_id = 0

function Entity:enter()
  self.l = 0
  self.t = 0
  self.z = 0

  self._alive = true
end

function Entity:update(dt)
  -- body
end

function Entity:draw()
  -- body
end

function Entity:onCollide(collider)
  -- body
end

function Entity:kill()
  self._alive = false
end

function Entity:isAlive()
  return self._alive
end

function Entity.static:getId()
  local id = "id" .. self.next_id
  self.next_id = self.next_id + 1
  return id
end

function Entity.static:resetIds()
  self.next_id = 0
end

return Entity
