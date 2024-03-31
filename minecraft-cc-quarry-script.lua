local numLayers = ...

function ensureFuel()
  if (turtle.getFuelLevel() == 0) then
    if (turtle.refuel(1) == false) then
      print("ERROR ensureFuel(): Failed to find fuel!")
      return false
    else
      print("LOG ensureFuel(): Consumed 1 fuel -> " ..  turtle.getFuelLevel())
    end
  end

  return true
end

function digDown()
  turtle.digDown()
  
  if (turtle.detectDown() == true) then
    print("ERROR digDown(): Failed to dig down!")
    return false
  end

  if (ensureFuel() == false) then
    print("ERROR digDown(): No Fuel?")
    return false
  end
  
  turtle.down()

  return true
end

function digForward()
  turtle.dig()
  -- check if we successfully dug forward
  if (turtle.detect() == true) then
    print("ERROR digForward(): Failed to dig forward!")
    return false
  end

  if (ensureFuel() == false) then
    print("ERROR digForward(): No Fuel?")
    return false
  end
  
  turtle.forward()
  return true
end

function mineLayer(sizeX, sizeZ, bIsAltCorner)
  -- dig into the layer first
  if (digDown() == false) then
    print("ERROR mineLayer(): Failed to dig down into the layer!")
    return false
  end

  x = 0
  z = 1 -- start at 1 since we dug one into the first layer
  while (x < sizeX) do
    while (z < sizeZ) do
      if (digForward() == false) then
        print("ERROR mineLayer(): Failed to dig forward for current row!")
        return false
      end
      
      z = z + 1;
    end

    x = x + 1;
    
    -- check if we need to prep of the next layer
    if (x < sizeX) then
      xOffsetForAlt = 0
      if (bIsAltCorner) then
        xOffsetForAlt = 1
      end
      bIsAltDirection = (x + xOffsetForAlt) % 2 == 0
      
      -- turn
      if (bIsAltDirection) then
      turtle.turnRight()
      else
      turtle.turnLeft()
      end
  
      if (digForward() == false) then
      print("ERROR mineLayer(): Failed to dig forward for new row!")
      return false
      end  
      z = 1 -- reset z to 1 instead of 0 because we have to dig into the row
      
      if (bIsAltDirection) then
      turtle.turnRight()
      else
      turtle.turnLeft()
      end
    end
        
    
  end
  
  return true
end

function mineMultipleLayers(numLayers)
  y = 0
  
  while (y < numLayers) do
    if (mineLayer(16, 16) == false) then
      print("ERROR mineMultipleLayers(): Failed to dig layer!")
      return false
    end
    
    -- turn around for next layer
    turtle.turnRight()
    turtle.turnRight()

    y = y + 1
  end

  return true
end 

numLayers = tonumber(numLayers)

print("Starting Mining Script for " .. numLayers .. " layers")
mineMultipleLayers(numLayers)
print("Finished Mining Script..")