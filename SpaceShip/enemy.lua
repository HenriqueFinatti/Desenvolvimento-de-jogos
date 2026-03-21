Enemy = {}

function Enemy:init()
    self.list = {}
    self.size = 30
    self.speed = 150
    self.spawnTimer = 0
    self.spawnInterval = 1.5
end

function Enemy:update(dt, player)
    -- Spawn de novos inimigos
    self.spawnTimer = self.spawnTimer - dt
    if self.spawnTimer <= 0 then
        self:spawn()
        self.spawnTimer = self.spawnInterval
    end
    
    -- Atualiza cada inimigo (iteração reversa para remover com segurança)
    for i = #self.list, 1, -1 do
        local enemy = self.list[i]
        self:updateEnemy(enemy, i, dt)
    end
end

function Enemy:updateEnemy(enemy, index, dt)
    -- Movimento apenas para esquerda (sem perseguição)
    enemy.x = enemy.x - self.speed * dt
    
    -- Remove se saiu da tela pela esquerda
    if enemy.x < -50 then
        table.remove(self.list, index)
    end
end

function Enemy:spawn()
    -- Inimigos só aparecem da DIREITA
    local enemy = {
        x = screenWidth + 20,
        y = math.random(0, screenHeight),
        health = 1
    }
    
    table.insert(self.list, enemy)
end

function Enemy:remove(index)
    if index and self.list[index] then
        table.remove(self.list, index)
    end
end

function Enemy:draw()
    for _, enemy in ipairs(self.list) do
        -- Desenha inimigo como um quadrado
        love.graphics.setColor(1, 0.3, 0.3, 1)  -- Vermelho
        love.graphics.rectangle("fill", 
            enemy.x - self.size/2, 
            enemy.y - self.size/2, 
            self.size, 
            self.size)
        
        -- Desenha olhos do inimigo
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.circle("fill", enemy.x - 8, enemy.y - 5, 3)
        love.graphics.circle("fill", enemy.x + 8, enemy.y - 5, 3)
    end
end