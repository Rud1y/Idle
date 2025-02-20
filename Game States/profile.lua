local love = require("love")

function Profile(player)
    return {
        draw = function(self)
            love.graphics.print("Profile", 0, 0)
        end
    }
end

return Profile