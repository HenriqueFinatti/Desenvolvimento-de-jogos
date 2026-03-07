local Class = require('src.utils.Class')
local Sprites = require('src.utils.Sprites')
local Player = Class {}

PLAYER_SPEED = 120
PLAYER_SCALE = 0.28

function Player:init(virtual_width, virtual_height)
    self.virtual_width = virtual_width
    self.virtual_height = virtual_width

    self.initialX = virtual_width / 2
    self.initialY = virtual_height - 24
    self.x = virtual_width / 2
    self.y = virtual_height - 24
    self.dx = 0

    self.scale = PLAYER_SCALE
    local spriteWidth, spriteHeight = Sprites.getDimensions()
    self.width = spriteWidth * self.scale
    self.height = spriteHeight * self.scale
end

function Player:update(dt)
    self.x = self.x + self.dx * dt
    self.x = math.max(self.width / 2, self.x)
    self.x = math.min(self.virtual_width - self.width / 2, self.x)
end

function Player:getDrawX()
    return self.x - self.width / 2
end

function Player:getDrawY()
    return self.y - self.height / 2
end


function Player:movePlayer(dt)
    if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
        self.x = self.x - PLAYER_SPEED * dt
    end

    if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
        self.x = self.x + PLAYER_SPEED * dt
    end

    local realPlayerWidth = SPRITE_WIDTH * PLAYER_SCALE
    local halfWidth = realPlayerWidth / 2

    if self.x < halfWidth then
        self.x = halfWidth
    elseif self.x > self.virtual_width - halfWidth then
        self.x = self.virtual_width - halfWidth
    end
end

function Player:getCollisionRect()
    local x = self:getDrawX() + self.width * 0.2
    local y = self:getDrawY() + self.height * 0.34
    local w = self.width * 0.6
    local h = self.height * 0.45
    return x, y, w, h
end

function Player:getGunPosition()
    local x, y, w = self:getCollisionRect()
    return x + w / 2, y
end

function Player:render(alpha)
    local drawAlpha = alpha or 1
    love.graphics.setColor(1, 0.27, 0.22, drawAlpha)
    Sprites.draw(Sprites.R3C5, self:getDrawX(), self:getDrawY(), self.scale)
    love.graphics.setColor(1, 1, 1, 1)
end

function Player:drawBoundingBox()
    local x, y, w, h = self:getCollisionRect()
    love.graphics.rectangle('line', x, y, w, h)
end

return Player
