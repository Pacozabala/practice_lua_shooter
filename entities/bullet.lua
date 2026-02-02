local Bullet = {}

function Bullet.new(x, y, dx, dy)
    return {
        x = x,
        y = y,
        dx = dx,
        dy = dy,
        speed = 500,
        radius = 5
    }
end

function Bullet.update(bullet, dt)
    bullet.x = bullet.x + (bullet.dx*bullet.speed*dt)
    bullet.y = bullet.y + (bullet.dy*bullet.speed*dt)
end

function Bullet.draw(bullet)
    love.graphics.circle("fill", bullet.x, bullet.y, bullet.radius)
end

return Bullet