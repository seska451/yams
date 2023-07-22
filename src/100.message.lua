--[[ message:header
# Message

!!! info message object
    The `yams.message` object is useful for sending messages to coalitions, groups, and units.

    Messages are the primary way to communicate information to players and can often be seen in both PVE and PVP, solo
    and multiplayer scenarios.

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

return message