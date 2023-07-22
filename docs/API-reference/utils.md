Every project has a bucket of _slightly_ useful functions, this is yams:utils.
]]--
local utils = { }

--[[ utils:serialize
!!! example
    ```lua
    local my_table = {
        bunch = "of stuff",
        right_here = {
            foo = 1,
            bar = 2,
            baz = function() do
                return tointeger("3")
            end
        }
    }
    local indent = 2 -- spaces
    print(yams.utils:serialize(my_table, indent))
    ```
    This will output the following to console:
    ```
    {
        bunch = "of stuff",
        right_here = {
            foo = 1,
            bar = 2
        }
    }
    ```
