-- Initialize variables
local player, bullets, enemies, particleSystems, xp = nil, {}, {}, {}, 0
local bulletImage, enemyImage, explosionImage = nil, nil, nil
local enemySpawnTimer, enemySpawnInterval = 0, 2 -- Enemies spawn every 2 seconds

function love.load()
    -- Player setup
    player = {
        x = 100,
        y = love.graphics.getHeight() - 32 - 20, -- Position near bottom
        speed = 300,
        image = love.graphics.newImage("player.png"),
        width = 32,
        height = 32,
    }

    -- Load bullet and enemy images
    bulletImage = love.graphics.newImage("bullet.png")
    enemyImage = love.graphics.newImage("enemy.png")
    explosionImage = love.graphics.newImage("explosion.png")
    background = love.graphics.newImage("background.png")

    -- Initialize other variables
    bullets = {}
    enemies = {}
    particleSystems = {}
    xp = 0

    love.graphics.setBackgroundColor(0.1, 0.1, 0.1) -- Dark background
end

function love.update(dt)
    -- Handle player movement
    local moveX = 0
    if love.keyboard.isDown("left") then
        moveX = moveX - 1
    end
    if love.keyboard.isDown("right") then
        moveX = moveX + 1
    end
    player.x = player.x + moveX * player.speed * dt
    player.x = math.max(0, math.min(love.graphics.getWidth() - player.width, player.x))

    -- Update bullets
    for i = #bullets, 1, -1 do
        local bullet = bullets[i]
        bullet.y = bullet.y - bullet.speed * dt
        if bullet.y < -bullet.height then
            table.remove(bullets, i)
        end
    end

    -- Spawn enemies
    enemySpawnTimer = enemySpawnTimer + dt
    if enemySpawnTimer >= enemySpawnInterval then
        enemySpawnTimer = 0
        table.insert(enemies, {
            x = math.random(0, love.graphics.getWidth() - enemyImage:getWidth()),
            y = -enemyImage:getHeight(),
            width = enemyImage:getWidth(),
            height = enemyImage:getHeight(),
            speed = 100,
            image = enemyImage,
        })
    end

    -- Update enemies
    for i = #enemies, 1, -1 do
        local enemy = enemies[i]
        enemy.y = enemy.y + enemy.speed * dt
        if enemy.y > love.graphics.getHeight() then
            table.remove(enemies, i)
        end
    end

    -- Check for bullet-enemy collisions
    for i = #bullets, 1, -1 do
        for j = #enemies, 1, -1 do
            local bullet = bullets[i]
            local enemy = enemies[j]
            if checkCollision(bullet, enemy) then
                createExplosion(enemy.x + enemy.width / 2, enemy.y + enemy.height / 2)
                table.remove(bullets, i)
                table.remove(enemies, j)
                xp = xp + 10 -- Increase XP
                break
            end
        end
    end

    -- Update particle systems
    for i = #particleSystems, 1, -1 do
        local ps = particleSystems[i]
        ps:update(dt)
        if ps:getCount() == 0 then
            table.remove(particleSystems, i)
        end
    end
end

function love.draw()
    --draw BG
    love.graphics.draw(background)
    -- Draw player
    love.graphics.draw(player.image, player.x, player.y)

    -- Draw bullets
    for _, bullet in ipairs(bullets) do
        love.graphics.draw(bullet.image, bullet.x, bullet.y)
    end

    -- Draw enemies
    for _, enemy in ipairs(enemies) do
        love.graphics.draw(enemy.image, enemy.x, enemy.y)
    end

    -- Draw XP
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("XP: " .. xp, 10, 10)

    -- Draw particle systems
    for _, ps in ipairs(particleSystems) do
        love.graphics.draw(ps, 0, 0)
    end
end

-- Handle shooting with spacebar
function love.keypressed(key)
    if key == "space" then
        fireBullet()
    end
end

-- Fire a bullet
function fireBullet()
    table.insert(bullets, {
        x = player.x + player.width / 2 - bulletImage:getWidth() / 2,
        y = player.y - bulletImage:getHeight(),
        width = bulletImage:getWidth(),
        height = bulletImage:getHeight(),
        speed = 400,
        image = bulletImage,
    })
end

-- Check for collisions
function checkCollision(a, b)
    return a.x < b.x + b.width and
           a.x + a.width > b.x and
           a.y < b.y + b.height and
           a.y + a.height > b.y
end

-- Create explosion effect
function createExplosion(x, y)
    local ps = love.graphics.newParticleSystem(explosionImage, 100)
    ps:setParticleLifetime(0.5, 0.9)
    ps:setEmissionRate(100)
    ps:setSizeVariation(1)
    ps:setLinearAcceleration(-200, -200, 200, 200)

    -- Ensure all colors include RGBA values
    ps:setColors(
        1, 1, 0, 1,   -- Yellow (fully opaque)
        1, 0.5, 0, 0  -- Orange (fully transparent)
    )

    ps:setPosition(x, y)
    ps:emit(50)
    table.insert(particleSystems, ps)
end

