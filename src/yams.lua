local log = require('log')
local config = require('config')
local enums = require('enums')
--local utils = require('utils')
local zone = require('zone')
local message = require('message')
local flag = require('flag')
local group = require('group')
local generator = require('generator')
local random_air_traffic = require('random_air_traffic')
local combat_air_patrol = require('combat_air_patrol')

--[[ yams:header

The `yams` object is the entry point into the YAMS API. See [Getting Started]('../../getting-started') to learn how to load YAMS into your mission.

There are several modules and methods you can use from yams.

## Modules

### message
The [message](/API-reference/message/) module is the entry point in to anything to do with sending information to players in the game.info

### flag
The [flag](/API-reference/flag/) module assists with setting and reading flag data.

## Methods

### Logging methods
The main way to print out debugging related information is via DCS.log which you can find in your `$ENV:USERPROFILE\Saved Games\DCS.openbeta\Logs\dcs.log`

So if your username is `sandra` and your profile is on the C:\ drive you can find your log file at `C:\Users\sandra\Saved Games\DCS.openbeta\Logs\dcs.log`

The following log functions are supported:

- info
- warn
- error

!!! example
    ```lua
    yams.flag:set(1337) -- sets the 1337 flag ON
    ```
--]]
yams = {
    message = message,
    flag = flag,
    group = group,
    logger = log,
    generator = generator,
    random_air_traffic = random_air_traffic,
    combat_air_patrol = combat_air_patrol,
    enums = enums,
    config = config,
    zone = zone
}

-- let the server know that yams has been loaded via this flag
flag:set(31337)
yams.logger:debug("Loaded and ready for action.")
return yams