local json = require("dkjson")
local love = require("love")

local log = {}
local playerData = {}

local function SaveData(filename)
    local data = {
        player = playerData,
        game = log
    }
    local jsonData = json.encode(data, { indent = true })
    print("JSON Data:", jsonData)
    if jsonData then
        local success, message = love.filesystem.write(filename, jsonData)
        if success then
            print("Data successfully written to " .. filename)
        else
            print("Failed to write data: " .. message)
        end
        print(love.filesystem.getSaveDirectory())
        return success
    end
    return false
end

local function LoadData(filename)
    print("l")
    if love.filesystem.getInfo(filename) then
        local contents, size = love.filesystem.read(filename)
        if contents then
            print(contents)
            return json.decode(contents)
        end
    end
    return nil
end

return {
    log = log,
    playerData = playerData,
    SaveData = SaveData,
    LoadData = LoadData
}