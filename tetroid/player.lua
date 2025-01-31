Player = {}
local Bullet = require("bullet")  -- Make sure this path matches your file structure

local playerImage
local player = {}

function Player.load()
    playerImage = love.graphics.newImage("player.png")
    player = {
        x = love.graphics.getWidth() / 2 - playerImage:getWidth() / 2,
        y = love.graphics.getHeight() - playerImage:getHeight() - 10,
        width = playerImage:getWidth(),
        height = playerImage:getHeight(),
        speed = 300,
        image = playerImage,
        shootCooldown = 0.25,  -- Time between shots in seconds
        currentCooldown = 0    -- Current cooldown timer
    }
end

function Player.update(dt)
    -- Horizontal movement
    if love.keyboard.isDown('left', 'a') then
        player.x = math.max(0, player.x - player.speed * dt)
    end
    if love.keyboard.isDown('right', 'd') then
        player.x = math.min(love.graphics.getWidth() - player.width, 
                          player.x + player.speed * dt)
    end

    -- Vertical movement (optional, comment out if you don't want vertical movement)
    if love.keyboard.isDown('up', 'w') then
        player.y = math.max(0, player.y - player.speed * dt)
    end
    if love.keyboard.isDown('down', 's') then
        player.y = math.min(love.graphics.getHeight() - player.height, 
                          player.y + player.speed * dt)
    end

    -- Update shooting cooldown
    if player.currentCooldown > 0 then
        player.currentCooldown = player.currentCooldown - dt
    end

    -- Auto-shooting when space is held (optional)
    if love.keyboard.isDown('space') and player.currentCooldown <= 0 then
        Bullet.fire()
        player.currentCooldown = player.shootCooldown
    end
end

function Player.draw()
    love.graphics.draw(player.image, player.x, player.y)
    
    -- Optional: Draw debug hitbox
    -- love.graphics.rectangle('line', player.x, player.y, player.width, player.height)
end

function Player.keypressed(key)
    if key == "space" then
        if player.currentCooldown <= 0 then
            Bullet.fire()
            player.currentCooldown = player.shootCooldown
        end
    end
end

-- Getter functions for other modules to access player properties
function Player.getX()
    return player.x
end

function Player.getY()
    return player.y
end

function Player.getWidth()
    return player.width
end

function Player.getHeight()
    return player.height
end

-- Function to check if player collides with another entity
function Player.checkCollision(entity)
    return player.x < entity.x + entity.width and
           player.x + player.width > entity.x and
           player.y < entity.y + entity.height and
           player.y + player.height > entity.y
end

--return Player