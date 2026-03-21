---@diagnostic disable: undefined-global

-- VARIÁVEIS GLOBAIS
local PlayerShip = nil
local BossShip = nil
local Enemies = {}
EnemyBullets = {}

-- IMPORTS
local Push = require 'src.libs.push'
local Player = require 'src.entities.Player'
local Sprites = require 'src.utils.Sprites'
local Enemy = require 'src.entities.Enemy'
local BossShipClass = require 'src.entities.BossShip'

-- CONFIGURAÇÕES DA TELA
local VIRTUAL_WIDTH = 225
local VIRTUAL_HEIGHT = 300
local WINDOW_WIDTH = 750
local WINDOW_HEIGHT = 800
local GROUND_Y = VIRTUAL_HEIGHT - 5

-- VARIÁVEIS DE JOGO
local gameOver = false
local hasWon = false
local victoryVideo = nil
local videoFinished = false

-- VARIÁVEIS DOS INIMIGOS
local fleetDirection = 1
local fleetTimer = 0
local fleetDelay = 0.05
local currentFleetSpeed = 1
local enemyShootTimer = 0
local enemyShootDelay = 1

-- ============================================================================
-- FUNÇÕES DE INICIALIZAÇÃO
-- ============================================================================

local function playerDefinitions()
    PlayerShip = Player(VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
end

local function enemyDefinitions()
    Enemies = {}
    
    local startX = 40
    local startY = 40
    local spacingX = 35
    local spacingY = 25
    
    local rowColors = {
        {r = 1, g = 0.2, b = 0.2},     -- Vermelho
        {r = 0.2, g = 1, b = 0.2},     -- Verde
        {r = 0.2, g = 0.2, b = 1},     -- Azul
        {r = 1, g = 1, b = 0.2}        -- Amarelo
    }
    
    for row = 1, 4 do
        Enemies[row] = {}
        
        for col = 1, 5 do
            local enemy = Enemy(VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
            
            enemy.x = startX + (col - 1) * spacingX
            enemy.y = startY + (row - 1) * spacingY
            enemy.row = row
            enemy.color = rowColors[row]
            
            Enemies[row][col] = enemy
        end
    end
end

-- ============================================================================
-- FUNÇÕES DE COLISÃO
-- ============================================================================

local function checkCollision(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2 + w2 and
           x1 + w1 > x2 and
           y1 < y2 + h2 and
           y1 + h1 > y2
end

local function checkBulletEnemyCollisions()
    for i = #PlayerShip.bullets, 1, -1 do
        local bullet = PlayerShip.bullets[i]
        local bx, by, bw, bh = bullet:getCollisionRect()
        
        for row = 1, 4 do
            for col = 1, 5 do
                local enemy = Enemies[row][col]
                if enemy then
                    local ex, ey, ew, eh = enemy:getCollisionRect()
                        
                    if checkCollision(bx, by, bw, bh, ex, ey, ew, eh) then
                        bullet:destroy()
                        Enemies[row][col] = nil
                        PlayerShip:gainScore(row)
                        currentFleetSpeed = currentFleetSpeed + 0.25
                        break
                    end
                end
            end
        end
    end
end

-- ✅ COLISÃO COM BOSS
local function checkBulletBossCollisions()
    if not BossShip.isActive then
        return
    end
    
    for i = #PlayerShip.bullets, 1, -1 do
        local bullet = PlayerShip.bullets[i]
        local bx, by, bw, bh = bullet:getCollisionRect()
        
        local bossx, bossy, bossw, bossh = BossShip:getCollisionRect()
        
        if checkCollision(bx, by, bw, bh, bossx, bossy, bossw, bossh) then
            bullet:destroy()
            local destroyed = BossShip:takeDamage()
            
            if destroyed then
                PlayerShip:gainScore(1)  -- Boss vale 40 pontos
            end
            break
        end
    end
end

local function checkEnemyBulletPlayerCollisions()
    local px, py, pw, ph = PlayerShip:getCollisionRect()
    
    for i = #EnemyBullets, 1, -1 do
        local bullet = EnemyBullets[i]
        local bx, by, bw, bh = bullet:getCollisionRect()
        
        if checkCollision(bx, by, bw, bh, px, py, pw, ph) then
            table.remove(EnemyBullets, i)
            local playerDied = PlayerShip:loseLife()
            if playerDied then
                gameOver = true
            end
        end
    end
end

-- ✅ COLISÃO INIMIGO COM SOLO
local function checkEnemiesReachedGround()
    for row = 1, 4 do
        for col = 1, 5 do
            local enemy = Enemies[row][col]
            if enemy and enemy:hasReachedGround(GROUND_Y) then
                gameOver = true
                return
            end
        end
    end
end

local function randomEnemyShoot()
    local aliveEnemies = {}
    
    for row = 1, 4 do
        for col = 1, 5 do
            if Enemies[row][col] then
                table.insert(aliveEnemies, Enemies[row][col])
            end
        end
    end
    
    if #aliveEnemies > 0 then
        local randomEnemy = aliveEnemies[math.random(1, #aliveEnemies)]
        randomEnemy:shoot()
    end
end

-- ============================================================================
-- FUNÇÕES DE VITÓRIA E RESET
-- ============================================================================

function checkVictory()
    for row = 1, 4 do
        for col = 1, 5 do
            if Enemies[row][col] then
                return false
            end
        end
    end
    return true
end

function resetGame()
    gameOver = false
    hasWon = false
    videoFinished = false
    
    EnemyBullets = {}
    
    fleetDirection = 1
    fleetTimer = 0
    currentFleetSpeed = 1
    
    enemyShootTimer = 0
    
    playerDefinitions()
    enemyDefinitions()
    
    -- ✅ RESETAR BOSS
    BossShip = BossShipClass(VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
    
    if victoryVideo then
        victoryVideo:seek(0)
        victoryVideo:pause()
    end
end

-- ============================================================================
-- CALLBACKS DO LOVE
-- ============================================================================

function love.load()
    Sprites.load()
    
    love.window.setTitle('Space Invaders')
    love.graphics.setDefaultFilter('nearest', 'nearest')
    victoryVideo = love.graphics.newVideo("assets/vitoria.ogv")
    
    Push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true,
        canvas = false
    })
    
    playerDefinitions()
    enemyDefinitions()
    
    -- ✅ CRIAR BOSS
    BossShip = BossShipClass(VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
    print("[MAIN] BossShip criado com sucesso!")
end

function love.keypressed(key)
    if gameOver and key == "r" then
        resetGame()
    end
    
    if hasWon and videoFinished and key == "r" then
        resetGame()
    end
    
    -- ✅ DEBUG: Forçar boss com B
    if key == "b" and not gameOver and not hasWon then
        BossShip:spawn()
    end
end

function love.resize(w, h)
    Push:resize(w, h)
end

function love.update(dt)
    if gameOver then
        return
    elseif not gameOver and checkVictory() then
        hasWon = true
        victoryVideo:play()
    end
    
    -- Verificar se vídeo terminou
    if hasWon and not videoFinished and victoryVideo:isPlaying() == false then
        videoFinished = true
    end
    
    -- Atualizar player
    PlayerShip:movePlayer(dt)
    PlayerShip:update(dt)
    
    -- Verificar colisões com inimigos
    checkBulletEnemyCollisions()
    
    -- ✅ Verificar colisões com boss
    checkBulletBossCollisions()
    
    -- Verificar inimigos no solo
    checkEnemiesReachedGround()
    
    -- Atualizar tiros dos inimigos
    for i = #EnemyBullets, 1, -1 do
        local bullet = EnemyBullets[i]
        bullet:update(dt)
        if bullet:shouldRemove() then
            table.remove(EnemyBullets, i)
        end
    end
    
    -- Verificar colisões dos tiros inimigos
    checkEnemyBulletPlayerCollisions()
    
    -- Inimigos atiram aleatoriamente
    enemyShootTimer = enemyShootTimer + dt
    if enemyShootTimer >= enemyShootDelay then
        enemyShootTimer = 0
        randomEnemyShoot()
    end
    
    -- Atualizar inimigos
    for row = 1, 4 do
        for col = 1, 5 do
            if Enemies[row][col] then
                Enemies[row][col]:update(dt)
            end
        end
    end
    
    -- ✅ Atualizar boss
    BossShip:update(dt)
    
    -- Movimento dos inimigos (vai e vem)
    fleetTimer = fleetTimer + dt
    
    if fleetTimer >= fleetDelay then
        fleetTimer = 0
        
        local hitRight = false
        local hitLeft = false
        
        for row = 1, 4 do
            for col = 1, 5 do
                local enemy = Enemies[row][col]
                if enemy then
                    enemy.x = enemy.x + (fleetDirection * currentFleetSpeed)
                    
                    if enemy.x > VIRTUAL_WIDTH - 20 then
                        hitRight = true
                    end
                    
                    if enemy.x < 20 then
                        hitLeft = true
                    end
                end
            end
        end
        
        if hitRight then
            fleetDirection = -1
        end
        
        if hitLeft then
            fleetDirection = 1
            
            for row = 1, 4 do
                for col = 1, 5 do
                    if Enemies[row][col] then
                        Enemies[row][col].y = Enemies[row][col].y + 10
                    end
                end
            end
        end
    end
end

function love.draw()
    Push:start()
    
    love.graphics.clear(10 / 255, 11 / 255, 26 / 255, 1)
    
    -- Renderizar player
    PlayerShip:render()
    PlayerShip:drawStats()
    
    -- Renderizar inimigos
    for row = 1, 4 do
        for col = 1, 5 do
            if Enemies[row][col] then
                Enemies[row][col]:render()
            end
        end
    end
    
    -- ✅ Renderizar boss
    BossShip:render()
    
    -- Renderizar tiros
    for _, bullet in ipairs(EnemyBullets) do
        bullet:render()
    end
    
    -- Tela de Game Over
    if gameOver then
        love.graphics.setColor(0, 0, 0, 0.8)
        love.graphics.rectangle("fill", 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
        love.graphics.setColor(1, 0, 0, 1)
        love.graphics.printf("DESISTA DOS SEUS SONHOS E MORRA", 0, VIRTUAL_HEIGHT / 2 - 20, VIRTUAL_WIDTH, "center")
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.printf("Pressione R para reiniciar", 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, "center")
    end
    
    -- Tela de vitória com vídeo
    if hasWon and not videoFinished then
        love.graphics.draw(victoryVideo, 0, 0, 0, VIRTUAL_WIDTH / victoryVideo:getWidth(), VIRTUAL_HEIGHT / victoryVideo:getHeight())
    end
    
    -- Tela de parabéns
    if hasWon and videoFinished then
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.rectangle("fill", 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
        
        love.graphics.setColor(0, 1, 0, 1)
        love.graphics.printf("PARABENS!", 0, VIRTUAL_HEIGHT / 2 - 30, VIRTUAL_WIDTH, "center")
        
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.printf("Pressione R para jogar de novo", 0, VIRTUAL_HEIGHT / 2 + 10, VIRTUAL_WIDTH, "center")
    end
    
    Push:finish()
end