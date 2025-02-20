local love = require("love")

function love.conf(app)
    app.window.title = "My Game"
    app.window.width = 0
    app.window.height = 0
    app.window.resizable = false
end