require ("Pipe")

PipeController = {}
PipeController.__index = PipeController

function PipeController:new(SCREEN_WIDTH, down_border)
    pc = {}
    setmetatable(pc, PipeController)
    pc.SW, pc.DB = SCREEN_WIDTH, down_border
    pc.pipes = {}
    -- создание труб
    for i = 0, 4 do
        pc.pipes[i] = Pipe:new(SCREEN_WIDTH, down_border)
        pc.pipes[i].x = pc.pipes[i].x + (pc.pipes[i].width * i) * 3.3
    end
    return pc
end

function PipeController:update(speed)
    -- если труба ушла за экран - заменяем новой. Смещение труб происходит в самих трубах.
    for i = 0, #self.pipes do
        if (not self.pipes[i]:update(speed)) then
            self.pipes[i] = Pipe:new(self.SW, self.DB)
        end
    end
end

function PipeController:draw(bird_height)
    for i = 0, #self.pipes do
        self.pipes[i]:draw(bird_height)
    end
end