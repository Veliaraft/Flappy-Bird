Background = {}
Background.__index = Background


function Background:Create(Screen_width, Screen_height, speed)
    back = {}
    setmetatable(back, Background)
    back.day = love.graphics.newImage("/sprites/background-day.png")
    back.night = love.graphics.newImage("/sprites/background-night.png")
    back.width = back.day:getWidth()
    back.height = back.day:getHeight()
    back.SW = Screen_width
    back.SH = Screen_height
    back.speed = speed
    back.x = 0
    back.switch = True
    back.Time = 0
    self.alpha = 1
end


function Background:Update(dt, stop)
    self.Time = self.Time + dt
    if (self.Time > 30) then
        self.Time = 0
        self.switch = not self.switch
    end
    self.x = self.x - self.speed
    if (self.x <= -self.width) then
        self.x = 0
    end

    if (not self.switch and self.alpha < 1) then
        self.alpha = self.alpha + 0.01
    elseif (self.switch and self.alpha > 0) then
        self.alpha = self.alpha - 0.01
    end

end


function Background:Draw()
    love.graphics.scale(self.SH / self.height, self.SH / self.height)

    for i = 0, 6, 1 do
        love.graphics.draw(self.day, self.x + self.width * i, 0)
    end

    love.graphics.setColor(255, 255, 255, 1 - self.alpha)
    for i = 0, 6, 1 do
        love.graphics.draw(self.night, self.x + self.width * i, 0)
    end
    love.graphics.setColor(255, 255, 255, 1)
    
    love.graphics.scale(self.height / self.SH, self.height / self.SH)
end