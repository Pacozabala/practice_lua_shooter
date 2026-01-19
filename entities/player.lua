local Player = {}

Player.x = 0
Player.y = 0
Player.size = 50
Player.speed = 300

function Player.init(windowWidth, windowHeight)
    Player.x = windowWidth/2
    Player.y = windowHeight/2
end