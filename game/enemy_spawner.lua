-- game/enemy_spawner.lua
local Enemy = require("entities.enemy")

local Spawner = {}

Spawner.timer = 0
Spawner.interval = 1.5

function Spawner.reset()
    Spawner.timer = 0
end

function Spawner.update(enemies, dt)
    Spawner.timer = Spawner.timer + dt

    if Spawner.timer >= Spawner.interval then
        Spawner.spawn(enemies)
        Spawner.timer = Spawner.timer - Spawner.interval
    end
end

function Spawner.spawn(enemies)
    local width, height = love.graphics.getDimensions()
    local side = love.math.random(1, 4)

    local x, y

    if side == 1 then
        x = love.math.random(0, width)
        y = -20
    elseif side == 2 then
        x = love.math.random(0, width)
        y = height + 20
    elseif side == 3 then
        x = -20
        y = love.math.random(0, height)
    else
        x = width + 20
        y = love.math.random(0, height)
    end

    table.insert(enemies, Enemy.new(x, y))
end

return Spawner