local Class = require('src.utils.Class')
local Sprites = require('src.utils.Sprites')
local Bullet = Class{}

BULLET_SPEED = 220
BULLET_WIDTH = 2
BULLET_HEIGHT = 4
ENEMY_BULLET_WIDTH = 2
ENEMY_BULLET_HEIGHT = 4

function Bullet:init(x, y, owner, sprite)
    self.x = x
    self.y = y
    self.sprite = sprite or nil
    self.isDestroyed = false
    self.owner = owner  -- "player", "enemy" ou "boss"
    
    -- Tiros do player vão para cima, tiros de inimigos/boss vão para baixo
    if owner == "player" then
        self.isPlayerBullet = true
        self.isBossBullet = false
    elseif owner == "boss" then
        self.isPlayerBullet = false
        self.isBossBullet = true
    else -- "enemy"
        self.isPlayerBullet = false
        self.isBossBullet = false
    end
end

function Bullet:update(dt)
    if self.isPlayerBullet then
        self.y = self.y - BULLET_SPEED * dt  -- Cima
    else
        self.y = self.y + BULLET_SPEED * dt  -- Baixo (inimigos e boss)
    end
end

function Bullet:render()
    if self.sprite then
        love.graphics.setColor(1, 1, 1, 1)
        Sprites.draw(self.sprite, self.x, self.y, 0.2)
    else
        -- Retângulo para tiro do player
        if self.isPlayerBullet then
            love.graphics.setColor(0, 1, 0, 1)  -- Verde
        else
            love.graphics.setColor(1, 0, 0, 1)  -- Vermelho (boss/inimigos)
        end
        love.graphics.rectangle("fill", self.x, self.y, BULLET_WIDTH, BULLET_HEIGHT)
        love.graphics.setColor(1, 1, 1, 1)
    end
end

function Bullet:isOffscreen()
    if self.isPlayerBullet then
        return self.y < 0
    else
        return self.y > 300  -- VIRTUAL_HEIGHT
    end
end

function Bullet:destroy()
    self.isDestroyed = true
end

function Bullet:shouldRemove()
    return self.isDestroyed or self:isOffscreen()
end

function Bullet:getCollisionRect()
    if self.isPlayerBullet then
        return self.x, self.y, BULLET_WIDTH, BULLET_HEIGHT
    else
        return self.x, self.y, ENEMY_BULLET_WIDTH, ENEMY_BULLET_HEIGHT
    end
end

return Bullet