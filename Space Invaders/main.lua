---@diagnostic disable: undefined-global
local PlayerShip = nil
local smallFont = nil

local Push = require 'src.libs.push'
local Player = require 'src.entities.Player'
local Sprites = require 'src.utils.Sprites'
local Enemy = require 'src.entities.Enemy'

--Variaveis para definir o movimento da frota de inimigos
local fleetDirection = 1 -- direção eixo x
local fleetTimer = 0
local fleetDelay = 0.05

--Variaveis para definir a janela do jogo
local VIRTUAL_WIDTH = 225
local VIRTUAL_HEIGHT = 300
local WINDOW_WIDTH = 750
local WINDOW_HEIGHT = 800

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
                        table.remove(PlayerShip.bullets, i)
                        Enemies[row][col] = nil
                        PlayerShip:gainScore(row)
                        break
                    end
                end
            end
        end
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
    smallFont = love.graphics.newFont('assets/font.ttf', 8)

    love.window.setTitle('Space Invaders')
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.graphics.setFont(smallFont)

    Push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true,
        canvas = false
    })

    playerDefinitions()
    enemyDefinitions()
end

function love.resize(w, h)
    Push:resize(w, h)
end

function love.update(dt)
    PlayerShip:movePlayer(dt)
    PlayerShip:update(dt)
    PlayerShip:drawStats()
    -- Verificar colisões entre tiros e inimigos
    checkBulletEnemyCollisions()

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
                    enemy.x = enemy.x + fleetDirection

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
    Push:finish()
end