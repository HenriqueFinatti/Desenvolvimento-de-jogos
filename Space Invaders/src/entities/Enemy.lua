local Class = require('src.utils.Class')
local Sprites = require('src.utils.Sprites')
local Enemy = Class {}

ENEMY_SPEED = 90
ENEMY_SCALE = 0.28

function Enemy:init(virtual_width, virtual_height)
    self.virtual_width = virtual_width
    self.virtual_height = virtual_width

    self.initialX = virtual_width / 2
    self.initialY = 30
    self.x = virtual_width / 2
    self.y = 30
    self.dx = 0

    self.animTimer = 0
    self.animDelay = 0.5
    self.currentFrame =1

    self.scale = ENEMY_SCALE
    local spriteWidth, spriteHeight = Sprites.getDimensions()
    self.width = spriteWidth * self.scale
    self.height = spriteHeight * self.scale
end

function Enemy:update(dt)
    self.x = self.x + self.dx * dt
    self.x = math.max(self.width / 2, self.x)
    self.x = math.min(self.virtual_width - self.width / 2, self.x)

    self.animTimer = self.animTimer + dt

    if self.animTimer >= self.animDelay then
        self.animTimer = 0

        if self.currentFrame == 1 then
            self.currentFrame = 2
        else
            self.currentFrame = 1
        end
    end
end

function Enemy:getDrawX()
    return self.x - self.width / 2
end

function Enemy:getDrawY()
    return self.y - self.height / 2
end

function Enemy:render(alpha)

    local drawAlpha = alpha or 1
    love.graphics.setColor(1, 0.27, 0.22, drawAlpha)
    local spriteA
    local spriteB

    if self.row == 1 then
        spriteA = Sprites.R1C2
        spriteB = Sprites.R1C3
    elseif self.row == 2 then
        spriteA = Sprites.R1C4
        spriteB = Sprites.R1C5
    elseif self.row == 3 then
        spriteA = Sprites.R1C6
        spriteB = Sprites.R1C7
    else
        spriteA = Sprites.R1C8
        spriteB = Sprites.R1C9
    end

    if self.currentFrame == 1 then
        Sprites.draw(spriteA, self:getDrawX(), self:getDrawY(), self.scale)
    else
        Sprites.draw(spriteB, self:getDrawX(), self:getDrawY(), self.scale)
    end

    love.graphics.setColor(1, 1, 1, 1)

end

return Enemy