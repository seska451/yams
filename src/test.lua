env:info('DCS is running. Overriding the require function, since DCS has disabled it anyway')

local test = { }

function test:hello_world()
    env:info("hello module squishing")
end

return test