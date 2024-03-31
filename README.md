# minecraft-computer-craft-scripts
 
Just some computer craft scripts for the turtles.

## mod link

https://www.computercraft.info/wiki/Main_Page

# build script
Allows the turtle to build simple flat walls, floors and roofs.

`build <mode> <width> <height> <minMaterialSlot> <maxMaterialSlot>`

Loading the script on the turtle

https://pastebin.com/jtUGAwPW

`pastebin get jtUGAwPW build`

Running the script for a 16 x 8 wall
1. Place fuel in slot 1
2. Place the material in slots 2, 3 and 4 (minMaterialSlot = 2, maxMaterialSlot = 4)
3. `build wall 16 8 2 4`

Note: The script is unaware what blocks are in the slot and won't use the slot if it has less than 2 blocks.
