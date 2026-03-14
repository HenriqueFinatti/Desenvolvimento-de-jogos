---@diagnostic disable: undefined-global
local PlayerShip = nil
local Push = require 'src.libs.push'
local Player = require 'src.entities.Player'
local Sprites = require 'src.utils.Sprites'
local Enemy = require 'src.entities.Enemy'

--Variaveis para definir o movimento da frota de inimigos
local fleetDirection = 1 -- direção eixo x
local fleetTimer = 0
local fleetDelay = 0.05
local currentFleetSpeed = 1 -- Velocidade atual da frota (multiplica o movimento)
EnemyBullets = {}  -- Array para armazenar tiros dos inimigos (global)
local enemyShootTimer = 0
local enemyShootDelay = 1  -- Um inimigo atira a cada 1 segundo
local gameOver = false
local hasWon = false
local victoryVideo = nil
local videoFinished = false  -- Controla se o vídeo acabou

--Variaveis para definir a janela do jogo
local VIRTUAL_WIDTH = 225
local VIRTUAL_HEIGHT = 300
local WINDOW_WIDTH = 750
local WINDOW_HEIGHT = 800
local GROUND_Y = VIRTUAL_HEIGHT - 5  -- ✅ CORRIGIDO - Linha do solo

local function playerDefinitions()
    PlayerShip = Player(VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
end

-- Função para testar colisão AABB (bounding box)
local function checkCollision(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2 + w2 and
           x1 + w1 > x2 and
           y1 < y2 + h2 and
           y1 + h1 > y2
end

-- Função para verificar colisões entre tiros e inimigos  
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
                        -- MODIFICADO: chamar destroy() ao invés de remover direto
                        bullet:destroy()
                        Enemies[row][col] = nil
                        PlayerShip:gainScore(row)
                        --Aumenta a velocidade conforme os inigmos vao morrendo
                        currentFleetSpeed = currentFleetSpeed + 1.2
                        break
                    end
                end
            end
        end
    end
end

-- Função para verificar colisões entre tiros de inimigos e player
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

-- ✅ Função para verificar se algum inimigo atingiu o solo
local function checkEnemiesReachedGround()
    for row = 1, 4 do
        for col = 1, 5 do
            local enemy = Enemies[row][col]
            if enemy and enemy:hasReachedGround(GROUND_Y) then
                -- Se um inimigo atingiu o solo, o jogador perde imediatamente
                gameOver = true
                return
            end
        end
    end
end

-- Função para selecionar um inimigo aleatório e fazer ele atirar
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

local function enemyDefinitions()
    --Definicao da posicao dos inimigos e a matriz representada por eles
    Enemies = {}

    local startX = 40
    local startY = 40
    local spacingX = 35
    local spacingY = 25

    -- Cores diferentes para cada linha
    local rowColors = {
        {r = 1, g = 0.2, b = 0.2},     -- Linha 1: Vermelho
        {r = 0.2, g = 1, b = 0.2},     -- Linha 2: Verde
        {r = 0.2, g = 0.2, b = 1},     -- Linha 3: Azul
        {r = 1, g = 1, b = 0.2}        -- Linha 4: Amarelo
    }

    for row = 1,4 do
        Enemies[row] = {}

        for col = 1,5 do
            local enemy = Enemy(VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

            enemy.x = startX + (col-1) * spacingX
            enemy.y = startY + (row-1) * spacingY

            enemy.row = row
            enemy.color = rowColors[row]

            Enemies[row][col] = enemy
        end
    end

end

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
end

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
    
    -- Parar o vídeo e resetar para o início
    if victoryVideo then
        victoryVideo:seek(0)
        victoryVideo:pause()
    end
end

function love.keypressed(key)
    if gameOver and key == "r" then
        resetGame()
    end
    
    -- Permite resetar o jogo após a vitória pressionando R
    if hasWon and videoFinished and key == "r" then
        resetGame()
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

    -- Verificar se o vídeo de vitória terminou
    if hasWon and not videoFinished and victoryVideo:isPlaying() == false then
        videoFinished = true
    end

    PlayerShip:movePlayer(dt)
    PlayerShip:update(dt)
    PlayerShip:drawStats()

    -- Verificar colisões entre tiros e inimigos
    checkBulletEnemyCollisions()

    -- Atualizar tiros dos inimigos e remover os que saíram da tela
    for i = #EnemyBullets, 1, -1 do
        local bullet = EnemyBullets[i]
        bullet:update(dt)
        if bullet:isOffscreen() then
            table.remove(EnemyBullets, i)
        end
    end

    -- Verificar colisões entre tiros de inimigos e player
    checkEnemyBulletPlayerCollisions()

    -- ✅ Verificar se algum inimigo atingiu o solo (ANTES de outros updates!)
    checkEnemiesReachedGround()

    -- Timer para inimigos atirarem (um por segundo)
    enemyShootTimer = enemyShootTimer + dt
    if enemyShootTimer >= enemyShootDelay then
        enemyShootTimer = 0
        randomEnemyShoot()
    end

    --Movimentação do inimigo
    for row=1,4 do
        for col=1,5 do
            if Enemies[row][col] then
                Enemies[row][col]:update(dt)
            end
        end
    end

    fleetTimer = fleetTimer + dt

    if fleetTimer >= fleetDelay then

        fleetTimer = 0

        local hitRight = false
        local hitLeft = false

        for row=1,4 do
            for col=1,5 do
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

            for row=1,4 do
                for col=1,5 do
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

    PlayerShip:render()
    PlayerShip:drawStats()
    for row=1,4 do
        for col=1,5 do
            if Enemies[row][col] then
                Enemies[row][col]:render()
            end
        end
    end

    -- Renderizar tiros dos inimigos
    for _, bullet in ipairs(EnemyBullets) do
        bullet:render()
    end

    -- Tela de Game Over
    if gameOver then
        love.graphics.setColor(0, 0, 0, 0.8)
        love.graphics.rectangle("fill", 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
        love.graphics.setColor(1, 0, 0, 1)
        love.graphics.printf("DESISTA DOS SEU  SONHOS E MORRA", 0, VIRTUAL_HEIGHT / 2 - 20, VIRTUAL_WIDTH, "center")
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.printf("Pressione R para reiniciar", 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, "center")
        love.graphics.setColor(1, 1, 1, 1)
    end

    -- Tela de vitória enquanto o vídeo toca
    if hasWon and not videoFinished then
        love.graphics.draw(victoryVideo, 0, 0, 0, VIRTUAL_WIDTH / victoryVideo:getWidth(), VIRTUAL_HEIGHT / victoryVideo:getHeight())
    end

    -- Tela de parabéns após o vídeo terminar
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