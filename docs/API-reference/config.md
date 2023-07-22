# Config
Yams is designed to minimize the amount of config you need to worry about. Whatever there is to worry about lives here though.

!!! example
    ```lua
    local cfg = yams.config
    cfg:set_debug(true)         -- turns on verbose logging into your DCS.log
    ```

***

### config:set_debug

# Debug Configuration
!!! example
    If you need to see how yams is working under the hood, then you can use the `set_debug` & `get_debug` property accessors
    in your scripts to enable debug logging.
    ```lua

    local cfg = yams.config
    cfg:set_debug(true)         -- turns on verbose logging into your DCS.log

    if cfg:get_debug() then
        -- do something else
    end
    ```
]]
function config:set_debug(val)
    env.info("[DEBUG] setting debug to " .. tostring(val))
    self.debug = val
    return self
end

--[[ config:get_debug
Gets the value of the debug `config` property
!!! example
    ```lua
    local is_debug =
        yams.config:get_debug()

    if is_debug then
        -- do something
    end
    ```
