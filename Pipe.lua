Pipe = {}
Pipe.__index = Pipe

function Pipe:new(screen_width, down_border)
    pipe = {}
    setmetatable(pipe, Pipe)
    pipe.image = love.graphics.newImage("/sprites/pipe-green.png")
    pipe.width = pipe.image:getWidth()
    pipe.height = pipe.image:getHeight()
    pipe.screen_width = screen_width
    pipe.down_border = down_border
    pipe.x = screen_width + 10
    pipe.finish = 0 -- указывает на преодоление препятствия
    pipe.y = math.random(down_border - pipe.height, down_border - pipe.height/6)
    
    return pipe
end

function Pipe:update(speed)
    self.x = self.x - speed

    if (self.x + self.width < -1) then
        return false
    end
    return true
end

function Pipe:draw(bird_height)
    -- рисуем нормальную трубу
    love.graphics.draw(self.image, self.x, self.y)
    -- рисуем повёрнутую трубу
    love.graphics.draw(self.image, self.x, self.y + bird_height, 0, 1, -1)
end
