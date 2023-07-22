The enums table defines the many static values that are used in the mission editor.

- **rules_of_engagement** - dictates how a unit may use weapons
- **reaction_to_threat** - dictates how a unit may react to threats
- **waypoint_type** - dictates how a unit should deal with a waypoint

***

### enums:waypoint_type

The choices for each waypoint for how a vehicle will interact with the waypoint.
!!! example
    ```lua
    local wp_type = yams.enums.waypoint_type.TAKEOFF
    ```

***

### enums:rules_of_engagement

| index | value | summary |
|---|---|---|
| 0 | WEAPON_FREE | Use weapons against any enemy target |
| 1 | PRIORITY_DESIGNATED | Use weapons, against enemy targets in order of priority |
| 2 | ONLY_DESIGNATED | Use weapons, against only designated enemy targets |
| 3 | RETURN_FIRE | Use weapons, against only enemy units that are firing on this unit |
| 4 | WEAPON_HOLD | Do not use weapons |

***

### enums:reaction_to_threat

| index | value | summary |
|---|---|---|
| 0 | NO_REACTION | Do not react to threats |
| 1 | PASSIVE_DEFENCE | Passively defend against threats (e.g. staying out of range) |
| 2 | EVADE_FIRE | When fired upon, attempt to evade incoming missiles or bullets |
| 3 | BYPASS_AND_ESCAPE | Avoid confrontation by evading fire, while re-routing to complete mission objectives. |
| 4 | ALLOW_ABORT_MISSION | Avoid confrontation by evading fire and return to base (RTB). |

***

### enums:airbases

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

