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
local fleetDelay = 0.3

--Variaveis para definir a janela do jogo
local VIRTUAL_WIDTH = 225
local VIRTUAL_HEIGHT = 300
local WINDOW_WIDTH = 750
local WINDOW_HEIGHT = 800

local function playerDefinitions()
    PlayerShip = Player(VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
end

local function enemyDefinitions()
    --Definicao da posicao dos inimigos e a mtrzi representada por eles
    Enemies = {}

    local startX = 40
    local startY = 40
    local spacingX = 35
    local spacingY = 25

    for row = 1,4 do
        Enemies[row] = {}

        for col = 1,5 do
            local enemy = Enemy(VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

            enemy.x = startX + (col-1) * spacingX
            enemy.y = startY + (row-1) * spacingY

            enemy.row = row

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
    --Movimentação do inimigo
    for row=1,4 do
        for col=1,5 do
            Enemies[row][col]:update(dt)
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

                enemy.x = enemy.x + fleetDirection

                if enemy.x > VIRTUAL_WIDTH - 20 then
                    hitRight = true
                end

                if enemy.x < 20 then
                    hitLeft = true
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
                    Enemies[row][col].y =
                    Enemies[row][col].y + 10
                end
            end
        end

    end
end

function love.draw()
    --Renderiza o player e inimigos na tela
    Push:start()

    love.graphics.clear(10 / 255, 11 / 255, 26 / 255, 1)

    PlayerShip:render()
    for row=1,4 do
        for col=1,5 do
            Enemies[row][col]:render()
        end
    end
    Push:finish()
end