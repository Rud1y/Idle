local love = require("love")
local counter = 0

function Button(func, buttonx, buttony, text, icon, width, height, scale)
    func = func or function() print("This button has no function attached") end

    return {
        buttonx = buttonx or 0,
        buttony = buttony or 0,
        width = width or 100,
        height = height or 100,
        text = text,
        icon = love.graphics.newImage(icon) or "No icon added",
        scale = 1,
        drawScale = scale or 1,

        checkHover = function(self, mousex, mousey)
            if mousex >= self.buttonx and mousex <= self.buttonx + self.width * self.drawScale then
                if mousey >= self.buttony and mousey <= self.buttony + self.height * self.drawScale then
                    if love.mouse.isDown(1) and counter == 0 then
                        self:click()
                        counter = 1
                    end
                    if not love.mouse.isDown(1) then
                        counter = 0
                    end
                    self.scale = 1.1
                    return true
                end
            end
            self.scale = 1
            return false
        end,

        click = function(self)
            func()
        end,

        draw = function(self)
            love.graphics.draw(self.icon, self.buttonx + 20 * (1 - self.scale), self.buttony + 20 * (1 - self.scale), 0, self.drawScale, self.drawScale)
            love.graphics.print(self.text, self.buttonx + 35 * (2 - self.scale), self.buttony + 5 * (2 - self.scale))
        end,
    }
end

return Button