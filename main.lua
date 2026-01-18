_G.playerX = 0
_G.playerY = 0
_G.playerSize = 50
_G.playerSpeed = 200 -- pixels per second


function love.load()
    love.graphics.setBackgroundColor(0.1,0.1,0.1)

    local width, height = love.window.getMode()
    playerX = width / 2
    playerY = height / 2
end

function love.update(dt)
    local dx, dy = 0, 0 -- movement base vectors

    if love.keyboard.isDown("w") then
        dy = dy - 1
    end

    if love.keyboard.isDown("s") then
        dy = dy + 1
    end

    if love.keyboard.isDown("a") then
        dx = dx - 1
    end

    if love.keyboard.isDown("d") then
        dx = dx + 1
    end

    -- normalize diagonal movement, 
    move_vector = math.sqrt((dx*dx)+ (dy*dy))
    if move_vector > 0 then
        dx = dx/move_vector
        dy = dy/move_vector
    end

    playerX = playerX + (dx*playerSpeed*dt)
    playerY = playerY + (dy*playerSpeed*dt)
end

function love.draw()
    -- calculate top-left position for drawing sprite
    -- coordinate - size/2
    local drawX = playerX - (playerSize/2)
    local drawY = playerY - (playerSize/2)

    love.graphics.rectangle("fill", drawX, drawY, playerSize, playerSize)
    love.graphics.print("Step 2: Game loop running", 10, 10)
end