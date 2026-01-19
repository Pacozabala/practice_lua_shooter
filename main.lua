Bullet = require("entities.bullet")
bullets = {}

playerX = 0
playerY = 0
playerSize = 50
playerSpeed = 300 -- pixels per second


function love.load()
    love.graphics.setBackgroundColor(0.1,0.1,0.1)

    local width, height = love.window.getMode()
    playerX = width / 2
    playerY = height / 2
end

function love.update(dt)
    local dx, dy = get_move_input()

    move_player(dx, dy, dt)

    clamp_player()

    update_bullets(dt)
end

function love.draw()
    -- calculate top-left position for drawing sprite
    -- coordinate - size/2
    local drawX = playerX - (playerSize/2)
    local drawY = playerY - (playerSize/2)

    love.graphics.rectangle("fill", drawX, drawY, playerSize, playerSize)
    love.graphics.print("Step 4: Shooting Bullets", 10, 10)

    for _, bullet in ipairs(bullets) do
        Bullet.draw(bullet)
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

-- calculates movement vector and updates position
function move_player(dx, dy, dt)

    -- normalize the vector (dot product)
    local move_vector = math.sqrt((dx*dx)+ (dy*dy))
    if move_vector > 0 then
        dx = dx/move_vector
        dy = dy/move_vector
    end

    playerX = playerX + (dx*playerSpeed*dt)
    playerY = playerY + (dy*playerSpeed*dt)
end

-- clamp player to screen
function clamp_player()
    local width, height = love.window.getMode()
    local half = playerSize/2

    if playerX < half then playerX = half end
    if playerX > width - half then playerX = width - half end
    if playerY < half then playerY = half end
    if playerY > height - half then playerY = height - half end
end

-- detect mouse click
function love.mousepressed(x, y, button)
    if button == 1 then
        spawn_bullet(x, y)
    end
end

-- calculate bullet direction and spawn
function spawn_bullet(mouseX, mouseY)
    local dx = mouseX - playerX
    local dy = mouseY - playerY

    local shot_vector = math.sqrt((dx*dx)+(dy*dy))
    if shot_vector == 0 then return end

    dx = dx/shot_vector
    dy = dy/shot_vector

    local bullet = Bullet.new(playerX, playerY, dx, dy)
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