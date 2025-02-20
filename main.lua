---@diagnostic disable: lowercase-global

local love = require("love")
local Game = require("Game States.game")
local Player = require("Components.player")
local Log = require("log")

function love.load()
    local os = love.system.getOS()
    local screenWidth, screenHeight = love.window.getDesktopDimensions()

    if os == "Windows" then
        local winWidth = math.floor(screenWidth / 3)
        local winHeight = screenHeight

        love.window.setMode(winWidth, winHeight - 30, { resizable = false })
        love.window.setPosition(screenWidth / 3, 30)
    elseif os == "Android" then
        love.window.setMode(screenWidth, screenHeight, { fullscreen = true })
    end
    local Data = Log.LoadData("gameLog.json")
    if Data then
        player = Player:New()
        player:Initialization(Data.player)
        game = Game(player)
        game:Initialization(Data.game)
    else
        print("no data")
    end
end

function love.update(dt)
    game:Update()
    player:Update(dt)
    if love.keyboard.isDown("escape") then
        game:ChangeGameState("ended")
    elseif love.keyboard.isDown("return") then
        player:ChangeAnimation("attack")
        player.equipment.pet:ChangeAnimation("attack")
    end
end

function love.draw()
    game:Draw()
    player:Draw()
end