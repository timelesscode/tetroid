local Enemy = {}
Enemy.list = {}
local enemyImage

function Enemy.load()
    enemyImage = love.graphics.newImage("enemy.png")
end

function Enemy.spawn()
    table.insert(Enemy.list, {
        x = math.random(0, love.graphics.getWidth() - enemyImage:getWidth()),
        y = -enemyImage:getHeight(),
        width = enemyImage:getWidth(),
        height = enemyImage:getHeight(),
        speed = 100,
        image = enemyImage,
    })
end

function Enemy.update(dt)
    for i = #Enemy.list, 1, -1 do
        local enemy = Enemy.list[i]
        enemy.y = enemy.y + enemy.speed * dt
        if enemy.y > love.graphics.getHeight() then
            table.remove(Enemy.list, i)
        end
    end
end

function Enemy.draw()
    for _, enemy in ipairs(Enemy.list) do
        love.graphics.draw(enemy.image, enemy.x, enemy.y)
    end
end
return Enemy