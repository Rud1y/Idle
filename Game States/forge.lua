local love = require("love")
local equipment = require("Components.equipment")
local Log = require("log")
local Button = require("Components.button")
local Dialog = require("Components.dialog")

local Data = Log.LoadData("C:/Users/Raul/OneDrive/Documenti/GitHub/Idle/gameLog.json")

local dialog = Dialog:New()

function Forge(player)
    local function randomDecimal(min, max, decimalPlaces)
        local factor = 10 ^ decimalPlaces
        return love.math.random(min * factor, max * factor) / factor
    end

    return {
        level = 1,
        probability = {},
        buttons = {},
        confirm = false,
        dialog = false,
        toEquip = {},

        Initialization = function(self, x)
            local forge = love.graphics.newImage("Assets/UI/home.png")
            self.buttons = {
                forgebutton = Button(function() self:createEquipment() end, 100, 500, "", "Assets/UI/home.png", forge:getWidth(), forge:getHeight(), 0.1)
            }
            self.level = x.level or 1
            if self.level >=1 and self.level <= 5 then
                self.probability = {
                    common = 70 - (self.level - 1) * 7.5,
                    uncommon = 20 + (self.level - 1) * 5,
                    rare = 10 + (self.level - 1) * 2.5,
                    epic = 0,
                    legendary = 0
                }
            elseif self.level >= 6 and self.level <= 10 then
                self.probability = {
                    common = 35 - (self.level - 6) * 7.5,
                    uncommon = 40 + (self.level - 6) * 2.5,
                    rare = 20 + (self.level - 6) * 2.5,
                    epic = 5 + (self.level - 6) * 2.5,
                    legendary = 0
                }
            elseif self.level >= 11 and self.level <= 15 then
                self.probability = {
                    common = 0,
                    uncommon = 44 - (self.level - 11) * 9.75,
                    rare = 40 + (self.level - 11) * 7.5,
                    epic = 15 + (self.level - 11) * 2,
                    legendary = 1 + (self.level - 11) * 0.25
                }
            elseif self.level >= 16 and self.level <= 20 then
                self.probability = {
                    common = 0,
                    uncommon = 0,
                    rare = 72 - (self.level - 16) * 5.5,
                    epic = 25 + (self.level - 16) * 5,
                    legendary = 3 + (self.level - 16) * 0.5
                }
            end

            self.toEquip = self.toEquip or {}
        end,

        createEquipment = function(self)
            local equipments = {
                "head",
                "chest",
                "legs",
                "feet",
                "weapon",
                "ring",
                "amulet",
                "stone"
            }
            local random = randomDecimal(0, 100, 2)
            local randomEquipment = equipments[love.math.random(1, #equipments)]
            local equip = equipment:New(randomEquipment, player.level)
            if random <= self.probability.common then
                equip:Initialization("common")
            elseif random >= self.probability.common and random <= self.probability.common + self.probability.uncommon then
                equip:Initialization("uncommon")
            elseif random >= self.probability.common + self.probability.uncommon and random <= self.probability.common + self.probability.uncommon + self.probability.rare then
                equip:Initialization("rare")
            elseif random >= self.probability.common + self.probability.uncommon + self.probability.rare and random <= self.probability.common + self.probability.uncommon + self.probability.rare + self.probability.epic then
                equip:Initialization("epic")
            else
                equip:Initialization("legendary")
            end

            print(equip)
            print(#self.toEquip)

            table.insert(self.toEquip, equip)
            table.insert(self.toEquip, randomEquipment)

            print(#self.toEquip)

            if player.equipment[randomEquipment] and player.equipment[randomEquipment].type then
                dialog:SelectDialog("createEquipment", true, equip, player.equipment[randomEquipment], self)
            else
                dialog:SelectDialog("createEquipment", false, equip, "", self)
            end
        end,

        draw = function(self)
            love.graphics.print("Forge", 0, 0)
            love.graphics.print("Level: " .. self.level, 100, 0)
            for _, button in pairs(self.buttons) do
                button:draw()
            end

            if self.dialog then
                dialog:Draw()
            end
        end,

        toTable = function(self)
            return {
                level = self.level
            }
        end,

        Update = function(self)
            self.dialog = dialog:State()
            if not self.dialog then
                for _, button in pairs(self.buttons) do
                    button:checkHover(love.mouse.getPosition())
                end
            else
                for _, button in pairs(self.buttons) do
                    button.scale = 1
                end
                dialog:Update()
                if self.confirm then
                    player.equipment[self.toEquip[2]] = self.toEquip[1]
                    self.confirm = false
                    print(self.toEquip[1])
                    self.toEquip = {}
                    player.RecalculationStats()
                end
            end

---recalculation of stats after new equipment is added

            return self.dialog
        end,

        SaveData = function(self)
            table.insert(Log.log, self:toTable())
            Log.SaveData("C:/Users/Raul/OneDrive/Documenti/GitHub/Idle/gameLog.json")
        end,
    }
end

return Forge