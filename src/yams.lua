--[[ yams:header

The `yams` object is the entry point into the YAMS API. See [Getting Started]('../../getting-started') to learn how to load YAMS into your mission.

There are several modules and methods you can use from yams.

## Modules

### message
The [message](/API-reference/message/) module is the entry point in to anything to do with sending information to players in the game.info

### flag
The [flag](/API-reference/flag/) module assists with setting and reading flag data.

## Methods

### Logging methods
The main way to print out debugging related information is via DCS.log which you can find in your `$ENV:USERPROFILE\Saved Games\DCS.openbeta\Logs\dcs.log`

So if your username is `sandra` and your profile is on the C:\ drive you can find your log file at `C:\Users\sandra\Saved Games\DCS.openbeta\Logs\dcs.log`

The following log functions are supported:

- info
- warn
- error

!!! example
    ```lua
    yams.flag:set(1337) -- sets the 1337 flag ON
    ```
--]]
local yams = {}


--[[ yams:info
Writes an info level message to the DCS Log.

| param | type | summary |
|---|---|---|
|message|string|The message you want to print into the log file.|

!!! example
    ```lua
    yams:info("Splash One Lizard")
    ```
--]]
function yams:info(message)
    env.info("[YAMS]" .. message, false)
end

--[[ yams:warn
Writes a warning level message to the DCS Log.

| param | type | summary |
|---|---|---|
|message|string|The message you want to print into the log file.|

!!! example
    ```lua
    yams:warn("Bogey on your six")
    ```
--]]
function yams:warn(message)
    env.warning("[YAMS]" .. message, false)
end

--[[ yams:error
Writes an error level message to the DCS Log.

| param | type | summary |
|---|---|---|
|message|string|The message you want to print into the log file.|

!!! example
    ```lua
    yams:error("Joker Fuel.")
    ```
--]]
function yams:error(message)
    env.error("[YAMS]" .. message, false)
end

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

!!! example
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
    coalition = nil
}

--[[ message:with_text

Adds text to an ephemeral message shown to the user on the upper RHS of the screen.

 | param | type | summary |
 |-------|------|---------|
 |txt    | string| the text to be sent.|

Returns self

!!! example
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

!!! example
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

!!! example
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

--[[ message:send

Display this message, to all players, in all coalitions. Messages appear in the upper RHS of the screen.

Returns self

!!! example
    ```lua
    local msg = yams.message:with_text("Bingo fuel"):to_coalition(coalition.side.RED)
    -- later
    msg:send()
    ```
--]]
function message:send()
    if self.coalition ~= nil then
        trigger.action.outTextForCoalition(self.coalition, self.text, self.time, self.should_clear )
    else
        trigger.action.outText(self.text, self.time, self.should_clear)
    end

    return self
end

--[[ message:to_coalition

Only send this message to the given coalition.

| param | type |
| --- | --- |
| coalition | SSE.coalition.side [Enumeration]|

!!! example
    ```lua
    yams.message
        :with_text("Hello, YAMS!")
        :to_coalition(coalition.side.BLUE)
        :send()
    ```
]]
function message:to_coalition(coalition)
    self.coalition = coalition
    return self
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

!!! example
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
-- end Flags

--[[ group:header

All helper functions to do with group management

--]]
local group = {}

--[[ group:find
Find a group by its name.

!!! example
    ```lua
    local group = yams.group:find("RAAF-FA18C")
    ```
--]]
function group:find(group_name)
    -- look in BLUE
    local g = coalition.getGroups(group_name, coalition.side.BLUE)

    -- look in RED
    if g == nil then
        g = coalition.getGroups(group_name, coalition.side.RED)
    end
    -- look in NEUTRAL
    if g == nil then
        g = coalition.getGroups(group_name, coalition.side.NEUTRAL)
    end
    if g == nil then
        yams:warn("Could not find group: " .. group_name)
        return nil
    end
    return g
end





yams.message = message
yams.flag = flag
yams.group = group

-- let the server know that yams has been loaded via this flag
flag:set(31337)
return yams