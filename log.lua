---@diagnostic disable:param-type-mismatch

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
    local file = io.open(filename, "w")
    if file then
        file:write(jsonData)
        file:close()
    end

    return false
end

local function LoadData(filename)
    local file = io.open(filename, "r")
    if file then
        local contents = file:read("*all")
        file:close()
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