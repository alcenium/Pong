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
        resizable = false,
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
        ball:update(dt)
    end
end

function love.draw()
    push.start()
    love.graphics.clear(33/255, 60/255, 81/255, 1)
    love.graphics.setColor(255/255, 255/255, 255/255, 255/255)

    love.graphics.setFont(largeFont)
    love.graphics.printf("Pong Clone 2026!", 0, 10, VIRTUAL_WIDTH, 'center')
    
    --Scores
    love.graphics.printf(player1Score, 0, VIRTUAL_HEIGHT/4, VIRTUAL_WIDTH/2 - 10, 'right')
    love.graphics.printf(player2Score, VIRTUAL_WIDTH/2 + 10, VIRTUAL_HEIGHT/4, VIRTUAL_WIDTH, 'left')

    paddle1:draw()
    paddle2:draw()

    ball:draw()

    love.graphics.setFont(smallFont)
    love.graphics.printf(gamestate, 0, 10 + 21, VIRTUAL_WIDTH, 'center')

    love.graphics.setColor(0, 255/255, 0, 255/255)
    love.graphics.printf('FPS: ' .. love.timer.getFPS(), 0, 5, VIRTUAL_WIDTH, 'center')
    push.finish()
end