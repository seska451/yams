$dist = ".\dist"
$dest = $ENV:USERPROFILE + "\Saved Games\DCS.openbeta\Missions\"

& 'C:\Program Files (x86)\Lua\5.1\lua.exe' .\builder.lua


# copy to the users mission directory for use with the game

cp .\dist\yams-dcs.* $dest

# build docs
pushd src
python '.\parse.py' -o '..\docs\API-Reference'
popd

& python -m mkdocs serve