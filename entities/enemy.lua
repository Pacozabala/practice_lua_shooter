local Enemy = {
    speed = 120,
    radius = 18,
}

function Enemy.new(x, y)
    return {
        x = x,
        y = y
    }
end

function Enemy.update(enemy, playerX, playerY, dt)
    local dx = playerX - enemy.x
    local dy = playerY - enemy.y

    local move_vector = math.sqrt((dx*dx) + (dy*dy))
    if move_vector > 0 then
        dx = dx/move_vector
        dy = dy/move_vector
    end

    enemy.x = enemy.x + (dx*Enemy.speed*dt)
    enemy.y = enemy.y + (dy*Enemy.speed*dt)
end

function Enemy.draw(enemy)
    love.graphics.circle("fill", enemy.x, enemy.y, Enemy.radius)
end

return Enemy