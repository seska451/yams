local base_char,keywords=128,{"and","break","do","else","elseif","end","false","for","function","if","in","local","nil","not","or","repeat","return","then","true","until","while",}; function prettify(code) return code:gsub("["..string.char(base_char).."-"..string.char(base_char+#keywords).."]", 
	function (c) return keywords[c:byte()-base_char]; end) end return assert(loadstring(prettify[===[å e={}â e:hello_world()env:info("hello module squishing")Ü
env:info('DCS is running. Overriding the require function, since DCS has disabled it anyway')require=â(e)env:info('script requested: '..e)ä _G[e]í
env:info('We found a variable that looks like the script you are after: '..utils:serialize(_G[e]))ë _G[e]Ñ
env:error('We have no idea where to find: '..e)Ü
Ü
config={}â house_keeping()env.info("-=_ YAMS v0.1 LOADING _=-")å e=math.random(1,100)env.info("-=_ TODAY'S SCRIPT BROUGHT TO YOU BY THE NUMBER "..e.." _=-")config={debug=á}Ü
house_keeping()å e=require('test')e:hello_world()â config:set_debug(e)env.info("[DEBUG] setting debug to "..tostring(e))self.debug=e
ë self
Ü
â config:get_debug()ë self.debug
Ü
å e={context="[YAMS]"}å o={TAKEOFF=AI.Task.WaypointType.TAKEOFF,TAKEOFF_PARKING=AI.Task.WaypointType.TAKEOFF_PARKING,TURNING_POINT=AI.Task.WaypointType.TURNING_POINT,TAKEOFF_PARKING_HOT=AI.Task.WaypointType.TAKEOFF_PARKING_HOT,LAND=AI.Task.WaypointType.LAND}å n={WEAPON_FREE=AI.Option.Air.val.ROE.WEAPON_FREE,PRIORITY_DESIGNATED=AI.Option.Air.val.ROE.OPEN_FIRE_WEAPON_FREE,ONLY_DESIGNATED=AI.Option.Air.val.ROE.OPEN_FIRE,RETURN_FIRE=AI.Option.Air.val.ROE.RETURN_FIRE,WEAPON_HOLD=AI.Option.Air.val.ROE.WEAPON_HOLD,get_id=â()ë AI.Option.Air.id.ROE
Ü}å t={NO_REACTION=AI.Option.Air.val.REACTION_ON_THREAT.NO_REACTION,PASSIVE_DEFENCE=AI.Option.Air.val.REACTION_ON_THREAT.PASSIVE_DEFENCE,EVADE_FIRE=AI.Option.Air.val.REACTION_ON_THREAT.EVADE_FIRE,BYPASS_AND_ESCAPE=AI.Option.Air.val.REACTION_ON_THREAT.BYPASS_AND_ESCAPE,ALLOW_ABORT_MISSION=AI.Option.Air.val.REACTION_ON_THREAT.ALLOW_ABORT_MISSION,get_id=â()ë AI.Option.Air.id.REACTION_ON_THREAT
Ü}å o={rules_of_engagement=n,reaction_to_threat=t,waypoint_type=o}å s={}â s:find(e)ë trigger.misc.getZone(e)Ü
å u={}â u:serialize(n,t)å e=""å t=t è 0
à o,n ã pairs(n)É
ä type(n)~="function"í
å o=(type(o)=="string")Å('"'..o..'": ')è tostring(o)å r=type(n)ä r=="table"í
e=e..string.rep(" ",t)..o.."{\n"e=e..u:serialize(n,t+2)e=e..string.rep(" ",t).."},\n"Ñ
å n=(r=="string")Å('"'..n..'"')è tostring(n)e=e..string.rep(" ",t)..o..n..",\n"Ü
Ü
Ü
ë e
Ü
â e:info(n)env.info(e.context.." "..n,á)Ü
â e:warn(n)env.warning(e.context.." "..n,á)Ü
â e:error(n)env.error(e.context.." "..n,á)Ü
â e:set_context(e)ä e==ç í
self.context="[YAMS]"Ñ
e="["..e.."]"self.context=e
Ü
Ü
â e:clear_context()self.context="[YAMS]"Ü
â e:debug(n)ä config:get_debug()==ì í
e:set_context("YAMS - DEBUG")e:info(n)e:clear_context()Ü
Ü
å a={text=ç,time=10,should_clear=á,coalition=ç}â a:with_text(e)self.text=e
ë self
Ü
â a:for_seconds(e)self.time=e
ë self
Ü
â a:clear_previous_messages()self.should_clear=ì
ë self
Ü
â a:send()ä self.coalition~=ç í
trigger.action.outTextForCoalition(self.coalition,self.text,self.time,self.should_clear)Ñ
trigger.action.outText(self.text,self.time,self.should_clear)Ü
ë self
Ü
â a:to_coalition(e)self.coalition=e
ë self
Ü
å l={flag_index=0,value=0}â l:set_value(n,e)self.flag_index=n
self.value=e
trigger.action.setUserFlag(self.flag_index,self.value)ë self
Ü
â l:set(e)self.flag_index=e
self.value=ì
self:set_value(self.flag_index,self.value)ë self
Ü
â l:unset(e)self.flag_index=e
self.value=á
self:set_value(self.flag_index,self.value)ë self
Ü
å i={}â i:find(e)ë Group.getByName(e)Ü
â i:get_country(t)å n
à t,e ã pairs(t:getUnits())É
n=Unit.getCountry(e)Ü
ä n==ç í
e:error("No units in group "..t:getName().." yielded a country ID!")Ü
ë n
Ü
å n={}â n:new()self.group={}self.groups_per_generation=0
self.max=10
self.count=-1
self.starting_position={}self.locations={}self.roe=o.rules_of_engagement.WEAPON_HOLD
self.rtt=o.reaction_to_threat.NO_REACTION
self.interval=0
self.generation_primitive="groups"self.pool_size=0
self.spawned_groups={}ë self
Ü
â n:from_pool_of(e)self.pool_size=e
ë self
Ü
â n:deep_clone(t,e)e=e è{}ä type(t)~="table"í
ë t
Ö e[t]í
ë e[t]Ü
å o={}e[t]=o
à t,r ã pairs(t)É
o[n:deep_clone(t,e)]=n:deep_clone(r,e)Ü
ë setmetatable(o,getmetatable(t))Ü
â n:groups()self.generation_primitive="groups"ë self
Ü
â n:generate(e)self.groups_per_generation=e
ë self
Ü
â n:every(e)self.interval=e
ë self
Ü
â n:minutes()self.interval=self.interval*60
ë self
Ü
â n:seconds()ë self
Ü
â n:with_rules_of_engagement(e)self.roe=e
ë self
Ü
â n:with_reaction_to_threat(e)self.rtt=e
ë self
Ü
â n:using_template(e)self.group=e
ë self
Ü
â n:at_random_locations(e)self.locations=e
ë self
Ü
â n:until_there_are(e)self.max=e
ë self
Ü
â n:exactly(e)self.count=e
ë self
Ü
â n:get_next_group_name(t)å e=1
å n=t
ï i:find(n)É
e=e+1
n=t.."-"..e
Ü
ë n
Ü
å â t()å e="xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"ë string.gsub(e,'[xy]',â(e)å e=(e=='x')Å math.random(0,15)è math.random(8,11)ë string.format('%x',e)Ü)Ü
å â r()ë string.upper(string.sub(t(),1,6))Ü
â n:get_next_unit_name(e)ë e.."-"..r()Ü
â n:with_starting_position(e)self.starting_position=e
ë self
Ü
â n:at_altitude(e)self.start_altitude=e
ë self
Ü
â n:copy_group_data(t,o)å i=t:getName()å r="x: "..o.x..", y: "..o.y..", z: "..o.z
e:debug("copying "..i.." to position "..r)å r={name=n:get_next_group_name(t:getName()),visible=ì,taskSelected=t.taskSelected,route=t.route,tasks=t.tasks,hidden=á,units=t.units,x=t.x,y=t.y,alt=t.alt,alt_type=t.alt_type,speed=t.speed,payload=t.payload,start_time=t.start_time,task=t.task,livery_id=t.livery_id,onboard_num=t.onboard_num,uncontrolled=ì}å i={}à e,t ã pairs(t:getUnits())É
å e={}å r=Unit.getName(t)å n=n:get_next_unit_name(r)e.name=n
e.type=Unit.getTypeName(t)e.x=o.x
e.y=o.y
e.alt=o.z
table.insert(i,e)Ü
r.units=i
ë r
Ü
â n:clone_group(a,u)å t
å r=i:find(a)å l=i:get_country(r)ä r~=ç í
e:debug("Cloning group:"..a)å n=n:copy_group_data(r,u)coalition.addGroup(l,r:getCategory(),n)t=i:find(n.name)ä t==ç í
e:error("Added group not found:"..n.name)ë ç
Ü
Ñ
e:error("Template group not found:"..a)Ü
å e=t:getController()e:setOption(o.reaction_to_threat.get_id(),self.rtt)e:setOption(o.rules_of_engagement.get_id(),self.roe)ë t
Ü
â get_next_random(n)å t=math.random(1,#n)e:debug("RNGesus rolled a "..t.." on a "..#n.." sided dice.")ë n[t]Ü
â send_group_to_refuel_with(n,e)å e=e:getUnits()å n={id="Refueling",params={tanker=n:getUnit(1):getID(),speed=400,},}à t,e ã pairs(e)É
e:getController():setTask(n)Ü
Ü
â get_cap_task_for_zone(e,n)å e=e:getUnit(1)ë{id="EngageTargets",params={route={points={[1]={action="From Waypoint",x=e:getPosition().p.x,y=e:getPosition().p.z,speed=200,ETA=0,ETA_locked=á,name="WP1",task={id="EngageTargets",params={targetTypes={[1]="Air",[2]="Ground"},targetPosition={n.point,},}}},},},},}Ü
â create_new_groups(t)à o=1,t.max É
e:debug("Spawn #"..o)å e
ä#t.locations>0 í
e=get_next_random(t.locations)Ñ
e=t.starting_position
Ü
ä t.start_altitude>0 í
e.z=t.start_altitude
Ü
å e=n:clone_group(t.group,e)ä t.patrol_area~=ç í
å n=t.patrol_area
å n=get_cap_task_for_zone(e,n)e:getController():setTask(n)Ü
table.insert(t.spawned_groups,e)Ü
Ü
â n:defending_zone(e)self.patrol_area=e
ë self
Ü
â n:refuelling_at(e)self.tanker_group=e
ë self
Ü
â n:spawn()e:debug("Initializing spawn with settings:\n"..u:serialize(self,2))create_new_groups(self)ä self.groups_per_generation>0 í
timer.scheduleFunction(schedule_spawning,self,timer.getTime()+self.interval)ë
Ü
Ü
â check_fuel_state(n,i)å t=.2
å o={}à t,n ã pairs(n)É
ä Group.isExist(n)í
à r,t ã pairs(Group.getUnits(n))É
å r=t:getFuelConsumption()å t=t:getFuelCapacity()å t=r/t
ä t<=lowFuelThreshold í
e:debug("Group "..Group.getName(n).." has a unit with low fuel, sending to the tanker")table.insert(o,n)Ü
Ü
Ü
Ü
à n,e ã pairs(o)É
send_group_to_refuel_with(i,e)Ü
Ü
â check_if_alive(n)å t={}à o,n ã pairs(n)É
ä Group.isExist(n)==á í
e:debug("Group dead: "..(n.name è"[unknown]"))table.insert(t,o)Ü
Ü
à t,e ã ipairs(t)É
table.remove(n,e)Ü
Ü
â schedule_spawning(n,o)e:debug("Spawn time "..o.."\n# groups left in pool: "..n.pool_size.."\n# already spawned: "..#n.spawned_groups.."\n# active max: "..n.max)ä n.pool_size==0 í
ë ç
Ü
check_if_alive(n.spawned_groups)ä n.tanker_group~=ç í
check_fuel_state(n.spawned_groups,n.tanker_group)Ü
ä#n.spawned_groups>=n.max í
e:debug("There are enough units out there right now, I'll come back in "..n.interval.."seconds to check again.")ë o+n.interval
Ü
å t
ä n.pool_size>=n.groups_per_generation í
t=n.groups_per_generation
Ñ
t=n.pool_size
Ü
n.pool_size=n.pool_size-t
e:debug("spawning "..t.." at a time, leaving"..n.pool_size.."in the pool")å t=create_new_groups(t,n.locations,n.start_altitude,n.group,n.spawned_groups)e:debug("Now there are the following spawned groups for this generation: "..u:serialize(n.spawned_groups))ë o+n.interval
Ü
å r={}â r:new()self.template=ç
self.max_groups=0
self.start_air=ç
self.positions=ç
self.name=""self.roe=o.rules_of_engagement.WEAPON_HOLD
self.rtt=o.reaction_to_threat.BYPASS_AND_ESCAPE
ë self
Ü
â r:with_rules_of_engagement(e)self.roe=e è o.rules_of_engagement.WEAPON_HOLD
ë self
Ü
â r:with_reaction_to_threat(e)self.rtt=e è o.reaction_to_threat.BYPASS_AND_ESCAPE
ë self
Ü
â r:with_name(e)self.name=e
ë self
Ü
â r:using_template(e)self.template=e
ë self
Ü
â r:no_more_than(e)self.max_groups=e
ë self
Ü
â r:from_pool_of(e)self.pool_size=e
ë self
Ü
â r:start_in_air(e)self.start_air=ì
self.start_altitude=e
ë self
Ü
â get_airbase_positions_for(t)å n={}à o,t ã pairs(coalition.getAirbases(t))É
å e=Airbase.getPosition(t).p
table.insert(n,e)Ü
e:debug("Found "..#n.." airbases for coalition: "..t)ë n
Ü
â r:start()ä self.name~=ç í
e:debug("Creating random air traffic for "..self.name)Ñ
e:debug("Creating random air traffic with "..self.template:getName())Ü
g=i:find(self.template)ä g==ç í
e:error(self.template.." group not found.")ë
Ü
å t=Group.getCoalition(g)coordinates=get_airbase_positions_for(t)å t=1e3
n:new():using_template(self.template):from_pool_of(t):groups():generate(self.max_groups):groups():every(20):seconds():until_there_are(self.max_groups):groups():at_random_locations(coordinates):at_altitude(self.start_altitude):with_rules_of_engagement(self.roe):with_reaction_to_threat(self.rtt):spawn()e:debug("RAT Started")Ü
å t={}â t:new()self.template=ç
self.max_groups=0
self.start_air=ç
self.name=""self.roe=o.rules_of_engagement.WEAPON_FREE
self.rtt=o.reaction_to_threat.EVADE_FIRE
self.start_location=ç
self.patrol_area=ç
self.tanker_group=ç
self.squadron_size=0
ë self
Ü
â t:using_template(e)self.template=e
ë self
Ü
â t:with_name(e)self.name=e
ë self
Ü
â t:no_more_than(e)self.max_groups=e
ë self
Ü
â t:start_in_air(e)self.start_air=ì
self.start_altitude=e
ë self
Ü
â t:for_squadron_size(e)self.squadron_size=e
ë self
Ü
â t:with_home_base(n)å n=Airbase.getByName(n)self.start_location=Airbase.getPosition(n)e:debug("home base at:"..u.serialize(self.start_location))ë self
Ü
â t:with_tanker_group(e)self.tanker_group=e
ë self
Ü
â t:zone_to_defend(e)self.patrol_area=e
ë self
Ü
â t:start()ä self.name~=ç í
e:debug("Creating combat air patrol for "..self.name)Ñ
e:debug("Creating combat air patrol with "..self.template:getName())Ü
g=i:find(self.template)ä g==ç í
e:error(self.template.." group not found.")ë
Ü
n:new():using_template(self.template):from_pool_of(self.squadron_size):groups():generate(self.max_groups):groups():every(20):seconds():until_there_are(self.max_groups):groups():with_starting_position(self.start_location):defending_zone(s:find(self.patrol_area)):refuelling_at(self.tanker_group):at_altitude(self.start_altitude):with_rules_of_engagement(self.roe):with_reaction_to_threat(self.rtt):spawn()e:debug("CAP Started")Ü
yams={message=a,flag=l,group=i,logger=e,generator=n,random_air_traffic=r,combat_air_patrol=t,enums=o,config=config,zone=s}l:set(31337)e:debug("Loaded and ready for action.")]===], '@dist/yams-dcs.min.lua'))()