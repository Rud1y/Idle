local love = require("love")

function Tower(player)
    return {
        draw = function(self)
            love.graphics.print("Tower", 0, 0)
        end,
    }
end

return Tower