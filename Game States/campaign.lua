local love = require("love")

function Campaign(player)
    return {
        draw = function(self)
            love.graphics.print("Campaign", 0, 0)
        end,
    }
end

return Campaign