--[[ flag:header
# Flag
Use the `flag` module to manage user flags in the game.

#### Properties & Methods
 | property | type | summary |
 |-------|------|---------|
 |flag_index    | int| the unique number representing the flag.|
 |value    | int| the numeric value of the flag. Non-zero values are considered 'true'|
 |set    | method| Sets a flag to 'true'|
 |unset    |method| Sets a flag to 'false'|
 |set_value    |method| Sets a flag to a given value|
 |clear_previous_messages    |method| Determines if the previous messages should be cleared|

!!! example
    ```lua
    yams.flag
        :set(31337)                 -- Sets Flag #31337 to true
        :unset(30)                  -- Sets Flag #30 to false
        :set_value(420, 8145317)    -- Sets Flag #420 to the number 8145317
    ```

!!! info
    The `yams.flag` object is useful for storing binary state as flags. DCS uses flags to communicate across triggers and steps.
    For example, a trigger may use a condition that checks is a flag is set or not, before executing its action.

--]]
local flag = {
    flag_index = 0,
    value = 0
}

--[[ flag:set_value
Sets the value of a given flag referred to by index.
--]]
function flag:set_value(ndx, value)
    self.flag_index = ndx
    self.value = value
    trigger.action.setUserFlag(self.flag_index, self.value)
    return self
end


--[[ flag:set
Sets a flag to ON.
--]]
function flag:set(ndx)
    self.flag_index = ndx
    self.value = true
    self:set_value(self.flag_index, self.value)
    return self
end


--[[ flag:unset
Sets a flag to OFF
--]]
function flag:unset(ndx)
    self.flag_index = ndx
    self.value = false
    self:set_value(self.flag_index, self.value)
    return self
end

return flag