FONT_FILE = 'magofonts/mago2.ttf'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

LFONT_SIZE = 32
SFONT_SIZE = 16

PADDLE_MIN_Y = 0
PADDLE_MAX_Y = VIRTUAL_HEIGHT - 20 -- (Paddle height)

require 'Ball'
require 'Paddle'
push = require 'push'

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    sounds = {
        ['paddle'] = love.audio.newSource('sounds/paddle.wav','static'),
        ['wall'] = love.audio.newSource('sounds/wall.wav','static'),
        ['lose'] = love.audio.newSource('sounds/lose.wav','static')
    }

    largeFont = love.graphics.newFont(FONT_FILE, LFONT_SIZE)
    smallFont = love.graphics.newFont(FONT_FILE, SFONT_SIZE)

    player1Score = 0
    player2Score = 0

    paddle1YPos = 10
    paddle2YPos = VIRTUAL_HEIGHT - 20 - 10

    math.randomseed(os.time())

    paddle1 = Paddle:new{x = 10, y = 10}
    paddle2 = Paddle:new{
        x = VIRTUAL_WIDTH - 10 - 4,  -- Spacing (10) and paddle width (4)
        y = VIRTUAL_HEIGHT - 10 - 20 -- Spacing (10) and paddle height (20)
    }

    ball = Ball:new{
        x = VIRTUAL_WIDTH/2 - 2,
        y = VIRTUAL_HEIGHT/2 - 2,
        dx = math.random(2) == 1 and 100 or -100,
        dy = math.random(-50, 50)
    }

    gamestate = 'start'

    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        resizable = true,
        fullscreen = false,
        vsync = true
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

        ball:reset()
    end
end

function love.update(dt)
    if love.keyboard.isDown('w') then
        paddle1:moveUp(dt)
    end

    if love.keyboard.isDown('s') then
        paddle1:moveDown(dt)
    end

    if love.keyboard.isDown('up') then
        paddle2:moveUp(dt)
    end

    if love.keyboard.isDown('down') then
        paddle2:moveDown(dt)
    end

    if gamestate == 'play' then
        ball:move(dt)

        -- Paddle colision check
        if ball:collide(paddle1) then
            ball.dy = ball.dy + paddle1:getCollidePos(ball)*10
            ball.dx = -ball.dx * 1.03
            ball.x = paddle1.x + paddle1.width + 1
            love.audio.play(sounds['paddle'])
        end
        if ball:collide(paddle2) then
            ball.dy = ball.dy + paddle2:getCollidePos(ball)*10
            ball.dx = -ball.dx * 1.03
            ball.x = paddle2.x - ball.width - 1
            love.audio.play(sounds['paddle'])
        end

        -- Left and right wall colision check
        if ball.x < 0 then 
            gamestate = 'start'
            player2Score = player2Score + 1
            ball:reset()
            love.audio.play(sounds['lose'])
        end
        if ball.x + ball.width > VIRTUAL_WIDTH then
            gamestate = 'start'
            player1Score = player1Score + 1
            ball:reset()
            love.audio.play(sounds['lose'])
        end

        -- Top and bottom wall colision check
        if ball.y < 0 then
            ball.dy = -ball.dy
            ball.y = 0
            love.audio.play(sounds['wall']); end
        if ball.y + ball.height > VIRTUAL_HEIGHT then
            ball.dy = -ball.dy
            ball.y = VIRTUAL_HEIGHT - ball.height
            love.audio.play(sounds['wall'])
        end

        if player1Score >= 3 then
            triggerWinState('player1')
        end
        if player2Score >= 3 then
            triggerWinState('player2')
        end
    end
end

function love.draw()
    push.start()
    love.graphics.clear(33/255, 60/255, 81/255, 1)
    
    love.graphics.setFont(largeFont)
    love.graphics.printf("Pong Clone 2026!", 0, 10, VIRTUAL_WIDTH, 'center')
    
    if (gamestate == 'win') then
    love.graphics.printf(winner .. ' won!', 0, VIRTUAL_HEIGHT/2 - LFONT_SIZE/2, VIRTUAL_WIDTH, 'center')
    else
    --Scores
    love.graphics.printf(player1Score, 0, VIRTUAL_HEIGHT/4, VIRTUAL_WIDTH/2 - 10, 'right')
    love.graphics.printf(player2Score, VIRTUAL_WIDTH/2 + 10, VIRTUAL_HEIGHT/4, VIRTUAL_WIDTH, 'left')

    ball:draw()
    end

    paddle1:draw()
    paddle2:draw()

    love.graphics.setFont(smallFont)
    love.graphics.printf(gamestate, 0, 10 + 21, VIRTUAL_WIDTH, 'center')

    displayFPS()

    push.finish()
end

function love.resize(width, height)
    push.resize(width, height)
end

function displayFPS()
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 255/255, 0, 255/255)

    love.graphics.printf('FPS: ' .. love.timer.getFPS(), 0, 5, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(1,1,1,1)
end

function triggerWinState(player)
    winner = player
    gamestate = 'win'
    ball:reset()

    player1Score = 0
    player2Score = 0
end