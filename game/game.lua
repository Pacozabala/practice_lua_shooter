-- game/game.lua
local Player = require("entities.player")
local Bullet = require("entities.bullet")
local Enemy = require("entities.enemy")

local Input = require("game.input")
local Spawner = require("game.enemy_spawner")
local CollisionSystem = require("game.collision_system")
local UI = require("game.ui")

local Game = {}

Game.Player = Player
Game.bullets = {}
Game.enemies = {}

function Game.load()
    love.graphics.setBackgroundColor(0.1, 0.1, 0.1)

    local width, height = love.graphics.getDimensions()
    Player.init(width, height)

    Game.bullets = {}
    Game.enemies = {}

    Spawner.reset()
end

function Game.update(dt)
    if not Player.isAlive then
        return
    end

    -- Update player movement.
    local dx, dy = Input.getMoveInput()
    Player.update(dx, dy, dt)

    -- Update existing bullets.
    Game.updateBullets(dt)

    -- Spawn and update enemies.
    Spawner.update(Game.enemies, dt)
    Game.updateEnemies(dt)

    -- Resolve collisions after movement.
    CollisionSystem.handleBulletEnemy(
        Game.bullets,
        Game.enemies
    )

    CollisionSystem.handlePlayerEnemy(
        Player,
        Game.enemies
    )
end

function Game.draw()
    Player.draw()

    for _, bullet in ipairs(Game.bullets) do
        Bullet.draw(bullet)
    end

    for _, enemy in ipairs(Game.enemies) do
        Enemy.draw(enemy)
    end

    UI.draw(Player)
end

function Game.spawnBullet(mouseX, mouseY)
    local dx = mouseX - Player.x
    local dy = mouseY - Player.y

    local length = math.sqrt(dx * dx + dy * dy)

    if length == 0 then
        return
    end

    dx = dx / length
    dy = dy / length

    local bullet = Bullet.new(
        Player.x, Player.y, dx, dy
    )

    table.insert(Game.bullets, bullet)
end

function Game.updateBullets(dt)
    local width, height = love.graphics.getDimensions()

    for i = #Game.bullets, 1, -1 do
        local bullet = Game.bullets[i]

        Bullet.update(bullet, dt)

        if bullet.x < 0 or bullet.x > width
        or bullet.y < 0 or bullet.y > height then
            table.remove(Game.bullets, i)
        end
    end
end

function Game.updateEnemies(dt)
    for _, enemy in ipairs(Game.enemies) do
        Enemy.update(enemy, Player.x, Player.y, dt)
    end
end

function Game.restart()
    local width, height = love.graphics.getDimensions()

    Game.bullets = {}
    Game.enemies = {}

    Spawner.reset()
    Player.init(width, height)
end

-- function Game.get_move_input()
--     local dx, dy = 0, 0 -- movement base vectors

--     if love.keyboard.isDown("w") then dy = dy - 1 end
--     if love.keyboard.isDown("s") then dy = dy + 1 end
--     if love.keyboard.isDown("a") then dx = dx - 1 end
--     if love.keyboard.isDown("d") then dx = dx + 1 end

--     return dx, dy
-- end

return Game