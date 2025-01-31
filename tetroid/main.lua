-- Load required modules
local Background = require("background")
local Player = require("player")
local Bullet = require("bullet")
local Enemy = require("enemy")
local Explosion = require("explosions")

-- Load game assets
function love.load()
    Background.load()
    Player.load()
    Bullet.load()
    Enemy.load()
    Explosion.load()
end

-- Update game logic
function love.update(dt)
    Background.update(dt)
    Player.update(dt)
    Bullet.update(dt)
    Enemy.update(dt)
    Explosion.update(dt)
end

-- Draw everything
function love.draw()
    Background.draw()
    Player.draw()
    Bullet.draw()
    Enemy.draw()
    Explosion.draw()
end

-- Handle keypresses
function love.keypressed(key)
    Player.keypressed(key)
end
