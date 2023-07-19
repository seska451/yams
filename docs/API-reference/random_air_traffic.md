Generates random air traffic (RAT) based on a template group. Yams will spawn no more than the desired number of groups.

For best results, set the template group to **late activation** to supress it from being spawned on startup. This saves a bit of CPU processing for you.

!!! example
    ```lua
    local rat = yams.random_air_traffic
    rat                             -- configure the RAT
        :using_group("RAAF F18C")   -- tell it the name of the group to use for the traffic
        :no_more_than(10)           -- configure the maximum number of groups in the air
        :start_from_ground()        -- (Optional) tell the RAT to start planes on the ground
        :init()
    ```
