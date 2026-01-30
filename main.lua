Player = require('entities.player')
Bullet = require("entities.bullet")
bullets = {}

Enemy = require("entities.enemy")
enemies = {}
enemySpawnTimer = 0
enemySpawnInterval = 1.5 -- 1.5 secs


function love.load()
    love.graphics.setBackgroundColor(0.1,0.1,0.1)

    local width, height = love.window.getMode()
    Player.init(width, height)
end

function love.update(dt)
    local dx, dy = get_move_input()

    Player.update(dx, dy, dt)

    update_bullets(dt)

    enemySpawnTimer = enemySpawnTimer + dt
    if enemySpawnTimer >= enemySpawnInterval then
        spawn_enemy()
        enemySpawnTimer = 0
    end

    update_enemies(dt)
end

function love.draw()
    -- calculate top-left position for drawing sprite
    -- coordinate - size/2
    Player.draw()

    love.graphics.print("Step 5: Enemies", 10, 10)

    for _, bullet in ipairs(bullets) do
        Bullet.draw(bullet)
    end

    for _, enemy in ipairs(enemies) do
        Enemy.draw(enemy)
    end
end

-----------------------------------------
--- FUNCTIONS TO KEEP UPDATE LOOP CLEANER 
-----------------------------------------

-- gets keyboard inputs
function get_move_input()
    local dx, dy = 0, 0 -- movement base vectors

    if love.keyboard.isDown("w") then dy = dy - 1 end
    if love.keyboard.isDown("s") then dy = dy + 1 end
    if love.keyboard.isDown("a") then dx = dx - 1 end
    if love.keyboard.isDown("d") then dx = dx + 1 end

    return dx, dy
end

-- detect mouse click
function love.mousepressed(x, y, button)
    if button == 1 then
        spawn_bullet(x, y)
    end
end

-- calculate bullet direction and spawn
function spawn_bullet(mouseX, mouseY)
    local dx = mouseX - Player.x
    local dy = mouseY - Player.y

    local shot_vector = math.sqrt((dx*dx)+(dy*dy))
    if shot_vector == 0 then return end

    dx = dx/shot_vector
    dy = dy/shot_vector

    local bullet = Bullet.new(Player.x, Player.y, dx, dy)
    table.insert(bullets, bullet)
end

-- remove offscreen bullets
function update_bullets(dt)
    local width, height = love.window.getMode()

    for i = #bullets, 1, -1 do
        local b = bullets[i]

        Bullet.update(b, dt)

        if b.x < 0 or b.x > width or b.y < 0 or b.y > height then
            table.remove(bullets, i)
        end
    end
end

-- spawns enemies randomly at the side of the screen
function spawn_enemy()
    local width, height = love.window.getMode()
    local side = love.math.random(1,4)

    local x,y

    if side == 1 then       -- top
        x = love.math.random(0, width)
        y = -20
    end
    if side == 2 then       -- bottom
        x = love.math.random(0, width)
        y = height + 20
    end
    if side == 3 then       -- left
        x = -20
        y = love.math.random(0, height)
    end
    if side == 4 then       -- right
        x = 20
        y = love.math.random(0, height)
    end

    table.insert(enemies, Enemy.new(x,y))
end

function update_enemies(dt)
    for i = #enemies, 1, -1 do
        Enemy.update(enemies[i], Player.x, Player.y, dt)
    end
end