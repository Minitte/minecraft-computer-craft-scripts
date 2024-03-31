-- mode: wall, floor or roof 
-- width/height: area
-- minSlotIndex/maxSlotIndex: the inventory indexs to place blocks with. (turtle api uses 1 based index. First slot is 1)
local mode, width, height, minSlotIndex, maxSlotIndex = ...;


-- mode names
local modeWall = "wall";
local modeFloor = "floor"
local modeRoof = "roof";

local enableLogging = true;

local function errorOut(functionName, errorMsg)
    print("ERROR: " .. functionName .. "() - " .. errorMsg);
    return false;
end

local function logMsg(functionName, msg)
    if (enableLogging) then
        print("LOG: " .. functionName .. "() - " .. msg);
    end
end

local function ensureFuel(shouldRestoreSelectedSlot)
    if (turtle.getFuelLevel() == 0) then
        local previousSlot = turtle.getSelectedSlot();
        turtle.select(1); -- select the first slot for fuel
        if (turtle.refuel(1) == false) then
            return errorOut("ensureFuel", "Failed to find fuel");
        end
        
        logMsg("ensureFuel", "Consumed 1 fuel -> " ..  turtle.getFuelLevel());
        
        if (shouldRestoreSelectedSlot) then
            turtle.select(previousSlot);
        end
    end

    return true
end

local function moveForward()
    if (ensureFuel(true) == false) then
        return errorOut("moveForward", "No fuel");
    end
    if (turtle.forward() == false) then
        return errorOut("moveForward", "Failed to move forward");
    end
    return true;
end

local function moveBack()
    if (ensureFuel(true) == false) then
        return errorOut("moveBack", "No fuel");
    end
    if (turtle.back() == false) then
        return errorOut("moveBack", "Failed to move forward");
    end
    return true;
end

local function moveRight()
    turtle.turnRight();
    if (moveForward() == false) then
        return errorOut("moveRight", "Failed to move forward while moving right");
    end
    turtle.turnLeft();
    return true;
end

local function moveDown()
    if (ensureFuel(true) == false) then
        return errorOut("moveDown", "No fuel");
    end
    if (turtle.down() == false) then
        return errorOut("moveDown", "Failed to move forward");
    end
    return true;
end

local function moveUp()
    if (ensureFuel(true) == false) then
        return errorOut("moveUp", "No fuel");
    end
    if (turtle.up() == false) then
        return errorOut("moveUp", "Failed to move forward");
    end
    return true;
end

local function ensureBlockSelected()
    local currentSlot = minSlotIndex;
    while (currentSlot <= maxSlotIndex) do
        if (turtle.getItemCount(currentSlot) > 1) then
            return true;
        end
        currentSlot = currentSlot + 1;
    end
    return errorOut("ensureBlockSelected", "Failed to find any blocks to use!");
end

local function replaceBlock(replaceMode)
    -- check if we have blocks
    if (ensureBlockSelected() == false) then
        return errorOut("replaceBlock", "No blocks to use");
    end

    if (replaceMode == modeWall) then
        turtle.dig();
        if (turtle.place() == false) then
            return errorOut("replaceBlock", "Failed to place block in front");
        end
    elseif (replaceMode == modeFloor) then
        turtle.digDown();
        if (turtle.placeDown() == false) then
            return errorOut("replaceBlock", "Failed to place block down");
        end
    elseif (replaceMode == modeRoof) then
        turtle.digUp();
        if (turtle.placeUp() == false) then
            return errorOut("replaceBlock", "Failed to place block up");
        end
    else
        return errorOut("replaceBlock", "Unknow mode: " .. mode);
    end
    
    return true;
end

local function moveMode(movementMode, isAlternate)
    if (movementMode == modeWall) then
        if (isAlternate) then
            if (moveUp() == false) then
                return errorOut("movementMode", "Failed to move up");
            end
        else
            if (moveDown() == false) then
                return errorOut("movementMode", "Failed to move down");
            end
        end
        
    elseif (movementMode == modeFloor or movementMode == modeFloor) then
        if (isAlternate) then
            if (moveForward() == false) then
                return errorOut("movementMode", "Failed to move forward");
            end
        else
            if (moveBack() == false) then
                return errorOut("movementMode", "Failed to move back");
            end
        end
        
    else
        return errorOut("movementMode", "Unknow mode: " .. mode);
    end
    
    return true;
end

local function Run()
    local x = 0;

    while (x < width) do
        local y = 0;
        local isAlternate = x % 2 == 1;

        -- fill in the column
        while (y < height) do
            if (replaceBlock(mode)) then
                return false
            end

            y = y + 1;

            -- if there are more spaces to move..
            if (y < height) then
                moveMode(mode, isAlternate); 
            end
        end
        
        x = x + 1;

        -- check if there are more to do. Reposition
        if (x < width) then
            if (moveRight() == false) then
                return errorOut("Run", "Failed to move to the next column");
            end
        end
    end

    return true;
end

Run();