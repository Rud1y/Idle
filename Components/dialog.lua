local love = require("love")
local Button = require("Components.button")

local Dialog = {}

local width, height = love.window.getDesktopDimensions()
width = math.floor(width / 3)
local dialogWindow = love.graphics.newImage("Assets/UI/dialog.png")
local dialogDimX, dialogDimY = dialogWindow:getDimensions()
local dialogX = (width - dialogDimX * 0.1) / 2
local dialogY = (height - dialogDimY * 0.2) / 2

Dialog.__index = Dialog

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
    local dimx = love.graphics.getWidth(love.graphics.newImage("Assets/UI/text.png"))
    local dimy = love.graphics.getHeight(love.graphics.newImage("Assets/UI/text.png"))
    print(dimx .. " " .. dimy)
    if dialogname == "createEquipment" then
        self.text = "Would you like to keep this equipemt?"
        self.buttons = {
            yes = Button(function() self.dialogShowing = false end, dialogX + 25, dialogY + dialogDimY * 0.12, "Confirm", "Assets/UI/text.png", 512,  834),
            no = Button(function() self.dialogShowing = false end, dialogX + 150, dialogY + dialogDimY * 0.12, "Reject", "Assets/UI/text.png", 512, 834)
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