-- URL that has the 64 block names in the same order as your scan
local url = "https://cedar.fogcloud.org/api/logs/CB6F"  -- use the same ID you post to


-- Refuel from slot 1

local function refuel()
    turtle.select(1)
    turtle.refuel(64)
end


-- Find the slot that holds a given block name
-- You must have the exact blocks in slots 2–16

local function findSlotForBlock(blockName)
    for slot = 2, 16 do
        local detail = turtle.getItemDetail(slot)
        if detail and detail.name == blockName then
            return slot
        end
    end
    return nil
end


-- Place the given block under the turtle

local function placeBlock(blockName)
    local slot = findSlotForBlock(blockName)
    if not slot then
        print("ERROR: Turtle does not have block:", blockName)
        return false
    end
    turtle.select(slot)
    turtle.placeDown()
    return true
end


local function drawLine(blocks)
    for i = 1, #blocks do
        if not placeBlock(blocks[i]) then
            return false
        end
        -- Only move forward if not at the last column
        if i < #blocks then
            turtle.forward()
        end
    end
    return true
end

-------------------------------------------------------
-- MAIN
-------------------------------------------------------
refuel()

local req = http.get(url)
if not req then
    print("Failed to connect to URL!")
    return
end

-- Read all lines from the server
local pixels = {}
while true do
    local line = req.readLine()
    if not line then break end
    table.insert(pixels, line)
end
req.close()

if #pixels < 64 then
    print("ERROR: Expected 64 lines, got " .. #pixels)
    return
end

-- Group pixels into 8 rows of 8, in EXACT order from the file
local rows = {}
for row = 1, 8 do
    rows[row] = {}
    for col = 1, 8 do
        local index = (row - 1) * 8 + col
        rows[row][col] = pixels[index]
    end
end

for row = 1, 8 do
    local line = rows[row]

    drawLine(line)

    if row < 8 then
        if row % 2 == 1 then
            -- After a left→right row: we are on the right side
            turtle.turnRight()
            turtle.forward()
            turtle.turnRight()
        else
            -- After a right→left row: we are on the left side
            turtle.turnLeft()
            turtle.forward()
            turtle.turnLeft()
        end
    end
end
