local love = require("love")

function Pet(name)
    return {
        statscaling = 1,
        primarystats = {},
        rarity = "common",
        specialstatscount = 0,
        specialstats = {},
        skin = nil,
        animations = {},
        currentanimation = nil,
        currentFrame = 1,
        animationSpeed = 0.1,
        timeElapsed = 0,

        Initialization = function(self, rarity)
--Adding different animations for different petts, change quads logic
            self.animations = {
                idle = { image = love.graphics.newImage("Assets/Pet/MiniWolf.png"), numframes = 4, row = 0, quads = {} },
                attack = { image = love.graphics.newImage("Assets/Pet/MiniWolf.png"), numframes = 5, row = 3, quads = {} },
            }
            self.currentanimation = "idle"
            local framewidth = self.animations.idle.image:getWidth() / 7
            local frameheight = self.animations.idle.image:getHeight() / 8

            for _, anim in pairs(self.animations) do
                for i = 1, anim.numframes do
                    anim.quads[i] = love.graphics.newQuad((i - 1) * framewidth, frameheight * anim.row, framewidth, frameheight, anim.image:getDimensions())
                end
            end

            self.rarity = rarity or self.rarity
            if self.rarity == "common" then
                self.specialstatscount = 0
            elseif self.rarity == "uncommon" then
                self.specialstatscount = 1
                self.statscaling = 1.5
            elseif self.rarity == "rare" then
                self.specialstatscount = 1
                self.statscaling = 2.2
            elseif self.rarity == "epic" then
                self.specialstatscount = 2
                self.statscaling = 3.1
            elseif self.rarity == "legendary" then
                self.specialstatscount = 3
                self.statscaling = 4.5
            end

            local types = {
                bunny = {hitpoints = 50, attack = 5, speed = 30},
                bear = {hitpoints = 120, attack = 15, speed = 5 },
                boar = {hitpoints = 80, attack = 10, speed = 15 },
                wolf = {hitpoints = 70, attack = 12, speed = 10 },
                deer = {hitpoints = 80, attack = 15, speed = 15 },
                fox = {hitpoints = 60, attack = 7, speed = 25 },
                }

            local stats = {
                "dodge",
                "block",
                "crit",
                "critdamage",
                "combochance",
                "damageovertimechance",
                "stun",
                "slow",
                "silence",
                "petrify"
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

            for pet, table in pairs(types) do
                if name == pet then
                    for stat, value in pairs(table) do
                        self.primarystats[stat] = value * self.statscaling
                    end
                end
            end
        end,

        changeAnimation = function(self, animation)
            self.currentanimation = animation
            self.currentFrame = 1
        end,

        Update = function(self, dt)
            self.timeElapsed = self.timeElapsed + dt
            if self.timeElapsed >= self.animationSpeed then
                self.timeElapsed = 0
                self.currentFrame = self.currentFrame + 1
                if self.currentFrame > self.animations[self.currentanimation].numframes and self.currentanimation == "attack" then
                    self.currentanimation = "idle"
                    self.currentFrame = 1
                elseif self.currentFrame > self.animations[self.currentanimation].numframes then
                    self.currentFrame = 1
                end
            end
        end,

        draw = function(self, x, y)
            local anim = self.animations[self.currentanimation]
            love.graphics.draw(anim.image, anim.quads[self.currentFrame], x, y, 0, 3, 3)
        end
    }
end

return Pet