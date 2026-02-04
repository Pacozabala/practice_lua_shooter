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
    if not Player.isAlive then return end

    local dx, dy = get_move_input()

    Player.update(dx, dy, dt)

    update_bullets(dt)

    enemySpawnTimer = enemySpawnTimer + dt
    if enemySpawnTimer >= enemySpawnInterval then
        spawn_enemy()
        enemySpawnTimer = 0
    end

    update_enemies(dt)

    handle_bullet_enemy_collision()

    handle_player_enemy_collision()
end

function love.draw()
    Player.draw()

    love.graphics.print("Step 6b: Player-Enemy collision", 10, 10)

    for _, bullet in ipairs(bullets) do
        Bullet.draw(bullet)
    end

    for _, enemy in ipairs(enemies) do
        Enemy.draw(enemy)
    end

    -- health bar background
    love.graphics.setColor(0.3, 0.3, 0.3)
    love.graphics.rectangle("fill", 10, 30, 200, 20)
    
    -- health fill
    local healthRatio = Player.health/Player.maxHealth
    love.graphics.setColor(0.8, 0.2, 0.2)
    love.graphics.rectangle("fill", 10, 30, 200*healthRatio, 20)

    love.graphics.setColor(1,1,1)

    if not Player.isAlive then
        love.graphics.printf("GAME OVER\nPress R to restart.",
        0,
        love.graphics.getHeight()/2 - 20,
        love.graphics.getWidth(),
        "center")
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

function love.keypressed(key)
    if key == "r" and not Player.isAlive then
        restart_game()
    end
end

function restart_game()
    local width, height = love.window.getMode()

    bullets = {}
    enemies = {}
    enemySpawnTimer = 0
    Player.x = width/2
    Player.y = height/2
    Player.health = Player.maxHealth
    Player.isAlive = true
end

-- BULLET MANAGEMENT

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

-- ENEMY MANAGEMENT

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
        x = width + 20
        y = love.math.random(0, height)
    end

    table.insert(enemies, Enemy.new(x,y))
end

function update_enemies(dt)
    for i = #enemies, 1, -1 do
        Enemy.update(enemies[i], Player.x, Player.y, dt)
    end
end

-- COLLISION MANAGEMENT

function radial_collision(a,b)
    local dx = a.x - b.x
    local dy = a.y - b.y
    local distance = math.sqrt(dx*dx + dy*dy)

    return distance < (a.size + b.size)
end

function border_clamp(value, min, max)
    -- clamp center to other shape's bounds

    return math.max(min, math.min(value, max))
end

function rect_circle_collision(rect, circle)
    -- use closest-point collision for rectangle-circle

    -- clamp circle center to box bounds
    local closestX = border_clamp(circle.x, rect.x, rect.x + rect.w)
    local closestY = border_clamp(circle.y, rect.y, rect.y + rect.h)

    local dx = circle.x - closestX
    local dy = circle.y - closestY

    return (dx*dx + dy*dy) < (circle.size * circle.size)
    
end

function handle_bullet_enemy_collision()
    for i = #bullets, 1, -1 do
        local b = bullets[i]

        for j = #enemies, 1, -1 do
            local e = enemies[j]

            if radial_collision(b, e) then
                table.remove(bullets, i)
                table.remove(enemies, j)
                break --bullet despawns, stop checking
            end
        end
    end
end

function handle_player_enemy_collision()
    if not Player.isAlive then return end

    local hitbox = Player.getHitbox()

    for i = #enemies, 1, -1 do
        local e = enemies[i]

        if rect_circle_collision(hitbox, e) then
            Player.health = Player.health - 20
            table.remove(enemies, i)

            if Player.health <= 0 then
                Player.health = 0
                Player.isAlive = false
            end
        end
    end
end