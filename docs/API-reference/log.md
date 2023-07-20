### log:info

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

### log:warn

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

### log:error

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
        context = "[YAMS - " .. context .."]"
        self.context = context
    end
end

function log:clear_context()
    self.context = "[YAMS]"
end
--[[ message:header
# Message

!!! info message object
    The `yams.message` object is useful for sending messages to coalitions, groups, and units.

    Messages are the primary way to communicate information to players and can often be seen in both PVE and PVP, solo
    and multiplayer scenarios
