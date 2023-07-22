local lfs = require("lfs")

local function get_git_commit_hash()
    local handle = io.popen("git rev-parse HEAD")
    local result = handle:read("*a")
    handle:close()
    return result and result:match("%w+")
end

local function find_all_lua_files_recursively_in(directory)
    print("Looking for lua files in: " .. directory)
    local luaFiles = {}

    for file in lfs.dir(directory) do
        if file ~= "." and file ~= ".." then
            local path = directory .. "/" .. file
            local attributes = lfs.attributes(path)

            if attributes.mode == "file" and file:match("%.lua$") then
                table.insert(luaFiles, path)
            elseif attributes.mode == "directory" then
                local subLuaFiles = findLuaFiles(path)
                for _, subFile in ipairs(subLuaFiles) do
                    table.insert(luaFiles, subFile)
                end
            end
        end
    end

    return luaFiles
end

local function read_file_as_string(file_path)
  print("reading " .. file_path)
  local file = io.open(file_path, "r")
  if file then
      local content = file:read("*all")
      file:close()
      return content
  else
      return nil
  end
end

local function write_to(destination, script)
  print("Writing to script" .. destination)
  local outputFile = io.open(destination, "w")
  if outputFile then
      outputFile:write(script)
      outputFile:close()
      print("Combined yams script written to:", destination)
  else
      print("Error: Unable to write to the output file.")
  end
end

local function get_filename_from_path(path)
    -- Find the last occurrence of a backslash or forward slash in the path
    local separator = path:match("[\\/]([^\\/]+)$")
    return separator or path -- Return the filename part or the whole path if no separator found
end

local function get_file_header()
    print("Getting commit hash and version info")
    local version = read_file_as_string('current_version.txt')
    local hash = get_git_commit_hash()
    local header = ""
    if hash then
        header = header .. "--=_ YAMS version " .. version .. "- git commit hash: " .. hash .. " _=--\n"
    end
    print(header)
    return header
end


local function build_single_yams_file_from(yam_files)
    print("Building yams into a single file")
    local script = ""
    for _, file in ipairs(yam_files) do
        local file_content = read_file_as_string(file)
        if file_content then
            -- Remove the last line if it starts with "return"
            local lastLine = file_content:match("[^\r\n]+$")
            if lastLine and lastLine:match("^%s*return") then
                file_content = file_content:sub(1, -1 * #lastLine - 1)
            end
            script = script .. "\n-- **** START:" .. get_filename_from_path(file) .. " **** ---"
            script = script .. "\n" .. file_content
            script = script .. "\n-- **** END:" .. get_filename_from_path(file) .. " **** ---"
        end
    end
    return script
end

local function minify_yams()
    print("Minifying and Uglifying yams")
    dofile('squish.lua')
end

local function copy_file(source_path, dest_path)
    print("Copying... " .. source_path .. " to " .. dest_path)
    local sourceFile = io.open(source_path, "rb")
    local destFile = io.open(dest_path, "wb")

    if sourceFile and destFile then
        local content = sourceFile:read("*all")
        destFile:write(content)
    else
        print("Error: Failed to copy file.")
    end

    if sourceFile then
        sourceFile:close()
    end

    if destFile then
        destFile:close()
    end
end

local function copy_yams_to_dev_environment()
    print("Copying to dev environment")
    local userProfile = os.getenv("USERPROFILE")
    local dest = userProfile .. "\\Saved Games\\DCS.openbeta\\Missions\\"
    local sourceDir = ".\\dist\\"

    for file in lfs.dir(sourceDir) do
        if file ~= "." and file ~= ".." then
            local sourcePath = sourceDir .. file
            local destPath = dest .. file
            copy_file(sourcePath, destPath)
        end
    end
end
--asdasd
print('Building yams-dcs.lua')
local yam_files = find_all_lua_files_recursively_in('./src')
local script = build_single_yams_file_from(yam_files)
local file_header = get_file_header()

write_to('./dist/yams-dcs.lua', script)
minify_yams()
copy_yams_to_dev_environment()
