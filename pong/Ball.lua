Ball = {width=4, height=4, x=0, y=0, dx=0, dy=0}

function Ball:draw()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end

function Ball:update(dt)
    if self.x < 0 or self.x > VIRTUAL_WIDTH - 4 then
        self.dx = self.dx * -1
    end
    if self.y < 0 or self.y > VIRTUAL_HEIGHT - 4 then
        self.dy = self.dy * -1
    end
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Ball:reset()
    self.x = VIRTUAL_WIDTH/2 - 2
    self.y = VIRTUAL_HEIGHT/2 - 2

    self.dx = math.random(2) == 1 and 100 or -100
    self.dy = math.random(-50, 50)
end

function Ball:new(object)
    object = object or {}
    setmetatable(object, self)
    self.__index = self
    return object
end