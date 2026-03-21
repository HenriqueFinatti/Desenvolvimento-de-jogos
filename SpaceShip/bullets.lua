-- ============================================================================
-- BULLETS.LUA - Módulo de tiros
-- Interage tanto com o player (tiro) quanto com inimigos (colisão)
-- ============================================================================

Bullets = {}

function Bullets:init()
    self.list = {}
end

function Bullets:add(x, y, vx, vy)
    table.insert(self.list, {
        x = x,
        y = y,
        vx = vx,
        vy = vy
    })
end

function Bullets:update(dt, player, enemy)
    -- Atualiza posição dos tiros
    for i = #self.list, 1, -1 do
        local bullet = self.list[i]
        
        bullet.x = bullet.x + bullet.vx * dt
        bullet.y = bullet.y + bullet.vy * dt
        
        -- Remove tiros fora da tela
        if bullet.y < -10 or bullet.y > screenHeight + 10 or
           bullet.x < -10 or bullet.x > screenWidth + 10 then
            table.remove(self.list, i)
        else
            -- Verifica colisão com inimigos
            self:checkEnemyCollision(bullet, i, enemy)
        end
    end
end

function Bullets:checkEnemyCollision(bullet, bulletIndex, enemy)
    for i = #enemy.list, 1, -1 do
        local e = enemy.list[i]
        
        if checkCollision(bullet.x, bullet.y, 5, e.x, e.y, enemy.size) then
            -- Remove inimigo da lista correta
            table.remove(enemy.list, i)
            -- Remove tiro
            if self.list[bulletIndex] then
                table.remove(self.list, bulletIndex)
            end
            -- Adiciona pontuação
            addScore(100)
            break
        end
    end
end

function Bullets:draw()
    love.graphics.setColor(0.2, 1, 0.2, 1)  -- Verde
    
    for _, bullet in ipairs(self.list) do
        love.graphics.circle("fill", bullet.x, bullet.y, 5)
    end
end