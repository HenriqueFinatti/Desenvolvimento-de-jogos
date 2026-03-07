local Class = require('src.utils.Class')
local Bullet = Class{}


BULLET_SPEED = 220
BULLET_WIDTH = 2
BULLET_HEIGHT = 4

function Bullet:init(x,y)
    self.x = x
    self.y = y
end


function Bullet:update(dt)
    self.y = self.y - BULLET_SPEED * dt
end

function Bullet:render()
    love.graphics.rectangle("fill",self.x,self.y, BULLET_WIDTH, BULLET_HEIGHT)
end


function Bullet:isOffscreen()
    return self.y < 0
end

function Bullet:getCollisionRect()
    return self.x, self.y, BULLET_WIDTH, BULLET_HEIGHT
end

return Bullet
