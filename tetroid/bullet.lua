local Bullet = {}  -- Make this local
local bullets = {}
local bulletImage

function Bullet.load()
    bulletImage = love.graphics.newImage("bullet.png")
end

function Bullet.fire()
    table.insert(bullets, {
        x = Player.x + Player.width / 2 - bulletImage:getWidth() / 2,
        y = Player.y - bulletImage:getHeight(),
        width = bulletImage:getWidth(),
        height = bulletImage:getHeight(),
        speed = 400,
        image = bulletImage,
    })
end

function Bullet.update(dt)
    for i = #bullets, 1, -1 do
        bullets[i].y = bullets[i].y - bullets[i].speed * dt
        if bullets[i].y < -bullets[i].height then
            table.remove(bullets, i)
        end
    end
end

function Bullet.draw()
    for _, bullet in ipairs(bullets) do
        love.graphics.draw(bullet.image, bullet.x, bullet.y)
    end
end

function Bullet.checkCollisions()
    for i = #bullets, 1, -1 do
        for j = #Enemy.list, 1, -1 do
            local bullet = bullets[i]
            local enemy = Enemy.list[j]
            if checkCollision(bullet, enemy) then
                Explosion.create(enemy.x + enemy.width / 2, enemy.y + enemy.height / 2)
                table.remove(bullets, i)
                table.remove(Enemy.list, j)
                xp = xp + 10
                break
            end
        end
    end
end

return Bullet  -- Add this line to return the module