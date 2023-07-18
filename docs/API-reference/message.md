# Message

> [!INFO]
> The `yams.message` object is useful for sending messages to coalitions, groups, and units.
>
> Messages are the primary way to communicate information to players and can often be seen in both PVE and PVP, solo
> and multiplayer scenarios

***

### message:

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

***

### message:with_text


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

***

### message:for_seconds


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

***

### message:clear_previous_messages


Upon displaying this message, remove all other messages

Returns self

Example:
```lua
yams.message
    :with_text("Hello, YAMS!")
    :clear_previous_messages()
    :send() -- sends to all players in all coalitions
```

***

### message:clear_previous_messages


Display this message, to all players, in all coalitions. Messages appear in the upper RHS of the screen.

Returns self

Example:
```lua
yams.message
    :with_text("Hello, YAMS!")
    :send()
```
