-- game/ui.lua
local UI = {}

function UI.draw(player)
    -- Health bar background.
    love.graphics.setColor(0.3, 0.3, 0.3)
    love.graphics.rectangle("fill", 10, 30, 200, 20)

    -- Health fill.
    local ratio = player.health / player.maxHealth

    love.graphics.setColor(0.8, 0.2, 0.2)
    love.graphics.rectangle(
        "fill", 10, 30, 200 * ratio, 20
    )

    love.graphics.setColor(1, 1, 1)

    if not player.isAlive then
        love.graphics.printf(
            "GAME OVER\nPress R to restart.",
            0,
            love.graphics.getHeight() / 2 - 20,
            love.graphics.getWidth(),
            "center"
        )
    end
end

return UI