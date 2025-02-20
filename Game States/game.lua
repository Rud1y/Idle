---@diagnostic disable: lowercase-global

local love = require("love")
local Forge = require("Game States.forge")
local Campaign = require("Game States.campaign")
local Settings = require("Game States.settings")
local Shop = require("Game States.shop")
local Stable = require("Game States.stable")
local Tower = require("Game States.tower")
local Profile = require("Game States.profile")
local Button = require("Components.button")

function Game(player)
    return {
        state = {
            running = true,
            profile = false,
            forge = false,
            campaign = false,
            settings = false,
            shop = false,
            stable = false,
            tower = false,
            ended = false
        },

        current = "running",
        previous = "running",

        window = {
            width = love.graphics.getWidth(),
            height = love.graphics.getHeight()
        },

        buttons = {},

        Initialization = function(self, data)
            profile = Profile(player)
            forge = Forge(player)
            forge:Initialization(data)
            campaign = Campaign(player)
            settings = Settings(player)
            shop = Shop(player)
            stable = Stable(player)
            tower = Tower(player)

            self.buttons = {
                backbutton = Button(function() self:ChangeGameState(self.previous) end, 64, self.window["height"] - 64, "", "Assets/UI/back.png", 64, 64),
                exitbutton = Button(function() self:GameOver() end, 128, self.window["height"] - 64, "", "Assets/UI/exit.png", 64, 64),
                homebutton = Button(function () self:ChangeGameState("running") end, 192, self.window["height"] - 64, "", "Assets/UI/home.png", 64, 64),
                rewindebutton = Button(function() self:ChangeGameState("forge") end, 256, self.window["height"] - 64, "", "Assets/UI/rewinde.png", 64, 64),
                settingsbutton = Button(function() self:ChangeGameState("settings") end, 320, self.window["height"] - 64, "", "Assets/UI/settings.png", 64, 64)
            }
        end,

        ChangeGameState = function(self, state)
            if self.current ~= state then
                self.state.running = state == "running"
                self.state.profile = state == "profile"
                self.state.forge = state == "forge"
                self.state.campaign = state == "campaign"
                self.state.settings = state == "settings"
                self.state.shop = state == "shop"
                self.state.stable = state == "stable"
                self.state.tower = state == "tower"
                self.state.ended = state == "ended"
                love.graphics.print(state, 0, 48)

                self.previous = self.current
                self.current = state

                if self.state.ended then
                    self:GameOver()
                end

                player:SaveData()
            end
        end,

        GameOver = function(self)
            player:SaveData()
            forge:SaveData()
            love.window.close()
        end,

        Update = function(self)
            for _, button in pairs(self.buttons) do
                button:checkHover(love.mouse.getPosition())
            end
        end,

        Draw = function(self)
            if self.state.running then
                love.graphics.print("Running", 0, 0)
                love.graphics.setBackgroundColor(0, 0, 0)
            elseif self.state.profile then
                profile:draw()
            elseif self.state.forge then
                forge:draw()
            elseif self.state.campaign then
                campaign:draw()
            elseif self.state.settings then
                settings:draw()
            elseif self.state.shop then
                shop:draw()
            elseif self.state.stable then
                stable:draw()
            elseif self.state.tower then
                tower:draw()
            end
            for _, button in pairs(self.buttons) do
                button:draw()
            end
        end
    }
end

return Game