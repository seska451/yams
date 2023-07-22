--[[ utils:header
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
--]]
function utils:serialize(tbl, indent)
    local result = ""
    local indent = indent or 0

    for key, value in pairs(tbl) do
        if type(value) ~= "function" then
            local keyStr = (type(key) == "string") and ('"' .. key .. '": ') or tostring(key)
            local valueType = type(value)

            if valueType == "table" then
                result = result .. string.rep(" ", indent) .. keyStr .. "{\n"
                result = result .. utils:serialize(value, indent + 2)
                result = result .. string.rep(" ", indent) .. "},\n"
            else
                local valueStr = (valueType == "string") and ('"' .. value .. '"') or tostring(value)
                result = result .. string.rep(" ", indent) .. keyStr .. valueStr .. ",\n"
            end
        end
    end

    return result
end

return utils