-- main.lua
local Game = require("game.game")
local Input = require("game.input")

function love.load()
    Game.load()
end

function love.update(dt)
    Game.update(dt)
end

function love.draw()
    Game.draw()
end

function love.mousepressed(x, y, button)
    Input.mousepressed(Game, x, y, button)
end

function love.keypressed(key)
    Input.keypressed(Game, key)
end