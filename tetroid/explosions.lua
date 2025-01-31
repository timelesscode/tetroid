local Explosion = {}
local particleSystems = {}
local explosionImage

function Explosion.load()
    explosionImage = love.graphics.newImage("explosion.png")
end

function Explosion.create(x, y)
    local ps = love.graphics.newParticleSystem(explosionImage, 100)
    ps:setParticleLifetime(1, 1)
    ps:setEmissionRate(100)
    ps:setSizeVariation(1)
    ps:setLinearAcceleration(-200, -200, 200, 200)
    ps:setColors(1, 1, 0, 1, 1, 0.5, 0, 1) -- Yellow to Orange

    ps:setPosition(x, y)
    ps:emit(50)
    table.insert(particleSystems, ps)
end

function Explosion.update(dt)
    for i = #particleSystems, 1, -1 do
        local ps = particleSystems[i]
        ps:update(dt)
        if ps:getCount() == 0 then
            table.remove(particleSystems, i)
        end
    end
end

function Explosion.draw()
    for _, ps in ipairs(particleSystems) do
        love.graphics.draw(ps, 0, 0)
    end
end
return Explosion