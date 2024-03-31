-- Script for redstone clock

-- delay: the amount of time between each redstone signal
-- duration: how long does the signal last
-- side: which side to output to. (rs.getSides() for options)
local delay, duration, side = ...;

delay = tonumber(delay);
duration = tonumber(duration);

while (true) do
    sleep(delay);

    redstone.setOutput(side, true);

    sleep(duration);

    redstone.setOutput(side, false);
end