# Dial-Display-LuaU
A simple "dial" display module written in LuaU for Roblox Studio.

![Dial](https://github.com/PlasmaGH/Dial-Display-LuaU/assets/77991203/5be66b8d-8e06-471f-8b29-877262fd6a9a)


## Useage:

```lua

local DialModule = require(DialDisplay)
local Dial = DialModule.new(
  3, -- (number) The number of slots. (REQUIRED)
  0, -- (number) The inital number required. (REQUIRED)
  OBJECTS_PARENT_HERE, -- (Instance) The desired parent of the dial interface (REQUIRED)
  UDim2.new(...), -- (UDim2) The desired position
  nil, -- (number) the desired X padding per slot. (Set to nil to use default)
  nil, -- (TweenInfo) the tween info used for updating the slot. (This is the flip animation)
)

DialModule.update(Dial, -- Dial
  15 -- The number you want to display. With 3 slots this is expected to show up as "015"
)

-- If the number is higher than it can display it will change every number to 9
-- This is shown as: 10 ^ slotsNum - 1

```
