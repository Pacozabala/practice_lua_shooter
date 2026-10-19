-- game/collision_system.lua
local Collision = require("utils.collision")

local CollisionSystem = {}

function CollisionSystem.handleBulletEnemy(bullets, enemies)
    for i = #bullets, 1, -1 do
        local bullet = bullets[i]

        for j = #enemies, 1, -1 do
            local enemy = enemies[j]

            if Collision.circleCircle(bullet, enemy) then
                table.remove(bullets, i)
                table.remove(enemies, j)
                break
            end
        end
    end
end

function CollisionSystem.handlePlayerEnemy(player, enemies)
    if not player.isAlive then
        return
    end

    local hitbox = player.getHitbox()

    for i = #enemies, 1, -1 do
        local enemy = enemies[i]

        if Collision.rectCircle(hitbox, enemy) then
            player.health = math.max(0, player.health - 20)
            table.remove(enemies, i)

            if player.health == 0 then
                player.isAlive = false
            end
        end
    end
end

return CollisionSystem