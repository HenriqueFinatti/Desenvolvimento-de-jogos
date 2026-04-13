local sti = require "sti"
local camX = -256
local camY = 0
local canvas
local larguraJogo, alturaJogo = 512, 256
local venceu = false
local derrota = false
local vidas = 3
local obstaculos = {}
local imgGigante

function love.load()
    wf = require "windfield"
    world = wf.newWorld(0, 800)

    btnReiniciar = {
    largura = 100,
    altura = 30,
    texto = "REINICIAR"
    }
    btnReiniciar.x = (larguraJogo / 2) - (btnReiniciar.largura / 2)
    btnReiniciar.y = (alturaJogo / 2) + 40

    imgGigante = love.graphics.newImage("assets/gigante.png")
    somAparecer = love.audio.newSource("assets/vai-corinthians003.mp3", "static")
    audio_derrota = love.audio.newSource("assets/veiga-me-da-seu-manguito.mp3", "static")
    audio_vitoria = love.audio.newSource("assets/bota-o-hino-do-corinthians.mp3", "static")
    world:addCollisionClass('Player')
    world:addCollisionClass('End')

    anim8 = require "anim8"
    love.graphics.setDefaultFilter("nearest", "nearest")
    player = {}
    player.x = -230
    player.y = 40
    player.startX = -230
    player.startY = 40
    player.speed = 100
    player.collider = world:newBSGRectangleCollider(player.x, player.y, 15, 36, 14)
    player.collider:setFixedRotation(true)
    player.collider:setCollisionClass('Player')

    player.spriteSheet = love.graphics.newImage("assets/player-sheet.png")
    player.grid = anim8.newGrid(12, 18, player.spriteSheet:getWidth(), player.spriteSheet:getHeight())

    player.animation = {}
    player.animation.right = anim8.newAnimation(player.grid('1-4', 3), 0.1)
    player.animation.left = anim8.newAnimation(player.grid('1-4', 2), 0.1)

    player.anim = player.animation.left

    local obs = {
        x = -32,
        y = 0,
        largura = 112,
        altura = 64,
        visivel = false,
        distanciaAtivacao = 40,
        alfa = 0,
        jaUsado = false
    }
    obs.collider = world:newRectangleCollider(obs.x, obs.y, obs.largura, obs.altura)
    obs.collider:setType('static')

    obs.sx = obs.largura / imgGigante:getWidth()
    obs.sy = obs.altura / imgGigante:getHeight()

    table.insert(obstaculos, obs)
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

    endGame = {}
    if map.layers["End"] then
        for i, obj in pairs(map.layers["End"].objects) do
            local item = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
            item:setType('static')
            item:setCollisionClass('End')
            table.insert(endGame, item)
        end
    end
    love.window.setMode(0, 0, {fullscreen = true})
end

function love.update(dt)
    if venceu or derrota then return end
    local isMoving = false
    local vx = 0
    local _, vy = player.collider:getLinearVelocity()

    if player.collider:enter('End') then
        venceu = true
    end

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

    if player.x < camX or player.x > camX + larguraJogo or
       player.y < camY or player.y > camY + alturaJogo then

        vidas = vidas - 1

        if vidas <= 0 then
            derrota = true
        else
            player.collider:setPosition(player.startX, player.startY)
            player.collider:setLinearVelocity(0, 0)
        end
    end

    for i = #obstaculos, 1, -1 do
        local obs = obstaculos[i]

        if not obs.jaUsado then
            local dx = player.x - obs.x
            local dy = player.y - obs.y
            local distancia = math.sqrt(dx*dx + dy*dy)

            if distancia < obs.distanciaAtivacao then
                obs.alfa = math.min(obs.alfa + dt * 5, 1)
                if not somAparecer:isPlaying() then
                    somAparecer:play()
                end


            else
                if obs.alfa > 0 then
                    obs.alfa = math.max(obs.alfa - dt * 2, 0)
                    if obs.alfa <= 0 then
                        obs.jaUsado = true
                        obs.collider:destroy()
                        obs.collider = nil
                    end
                end
            end
        end
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

    if venceu or derrota then
        if venceu then
            audio_vitoria:play()
            love.graphics.clear(0.1, 0.5, 0.3)
            love.graphics.printf("VAI CORINTHIANS!", 0, alturaJogo / 2 - 30, larguraJogo, "center")
        else
            audio_derrota:play()
            love.graphics.clear(0.5, 0.1, 0.1)
            love.graphics.printf("GAME OVER", 0, alturaJogo / 2 - 40, larguraJogo, "center")
            love.graphics.printf("Você falhou miseravelmente!", 0, alturaJogo / 2 - 10, larguraJogo, "center")
        end

        love.graphics.setColor(0, 0, 0, 0.6)
        love.graphics.rectangle("fill", btnReiniciar.x, btnReiniciar.y, btnReiniciar.largura, btnReiniciar.altura, 5)

        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("line", btnReiniciar.x, btnReiniciar.y, btnReiniciar.largura, btnReiniciar.altura, 5)
        love.graphics.printf(btnReiniciar.texto, btnReiniciar.x, btnReiniciar.y + 8, btnReiniciar.largura, "center")
    else
        map:draw(-camX, -camY)

        for _, obs in ipairs(obstaculos) do
            if obs.alfa > 0 then
                love.graphics.setColor(1, 1, 1, obs.alfa)
                love.graphics.draw(imgGigante, obs.x - camX, obs.y - camY, 0, obs.sx, obs.sy)
                love.graphics.setColor(1, 1, 1, 1)
            end
        end

        player.anim:draw(player.spriteSheet, player.x - camX, player.y - camY, 0, 2, 2, 6, 9)

        love.graphics.setColor(0, 0, 0, 0.4)
        love.graphics.rectangle("fill", 5, 5, 65, 15)

        love.graphics.setColor(1, 1, 1)
        love.graphics.print("VIDAS: " .. vidas, 10, 7)

        love.graphics.push()
        love.graphics.translate(-camX, -camY)
        love.graphics.pop()
    end
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


function love.mousepressed(x, y, button)
    if (venceu or derrota) and button == 1 then
        local escalaX = love.graphics.getWidth() / larguraJogo
        local escalaY = love.graphics.getHeight() / alturaJogo
        local escalaFinal = math.min(escalaX, escalaY)
        local offsetX = (love.graphics.getWidth() - (larguraJogo * escalaFinal)) / 2
        local offsetY = (love.graphics.getHeight() - (alturaJogo * escalaFinal)) / 2

        local mouseJogoX = (x - offsetX) / escalaFinal
        local mouseJogoY = (y - offsetY) / escalaFinal

        if mouseJogoX >= btnReiniciar.x and mouseJogoX <= btnReiniciar.x + btnReiniciar.largura and
           mouseJogoY >= btnReiniciar.y and mouseJogoY <= btnReiniciar.y + btnReiniciar.altura then
            love.event.quit("restart")
        end
    end
end