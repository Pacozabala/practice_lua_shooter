local Bullet = {}

Bullet.speed = 500
Bullet.radius = 5

function Bullet.new(x, y, dx, dy)
    return {
        x = x,
        y = y,
        dx = dx,
        dy = dy
    }
end

function Bullet.update(bullet, dt)
    bullet.x = bullet.x + (bullet.dx*Bullet.speed*dt)
    bullet.y = bullet.y + (bullet.dy*Bullet.speed*dt)
end

function Bullet.draw(bullet)
    love.graphics.circle("fill", bullet.x, bullet.y, Bullet.radius)
end

return Bullet