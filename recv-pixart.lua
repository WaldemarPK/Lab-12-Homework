local url = "https://cedar.fogcloud.org/api/logs/58F4"

local function refuel()
    turtle.select(1)
    turtle.refuel(64)
end

local function findSlotForBlock(blockName)
    for slot = 2, 16 do
        local detail = turtle.getItemDetail(slot)
        if detail and detail.name == blockName then
            return slot
        end
    end
    return nil
end

-- FIXED: No extra forward on last pixel
local function drawLine(blocks)
    for i = 1, #blocks do
        local block = blocks[i]
        local slot = findSlotForBlock(block)

        if not slot then
            print("ERROR: Missing block:", block)
            return false
        end

        turtle.select(slot)
        turtle.placeDown()

        -- Only move forward if NOT at end of row
        if i < #blocks then
            turtle.forward()
        end
    end
    return true
end

local function drawImage(rows)
    for row = 1, 8 do
        local line = rows[row]

        if row % 2 == 0 then
            local rev = {}
            for i = 8, 1, -1 do rev[#rev+1] = line[i] end
            line = rev
        end

        drawLine(line)

        -- Now the turtle is standing on the final block in the row.
        -- Move to next row if not finished.
        if row < 8 then
            if row % 2 == 1 then
                turtle.turnRight()
                turtle.forward()
                turtle.turnRight()
            else
                turtle.turnLeft()
                turtle.forward()
                turtle.turnLeft()
            end
        end
    end
end

refuel()

local req = http.get(url)
if not req then
    print("Failed to connect.")
    return
end

local pixels = {}
while true do
    local line = req.readLine()
    if not line then break end
    table.insert(pixels, line)
end
req.close()

if #pixels < 64 then
    print("Expected 64 lines, got", #pixels)
    return
end

local rows = {}
for row = 1, 8 do
    rows[row] = {}
    for col = 1, 8 do
        local index = (row - 1) * 8 + col
        rows[row][col] = pixels[index]
    end
end

drawImage(rows)
print("8×8 complete!")

