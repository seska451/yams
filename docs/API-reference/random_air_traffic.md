Generates random air traffic (RAT) based on a template group. Yams will spawn no more than the desired number of groups.
It will schedule a check every 60 seconds to ensure there is enough aircraft in the sky.

For best results, set the template group to **late activation** to supress it from being spawned on startup. This saves a bit of CPU processing for you.

!!! info Abstraction ahead
    This function is a convenience over the generator:spawn function it is basically an opinionated wrapper. If you want more control, check out the `generator` module.


!!! example Starting a RAT
    ```lua
    local rat = yams.random_air_traffic
    local positions = {

    }
    rat                             -- configure the RAT
        :using_group("RAAF F18C")   -- tell it the name of the group to use for the traffic
        :no_more_than(10)           -- configure the maximum number of groups in the air
        :start_from_air(4500)        -- (Optional) tell the RAT to start planes at a specific altitude
        :init()
    ```

***

### random_air_traffic:with_name

Gives this random air traffic a name to identify it by, which is displayed in logs

***

### random_air_traffic:using_group

Use a `group_name` to find a late activated template group for use in random air traffic generation

***

### random_air_traffic:no_more_than

Set the maximum number of aircraft spawned for random air traffic

***

### random_air_traffic:start_in_air

Tells all traffic to be spawned in the air at a given altitude

***

### random_air_traffic:start_from_ground


!!! warning not yet implemented
    Planned feature.

***

### random_air_traffic:init

Final call in the random_air_traffic fluent API. Use this to start random air traffic using the parameters set by previous calls.
