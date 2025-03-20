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
local owned = false

local align = function (Bwidth, Dwidth)
    return (Dwidth * 0.1 - (Bwidth * 0.1 * 2)) / 3
end

local printEquipment = function(e, x, y)
    local i = 0
    for equip in pairs(e.primarystats) do
        love.graphics.print(equip .. ": " .. e.primarystats[equip], x, y + 13 * i)
        i = i + 1
    end
    for equip in pairs(e.specialstats) do
        love.graphics.print(equip .. ": " .. e.specialstats[equip], x, y + 13 * i)
        i = i + 1
    end
end

function Dialog:New()
    local obj = {
        text = "",
        buttons = {},
        dialogShowing = false,
        newSkin = nil,
        currentSkin = nil,
    }

    setmetatable(obj, Dialog)

    return obj
end

function Dialog:SelectDialog(dialogname, bool, newSkin, currentSkin, forge)
    self.dialogShowing = true
    local confirm = false
    local button = love.graphics.newImage("Assets/UI/text.png")
    local dimx = button:getWidth()
    local dimy = button:getHeight()
    local space = align(button:getWidth(), dialogDimX)
    if dialogname == "createEquipment" then
        if bool then
            self.text = "Would you like to keep this equipemt?"
            self.currentSkin = currentSkin
            owned = true
        else
            self.text = "You don't own this equipment at the moment"
            owned = false
        end

        self.newSkin = newSkin

        self.buttons = {
            yes = Button(function() self.dialogShowing = false forge.confirm = true end, dialogX + space, dialogY + dialogDimY * 0.4 - 5 * space, "Confirm", "Assets/UI/text.png", dimx,  dimy, 0.1),
            no = Button(function() self.dialogShowing = false forge.confirm = false end, dialogX + dimx * 0.1 + 2 * space, dialogY + dialogDimY * 0.4 - 5 * space, "Reject", "Assets/UI/text.png", dimx, dimy, 0.1)
        }
    end

    return confirm
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
    love.graphics.draw(dialogWindow, dialogX, dialogY, 0, 0.1, 0.4)
    love.graphics.setColor(0, 0, 0)
    love.graphics.printf(self.text, dialogX + 25, dialogY + 80, dialogX * 2, "center")
    local newSkin = love.graphics.newImage(self.newSkin.skin)
    local Swidth = love.graphics.getWidth(newSkin)
    local space = align(Swidth, dialogDimX)

    if owned then
        local currentSkin = love.graphics.newImage(self.currentSkin.skin)
        love.graphics.print("Old Equipment", dialogX + space * 0.5, dialogY + dialogDimY * 0.4 - 4.5 * space)
        love.graphics.print("New Equipment", dialogX + 2.5 * space, dialogY + dialogDimY * 0.4 - 4.5 * space)
        printEquipment(self.currentSkin, dialogX + 0.5 * space, dialogY + dialogDimY * 0.4 - 3.5 * space)
        printEquipment(self.newSkin, dialogX + 2.5 * space, dialogY + dialogDimY * 0.4 - 3.5 * space)
        love.graphics.setColor(self.currentSkin.background["red"], self.currentSkin.background["green"], self.currentSkin.background["blue"])
        love.graphics.rectangle("fill", dialogX + space, dialogY + dialogDimY * 0.4 - 4.25 * space, 32, 32)
        love.graphics.setColor(self.newSkin.background["red"], self.newSkin.background["green"], self.newSkin.background["blue"])
        love.graphics.rectangle("fill", dialogX + Swidth * 0.1 + 2 * space, dialogY + dialogDimY * 0.4 - 4.25 * space, 32, 32)
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(currentSkin, dialogX + space, dialogY + dialogDimY * 0.4 - 4.25 * space, 0, 2)
        love.graphics.draw(newSkin, dialogX + Swidth * 0.1 + 2 * space, dialogY + dialogDimY * 0.4 - 4.25 * space, 0, 2)
    else
        love.graphics.print("New Equipment", dialogX + 1.5 * space, dialogY + dialogDimY * 0.4 - 4.5 * space)
        printEquipment(self.newSkin, dialogX + 1.5 * space, dialogY + dialogDimY * 0.4 - 3.5 * space)
        love.graphics.setColor(self.newSkin.background["red"], self.newSkin.background["green"], self.newSkin.background["blue"])
        love.graphics.rectangle("fill", dialogX + 2 * space, dialogY + dialogDimY * 0.4 - 4.25 * space, 32, 32)
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(newSkin, dialogX + 2 * space, dialogY + dialogDimY * 0.4 - 4.25 * space, 0, 2)
    end

    for _, button in pairs(self.buttons) do
        button:draw()
    end
end

return Dialog