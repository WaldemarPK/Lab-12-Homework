function postToURL()
    local ok, block = turtle.inspectDown()
    if ok then
        local response, message =
            http.post("https://cedar.fogcloud.org/api/logs/CB6F", "line="..block.name)

        if not response then
            print(message)
        end
    end
end

turtle.refuel(64)

-- Scan starting block
postToURL()

for row = 1, 8 do

    -- Scan left → right
    if row % 2 == 1 then
        for i = 1, 7 do
            turtle.forward()
            postToURL()
        end

        -- Move down except last row
        if row < 8 then
            turtle.turnRight()
            turtle.forward()
            turtle.turnRight()
            postToURL()
        end

    -- Scan right → left
    else
        for i = 1, 7 do
            turtle.forward()
            postToURL()
        end

        -- Move down except last row
        if row < 8 then
            turtle.turnLeft()
            turtle.forward()
            turtle.turnLeft()
            postToURL()
        end
    end

end
