$dist = ".\dist"
$dest = $ENV:USERPROFILE + "\Saved Games\DCS.openbeta\Missions\"


cp .\src\yams.lua "${dist}\yams-dcs.lua"
# minify/uglify the script
& 'C:\Program Files (x86)\Lua\5.1\lua.exe' .\squish.lua

# copy to the users mission directory for use with the game

cp .\dist\yams-dcs.min.lua.uglified $dest
cp .\dist\yams-dcs.min.lua $dest
cp .\dist\yams-dcs.lua $dest

# build docs
pushd src
python '.\parse.py' -o '..\docs\API-Reference'
popd

& python -m mkdocs serve