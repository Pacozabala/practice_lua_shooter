_G.playerX = 100
_G.playerY = 100

function love.load()
    love.graphics.setBackgroundColor(0.1,0.1,0.1)
end

function love.update(dt)
    
end

function love.draw()
    love.graphics.rectangle("fill",playerX,playerY,50,50)
    love.graphics.print("Step 2: Game loop running", 10, 10)
end