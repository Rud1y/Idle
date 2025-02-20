local love = require("love")

function Stable(player)
    return {
        draw = function(self)
            love.graphics.print("Stable", 0, 0)
        end
    }
end

return Stable