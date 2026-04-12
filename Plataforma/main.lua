local sti = require "sti"
local camX = -256
local camY = 0
local canvas
local larguraJogo, alturaJogo = 512, 256

function love.load()
    wf = require "windfield"
    world = wf.newWorld(0, 800)
    anim8 = require "anim8"
    love.graphics.setDefaultFilter("nearest", "nearest")
    player = {}
    player.x = -240
    player.y = 40
    player.speed = 100
    player.collider = world:newBSGRectangleCollider(player.x, player.y, 15, 36, 14)
    player.collider:setFixedRotation(true)

    player.spriteSheet = love.graphics.newImage("assets/player-sheet.png")
    player.grid = anim8.newGrid(12, 18, player.spriteSheet:getWidth(), player.spriteSheet:getHeight())

    player.animation = {}
    player.animation.right = anim8.newAnimation(player.grid('1-4', 3), 0.1)
    player.animation.left = anim8.newAnimation(player.grid('1-4', 2), 0.1)

    player.anim = player.animation.left
    map = sti("assets/mapa.lua")

    canvas = love.graphics.newCanvas(larguraJogo, alturaJogo)

    plataforms = {}

    if map.layers["Plataforms"] then
        for i, obj in pairs(map.layers["Plataforms"].objects) do
            local plataform = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
            plataform:setType('static')
            table.insert(plataforms, plataform)
        end
    end
    love.window.setMode(0, 0, {fullscreen = true})
end

function love.update(dt)
    local isMoving = false
    local vx = 0
    local _, vy = player.collider:getLinearVelocity()
    if love.keyboard.isDown("right") then
        vx = player.speed
        player.anim = player.animation.right
        isMoving = true
    end

    if love.keyboard.isDown("left") then
        vx = player.speed * -1
        player.anim = player.animation.left
        isMoving = true
    end

    player.collider:setLinearVelocity(vx, vy)

    if isMoving == false then
        player.anim:gotoFrame(2)
    end
    world:update(dt)

    player.x = player.collider:getX()
    player.y = player.collider:getY()
    player.anim:update(dt)
end

function love.keypressed(key)
    if key == "escape" then love.event.quit() end

    if key == "space" or key == "up" or key == "w" then
        player.collider:applyLinearImpulse(0, -300)
    end
end

function love.draw()
    love.graphics.setCanvas(canvas)
    love.graphics.clear()

    map:draw(-camX, -camY)

    player.anim:draw(player.spriteSheet, player.x - camX, player.y - camY, 0, 2, 2, 6, 9)

    love.graphics.push()
    love.graphics.translate(-camX, -camY)
    love.graphics.pop()

    love.graphics.setCanvas()

    local larguraMonitor = love.graphics.getWidth()
    local alturaMonitor = love.graphics.getHeight()

    local escalaX = larguraMonitor / larguraJogo
    local escalaY = alturaMonitor / alturaJogo

    local escalaFinal = math.min(escalaX, escalaY)

    local offsetX = (larguraMonitor - (larguraJogo * escalaFinal)) / 2
    local offsetY = (alturaMonitor - (alturaJogo * escalaFinal)) / 2

    love.graphics.draw(canvas, offsetX, offsetY, 0, escalaFinal, escalaFinal)
end