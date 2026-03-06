---@diagnostic disable: undefined-global
local push = require 'push'
local PlayerShip = nil
local smallFont = nil

Class = require 'Classes.class'
Player = require 'Classes.Player'
Sprites = require 'Sprites'

VIRTUAL_WIDTH = 225
VIRTUAL_HEIGHT = 300
WINDOW_WIDTH = 750
WINDOW_HEIGHT = 1000

local function playerDefinitions()
    PlayerShip = Player(VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT - 24)
end

function love.load()
    Sprites.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    math.randomseed(os.time())
    love.window.setTitle('Space Invaders')
    smallFont = love.graphics.newFont('Assets/font.ttf', 8)
    love.graphics.setFont(smallFont)
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true,
        canvas = false
    })
    playerDefinitions()
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)
    PlayerShip:movePlayer(dt)
end
local function drawHud()
    love.graphics.setFont(smallFont)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print('Pontos: ' .. tostring(score), 6, 6)
    love.graphics.print('Vidas: ' .. tostring(lives), 6, 16)
    love.graphics.print('Nivel: ' .. tostring(level), VIRTUAL_WIDTH - 50, 6)
end

function love.draw()
    push:start()

    love.graphics.clear(10 / 255, 11 / 255, 26 / 255, 1)
    drawHud()

    PlayerShip:render()
    push:finish()
end