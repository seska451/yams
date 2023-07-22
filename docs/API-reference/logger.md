# Logger

The `logger` is the entry point for functions to do with logging to DCS.log. You can access it via `yams.logger`.

!!! example
    ```lua
    local log = yams.logger
    log:info("Splash One Lizard")
    ```

***

### logger:info

Writes an info level message to the DCS Log.

| param | type | summary |
|---|---|---|
|message|string|The message you want to print into the log file.|

!!! example
    ```lua
    local log = yams.logger
    log:info("Splash One Lizard")
    ```

***

### logger:warn

Writes a warning level message to the DCS Log.

| param | type | summary |
|---|---|---|
|message|string|The message you want to print into the log file.|

!!! example
    ```lua
    local log = yams.logger
    log:warn("Bogey on your six")
    ```

***

### logger:error

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

--[[ logger:set_context


***

### logger:clear_context



***

### logger:debug


