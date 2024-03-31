-- args
local sizeX, sizeY, sizeZ = ...;

local enableLogging = true;

function errorOut(functionName, errorMsg)
    print("ERROR: " .. functionName .. "() - " .. errorMsg);
    return false;
end

function logMsg(functionName, msg)
    if (enableLogging) then
        print("LOG: " .. functionName .. "() - " .. msg);
    end
end

function ensureFuel()
    if (turtle.getFuelLevel() == 0) then
        if (turtle.refuel(1) == false) then
            return errorOut("ensureFuel", "Failed to find fuel");
        else
            logMsg("ensureFuel", "Consumed 1 fuel -> " ..  turtle.getFuelLevel());
        end
    end

    return true
end

function moveForward()
    if (ensureFuel() == false) then
        return errorOut("moveForward", "No fuel");
    end
    if (turtle.forward() == false) then
        return errorOut("moveForward", "Failed to move forward");
    end
    return true;
end

function moveDown()
    if (ensureFuel() == false) then
        return errorOut("moveDown", "No fuel");
    end
    if (turtle.down() == false) then
        return errorOut("moveDown", "Failed to move down");
    end
    return true;
end

function mineRow(amount)
    movement = 0;
    while (movement < amount) do
        turtle.digDown();

        if (turtle.detectDown() == true) then
            return errorOut("mineRow", "Failed to mine.");
        end
        
        movement = movement + 1;
        
        if (movement < amount) then
            if (moveForward() == false) then
                return errorOut("mineRow", "Failed to move forward.");
            end
        end
    end

    return true;
end

function mineLayer(amountX, amountZ, shouldFlipRowDirection)
    x = 0;

    xAltOffset = 0;
    if (shouldFlipRowDirection) then
        xAltOffset = 1;
    end

    while (x < amountX) do
        if (mineRow(amountZ) == false) then
            return errorOut("mineLayer", "Failed to mine a row."); 
        end

        x = x + 1;
        -- reposition for the next row if there are more rows to mine
        if (x < amountX) then
            if (((x + xAltOffset) % 2) == 1) then
                turtle.turnRight();
                if (moveForward() == false) then
                    return errorOut("mineLayer", "Failed to move forward to next row.");
                end
                turtle.turnRight();
            else
                turtle.turnLeft();
                if (moveForward() == false) then
                    return errorOut("mineLayer", "Failed to move forward to next row.");
                end
                turtle.turnLeft();
            end
        end
    end

    return true;
end

function mineMultipleLayers(amountX, amountY, amountZ)
    y = 0;

    requiresAlternatingRowDirections = (amountX % 2) == 0;

    while (y < amountY) do
        logMsg("mineMultipleLayers", "Starting layer " .. (y + 1) .. " of " .. amountY);
        flipDirection = requiresAlternatingRowDirections and (y % 2) == 1;
        if (mineLayer(amountX, amountZ, flipDirection) == false) then
            return errorOut("mineMultipleLayers", "Failed to mine a layer."); 
        end

        -- turn around to prepare for the next layer
        turtle.turnRight();
        turtle.turnRight();

        y = y + 1;
        logMsg("mineMultipleLayers", "Completed layer " .. y .. " of " .. amountY);

        if (y < amountY) then
            moveDown();
        end
    end
end
sizeX = tonumber(sizeX);
sizeY = tonumber(sizeY);
sizeZ = tonumber(sizeZ);

logMsg("G", "Mining " .. sizeX .. " " .. sizeY .. " " .. sizeZ);

mineMultipleLayers(sizeX, sizeY, sizeZ);

logMsg("G", "Done!");