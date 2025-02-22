local love = require("love")
local Button = require("Components.button")

local Dialog = {}

Dialog.__index = Dialog

function Dialog:New()
    local obj = {
        text = "",
        buttons = {}
    }

    setmetatable(obj, Dialog)

    return obj
end

function Dialog:SelectDialog(dialogname, object)
    if dialogname == "createEquipment" then
        self.buttons = {
            yes = Button()
        }
    end
end

return Dialog