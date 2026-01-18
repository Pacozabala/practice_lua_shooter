-- spawn player at center
width, height = love.window.getMode()
playerX = width / 2
playerY = height / 2
playerSize = 50
playerSpriteX = playerX - playerSize
playerSpriteY = playerY - playerSize


function love.load()
    love.graphics.setBackgroundColor(0.1,0.1,0.1)
end

function love.update(dt)
    
end

function love.draw()
    love.graphics.rectangle("fill",playerSpriteX,playerSpriteY,playerSize,playerSize)
    love.graphics.print("Step 2: Game loop running", 10, 10)
end