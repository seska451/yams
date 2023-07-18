-- myproject.rockspec

package = "yams"
version = "0.1-1"
source = {
    url = "file://./src",
    url = "https://github.com/LuaDist/squish/blob/master/squish.lua",
}

description = {
    summary = "YAMS",
    detailed = [[
        Yet Another Mission Script for DCS.
    ]],
    license = "MIT",
    homepage = "http://yams-dcs.rtfd.io/"
}

dependencies = {
   "lua >= 5.1",
}

build = {
    type = "builtin",
    modules = {
        ["yams-dcs"] = {
            sources = function()
                local squish = require("squish.lua")
                local files = {}
                local lfs = require("lfs")
                local path = "./src"
                for file in lfs.dir(path) do
                    if file:match("%.lua$") then
                        table.insert(files, path .. "/" .. file)
                    end
                end
                local output = "dist/yams-dcs.lua"
                squish.squishFiles(files, output)
                return { output }
            end,
            install = false
        }
    },
    rock_manifest = {
        files = {
            "dist/squished.lua"
        }
    }
}