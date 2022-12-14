require ("Ground")
require ("Background")
require ("Bird")
require ("PipeController")

SCREEN_WIDTH, SCREEN_HEIGHT = love.graphics.getWidth(), love.graphics.getHeight()
math.randomseed(os.clock())
max_fps = 1/60
speed = 2
-- красивая музычка чтобы чисто почиллить
snd = love.audio.newSource("/audio/Hoogway-Missing Earth.mp3", "static")
snd:play()
-- ограничитель кадров
frame_limiter =require("frame_limiter")
frame_limiter.set(60)


function love.load()
    local ground = Ground:create(speed)
    local back = Background:Create(SCREEN_WIDTH, SCREEN_HEIGHT, speed/10)
    local bird = Bird:new(SCREEN_HEIGHT, SCREEN_WIDTH, ground.y)
    local pc = PipeController:new(SCREEN_WIDTH, ground.y)
    local gameover = 0
    local stop = false
    local play = false

end

function love.update(dt)
    if (love.keyboard.isDown("escape")) then
        love.quit()
    end
    if not snd:isPlaying() then
        snd:play()
    end
    if (love.keyboard.isDown("space") or love.mouse.isDown(1)) then
        play = true
        bird:start_play()
        if stop == true and bird.gravity == 0 then
            love.load()
        end
    end
    bird:update()
    stop = bird:collide(pc)

    if not stop then
        ground:update()
        back:Update(dt)
        if (play) then
            pc:update(speed)
        end
    end
end

function love.draw(dt)
    back:Draw()
    pc:draw(bird.translate_y * 10, 300)
    ground:draw()
    gameover = bird:draw()
    if (not play) then
        love.graphics.print("Space or Mouse Click for jump", SCREEN_WIDTH / 2 - 100, SCREEN_HEIGHT/2)
    end
    love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)
end

frame_limiter.run()