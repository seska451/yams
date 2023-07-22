local base_char,keywords=128,{"and","break","do","else","elseif","end","false","for","function","if","in","local","nil","not","or","repeat","return","then","true","until","while",}; function prettify(code) return code:gsub("["..string.char(base_char).."-"..string.char(base_char+#keywords).."]", 
	function (c) return keywords[c:byte()-base_char]; end) end return assert(loadstring(prettify[===[� e={}� e:hello_world()env:info("hello module squishing")�
env:info('DCS is running. Overriding the require function, since DCS has disabled it anyway')require=�(e)env:info('script requested: '..e)� _G[e]�
env:info('We found a variable that looks like the script you are after: '..utils:serialize(_G[e]))� _G[e]�
env:error('We have no idea where to find: '..e)�
�
config={}� house_keeping()env.info("-=_ YAMS v0.1 LOADING _=-")� e=math.random(1,100)env.info("-=_ TODAY'S SCRIPT BROUGHT TO YOU BY THE NUMBER "..e.." _=-")config={debug=�}�
house_keeping()� e=require('test')e:hello_world()� config:set_debug(e)env.info("[DEBUG] setting debug to "..tostring(e))self.debug=e
� self
�
� config:get_debug()� self.debug
�
� e={context="[YAMS]"}� o={TAKEOFF=AI.Task.WaypointType.TAKEOFF,TAKEOFF_PARKING=AI.Task.WaypointType.TAKEOFF_PARKING,TURNING_POINT=AI.Task.WaypointType.TURNING_POINT,TAKEOFF_PARKING_HOT=AI.Task.WaypointType.TAKEOFF_PARKING_HOT,LAND=AI.Task.WaypointType.LAND}� n={WEAPON_FREE=AI.Option.Air.val.ROE.WEAPON_FREE,PRIORITY_DESIGNATED=AI.Option.Air.val.ROE.OPEN_FIRE_WEAPON_FREE,ONLY_DESIGNATED=AI.Option.Air.val.ROE.OPEN_FIRE,RETURN_FIRE=AI.Option.Air.val.ROE.RETURN_FIRE,WEAPON_HOLD=AI.Option.Air.val.ROE.WEAPON_HOLD,get_id=�()� AI.Option.Air.id.ROE
�}� t={NO_REACTION=AI.Option.Air.val.REACTION_ON_THREAT.NO_REACTION,PASSIVE_DEFENCE=AI.Option.Air.val.REACTION_ON_THREAT.PASSIVE_DEFENCE,EVADE_FIRE=AI.Option.Air.val.REACTION_ON_THREAT.EVADE_FIRE,BYPASS_AND_ESCAPE=AI.Option.Air.val.REACTION_ON_THREAT.BYPASS_AND_ESCAPE,ALLOW_ABORT_MISSION=AI.Option.Air.val.REACTION_ON_THREAT.ALLOW_ABORT_MISSION,get_id=�()� AI.Option.Air.id.REACTION_ON_THREAT
�}� o={rules_of_engagement=n,reaction_to_threat=t,waypoint_type=o}� s={}� s:find(e)� trigger.misc.getZone(e)�
� u={}� u:serialize(n,t)� e=""� t=t � 0
� o,n � pairs(n)�
� type(n)~="function"�
� o=(type(o)=="string")�('"'..o..'": ')� tostring(o)� r=type(n)� r=="table"�
e=e..string.rep(" ",t)..o.."{\n"e=e..u:serialize(n,t+2)e=e..string.rep(" ",t).."},\n"�
� n=(r=="string")�('"'..n..'"')� tostring(n)e=e..string.rep(" ",t)..o..n..",\n"�
�
�
� e
�
� e:info(n)env.info(e.context.." "..n,�)�
� e:warn(n)env.warning(e.context.." "..n,�)�
� e:error(n)env.error(e.context.." "..n,�)�
� e:set_context(e)� e==� �
self.context="[YAMS]"�
e="["..e.."]"self.context=e
�
�
� e:clear_context()self.context="[YAMS]"�
� e:debug(n)� config:get_debug()==� �
e:set_context("YAMS - DEBUG")e:info(n)e:clear_context()�
�
� a={text=�,time=10,should_clear=�,coalition=�}� a:with_text(e)self.text=e
� self
�
� a:for_seconds(e)self.time=e
� self
�
� a:clear_previous_messages()self.should_clear=�
� self
�
� a:send()� self.coalition~=� �
trigger.action.outTextForCoalition(self.coalition,self.text,self.time,self.should_clear)�
trigger.action.outText(self.text,self.time,self.should_clear)�
� self
�
� a:to_coalition(e)self.coalition=e
� self
�
� l={flag_index=0,value=0}� l:set_value(n,e)self.flag_index=n
self.value=e
trigger.action.setUserFlag(self.flag_index,self.value)� self
�
� l:set(e)self.flag_index=e
self.value=�
self:set_value(self.flag_index,self.value)� self
�
� l:unset(e)self.flag_index=e
self.value=�
self:set_value(self.flag_index,self.value)� self
�
� i={}� i:find(e)� Group.getByName(e)�
� i:get_country(t)� n
� t,e � pairs(t:getUnits())�
n=Unit.getCountry(e)�
� n==� �
e:error("No units in group "..t:getName().." yielded a country ID!")�
� n
�
� n={}� n:new()self.group={}self.groups_per_generation=0
self.max=10
self.count=-1
self.starting_position={}self.locations={}self.roe=o.rules_of_engagement.WEAPON_HOLD
self.rtt=o.reaction_to_threat.NO_REACTION
self.interval=0
self.generation_primitive="groups"self.pool_size=0
self.spawned_groups={}� self
�
� n:from_pool_of(e)self.pool_size=e
� self
�
� n:deep_clone(t,e)e=e �{}� type(t)~="table"�
� t
� e[t]�
� e[t]�
� o={}e[t]=o
� t,r � pairs(t)�
o[n:deep_clone(t,e)]=n:deep_clone(r,e)�
� setmetatable(o,getmetatable(t))�
� n:groups()self.generation_primitive="groups"� self
�
� n:generate(e)self.groups_per_generation=e
� self
�
� n:every(e)self.interval=e
� self
�
� n:minutes()self.interval=self.interval*60
� self
�
� n:seconds()� self
�
� n:with_rules_of_engagement(e)self.roe=e
� self
�
� n:with_reaction_to_threat(e)self.rtt=e
� self
�
� n:using_template(e)self.group=e
� self
�
� n:at_random_locations(e)self.locations=e
� self
�
� n:until_there_are(e)self.max=e
� self
�
� n:exactly(e)self.count=e
� self
�
� n:get_next_group_name(t)� e=1
� n=t
� i:find(n)�
e=e+1
n=t.."-"..e
�
� n
�
� � t()� e="xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"� string.gsub(e,'[xy]',�(e)� e=(e=='x')� math.random(0,15)� math.random(8,11)� string.format('%x',e)�)�
� � r()� string.upper(string.sub(t(),1,6))�
� n:get_next_unit_name(e)� e.."-"..r()�
� n:with_starting_position(e)self.starting_position=e
� self
�
� n:at_altitude(e)self.start_altitude=e
� self
�
� n:copy_group_data(t,o)� i=t:getName()� r="x: "..o.x..", y: "..o.y..", z: "..o.z
e:debug("copying "..i.." to position "..r)� r={name=n:get_next_group_name(t:getName()),visible=�,taskSelected=t.taskSelected,route=t.route,tasks=t.tasks,hidden=�,units=t.units,x=t.x,y=t.y,alt=t.alt,alt_type=t.alt_type,speed=t.speed,payload=t.payload,start_time=t.start_time,task=t.task,livery_id=t.livery_id,onboard_num=t.onboard_num,uncontrolled=�}� i={}� e,t � pairs(t:getUnits())�
� e={}� r=Unit.getName(t)� n=n:get_next_unit_name(r)e.name=n
e.type=Unit.getTypeName(t)e.x=o.x
e.y=o.y
e.alt=o.z
table.insert(i,e)�
r.units=i
� r
�
� n:clone_group(a,u)� t
� r=i:find(a)� l=i:get_country(r)� r~=� �
e:debug("Cloning group:"..a)� n=n:copy_group_data(r,u)coalition.addGroup(l,r:getCategory(),n)t=i:find(n.name)� t==� �
e:error("Added group not found:"..n.name)� �
�
�
e:error("Template group not found:"..a)�
� e=t:getController()e:setOption(o.reaction_to_threat.get_id(),self.rtt)e:setOption(o.rules_of_engagement.get_id(),self.roe)� t
�
� get_next_random(n)� t=math.random(1,#n)e:debug("RNGesus rolled a "..t.." on a "..#n.." sided dice.")� n[t]�
� send_group_to_refuel_with(n,e)� e=e:getUnits()� n={id="Refueling",params={tanker=n:getUnit(1):getID(),speed=400,},}� t,e � pairs(e)�
e:getController():setTask(n)�
�
� get_cap_task_for_zone(e,n)� e=e:getUnit(1)�{id="EngageTargets",params={route={points={[1]={action="From Waypoint",x=e:getPosition().p.x,y=e:getPosition().p.z,speed=200,ETA=0,ETA_locked=�,name="WP1",task={id="EngageTargets",params={targetTypes={[1]="Air",[2]="Ground"},targetPosition={n.point,},}}},},},},}�
� create_new_groups(t)� o=1,t.max �
e:debug("Spawn #"..o)� e
�#t.locations>0 �
e=get_next_random(t.locations)�
e=t.starting_position
�
� t.start_altitude>0 �
e.z=t.start_altitude
�
� e=n:clone_group(t.group,e)� t.patrol_area~=� �
� n=t.patrol_area
� n=get_cap_task_for_zone(e,n)e:getController():setTask(n)�
table.insert(t.spawned_groups,e)�
�
� n:defending_zone(e)self.patrol_area=e
� self
�
� n:refuelling_at(e)self.tanker_group=e
� self
�
� n:spawn()e:debug("Initializing spawn with settings:\n"..u:serialize(self,2))create_new_groups(self)� self.groups_per_generation>0 �
timer.scheduleFunction(schedule_spawning,self,timer.getTime()+self.interval)�
�
�
� check_fuel_state(n,i)� t=.2
� o={}� t,n � pairs(n)�
� Group.isExist(n)�
� r,t � pairs(Group.getUnits(n))�
� r=t:getFuelConsumption()� t=t:getFuelCapacity()� t=r/t
� t<=lowFuelThreshold �
e:debug("Group "..Group.getName(n).." has a unit with low fuel, sending to the tanker")table.insert(o,n)�
�
�
�
� n,e � pairs(o)�
send_group_to_refuel_with(i,e)�
�
� check_if_alive(n)� t={}� o,n � pairs(n)�
� Group.isExist(n)==� �
e:debug("Group dead: "..(n.name �"[unknown]"))table.insert(t,o)�
�
� t,e � ipairs(t)�
table.remove(n,e)�
�
� schedule_spawning(n,o)e:debug("Spawn time "..o.."\n# groups left in pool: "..n.pool_size.."\n# already spawned: "..#n.spawned_groups.."\n# active max: "..n.max)� n.pool_size==0 �
� �
�
check_if_alive(n.spawned_groups)� n.tanker_group~=� �
check_fuel_state(n.spawned_groups,n.tanker_group)�
�#n.spawned_groups>=n.max �
e:debug("There are enough units out there right now, I'll come back in "..n.interval.."seconds to check again.")� o+n.interval
�
� t
� n.pool_size>=n.groups_per_generation �
t=n.groups_per_generation
�
t=n.pool_size
�
n.pool_size=n.pool_size-t
e:debug("spawning "..t.." at a time, leaving"..n.pool_size.."in the pool")� t=create_new_groups(t,n.locations,n.start_altitude,n.group,n.spawned_groups)e:debug("Now there are the following spawned groups for this generation: "..u:serialize(n.spawned_groups))� o+n.interval
�
� r={}� r:new()self.template=�
self.max_groups=0
self.start_air=�
self.positions=�
self.name=""self.roe=o.rules_of_engagement.WEAPON_HOLD
self.rtt=o.reaction_to_threat.BYPASS_AND_ESCAPE
� self
�
� r:with_rules_of_engagement(e)self.roe=e � o.rules_of_engagement.WEAPON_HOLD
� self
�
� r:with_reaction_to_threat(e)self.rtt=e � o.reaction_to_threat.BYPASS_AND_ESCAPE
� self
�
� r:with_name(e)self.name=e
� self
�
� r:using_template(e)self.template=e
� self
�
� r:no_more_than(e)self.max_groups=e
� self
�
� r:from_pool_of(e)self.pool_size=e
� self
�
� r:start_in_air(e)self.start_air=�
self.start_altitude=e
� self
�
� get_airbase_positions_for(t)� n={}� o,t � pairs(coalition.getAirbases(t))�
� e=Airbase.getPosition(t).p
table.insert(n,e)�
e:debug("Found "..#n.." airbases for coalition: "..t)� n
�
� r:start()� self.name~=� �
e:debug("Creating random air traffic for "..self.name)�
e:debug("Creating random air traffic with "..self.template:getName())�
g=i:find(self.template)� g==� �
e:error(self.template.." group not found.")�
�
� t=Group.getCoalition(g)coordinates=get_airbase_positions_for(t)� t=1e3
n:new():using_template(self.template):from_pool_of(t):groups():generate(self.max_groups):groups():every(20):seconds():until_there_are(self.max_groups):groups():at_random_locations(coordinates):at_altitude(self.start_altitude):with_rules_of_engagement(self.roe):with_reaction_to_threat(self.rtt):spawn()e:debug("RAT Started")�
� t={}� t:new()self.template=�
self.max_groups=0
self.start_air=�
self.name=""self.roe=o.rules_of_engagement.WEAPON_FREE
self.rtt=o.reaction_to_threat.EVADE_FIRE
self.start_location=�
self.patrol_area=�
self.tanker_group=�
self.squadron_size=0
� self
�
� t:using_template(e)self.template=e
� self
�
� t:with_name(e)self.name=e
� self
�
� t:no_more_than(e)self.max_groups=e
� self
�
� t:start_in_air(e)self.start_air=�
self.start_altitude=e
� self
�
� t:for_squadron_size(e)self.squadron_size=e
� self
�
� t:with_home_base(n)� n=Airbase.getByName(n)self.start_location=Airbase.getPosition(n)e:debug("home base at:"..u.serialize(self.start_location))� self
�
� t:with_tanker_group(e)self.tanker_group=e
� self
�
� t:zone_to_defend(e)self.patrol_area=e
� self
�
� t:start()� self.name~=� �
e:debug("Creating combat air patrol for "..self.name)�
e:debug("Creating combat air patrol with "..self.template:getName())�
g=i:find(self.template)� g==� �
e:error(self.template.." group not found.")�
�
n:new():using_template(self.template):from_pool_of(self.squadron_size):groups():generate(self.max_groups):groups():every(20):seconds():until_there_are(self.max_groups):groups():with_starting_position(self.start_location):defending_zone(s:find(self.patrol_area)):refuelling_at(self.tanker_group):at_altitude(self.start_altitude):with_rules_of_engagement(self.roe):with_reaction_to_threat(self.rtt):spawn()e:debug("CAP Started")�
yams={message=a,flag=l,group=i,logger=e,generator=n,random_air_traffic=r,combat_air_patrol=t,enums=o,config=config,zone=s}l:set(31337)e:debug("Loaded and ready for action.")]===], '@dist/yams-dcs.min.lua'))()