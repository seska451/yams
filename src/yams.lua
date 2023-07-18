--[[ message:header
# Message

!!! info message object
    The `yams.message` object is useful for sending messages to coalitions, groups, and units.

    Messages are the primary way to communicate information to players and can often be seen in both PVE and PVP, solo
    and multiplayer scenarios
--]]

--[[ message:
#### Summary
Data structure for messaging information.
#### Properties & Methods
 | property | type | summary |
 |-------|------|---------|
 |text    | string| the text to be sent.|
 |time    | int| the time to display the text for.|
 |should_clear    | bool| If true, clears the previous messages.|
 |with_text    |method| Sets the message text|
 |for_seconds    |method| Sets the message timer|
 |clear_previous_messages    |method| Determines if the previous messages should be cleared|

#### Usage Example
```lua
yams.message
    :with_text("Hello, YAMS!")  -- Output Hello, YAMS!
    :for_seconds(30)            --    for 30 seconds
    :clear_previous_messages()  --    clearing the previous messages
    :send()                     --    send to all players
```
--]]
local message = {
    text = nil,
    time = 10,
    should_clear = false,
    coalition = coalition.side.NEUTRAL
}

--[[ message:with_text

Adds text to an ephemeral message shown to the user on the upper RHS of the screen.

 | param | type | summary |
 |-------|------|---------|
 |txt    | string| the text to be sent.|

Returns self

Example:
```lua
yams.message
    :with_text("Hello, YAMS!")
    :send() -- sends to all players in all coalitions
```
--]]
function message:with_text(txt)
    self.text = txt
    return self
end

--[[ message:for_seconds

Sets the message duration

 | param | type | summary |
 |-------|------|---------|
 |seconds|int| the number of seconds to apply the message to the screen before it is erased. _Defaults to 10 seconds_|

Returns self

Example:
```lua
yams.message
    :with_text("Hello, YAMS!")
    :for_seconds(5)
    :send() -- sends to all players in all coalitions
```
--]]
function message:for_seconds(seconds)
    self.time = seconds
    return self
end

--[[ message:clear_previous_messages

Upon displaying this message, remove all other messages

Returns self

Example:
```lua
yams.message
    :with_text("Hello, YAMS!")
    :clear_previous_messages()
    :send() -- sends to all players in all coalitions
```
--]]
function message:clear_previous_messages()
    self.should_clear = true
    return self
end

--[[ message:clear_previous_messages

Display this message, to all players, in all coalitions. Messages appear in the upper RHS of the screen.

Returns self

Example:
```lua
yams.message
    :with_text("Hello, YAMS!")
    :send()
```
--]]
function message:send()
    trigger.action.outText(self.text, self.time, self.should_clear)
    return self
end

function message:to_coalition(coalition)

end

-- End Messages

--[[ flag:header
# Flag

> [!INFO]
> The `yams.flag` object is useful for storing binary state as flags. DCS uses flags to communicate across triggers and steps.
>
> For example, a trigger may use a condition that checks is a flag is set or not, before executing its action.
--]]
--[[ flag:
#### Summary
Data structure for flag management.
#### Properties & Methods
 | property | type | summary |
 |-------|------|---------|
 |flag_index    | int| the unique number representing the flag.|
 |value    | int| the numeric value of the flag. Non-zero values are considered 'true'|
 |set    | method| Sets a flag to 'true'|
 |unset    |method| Sets a flag to 'false'|
 |set_value    |method| Sets a flag to a given value|
 |clear_previous_messages    |method| Determines if the previous messages should be cleared|

#### Usage Example
```lua
yams.flag
    :set(31337)                 -- Sets Flag #31337 to true
    :unset(30)                  -- Sets Flag #30 to false
    :set_value(420, 8145317)    -- Sets Flag #420 to the number 8145317
```
--]]
local flag = {
    flag_index = 0,
    value = 0
}

--- Sets the value of a flag for a given index.
--- @param ndx The flags index number.
--- @param value The value to set the flag. 0 means off, or false. 1 or higher means on, or true.
function flag:set_value(ndx, value)
    self.flag_index = ndx
    self.value = value
    trigger.action.setUserFlag(self.flag_index, self.value)
    return self
end

--- Sets a flag for a given index, to ON.
--- @param ndx The flags index number.
function flag:set(ndx)
    self.flag_index = ndx
    self.value = true
    self:set_value(self.flag_index, self.value)
    return self
end

--- Sets a flag for a given index, to OFF.
--- @param ndx The flags index number.
function flag:unset(ndx)
    self.flag_index = ndx
    self.value = false
    self:set_value(self.flag_index, self.value)
    return self
end
-- end Flags

yams = {
    message = message,
    flag = flag
}
-- let the server know that yams has been loaded via this flag
flag:set(31337)
return yams