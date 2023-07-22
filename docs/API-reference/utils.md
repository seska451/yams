Every project has a bucket of _slightly_ useful functions, this is yams:utils.
]]--
local utils = { }

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

--[[ log:info
Writes an info level message to the DCS Log.

| param | type | summary |
|---|---|---|
|message|string|The message you want to print into the log file.|

!!! example
    ```lua
    local log = yams.logger
    log:info("Splash One Lizard")
    ```
