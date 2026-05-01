FONT_FILE = 'magofonts/mago2.ttf'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

LFONT_SIZE = 32
SFONT_SIZE = 16

PADDLE_MIN_Y = 0
PADDLE_MAX_Y = VIRTUAL_HEIGHT - 20 -- (Paddle height)

PADDLE_SPEED = 150 -- px/s

push = require 'push'

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    largeFont = love.graphics.newFont(FONT_FILE, LFONT_SIZE)
    smallFont = love.graphics.newFont(FONT_FILE, SFONT_SIZE)

    player1Score = 0
    player2Score = 0

    paddle1YPos = 10
    paddle2YPos = VIRTUAL_HEIGHT - 20 - 10

    math.randomseed(os.time())

    ballX = VIRTUAL_WIDTH/2 - 2
    ballY = VIRTUAL_HEIGHT/2 - 2

    ballDX = math.random(2) == 1 and 100 or -100
    ballDY = math.random(-50, 50)

    gamestate = 'start'

    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        resizable = false,
        fullscreen = false,
        vsync = false
    })

    push.setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, { upscale = 'normal' })
end

function love.keypressed(key)
    if key == 'e' then
        love.event.quit()
    elseif key == 'return' then
        if gamestate == 'start' then
            gamestate = 'play'
        else
            gamestate = 'start'
        end

        ballX = VIRTUAL_WIDTH/2 - 2
        ballY = VIRTUAL_HEIGHT/2 - 2

        ballDX = math.random(2) == 1 and 100 or -100
        ballDY = math.random(-50, 50)
    end
end

function love.update(dt)
    if love.keyboard.isDown('w') then
        paddle1YPos = math.max(paddle1YPos - PADDLE_SPEED * dt, 0)
    end

    if love.keyboard.isDown('s') then
        paddle1YPos = math.min(paddle1YPos + PADDLE_SPEED * dt, PADDLE_MAX_Y)
    end

    if love.keyboard.isDown('up') then
        paddle2YPos = math.max(paddle2YPos - PADDLE_SPEED * dt, 0)
    end

    if love.keyboard.isDown('down') then
        paddle2YPos = math.min(paddle2YPos + PADDLE_SPEED * dt, PADDLE_MAX_Y)
    end

    if gamestate == 'play' then
        ballX = ballX + ballDX * dt
        if ballX < 0 or ballX > VIRTUAL_WIDTH - 4 then
            ballDX = ballDX * -1
        end

        ballY = ballY + ballDY * dt
        if ballY < 0 or ballY > VIRTUAL_HEIGHT - 4 then
            ballDY = ballDY * -1
        end
    end
end

function love.draw()
    push.start()
    love.graphics.clear(33/255, 60/255, 81/255, 1)
    love.graphics.setFont(largeFont)
    love.graphics.printf("Pong Clone 2026!", 0, 10, VIRTUAL_WIDTH, 'center')
    
    --Scores
    love.graphics.printf(player1Score, 0, VIRTUAL_HEIGHT/4, VIRTUAL_WIDTH/2 - 10, 'right')
    love.graphics.printf(player2Score, VIRTUAL_WIDTH/2 + 10, VIRTUAL_HEIGHT/4, VIRTUAL_WIDTH, 'left')

    -- First paddle
    love.graphics.rectangle('fill', 10, paddle1YPos, 4, 20)

    -- Second paddle
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 14, paddle2YPos, 4, 20)

    -- Ball
    love.graphics.rectangle('fill', ballX, ballY, 4, 4)

    love.graphics.setFont(smallFont)
    love.graphics.printf(gamestate, 0, 10 + 21, VIRTUAL_WIDTH, 'center')
    push.finish()
end