local Class = require('src.utils.Class')
local Sprites = require('src.utils.Sprites')
local Bullet = require('src.entities.Bullet')
local BossShip = Class {}

-- Constantes
BOSS_SPEED = 80
BOSS_SCALE = 0.28
BOSS_WIDTH = 16
BOSS_HEIGHT = 16

local contador_parede 

function BossShip:init(virtual_width, virtual_height)
    self.virtual_width = virtual_width
    self.virtual_height = virtual_height
    
    -- Posição
    self.x = -50
    self.y = 20
    
    -- Estado
    self.isActive = false
    self.direction = 1  -- 1 = direita, -1 = esquerda
    
    -- Sprites e tamanho
    local spriteWidth, spriteHeight = Sprites.getDimensions()
    self.width = spriteWidth * BOSS_SCALE
    self.height = spriteHeight * BOSS_SCALE
    
    -- Vida
    self.health = 3
    
    -- Timer de aparição
    self.spawnTimer = 0
    self.spawnDelay = math.random(15, 20)  -- Aparece entre 15-20 segundos
    
    -- Timer de tiro
    self.shootTimer = 0
    self.shootDelay = 1.0  -- Atira a cada 1 segundo
    
    -- Cor
    self.color = {r = 1, g = 1, b = 0.2}  -- Amarelo
    self.contador_parede = 0
    
    print("[BossShip] Criado! Próxima aparição em: " .. self.spawnDelay .. "s")
end

function BossShip:update(dt)
    -- Se não está ativo, incrementar timer de spawn
    if not self.isActive then
        self.spawnTimer = self.spawnTimer + dt
        if self.spawnTimer >= self.spawnDelay then
            self:spawn()
        end
    else
        -- Se está ativo, mover e atirar
        self:move(dt)
        self:updateShoot(dt)
    end
end

function BossShip:move(dt)

    self.x = self.x + (self.direction * BOSS_SPEED * dt)

    -- parede direita
    if self.x >= self.virtual_width then
        self.x = self.virtual_width
        self.direction = -1
        
        self.contador_parede = self.contador_parede + 1
        print("Bateu na direita. Contador:", self.contador_parede)
    end

    -- parede esquerda
    if self.x <= 0 then
        self.x = 0
        self.direction = 1
        
        self.contador_parede = self.contador_parede + 1
        print("Bateu na esquerda. Contador:", self.contador_parede)
    end

    -- se bateu 3 vezes
    if self.contador_parede >= 3 then
        print("[BossShip] Bateu 3 vezes, desaparecendo")
        self:despawn()
    end

end


function BossShip:updateShoot(dt)
    self.shootTimer = self.shootTimer + dt
    if self.shootTimer >= self.shootDelay then
        self:shoot()
        self.shootTimer = 0
    end
end

function BossShip:spawn()
    self.isActive = true
    self.x = -50  -- Começa fora da tela à esquerda
    self.direction = 1  -- Vai para direita
    self.health = 3
    self.shootTimer = 0
    self.contador_parede = 0
    print("[BossShip] ⚡ APARECENDO!")
end

function BossShip:despawn()
    self.isActive = false
    self.spawnTimer = 0
    self.spawnDelay = math.random(15, 20)  -- Novo intervalo
    
end

function BossShip:shoot()
    local gunX, gunY = self:getGunPosition()
    local bullet = Bullet(gunX, gunY, "boss", nil)  -- "boss" = tiro que só colide com player
    table.insert(EnemyBullets, bullet)
end

function BossShip:getGunPosition()
    return self.x, self:getDrawY() + self.height
end

function BossShip:takeDamage()
    self.health = self.health - 1
    print("[BossShip] ⚡ ACERTADO! Vida: " .. self.health)
    
    if self.health <= 0 then
        self:despawn()
        print("[BossShip] 💥 DESTRUÍDA!")
        return true
    end
    return false
end

function BossShip:getDrawX()
    return self.x - self.width / 2
end

function BossShip:getDrawY()
    return self.y - self.height / 2
end

function BossShip:getCollisionRect()
    return self:getDrawX(), self:getDrawY(), self.width, self.height
end

function BossShip:render()
    if not self.isActive then
        return
    end
    
    -- Desenhar nave
    love.graphics.setColor(self.color.r, self.color.g, self.color.b, 1)
    Sprites.draw(Sprites.R3C4, self:getDrawX(), self:getDrawY(), BOSS_SCALE)
    
    -- Desenhar barra de vida
    self:renderHealthBar()
    
    love.graphics.setColor(1, 1, 1, 1)
end

function BossShip:renderHealthBar()
    local barWidth = self.width
    local barHeight = 2
    local barX = self:getDrawX()
    local barY = self:getDrawY() - 5
    
    -- Fundo vermelho
    love.graphics.setColor(0.5, 0, 0, 1)
    love.graphics.rectangle("fill", barX, barY, barWidth, barHeight)
    
    -- Vida em verde
    local healthPercent = self.health / 3
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.rectangle("fill", barX, barY, barWidth * healthPercent, barHeight)
end

return BossShip