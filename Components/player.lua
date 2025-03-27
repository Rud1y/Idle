local love = require("love")
local Pet = require("Components.pet")
local Equipment = require("Components.equipment")
local Log = require("log")

local Player = {}

Player.__index = Player

function Player:New()
    local obj = {
        level = 1,
        primarystats = {
            hitpoints = 100,
            attack = 10,
            defense = 10,
            speed = 15
        },
        specialstats = {
            crit = 5,
            critdamage = 150,
            combo = 0,
            combochance = 0,
            croudcontrolimmunity = 0,
            damageovertimechance = 0
        },
        croudcontrol = {
            stun = 0,
            slow = 0,
            silence = 0,
            petrify = 0
        },
        skin = "",
        animations = {},
        currentanimation = nil,
        currentFrame = 1,
        animationSpeed = 0.1,
        timeElapsed = 0,

        pet = Pet(),

        equipment = {},
    }
    setmetatable(obj, Player)

    return obj
end

function Player:Initialization(playerInfo)
    self.level = playerInfo.level or 1
    self.primarystats = playerInfo.primarystats or {
        hitpoints = 100,
        attack = 10,
        defense = 10,
        speed = 15
    }
    self.specialstats = playerInfo.specialstats or {
        crit = 5,
        critdamage = 150,
        combo = 0,
        combochance = 0,
        croudcontrolimmunity = 0,
        damageovertimechance = 0
    }
    self.croudcontrol = playerInfo.croudcontrol or {
        stun = 0,
        slow = 0,
        silence = 0,
        petrify = 0
    }
    self.skin = playerInfo.skin or ""
    self.equipment = playerInfo.equipment or {}
    self.animations = {
        idle = { image = love.graphics.newImage("Assets/Player/IDLE.png"), numframes = 10, quads = {} },
        attack = { image = love.graphics.newImage("Assets/Player/ATTACK 1.png"), numframes = 7, quads = {} },
        hit = { image = love.graphics.newImage("Assets/Player/HURT.png"), numframes = 4, quads = {} },
    }
    self.currentanimation = "idle"
    local framewidth = self.animations.idle.image:getWidth() / self.animations.idle.numframes
    local frameheight = self.animations.idle.image:getHeight()

    for _, anim in pairs(self.animations) do
        for i = 1, anim.numframes do
            anim.quads[i] = love.graphics.newQuad((i - 1) * framewidth, 0, framewidth, frameheight,
                anim.image:getDimensions())
        end
    end

    local pet = Pet()
    pet:Initialization("common")
    self.pet = pet

---modify initialization logic

    for _, e in pairs(self.equipment) do
        for stat, value in pairs(e.primarystats) do
            self.primarystats[stat] = self.primarystats[stat] + value
        end
        for stat, value in pairs(e.specialstats) do
            if stat == "stun" or stat == "slow" or stat == "silence" or stat == "petrify" then
                if self.croudcontrol[stat] == nil then
                    self.croudcontrol[stat] = 0
                end
                self.croudcontrol[stat] = self.croudcontrol[stat] + value
            else
                if self.specialstats[stat] == nil then
                    self.specialstats[stat] = 0
                end
                self.specialstats[stat] = self.specialstats[stat] + value
            end
        end
    end
end

function Player:ChangeAnimation(animation)
    self.currentanimation = animation
    self.currentFrame = 1
end

function Player:Update(dt)
    self.timeElapsed = self.timeElapsed + dt
    if self.timeElapsed >= self.animationSpeed then
        self.currentFrame = self.currentFrame + 1
        if self.currentFrame > self.animations[self.currentanimation].numframes then
            if self.currentanimation == "attack" then
                self.currentanimation = "idle"
            end
            self.currentFrame = 1
        end
        self.timeElapsed = 0
    end
end

function Player:Draw()
    local anim = self.animations[self.currentanimation]
    love.graphics.draw(anim.image, anim.quads[self.currentFrame], 100, 100, 0, 3, 3)
    love.graphics.print("Player Level: " .. self.level, 10, 10)
    love.graphics.print("HP: " .. self.primarystats.hitpoints, 10, 30)
    love.graphics.print("Attack: " .. self.primarystats.attack, 10, 50)
    love.graphics.print("Defense: " .. self.primarystats.defense, 10, 70)
    love.graphics.print("Speed: " .. self.primarystats.speed, 10, 90)

    local yOffset = 110
    for stat, value in pairs(self.specialstats) do
        love.graphics.print(stat .. ": " .. value, 10, yOffset)
        yOffset = yOffset + 20
    end

    yOffset = yOffset + 10
    for stat, value in pairs(self.croudcontrol) do
        love.graphics.print(stat .. ": " .. value, 10, yOffset)
        yOffset = yOffset + 20
    end
    self.pet:Draw(190, 250)
end

function Player:RecalculationStats()
    print(#self.equipment)
    for _, e in pairs(self.equipment) do
        for stat, value in pairs(e.primarystats) do
            self.primarystats[stat] = self.primarystats[stat] + value
        end
        for stat, value in pairs(e.specialstats) do
            if stat == "stun" or stat == "slow" or stat == "silence" or stat == "petrify" then
                if self.croudcontrol[stat] == nil then
                    self.croudcontrol[stat] = 0
                end
                self.croudcontrol[stat] = self.croudcontrol[stat] + value
            else
                if self.specialstats[stat] == nil then
                    self.specialstats[stat] = 0
                end
                self.specialstats[stat] = self.specialstats[stat] + value
            end
        end
    end
end

function Player:toTable()
    return {
        level = self.level,
        primarystats = self.primarystats,
        specialstats = self.specialstats,
        croudcontrol = self.croudcontrol,
        skin = self.skin,
        equipment = self.equipment
    }
end

function Player:SaveData()
    table.remove(Log.playerData, 1)
    table.insert(Log.playerData, self:toTable())
    Log.SaveData("C:/Users/Raul/OneDrive/Documenti/GitHub/Idle/gameLog.json")
end

return Player