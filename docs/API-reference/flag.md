# Flag

> [!INFO]
> The `yams.flag` object is useful for storing binary state as flags. DCS uses flags to communicate across triggers and steps.
>
> For example, a trigger may use a condition that checks is a flag is set or not, before executing its action.

***

### flag:

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
