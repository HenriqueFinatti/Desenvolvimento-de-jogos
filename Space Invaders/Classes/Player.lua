Player = Class {}

PLAYER_SPEED = 120
PLAYER_SCALE = 0.28

function Player:init(x, y)
    self.initialX = x
    self.initialY = y
    self.x = x
    self.y = y
    self.dx = 0

    self.scale = PLAYER_SCALE
    local spriteWidth, spriteHeight = Sprites.getDimensions()
    self.width = spriteWidth * self.scale
    self.height = spriteHeight * self.scale
end

function Player:update(dt)
    self.x = self.x + self.dx * dt
    self.x = math.max(self.width / 2, self.x)
    self.x = math.min(VIRTUAL_WIDTH - self.width / 2, self.x)
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

-- 2. Largura total e Metade da largura
    local realPlayerWidth = SPRITE_WIDTH * PLAYER_SCALE
    local halfWidth = realPlayerWidth / 2

    -- 3. Limites considerando que o X é o CENTRO do tanque
    if self.x < halfWidth then
        -- O centro do tanque para a uma distância "halfWidth" da borda 0
        self.x = halfWidth
    elseif self.x > VIRTUAL_WIDTH - halfWidth then
        -- O centro do tanque para a uma distância "halfWidth" da borda direita
        self.x = VIRTUAL_WIDTH - halfWidth
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
