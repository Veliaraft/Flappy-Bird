Bird = {}
Bird.__index = Bird

function Bird:new(screen_height, screen_width, floor)
    bird = {}
    setmetatable(bird, Bird)
    bird.sprite = {0, 1, 2}
    -- изображения СБП* (СБП - Суицидальный Баллистический Петух)
    bird.sprite[0] = love.graphics.newImage("/sprites/yellowbird-downflap.png")
    bird.sprite[1] = love.graphics.newImage("/sprites/yellowbird-upflap.png")
    bird.sprite[2] = love.graphics.newImage("/sprites/yellowbird-midflap.png")
    -- изображения цифр
    bird.numbers = {}
    for i = 0, 9 do
        bird.numbers[i] = love.graphics.newImage("/sprites/"..tostring(i)..".png")
    end
    bird.numwidth = bird.numbers[0]:getWidth()
    bird.textwidth = 0
    -- Стартовая позиция СБП
    bird.screen_width = screen_width
    bird.screen_height = screen_height
    bird.y = screen_height / 2
    bird.x = screen_width / 6
    bird.floor = floor
    -- Для адекватного поворота СБП
    bird.translate_x = bird.sprite[0]:getWidth() / 2
    bird.translate_y = bird.sprite[0]:getHeight() / 2
    bird.translate_x, bird.translate_y = -bird.translate_x, -bird.translate_y
    -- направление СБП
    bird.yvec = 0
    bird.gravity = 0.5
    bird.speedup = -7
    -- задача аргументов поведения СБП
    bird.play = false
    bird.press = false
    bird.animateCount = 0
    bird.animate_index = 0
    bird.stop = 0
    bird.rotate = 0
    bird.score = 0
    bird.die = false

    return bird
end

function Bird:update()
    if (self.play) then
        -- вызывается для управления и реализации физики петуха
        self:controller()
    end
    if (self.stop == 1) then
        -- если игра завершилась
        if (self.y - self.translate_y >= self.floor and not (self.gravity == 0) ) then
            self.gravity = 0
            self.yvec = 0
            love.audio.newSource("/audio/hit.ogg", "static"):play()
        end
    end
end

function Bird:draw()
    -- тики анимации СБП
    self.animateCount = self.animateCount + 1
    if (self.animateCount == 15) then 
        self.animateCount = 0
    end

    -- рисуем, собсна, не особо умного виновника торжества внезапно решившего полетать на цехе трубопроката.
    if (self.yvec <= -1 or not self.play) then
        love.graphics.draw(self.sprite[(self.animateCount - self.animateCount % 5) / 5], self.x, self.y, self.rotate, 1, 1, -self.translate_x, -self.translate_y)
    else 
        love.graphics.draw(self.sprite[0], self.x , self.y, self.rotate, 1, 1, -self.translate_x, -self.translate_y)
    end
    -- отображение надписи в случае проигрыша
    if (self.gravity == 0) then
        text = "Press 'space' or click for restart"
        love.graphics.print(text, self.screen_width/2 - 3*#text, self.screen_height/2)
        self:scoredraw()
        return 1
    end
    -- отрисовывание очков игрока
    CW = self.score
    self:scoredraw()
    return 0
end

function Bird:start_play()
    self.play = true
end

function Bird:controller()
    -- управление безумцем
    self.yvec = self.yvec + self.gravity
    if (not self.press) then
        if (love.keyboard.isDown("space") or love.mouse.isDown(1)) then 
            self.press = true
            self.yvec = self.yvec * self.stop + self.speedup
            if (self.stop == 0) then
                self.rotate = -0.8
            end
            if (not (self.yvec == 0)) then
                love.audio.newSource("/audio/wing.ogg", "static"):play()
            end
        end
    elseif (not love.keyboard.isDown('space') and not love.mouse.isDown(1)) then
        self.press = false
    end
    if (self.rotate < 1) then
        self.rotate = self.rotate + 0.05
    end
    self.y = self.y + self.yvec
end

function Bird:collide(pipes, count) -- проверка столкновений
    -- с потолком и полом
    if (self.y + self.translate_y < 0 or self.y - self.translate_y > self.floor) then
        self:stop_bird()
        return true
    end
    -- с каждой из труб
    for i = 0, #pipes.pipes do
        pipe = pipes.pipes[i]
        -- Если птичка стукнулась об трубу
        if (self.x > pipe.x and self.x < pipe.x + pipe.width) then
            if self.y + self.translate_y < pipe.y + self.translate_y*10 or self.y - self.translate_y > pipe.y then
                self:stop_bird()
                return true
            end
        -- если пролетели через трубу
        elseif (self.x > pipe.x + pipe.width and pipe.finish == 0) then
            pipe.finish = 1
            self.score = self.score + 1
            love.audio.newSource("/audio/point.ogg", "static"):play()
        end
    end
    return false
end

function Bird:stop_bird() -- остановка основной физики птицы при окончании игры
    if (self.yvec < 0) then
        self.yvec = 0
    end
    self.speedup = 0
    self.stop = 1
    if (not self.die) then
        self.die = true
        if (self.y - self.translate_y < self.floor) then
            love.audio.newSource("/audio/die.ogg", "static"):play()
        end
    end
end

function Bird:scoredraw()
    CW = self.score
    if CW < 10 then
        love.graphics.draw(self.numbers[CW], self.screen_width/2-self.numwidth/2, 10)
    else
        numers = {}
        counter = 0
        while CW > 0 do
            numers[counter] = math.floor(CW%10)
            CW = (CW - CW%10)/10
            counter = counter + 1
        end
        for i = 0, #numers do
            love.graphics.draw(self.numbers[numers[i]], self.screen_width/2 - self.numwidth * i, 10)
        end
    end
end