-- conf.lua
function love.conf(t)
    -- Window settings
    t.window.title = "Top-Down Shooter"
    t.window.width = 800
    t.window.height = 600
    t.window.resizable = false
    t.window.fullscreen = false
    t.window.vsync = true
    t.window.msaa = 0  -- anti-aliasing off for simplicity

    -- Console output (optional, useful for debugging on Windows)
    t.console = true

    -- Modules to enable/disable (leave most on for now)
    t.modules.audio = true
    t.modules.event = true
    t.modules.graphics = true
    t.modules.keyboard = true
    t.modules.mouse = true
    t.modules.timer = true
    t.modules.window = true

    -- Optional: pixel-perfect mode
    -- t.window.pixelperfect = true
end
