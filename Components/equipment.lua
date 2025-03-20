local love = require("love")
local Equipment = {}

Equipment.__index = Equipment

function Equipment:New(name, playerlevel)
    local POLYNOMIAL_GROWTH = 1 + (playerlevel ^ 0.6) / 4

    local obj = {
        statscaling = 1,
        primarystats = {
            hitpoints = math.floor(love.math.random(20, 100) * POLYNOMIAL_GROWTH),
            attack = math.floor(love.math.random(5, 20) * POLYNOMIAL_GROWTH),
            defense = math.floor(love.math.random(5, 10) * POLYNOMIAL_GROWTH),
            speed = math.floor(love.math.random(5, 15) * POLYNOMIAL_GROWTH)
        },
        rarity = "common",
        specialstatscount = 0,
        specialstats = {},
        skin = "",
        type = name,
        background = {
            red = 1,
            green = 1,
            blue = 1
        }
    }

    setmetatable(obj, Equipment)

    return obj
end

function Equipment:Initialization(rarity)
    self.rarity = rarity or self.rarity
    if self.rarity == "common" then
        self.specialstatscount = 0
        self.background["red"] = 124 / 255
        self.background["green"] = 132 / 255
        self.background["blue"] = 145 / 255
    elseif self.rarity == "uncommon" then
        self.specialstatscount = 1
        self.statscaling = 1.5
        self.background["red"] = 40 / 255
        self.background["green"] = 209 / 255
        self.background["blue"] = 54 / 255
    elseif self.rarity == "rare" then
        self.specialstatscount = 1
        self.statscaling = 2.2
        self.background["red"] = 40 / 255
        self.background["green"] = 54 / 255
        self.background["blue"] = 209 / 255
    elseif self.rarity == "epic" then
        self.specialstatscount = 2
        self.statscaling = 3.1
        self.background["red"] = 150 / 255
        self.background["green"] = 13 / 255
        self.background["blue"] = 209 / 255
    elseif self.rarity == "legendary" then
        self.specialstatscount = 3
        self.statscaling = 4.5
        self.background["red"] = 237 / 255
        self.background["green"] = 213 / 255
        self.background["blue"] = 28 / 255
    end

    local stats = {
        "dodge", "block", "crit", "critdamage",
        "combochance", "damageovertimechance",
        "stun", "slow", "silence", "petrify"
    }

    local added_stats = {}

    local count = 0
    while count < self.specialstatscount do
        local stat = stats[love.math.random(1, #stats)]
        if not added_stats[stat] then
            self.specialstats[stat] = love.math.random(1, 10)
            added_stats[stat] = true
            count = count + 1
        end
    end

    self.skin = "Assets/UI/sword" .. love.math.random(1, 9) .. ".png"

    for stat, value in pairs(self.primarystats) do
        self.primarystats[stat] = value * self.statscaling
    end
end

function Equipment:__tostring()
    local str = self.type .. " (" .. self.rarity .. ")"
    for stat, value in pairs(self.primarystats) do
        str = str .. stat .. ": " .. string.format("%.2f", value) .. " "
    end
    for stat, value in pairs(self.specialstats) do
        str = str .. stat .. ": " .. value
    end
    return str
end

return Equipment