Player = require('entities.player')
Bullet = require("entities.bullet")
bullets = {}


function love.load()
    love.graphics.setBackgroundColor(0.1,0.1,0.1)

    local width, height = love.window.getMode()
    Player.init(width, height)
end

function love.update(dt)
    local dx, dy = get_move_input()

    Player.update(dx, dy, dt)

    update_bullets(dt)
end

function love.draw()
    -- calculate top-left position for drawing sprite
    -- coordinate - size/2
    Player.draw()

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