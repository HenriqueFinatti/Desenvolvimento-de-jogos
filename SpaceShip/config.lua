-- ============================================================================
-- CONFIG.LUA - Configurações centralizadas do jogo
-- Modifique este arquivo para ajustar dificuldade e comportamento
-- ============================================================================

-- ========== CONFIGURAÇÃO DE TELA ==========
CONFIG_SCREEN_WIDTH = 1280
CONFIG_SCREEN_HEIGHT = 720

-- ========== CONFIGURAÇÃO DO JOGADOR ==========
CONFIG_PLAYER = {
    speed = 200,           -- Velocidade de movimento (pixels/s)
    bulletSpeed = 400,     -- Velocidade dos tiros (pixels/s)
    fireRate = 0.15        -- Tempo entre tiros (segundos)
}

-- ========== CONFIGURAÇÃO DE INIMIGOS ==========
CONFIG_ENEMY = {
    speed = 150,           -- Velocidade de movimento (pixels/s)
    size = 30,             -- Tamanho visual (pixels)
    spawnInterval = 1.5,   -- Tempo entre spawns (segundos)
    spawnRate = 0.5        -- Multiplicador de spawn (1.0 = normal, 0.5 = mais lento)
}

-- ========== CONFIGURAÇÃO DE FUNDO ==========
CONFIG_BACKGROUND = {
    scrollSpeed = 80,              -- Velocidade de scroll (pixels/s)
    nebulosSpeedMultiplier = 0.3,  -- Multiplicador de velocidade da nebulosa
    starsSpeedMultiplier = 0.5     -- Multiplicador de velocidade das estrelas
}

-- ========== CONFIGURAÇÃO DE SLOW-MOTION ==========
CONFIG_SLOWMOTION = {
    threshold = 500,   -- Pontuação para ativar slow-motion
    duration = 5,      -- Duração do efeito (segundos)
    timeScale = 0.3    -- Escala de tempo durante slow-motion (0.3 = 30% da velocidade)
}

-- ========== CONFIGURAÇÃO DE PONTUAÇÃO ==========
CONFIG_SCORE = {
    killReward = 100   -- Pontos por inimigo destruído
}

-- ========== PRESETS DE DIFICULDADE ==========
-- Use estes para ajustar múltiplas configurações de uma vez

DIFFICULTY_PRESETS = {
    EASY = {
        enemySpeed = 80,
        enemySpawnInterval = 3.0,
        slowMotionThreshold = 200,
        slowMotionDuration = 8,
        playerSpeed = 250,
        bulletSpeed = 500
    },
    NORMAL = {
        enemySpeed = 150,
        enemySpawnInterval = 1.5,
        slowMotionThreshold = 500,
        slowMotionDuration = 5,
        playerSpeed = 200,
        bulletSpeed = 400
    },
    HARD = {
        enemySpeed = 250,
        enemySpawnInterval = 0.8,
        slowMotionThreshold = 1500,
        slowMotionDuration = 2,
        playerSpeed = 200,
        bulletSpeed = 250
    },
    INSANE = {
        enemySpeed = 350,
        enemySpawnInterval = 0.4,
        slowMotionThreshold = 3000,
        slowMotionDuration = 1,
        playerSpeed = 150,
        bulletSpeed = 300
    }
}

-- ========== DICA DE USO ==========
-- Para usar um preset, adicione isto em main.lua após require("config"):
--
-- local currentDifficulty = DIFFICULTY_PRESETS.NORMAL
-- CONFIG_ENEMY.speed = currentDifficulty.enemySpeed
-- CONFIG_ENEMY.spawnInterval = currentDifficulty.enemySpawnInterval
-- CONFIG_SLOWMOTION.threshold = currentDifficulty.slowMotionThreshold
-- etc...