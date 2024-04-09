-- distance: how far to go forward
-- placeIce: should the bot replace the floor with ice (or any block)
-- minSlotIndex/maxSlotIndex: the inventory indexs to place blocks with. (turtle api uses 1 based index. First slot is 1)
local distance, placeIce, minSlotIndex, maxSlotIndex = ...;

local placeIceOptions = { ["y"] = true, ["n"] = false };

distance = tonumber(distance);
placeIce = placeIceOptions[placeIce];
minSlotIndex = tonumber(minSlotIndex);
maxSlotIndex = tonumber(maxSlotIndex);

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

local function ensureBlockSelected()
    local currentSlot = minSlotIndex;
    while (currentSlot <= maxSlotIndex) do
        if (turtle.getItemCount(currentSlot) > 1) then
            turtle.select(currentSlot);
            return true;
        end
        currentSlot = currentSlot + 1;
    end
    return errorOut("ensureBlockSelected", "Failed to find any blocks to use!");
end

local function replaceDown()
    -- check if we have blocks
    if (ensureBlockSelected() == false) then
        return errorOut("replaceDown", "No blocks to use");
    end

    turtle.digDown();
    if (turtle.placeDown() == false) then
        return errorOut("replaceDown", "Failed to place block down");
    end
    
    return true;
end

-- script

local function run()
    for index = 1, distance do
        turtle.dig();

        if (moveForward() == false) then
            return errorOut("run", "Failed to move forward");
        end

        turtle.digUp()
        if (turtle.detectUp() == true) then
            return errorOut("run", "Failed to dig the block above?");
        end
        
        if (placeIce) then
            if (replaceDown() == false) then
                return errorOut("run", "Failed to place ice below");
            end
        end
    end
    return true;
end

run();