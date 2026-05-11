Paddle = {
    x=0, y=0,
    width = 4, height = 20,
    speed = 150 -- px/s
}

function Paddle:draw()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end

function Paddle:moveUp(dt)
    self.y = math.max(PADDLE_MIN_Y, self.y - self.speed * dt)
end

function Paddle:moveDown(dt)
    self.y = math.min(PADDLE_MAX_Y, self.y + self.speed * dt)
end

function Paddle:getCollidePos(object)
    return (object.y + object.height/2) - (self.y + self.height/2)
end

function Paddle:new(object)
    object = object or {}
    setmetatable(object, self)
    self.__index = self
    return object
end