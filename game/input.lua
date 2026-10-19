-- game/input.lua
local Input = {}

function Input.getMoveInput()
    local dx, dy = 0, 0

    if love.keyboard.isDown("w") then dy = dy - 1 end
    if love.keyboard.isDown("s") then dy = dy + 1 end
    if love.keyboard.isDown("a") then dx = dx - 1 end
    if love.keyboard.isDown("d") then dx = dx + 1 end

    return dx, dy
end

function Input.mousepressed(Game, x, y, button)
    if button == 1 then
        Game.spawnBullet(x, y)
    end
end

function Input.keypressed(Game, key)
    if key == "r" and not Game.Player.isAlive then
        Game.restart()
    end
end

return Input