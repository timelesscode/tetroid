local Background = {}

function Background.load()
    Background.layers = {
        { image = love.graphics.newImage("bg_far.jpg"), speed = 10 },
        { image = love.graphics.newImage("bg_middle.jpg"), speed = 30 },
        { image = love.graphics.newImage("bg_near.jpg"), speed = 60 }
    }
    
    Background.scrollX = 0
    Background.rotation = 0
end

function Background.update(dt)
    Background.scrollX = Background.scrollX + 100 * dt  -- Adjust speed as needed
    Background.rotation = Background.rotation + 0.02 * dt  -- Adjust rotation speed
end

function Background.draw()
    for _, bg in ipairs(Background.layers) do
        local x = -(Background.scrollX * bg.speed * 0.01) % bg.image:getWidth()
        local ox, oy = bg.image:getWidth() / 2, bg.image:getHeight() / 2
        love.graphics.draw(bg.image, x + ox, oy, Background.rotation, 1, 1, ox, oy)
        love.graphics.draw(bg.image, x + bg.image:getWidth() + ox, oy, Background.rotation, 1, 1, ox, oy)
    end
end

return Background  -- This is necessary to return the module table
