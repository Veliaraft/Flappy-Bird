local FPS_L = 300
return {
run = function()

    if love.math then
        love.math.setRandomSeed(os.time())
    end

    if love.event then
        love.event.pump()
    end

    if love.load then love.load(arg) end
    if love.timer then love.timer.step() end

    local dt = 0

    -- Main loop time.
    while true do
        local m1 = love.timer.getTime( )
        if love.event then
            love.event.pump()
            for e,a,b,c,d in love.event.poll() do
                if e == "quit" then
                    if not love.quit or not love.quit() then
                        if love.audio then
                            love.audio.stop()
                        end
                        return
                    end
                end
                love.handlers[e](a,b,c,d)
            end
        end

        if love.timer then
            love.timer.step()
            dt = love.timer.getDelta()
        end

        -- Call update and draw
        if love.update then love.update(dt) end

        if love.window and love.graphics and love.window.isVisible() then
            love.graphics.clear()
            love.graphics.origin()
            if love.draw then love.draw() end
            love.graphics.present()
        end
	local delta1 = love.timer.getTime() - m1
        if love.timer then love.timer.sleep(1/FPS_L-delta1) end
    end

end,
set = function(newlimit)
	FPS_L = newlimit
end
}