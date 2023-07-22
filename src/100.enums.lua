--[[ enums:header
The enums table defines the many static values that are used in the mission editor.

- **rules_of_engagement** - dictates how a unit may use weapons
- **reaction_to_threat** - dictates how a unit may react to threats
- **waypoint_type** - dictates how a unit should deal with a waypoint
--]]


--[[ enums:waypoint_type
The choices for each waypoint for how a vehicle will interact with the waypoint.
!!! example
    ```lua
    local wp_type = yams.enums.waypoint_type.TAKEOFF
    ```
--]]
local waypoint_type = {
    TAKEOFF = AI.Task.WaypointType.TAKEOFF,
    TAKEOFF_PARKING = AI.Task.WaypointType.TAKEOFF_PARKING,
    TURNING_POINT = AI.Task.WaypointType.TURNING_POINT,
    TAKEOFF_PARKING_HOT = AI.Task.WaypointType.TAKEOFF_PARKING_HOT,
    LAND = AI.Task.WaypointType.LAND
}
--[[ enums:rules_of_engagement
| index | value | summary |
|---|---|---|
| 0 | WEAPON_FREE | Use weapons against any enemy target |
| 1 | PRIORITY_DESIGNATED | Use weapons, against enemy targets in order of priority |
| 2 | ONLY_DESIGNATED | Use weapons, against only designated enemy targets |
| 3 | RETURN_FIRE | Use weapons, against only enemy units that are firing on this unit |
| 4 | WEAPON_HOLD | Do not use weapons |
--]]
local rules_of_engagement = {
    WEAPON_FREE = AI.Option.Air.val.ROE.WEAPON_FREE,
    PRIORITY_DESIGNATED = AI.Option.Air.val.ROE.OPEN_FIRE_WEAPON_FREE,
    ONLY_DESIGNATED = AI.Option.Air.val.ROE.OPEN_FIRE,
    RETURN_FIRE = AI.Option.Air.val.ROE.RETURN_FIRE,
    WEAPON_HOLD = AI.Option.Air.val.ROE.WEAPON_HOLD,
    get_id = function()
        return AI.Option.Air.id.ROE
    end
}

--[[ enums:reaction_to_threat
| index | value | summary |
|---|---|---|
| 0 | NO_REACTION | Do not react to threats |
| 1 | PASSIVE_DEFENCE | Passively defend against threats (e.g. staying out of range) |
| 2 | EVADE_FIRE | When fired upon, attempt to evade incoming missiles or bullets |
| 3 | BYPASS_AND_ESCAPE | Avoid confrontation by evading fire, while re-routing to complete mission objectives. |
| 4 | ALLOW_ABORT_MISSION | Avoid confrontation by evading fire and return to base (RTB). |
--]]
local reaction_to_threat = {
    NO_REACTION = AI.Option.Air.val.REACTION_ON_THREAT.NO_REACTION,
    PASSIVE_DEFENCE = AI.Option.Air.val.REACTION_ON_THREAT.PASSIVE_DEFENCE,
    EVADE_FIRE = AI.Option.Air.val.REACTION_ON_THREAT.EVADE_FIRE,
    BYPASS_AND_ESCAPE = AI.Option.Air.val.REACTION_ON_THREAT.BYPASS_AND_ESCAPE,
    ALLOW_ABORT_MISSION = AI.Option.Air.val.REACTION_ON_THREAT.ALLOW_ABORT_MISSION,
    get_id = function()
        return AI.Option.Air.id.REACTION_ON_THREAT
    end
}
--[[ enums:airbases
The following airbases are available to use in yams
!!! example
    ```lua
    local home_plate = yams.airbases.persian_gulf.ras_al_khaimah_intl
    ```
# Maps
## Persian Gulf
| property | value |
| --- | --- |
| ras_al_khaimah_intl | Ras Al Khaimah Intl |

--]]
local airbases = {
   persian_gulf = {
       ras_al_khaimah_intl = "Ras Al Khaimah Intl"
   }
}

local enums = {
    rules_of_engagement = rules_of_engagement,
    reaction_to_threat = reaction_to_threat,
    waypoint_type = waypoint_type,
    airbases = airbases
}
return enums