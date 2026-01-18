_G.playerX = 0
_G.playerY = 0
_G.playerSize = 50
_G.playerSpeed = 200 -- pixels per second


function love.load()
    love.graphics.setBackgroundColor(0.1,0.1,0.1)

    local width, height = love.window.getMode()
    _G.playerX = width / 2
    _G.playerY = height / 2
end

function love.update(dt)
    local dx, dy = 0, 0 -- movement base vectors

    if love.keyboard.isDown("w") then dy = dy - 1 end

    if love.keyboard.isDown("s") then dy = dy + 1 end

    if love.keyboard.isDown("a") then dx = dx - 1 end

    if love.keyboard.isDown("d") then dx = dx + 1 end

    _G.playerX, _G.playerY = normalize_movement(dx, dy, dt)

    -- clamp player to screen
    local width, height = love.window.getMode()
    local half = playerSize/2
end

function love.draw()
    -- calculate top-left position for drawing sprite
    -- coordinate - size/2
    local drawX = playerX - (playerSize/2)
    local drawY = playerY - (playerSize/2)

    love.graphics.rectangle("fill", drawX, drawY, playerSize, playerSize)
    love.graphics.print("Step 3: Player Movement", 10, 10)
end

function normalize_movement(dx, dy, dt)
    local dx, dy, dt = dx, dy, dt

    local move_vector = math.sqrt((dx*dx)+ (dy*dy))
    if move_vector > 0 then
        dx = dx/move_vector
        dy = dy/move_vector
    end

    local xPos = playerX + (dx*playerSpeed*dt)
    local yPos = playerY + (dy*playerSpeed*dt)

    return xPos, yPos
end