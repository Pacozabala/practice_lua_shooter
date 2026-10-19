-- utils/collision.lua
local Collision = {}

function Collision.circleCircle(a, b)
    local dx = a.x - b.x
    local dy = a.y - b.y

    local radius = a.size + b.size

    return dx * dx + dy * dy < radius * radius
end

local function clamp(value, min, max)
    return math.max(min, math.min(value, max))
end

function Collision.rectCircle(rect, circle)
    local closestX = clamp(
        circle.x, rect.x, rect.x + rect.w
    )

    local closestY = clamp(
        circle.y, rect.y, rect.y + rect.h
    )

    local dx = circle.x - closestX
    local dy = circle.y - closestY

    return dx * dx + dy * dy < circle.size * circle.size
end

return Collision