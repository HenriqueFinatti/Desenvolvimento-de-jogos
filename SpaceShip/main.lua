-- ============================================================================
-- SPACESHIP GAME - main.lua
-- Arquivo principal que carrega tudo e controla o fluxo do jogo
-- ============================================================================

function love.load()
    -- Carrega os módulos
    require("player")
    require("enemy")
    require("bullets")
    require("powerup")
    
    -- ========== CONFIGURAÇÃO DA TELA ==========
    screenWidth = love.graphics.getWidth()
    screenHeight = love.graphics.getHeight()
    
    -- ========== CARREGAMENTO DE ASSETS ==========
    nebulosa = love.graphics.newImage("Assets/Farback01.png")
    stars = love.graphics.newImage("Assets/Stars.png")
    
    shipFrames = {
        love.graphics.newImage("Assets/Ship01.png"),
        love.graphics.newImage("Assets/Ship02.png"),
        love.graphics.newImage("Assets/Ship03.png"),
        love.graphics.newImage("Assets/Ship04.png")
    }
    
    -- ========== INICIALIZAR SISTEMAS ==========
    Player:init()
    Enemy:init()
    Bullets:init()
    Powerup:init()
    initBackgroundSystem()
    initScoreSystem()
    initSlowMotionSystem()
    initGameState()
end

-- ============================================================================
-- UPDATE - Lógica do jogo
-- ============================================================================
function love.update(dt)
    -- Se jogo acabou, não atualiza
    if gameState.gameOver then
        return
    end
    
    -- ========== ATUALIZAR SLOW-MOTION (usa dt real, não scaled) ==========
    updateSlowMotion(dt)
    
    -- ========== MOVIMENTO CONTÍNUO DO FUNDO ==========
    -- Fundo é afetado pelo slow-motion
    local backgroundDt = dt
    if slowMotion.active then
        backgroundDt = dt * slowMotion.timeScale
    end
    updateBackground(backgroundDt)
    
    -- ========== ATUALIZAR PLAYER (sempre em velocidade normal) ==========
    Player:update(dt)  -- Sempre usa dt real!
    
    -- ========== ATUALIZAR INIMIGOS E POWER-UPS (afetados por slow-motion) ==========
    local enemyDt = dt
    if slowMotion.active then
        enemyDt = dt * slowMotion.timeScale
    end
    Enemy:update(enemyDt, Player)
    Powerup:update(enemyDt, Player)
    Bullets:update(dt, Player, Enemy)
    
    -- Verifica colisão entre player e inimigos
    checkPlayerEnemyCollision()
end

-- ============================================================================
-- DRAW - Renderização
-- ============================================================================
function love.draw()
    love.graphics.setColor(1, 1, 1, 1)
    
    -- ========== DESENHAR FUNDO ==========
    drawRepeatingImage(nebulosa, backgroundState.nebulosOffset, 0)
    drawRepeatingImage(stars, backgroundState.starsOffset, 0)
    
    -- ========== DESENHAR INIMIGOS ==========
    Enemy:draw()
    
    -- ========== DESENHAR POWER-UPS ==========
    Powerup:draw()
    
    -- ========== DESENHAR TIROS ==========
    Bullets:draw()
    
    -- ========== DESENHAR PLAYER ==========
    Player:draw(shipFrames)
    
    -- ========== DESENHAR UI ==========
    drawUI()
    
    -- ========== EFEITO VISUAL DE SLOW-MOTION ==========
    drawSlowMotionEffect()
    
    -- ========== DESENHAR GAME OVER ==========
    if gameState.gameOver then
        drawGameOver()
    end
end

-- ============================================================================
-- SISTEMAS - Background
-- ============================================================================

function initBackgroundSystem()
    backgroundState = {
        scrollSpeed = 80,
        nebulosOffset = 0,
        starsOffset = 0,
        nebulosSpeedMultiplier = 0.3,
        starsSpeedMultiplier = 0.5
    }
end

function updateBackground(actualDt)
    backgroundState.nebulosOffset = backgroundState.nebulosOffset - 
        backgroundState.scrollSpeed * actualDt * backgroundState.nebulosSpeedMultiplier
    backgroundState.starsOffset = backgroundState.starsOffset - 
        backgroundState.scrollSpeed * actualDt * backgroundState.starsSpeedMultiplier
end

function drawRepeatingImage(image, offsetX, offsetY)
    local imgWidth = image:getWidth()
    local imgHeight = image:getHeight()
    
    offsetX = offsetX % imgWidth
    if offsetX < 0 then offsetX = offsetX + imgWidth end
    
    love.graphics.draw(image, offsetX, offsetY)
    
    if offsetX > 0 then
        love.graphics.draw(image, offsetX - imgWidth, offsetY)
    end
end

-- ============================================================================
-- SISTEMAS - Score
-- ============================================================================

function initScoreSystem()
    scoreState = {
        current = 0,
        max = 0
    }
    updateScoreText()
end

function addScore(points)
    scoreState.current = scoreState.current + points
    if scoreState.current > scoreState.max then
        scoreState.max = scoreState.current
    end
    updateScoreText()
end

