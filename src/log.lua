--[[ logger:header
# Logger

The `logger` is the entry point for functions to do with logging to DCS.log. You can access it via `yams.logger`.

!!! example
    ```lua
    local log = yams.logger
    log:info("Splash One Lizard")
    ```
--]]
local log = {
    context = "[YAMS]"
}

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
--]]
function log:info(message)
    env.info(log.context .. " " .. message, false)
end

--[[ log:warn
Writes a warning level message to the DCS Log.

| param | type | summary |
|---|---|---|
|message|string|The message you want to print into the log file.|

!!! example
    ```lua
    local log = yams.logger
    log:warn("Bogey on your six")
    ```
--]]
function log:warn(message)
    env.warning(log.context .. " " .. message, false)
end

--[[ log:error
Writes an error level message to the DCS Log.

| param | type | summary |
|---|---|---|
|message|string|The message you want to print into the log file.|

!!! example
    ```lua
    local log = yams.logger
    log:error("Joker Fuel.")
    ```
]]
function log:error(message)
    env.error(log.context .. " " .. message, false)
end



function log:set_context(context)
    if context == nil then
        self.context = "[YAMS]"
    else
        context = "[" .. context .."]"
        self.context = context
    end
end

function log:clear_context()
    self.context = "[YAMS]"
end

function log:debug(message)
    if config:get_debug() == true then
        log:set_context("YAMS - DEBUG")
        log:info(message)
        log:clear_context()
    end
end