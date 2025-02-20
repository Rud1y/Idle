local love = require("love")

function Settings(player)
    return {
        draw = function(self)
            love.graphics.print("Settings", 0, 0)
            love.graphics.setBackgroundColor(1, 0, 0)
        end,
    }
end

return Settings