local love = require("love")
local Button = require("Components.button")

local Dialog = {}

local width, height = love.graphics.getDimensions()
width = math.floor(width / 3)
local dialogWindow = love.graphics.newImage("Assets/UI/dialog.png")
local dialogDimX, dialogDimY = dialogWindow:getDimensions()
local dialogX = (width - dialogDimX * 0.1) / 2
local dialogY = (height - dialogDimY * 0.2) / 2
Dialog.__index = Dialog

local align = function (Bwidth, Dwidth)
    return (Dwidth * 0.1 - (Bwidth * 0.1 * 2)) / 3
end

function Dialog:New()
    local obj = {
        text = "",
        buttons = {},
        dialogShowing = false
    }

    setmetatable(obj, Dialog)

    return obj
end

function Dialog:SelectDialog(dialogname)
    self.dialogShowing = true
    local button = love.graphics.newImage("Assets/UI/text.png")
    local dimx = button:getWidth()
    local dimy = button:getHeight()
    local space = align(button:getWidth(), dialogDimX)
    if dialogname == "createEquipment" then
        self.text = "Would you like to keep this equipemt?"
        self.buttons = {
            yes = Button(function() self.dialogShowing = false end, dialogX + space, dialogY + dialogDimY * 0.2 - 4 * space, "Confirm", "Assets/UI/text.png", dimx,  dimy, 0.1),
            no = Button(function() self.dialogShowing = false end, dialogX + dimx * 0.1 + 2 * space, dialogY + dialogDimY * 0.2 - 4 * space, "Reject", "Assets/UI/text.png", dimx, dimy, 0.1)
        }
    end
end

function Dialog:State()
    return self.dialogShowing
end

function Dialog:Update()
    for _, button in pairs(self.buttons) do
        button:checkHover(love.mouse.getPosition())
    end
end

function Dialog:Draw()
    love.graphics.draw(dialogWindow, dialogX, dialogY, 0, 0.1, 0.2)
    love.graphics.setColor(0, 0, 0)
    love.graphics.print(self.text, dialogX + 25, dialogY + 40)
    love.graphics.setColor(1, 1, 1)
    for _, button in pairs(self.buttons) do
        button:draw()
    end
end

return Dialog