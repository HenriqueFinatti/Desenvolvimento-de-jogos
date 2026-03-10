-- Cena de Nave no Espaço com Efeito Parallax
-- Este script cria a ilusão de movimento da nave manipulando as posições das camadas de fundo

function love.load()
    -- Dimensões da tela
    screenWidth = love.graphics.getWidth()
    screenHeight = love.graphics.getHeight()
    
    -- Carrega as imagens
    nebulosa = love.graphics.newImage("Assets/Farback01.png") -- ou Farback02.png
    stars = love.graphics.newImage("Assets/Stars.png")
    
    -- Carrega as 4 frames da animação da nave
    shipFrames = {
        love.graphics.newImage("Assets/Ship01.png"),
        love.graphics.newImage("Assets/Ship02.png"),
        love.graphics.newImage("Assets/Ship03.png"),
        love.graphics.newImage("Assets/Ship04.png")
    }
    
    -- Variáveis de animação
    currentFrame = 1
    animationTimer = 0
    animationSpeed = 0.1  -- Tempo entre frames (em segundos). Aumente para mais lento, diminua para mais rápido
    
    -- Velocidade da nave (controla a velocidade do parallax)
    shipSpeed = 200 -- pixels por segundo
    
    -- Posições de offset para criar o efeito de movimento
    nebulosOffset = 0
    starsOffset = 0
    
    -- Velocidades multiplicadoras (parallax effect)
    -- Quanto maior o número, mais rápido o fundo se move
    nebulosSpeedMultiplier = 0.3  -- Nebulosa mais próxima, se move mais rápido
    starsSpeedMultiplier = 0.5    -- Estrelas em meio termo
end

function love.update(dt)
    -- Atualiza a animação da nave
    animationTimer = animationTimer + dt
    
    if animationTimer >= animationSpeed then
        -- Avança para o próximo frame
        currentFrame = currentFrame + 1
        
        -- Volta ao primeiro frame quando chegar no final
        if currentFrame > #shipFrames then
            currentFrame = 1
        end
        
        -- Reseta o timer
        animationTimer = 0
    end
    
    -- Movimento horizontal (esquerda/direita)
    local moveX = 0
    
    if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
        moveX = shipSpeed * dt
    end
    
    -- Movimento vertical (cima/baixo)
    local moveY = 0
    
    
    
    -- Atualiza os offsets com efeito parallax
    -- O sinal negativo faz o fundo se mover na direção oposta (parecendo que a nave se move)
    nebulosOffset = nebulosOffset - moveX * nebulosSpeedMultiplier
    starsOffset = starsOffset - moveX * starsSpeedMultiplier
    
    -- Para movimento vertical (opcional, comente se não quiser)
    nebulosOffset = nebulosOffset - moveY * nebulosSpeedMultiplier
    starsOffset = starsOffset - moveY * starsSpeedMultiplier
end

function love.draw()
    -- Define cor branca como padrão
    love.graphics.setColor(1, 1, 1, 1)
    
    -- Desenha nebulosa (fundo mais distante)
    drawRepeatingImage(nebulosa, nebulosOffset, 0)
    
    -- Desenha estrelas (segundo plano)
    drawRepeatingImage(stars, starsOffset, 0)
    
    -- Desenha a nave no centro da tela
    drawShip()
    
    -- Desenha instruções na tela
    love.graphics.setColor(1, 1, 1, 0.8)
    love.graphics.print("Use WASD ou Setas para mover", 10, 10)
    love.graphics.print("ESC para sair", 10, 30)
    
    if love.keyboard.isDown("escape") then
        love.event.quit()
    end
end

-- Função auxiliar para desenhar imagens que se repetem
function drawRepeatingImage(image, offsetX, offsetY)
    local imgWidth = image:getWidth()
    local imgHeight = image:getHeight()
    
    -- Normaliza o offset para evitar que cresça infinitamente
    offsetX = offsetX % imgWidth
    if offsetX < 0 then offsetX = offsetX + imgWidth end
    
    -- Desenha a imagem e uma cópia dela para criar efeito contínuo
    love.graphics.draw(image, offsetX, offsetY)
    
    -- Se há espaço vazio à direita, desenha outra cópia
    if offsetX > 0 then
        love.graphics.draw(image, offsetX - imgWidth, offsetY)
    end
end

-- Função para desenhar a nave no centro com animação
function drawShip()
    -- Obtém o frame atual
    local shipImage = shipFrames[currentFrame]
    local shipWidth = shipImage:getWidth()
    local shipHeight = shipImage:getHeight()
    
    -- Centraliza a nave na tela
    local shipX = (screenWidth - shipWidth) / 2
    local shipY = (screenHeight - shipHeight) / 2
    
    love.graphics.draw(shipImage, shipX, shipY)
end