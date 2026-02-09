local Collision = {}

function Collision.radial(a,b)
    local dx = a.x - b.x
    local dy = a.y - b.y
    local distance = math.sqrt(dx*dx + dy*dy)

    return distance < (a.size + b.size)
end

function Collision.borderClamp(value, min, max)
    -- clamp center to other shape's bounds

    return math.max(min, math.min(value, max))
end

function Collision.rectCircle(rect, circle)
    -- use closest-point collision for rectangle-circle

    -- clamp circle center to box bounds
    local closestX = Collision.borderClamp(circle.x, rect.x, rect.x + rect.w)
    local closestY = Collision.borderClamp(circle.y, rect.y, rect.y + rect.h)

    local dx = circle.x - closestX
    local dy = circle.y - closestY

    return (dx*dx + dy*dy) < (circle.size * circle.size)
    
end

return Collision