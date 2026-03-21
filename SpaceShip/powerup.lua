-- ============================================================================
-- POWERUP.LUA - Módulo de power-ups
-- Power-ups que vêm da direita
-- ============================================================================

Powerup = {}

function Powerup:init()
    self.list = {}
    self.spawnTimer = 0
    self.spawnInterval = math.random(20, 30)  -- Entre 20s e 30s (1 min)
    self.size = 15
    self.speed = 100
end

function Powerup:update(dt, player)
    -- Spawn de novos power-ups
    self.spawnTimer = self.spawnTimer + dt
    if self.spawnTimer >= self.spawnInterval then
        self:spawn()
        self.spawnTimer = 0
        self.spawnInterval = math.random(20, 30)  -- Próximo aleatório
    end
    
    -- Atualiza cada power-up (iteração reversa para remover com segurança)
    for i = #self.list, 1, -1 do
        local powerup = self.list[i]
        self:updatePowerup(powerup, i, player, dt)
    end
end

function Powerup:updatePowerup(powerup, index, player, dt)
    -- Movimento apenas para esquerda
    powerup.x = powerup.x - self.speed * dt
    
    -- Verifica colisão com player
    if checkAABBCollision(
        player.x, player.y, player.width, player.height,
        powerup.x - self.size, powerup.y - self.size, self.size * 2, self.size * 2
    ) then
        -- Ativa slow-motion
        slowMotion.active = true
        slowMotion.timer = slowMotion.duration
        slowMotion.activated = true
        
        -- Remove power-up
        table.remove(self.list, index)
    end
    
    -- Remove se saiu da tela pela esquerda
    if powerup.x < -50 then
        table.remove(self.list, index)
    end
end

function Powerup:spawn()
    -- Power-up aparece da direita (círculo verde)
    local powerup = {
        x = screenWidth + 20,
        y = math.random(50, screenHeight - 50),
        type = "slowmotion"
    }
    
    table.insert(self.list, powerup)
end

function Powerup:draw()
    for _, powerup in ipairs(self.list) do
        if powerup.type == "slowmotion" then
            -- Círculo verde (slow-motion)
            love.graphics.setColor(0.2, 1, 0.2, 1)  -- Verde brilhante
            love.graphics.circle("fill", powerup.x, powerup.y, self.size)
            
            -- Borda mais brilhante
            love.graphics.setColor(0.4, 1, 0.4, 1)
            love.graphics.circle("line", powerup.x, powerup.y, self.size)
        end
    end
end