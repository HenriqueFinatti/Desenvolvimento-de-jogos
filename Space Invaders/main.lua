---@diagnostic disable: undefined-global
local PlayerShip = nil
local smallFont = nil

local Push = require 'src.libs.push'
local Player = require 'src.entities.Player'
local Sprites = require 'src.utils.Sprites'

local VIRTUAL_WIDTH = 225
local VIRTUAL_HEIGHT = 300
local WINDOW_WIDTH = 750
local WINDOW_HEIGHT = 1000

local function playerDefinitions()
    PlayerShip = Player(VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
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
end

function love.resize(w, h)
    Push:resize(w, h)
end

function love.update(dt)
    PlayerShip:movePlayer(dt)
end

function love.draw()
    Push:start()

    love.graphics.clear(10 / 255, 11 / 255, 26 / 255, 1)

    PlayerShip:render()
    Push:finish()
end