function updateScoreText()
    scoreState.text = "Score: " .. scoreState.current
end

-- ============================================================================
-- SISTEMAS - Slow Motion
-- ============================================================================

function initSlowMotionSystem()
    slowMotion = {
        active = false,
        duration = 5,          -- Dura 5 segundos
        timer = 0,
        timeScale = 0.3,       -- 30% da velocidade
        activated = false
    }
end

function updateSlowMotion(dt)
    if slowMotion.active then
        slowMotion.timer = slowMotion.timer - dt
        if slowMotion.timer <= 0 then
            slowMotion.active = false
            slowMotion.timer = 0
        end
    end
end

function drawSlowMotionEffect()
    if slowMotion.active then
        love.graphics.setColor(0.2, 0.4, 1, 0.1)
        love.graphics.rectangle("fill", 0, 0, screenWidth, screenHeight)
        
        local font = love.graphics.getFont()
        love.graphics.setColor(0.2, 0.8, 1, 0.8)
        local slowText = "SLOW MOTION! " .. string.format("%.1f", slowMotion.timer) .. "s"
        local textWidth = font:getWidth(slowText)
        love.graphics.printf(slowText, screenWidth/2 - textWidth/2, 50, screenWidth, "center")
    end
end

-- ============================================================================
-- SISTEMAS - Game State
-- ============================================================================

function initGameState()
    gameState = {
        gameOver = false
    }
end

-- ============================================================================
-- COLISÕES
-- ============================================================================

function checkPlayerEnemyCollision()
    for i = #Enemy.list, 1, -1 do
        local enemy = Enemy.list[i]
        -- Usa dimensões reais: Player.width x Player.height e Enemy.size x Enemy.size
        -- Colisão de caixa (AABB) é mais precisa que círculo
        if checkAABBCollision(
            Player.x, Player.y, Player.width, Player.height,
            enemy.x - Enemy.size/2, enemy.y - Enemy.size/2, Enemy.size, Enemy.size
        ) then
            -- Se player não está invulnerável
            if not Player.invulnerable then
                -- Ativa invulnerabilidade
                Player.invulnerable = true
                Player.invulnerableTimer = Player.invulnerableDuration
                
                -- Reduz vida
                Player.health = Player.health - 1
                
                -- Remove inimigo
                table.remove(Enemy.list, i)
                
                -- Verifica game over
                if Player.health <= 0 then
                    gameState.gameOver = true
                end
            end
        end
    end
end

-- Colisão de caixa (AABB) - mais precisa que círculo
function checkAABBCollision(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2 + w2 and
           x1 + w1 > x2 and
           y1 < y2 + h2 and
           y1 + h1 > y2
end

function checkCollision(x1, y1, size1, x2, y2, size2)
    local dx = x1 - x2
    local dy = y1 - y2
    local distance = math.sqrt(dx*dx + dy*dy)
    return distance < (size1 + size2)
end

-- ============================================================================
-- UI
-- ============================================================================

function drawUI()
    local font = love.graphics.getFont()
    love.graphics.setColor(1, 1, 1, 0.9)
    love.graphics.print(scoreState.text, 20, 20)
    love.graphics.print("Max: " .. scoreState.max, 20, 50)
    love.graphics.print("Health: " .. Player.health .. "/" .. Player.maxHealth, 20, 80)
    
    love.graphics.setFont(font)
    love.graphics.print("WASD/Arrows: Move | Space: Shoot | ESC: Quit", 20, screenHeight - 40)
    love.graphics.print("Colete power-ups verdes para ativar SLOW-MOTION!", 20, screenHeight - 20)
end

function drawGameOver()
    -- Overlay escuro
    love.graphics.setColor(0, 0, 0, 0.7)
    love.graphics.rectangle("fill", 0, 0, screenWidth, screenHeight)
    
    -- Texto Game Over
    love.graphics.setColor(1, 0.2, 0.2, 1)
    local bigFont = love.graphics.newFont(64)
    love.graphics.setFont(bigFont)
    love.graphics.printf("GAME OVER", screenWidth/2 - 200, screenHeight/2 - 100, 400, "center")
    
    -- Score final
    love.graphics.setColor(1, 1, 1, 1)
    local mediumFont = love.graphics.newFont(32)
    love.graphics.setFont(mediumFont)
    love.graphics.printf("Score: " .. scoreState.current, screenWidth/2 - 150, screenHeight/2, 300, "center")
    
    -- Instrução
    love.graphics.setColor(1, 1, 1, 0.8)
    local smallFont = love.graphics.newFont(24)
    love.graphics.setFont(smallFont)
    love.graphics.printf("Press R to Restart", screenWidth/2 - 150, screenHeight/2 + 80, 300, "center")
end

-- ============================================================================
-- INPUT
-- ============================================================================

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    elseif key == "r" and gameState.gameOver then
        -- Reinicia o jogo
        love.load()
    end
end

-- ============================================================================
-- GAME OVER
-- ============================================================================

function gameOver()
    print("========== GAME OVER ==========")
    print("Final Score: " .. scoreState.current)
    print("Max Score: " .. scoreState.max)
    print("===============================")
    gameState.gameOver = true
end