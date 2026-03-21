-- ============================================================================
-- PLAYER.LUA - Módulo do jogador
-- ============================================================================

Player = {}

function Player:init()
    self.x = screenWidth / 2
    self.y = screenHeight / 2
    self.speed = 200
    
    -- Animação
    self.frameIndex = 1
    self.animationTimer = 0
    self.animationSpeed = 0.1
    
    -- Dimensões (serão definidas quando drawShip for chamado)
    self.width = 0
    self.height = 0
    
    -- Tiro
    self.fireTimer = 0
    self.fireRate = 0.15
    self.bulletSpeed = 400
    
    -- Vidas
    self.health = 3
    self.maxHealth = 3
    self.invulnerable = false
    self.invulnerableTimer = 0
    self.invulnerableDuration = 1.0  -- 1 segundo de invulnerabilidade após dano
end

function Player:update(dt)
    -- Atualiza invulnerabilidade
    if self.invulnerable then
        self.invulnerableTimer = self.invulnerableTimer - dt
        if self.invulnerableTimer <= 0 then
            self.invulnerable = false
        end
    end
    
    -- Atualiza animação
    self:updateAnimation(dt)
    
    -- Processa input
    self:handleInput(dt)
    
    -- Atualiza tiro
    self:updateFire(dt)
    
    -- Limita aos limites da tela
    self.x = math.max(0, math.min(self.x, screenWidth - self.width))
    self.y = math.max(0, math.min(self.y, screenHeight - self.height))
end

function Player:updateAnimation(dt)
    self.animationTimer = self.animationTimer + dt
    
    if self.animationTimer >= self.animationSpeed then
        self.frameIndex = self.frameIndex + 1
        
        if self.frameIndex > #shipFrames then
            self.frameIndex = 1
        end
        
        self.animationTimer = 0
    end
end

function Player:handleInput(dt)
    local moveX = 0
    local moveY = 0
    
    -- Movimento horizontal
    if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
        moveX = self.speed * dt
    end
    if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
        moveX = -self.speed * dt
    end
    
    -- Movimento vertical
    if love.keyboard.isDown("down") or love.keyboard.isDown("s") then
        moveY = self.speed * dt
    end
    if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
        moveY = -self.speed * dt
    end
    
    self.x = self.x + moveX
    self.y = self.y + moveY
end

function Player:updateFire(dt)
    self.fireTimer = self.fireTimer - dt
    
    if love.keyboard.isDown("space") and self.fireTimer <= 0 then
        self:shoot()
        self.fireTimer = self.fireRate
    end
end

function Player:shoot()
    -- Cria novo tiro na DIREITA do jogador (onde os inimigos vêm)
    Bullets:add(
        self.x + self.width,     -- Começa na borda direita da nave
        self.y + self.height / 2, -- Meio da nave
        self.bulletSpeed,         -- Velocidade para DIREITA
        0                         -- Sem movimento vertical
    )
end

function Player:draw(frames)
    local shipImage = frames[self.frameIndex]
    self.width = shipImage:getWidth()
    self.height = shipImage:getHeight()
    
    -- Se invulnerável, pisca
    if self.invulnerable then
        -- Pisca a cada 0.1 segundo
        if math.floor(self.invulnerableTimer * 10) % 2 == 0 then
            love.graphics.setColor(1, 1, 1, 0.5)  -- Semi-transparente
        else
            love.graphics.setColor(1, 1, 1, 1)
        end
    else
        love.graphics.setColor(1, 1, 1, 1)
    end
    
    love.graphics.draw(shipImage, self.x, self.y)
end