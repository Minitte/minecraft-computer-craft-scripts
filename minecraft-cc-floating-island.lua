-- width/height: area
local width, height= ...;

width = tonumber(width);
height = tonumber(height);

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
    local currentSlot = 2; -- 1 is for fuel
    while (currentSlot <= 15) do
        if (turtle.getItemCount(currentSlot) > 0) then
            turtle.select(currentSlot);
            return true;
        end
        currentSlot = currentSlot + 1;
    end
    return errorOut("ensureBlockSelected", "Failed to find any blocks to use!");
end

local function placeBlock()
    -- check if we have blocks
    if (ensureBlockSelected() == false) then
        return errorOut("replaceBlock", "No blocks to use");
    end

    if (turtle.placeDown() == false) then
        return errorOut("replaceBlock", "Failed to place block down");
    end
    
    return true;
end

-- init 2d map
-- scan layer and update map

-- loop:
--  try to expand layer (random)
--  go to next layer and being placing blocks
--  return to starting XZ


-- optimizations/adjustments:
--  pre generate all layers and place vertically
--  calculate new started/end position based on min/max xz
--  pre-fueling stage (100k)

-- alternative:
--  only expand edges, less resources. Use a sand filling bot. OR just use water/lava cobble fill by hand.