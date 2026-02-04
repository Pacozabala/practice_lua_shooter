local Player = {}

Player.x = 0
Player.y = 0
Player.size = 50
Player.speed = 300
Player.maxHealth = 100

Player.hitboxPadding = 8 -- inward border

function Player.init(windowWidth, windowHeight)
    Player.x = windowWidth/2
    Player.y = windowHeight/2

    Player.health = Player.maxHealth
    Player.isAlive = true
end

-- calculates movement vector and updates position
function Player.update(dx, dy, dt)
    -- normalize the vector (distance formula)
    local move_vector = math.sqrt((dx*dx)+ (dy*dy))
    if move_vector > 0 then
        dx = dx/move_vector
        dy = dy/move_vector
    end

    Player.x = Player.x + (dx*Player.speed*dt)
    Player.y = Player.y + (dy*Player.speed*dt)

    Player.clamp()
end

-- clamp player to screen
function Player.clamp()
    local width, height = love.window.getMode()
    local half = Player.size/2

    if Player.x < half then Player.x = half end
    if Player.x > width - half then Player.x = width - half end
    if Player.y < half then Player.y = half end
    if Player.y > height - half then Player.y = height - half end
end

function Player.draw()
    -- calculate top-left position for drawing sprite
    -- coordinate - size/2
    local drawX = Player.x - (Player.size/2)
    local drawY = Player.y - (Player.size/2)

    love.graphics.rectangle("fill", drawX, drawY, Player.size, Player.size)
end

function Player.getHitbox()
    local half = Player.size / 2
    local pad = Player.hitboxPadding

    return {
        x = Player.x - half + pad,
        y = Player.y - half + pad,
        w = Player.size - pad * 2,
        h = Player.size - pad * 2
    }
end

return Player