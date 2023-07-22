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
