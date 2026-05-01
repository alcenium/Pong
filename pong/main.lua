FONT_FILE = 'magofonts/mago2.ttf'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

LFONT_SIZE = 32
SFONT_SIZE = 8

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
    end
end

function love.update(dt)
    if love.keyboard.isDown('w') then
        paddle1YPos = paddle1YPos - (PADDLE_SPEED * dt)
        if paddle1YPos < PADDLE_MIN_Y then
            paddle1YPos = PADDLE_MIN_Y
        end
    end

    if love.keyboard.isDown('s') then
        paddle1YPos = paddle1YPos + (PADDLE_SPEED * dt)
        if paddle1YPos > PADDLE_MAX_Y then
            paddle1YPos = PADDLE_MAX_Y
        end
    end

    if love.keyboard.isDown('up') then
        paddle2YPos = paddle2YPos - (PADDLE_SPEED * dt)
        if paddle2YPos < PADDLE_MIN_Y then
            paddle2YPos = PADDLE_MIN_Y
        end
    end

    if love.keyboard.isDown('down') then
        paddle2YPos = paddle2YPos + (PADDLE_SPEED * dt)
        if paddle2YPos > PADDLE_MAX_Y then
            paddle2YPos = PADDLE_MAX_Y
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
    love.graphics.rectangle('fill', VIRTUAL_WIDTH/2 - 2, VIRTUAL_HEIGHT/2 -2, 4, 4)
    push.finish()
end