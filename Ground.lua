Ground = {}
Ground.__index = Ground

function Ground:create(speed)
    ground = {}
    setmetatable(ground, Ground)
    ground.image = love.graphics.newImage("/sprites/base.png")
    ground.x = 0
    ground.y = love.graphics.getHeight() - ground.image:getHeight()
    ground.width = ground.image:getWidth()
    ground.speed = speed
    return ground
end

function Ground:update()
    self.x = self.x - self.speed
    if (self.x <= -self.width) then
        self.x = 0
    end
end

function Ground:draw()
    for i = 0, 9, 1 do 
        love.graphics.draw(self.image, self.x + self.width * i, self.y)
    end
end