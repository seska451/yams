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


***

### flag:set_value

Sets the value of a given flag referred to by index.

***

### flag:set

Sets a flag to ON.

***

### flag:unset

Sets a flag to OFF
