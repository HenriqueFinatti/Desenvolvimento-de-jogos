local Class = require('src.utils.Class')
local Sprites = require('src.utils.Sprites')
local Bullet = Class{}

BULLET_SPEED = 220
BULLET_WIDTH = 2
BULLET_HEIGHT = 4
ENEMY_BULLET_WIDTH = 2
ENEMY_BULLET_HEIGHT = 4

--owner: tiro do player ou enemy
--sprite: imagem do tiro que é diferente para enemy ou player
function Bullet:init(x, y, owner, sprite)
    self.x = x
    self.y = y
    self.sprite = sprite or nil
    self.isDestroyed = false

    if owner == "enemy" then
        self.isEnemyBullet = true
    else
        self.isEnemyBullet = false
    end
end

function Bullet:update(dt)
    if self.isEnemyBullet then
        self.y = self.y + BULLET_SPEED * dt
    else
        self.y = self.y - BULLET_SPEED * dt
    end
end

function Bullet:render()
    if self.sprite then
        -- Renderizar sprite do inimigo
        love.graphics.setColor(1, 1, 1, 1)
        Sprites.draw(self.sprite, self.x, self.y, 0.2)
    else
        -- Renderizar retângulo do player
        love.graphics.rectangle("fill", self.x, self.y, BULLET_WIDTH, BULLET_HEIGHT)
    end
end

function Bullet:isOffscreen()
    if self.isEnemyBullet then
        return self.y > 300
    else
        return self.y < 0
    end
end

-- Marca o tiro como destruído
function Bullet:destroy()
    self.isDestroyed = true
end

-- Verifica se deve ser removido
function Bullet:shouldRemove()
    return self.isDestroyed or self:isOffscreen()
end

function Bullet:getCollisionRect()
    if self.isEnemyBullet then
        return self.x, self.y, ENEMY_BULLET_WIDTH, ENEMY_BULLET_HEIGHT
    else
        return self.x, self.y, BULLET_WIDTH, BULLET_HEIGHT
    end
end



return Bullet
