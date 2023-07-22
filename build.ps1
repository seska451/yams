& 'C:\Program Files (x86)\Lua\5.1\lua.exe' .\build.lua

# build docs
pushd src
python '.\parse.py' -o '..\docs\API-Reference'
popd

& python -m mkdocs serve