# Combat Air Patrol (CAP)

The `combat_air_patrol` fluent interface is designed to make building CAPs easy. It checks the state of the CAP every 20
seconds for you and will keep topping up the groups that are active in the world up to any limit that you set. Stops once
it has run out of groups to dispatch. Only works against air units. It will even check the fuel state of the groups and
tell them to refuel if required.

This module makes plenty of assumptions in order to achieve this ease of use.

!!! info
    If you want finer control, then you should look at the [`generator`](../generator) module instead.

!!! example
    ```lua
    yams.combat_air_patrol
        :new()                                      -- You must initialize this type
        :with_name("Iranian Combat Air Patrol")     -- Optionally name this CAP squadron
        :for_squadron_size(20)                      -- Set a size for the squadron, this is the number of groups
        :using_template("IRANAF-MIG29")             -- Use this template for generating groups, this dictates the # of planes per group
        :with_tanker_group("IRANAF-TANKER")         -- Use this to designate a tanker for refuelling
        :with_home_base("Ras Al Khaimah Intl")      -- Sets the home airbase
        :zone_to_defend("red-patrol-zone")          -- Sets the CAP patrol area to defend from threats
        :no_more_than(2)                            -- Limit the number of groups that can be active at any given point in time
        :start_in_air(6000)                         -- Set the cruising altitude for this CAP (all units are in metres)
        :start()                                    -- Send them on their way.
    ```

***

### combat_air_patrol:using_template

!!! example
    ```lua
    ```

***

### combat_air_patrol:with_name

!!! example
    ```lua
    ```

***

### combat_air_patrol:no_more_than

!!! example
    ```lua
    yams.combat_air_patrol:no_more_than(count)
    ```

***

### combat_air_patrol:start_in_air

!!! example
    ```lua
    yams.combat_air_patrol:start_in_air(altitude)

    ```

***

### combat_air_patrol:for_squadron_size

!!! example
    ```lua
    yams.combat_air_patrol:for_squadron_size(count)

    ```

***

### combat_air_patrol:with_home_base

!!! example
    ```lua
    yams.combat_air_patrol:with_home_base(airbase_name)

    ```

***

### combat_air_patrol:with_tanker_group

!!! example
    ```lua
    yams.combat_air_patrol:with_tanker_group(grp)

    ```

***

### combat_air_patrol:zone_to_defend

!!! example
    ```lua
    yams.combat_air_patrol:zone_to_defend(zone)

    ```

***

### combat_air_patrol:start

Starts the CAP with the settings you've provided earlier
!!! example
    ```lua
    local cap = yams.combat_air_patrol
    cap
        :new()
        :with_name("Iranian Combat Air Patrol")
        :for_squadron_size(20)
        :using_template("IRANAF-MIG29")
        :with_tanker_group("IRANAF-TANKER")
        :with_home_base("Ras Al Khaimah Intl")
        :zone_to_defend("red-patrol-zone")
        :no_more_than(2) -- groups
        :start_in_air(6000) -- metres
        :start()
    ```
