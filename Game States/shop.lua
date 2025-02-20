local love = require("love")

function Shop(player)
    return {
        draw = function(self)
            love.graphics.print("Shop", 0, 0)
        end,
    }
end

return Shop