-- made by [G-moder]FertNoN
local keys = {
["w"]= IN_FORWARD,
["a"]= IN_MOVELEFT,
["s"]= IN_BACK,
["d"]= IN_MOVERIGHT,
["mouse1"]= IN_ATTACK,
["mouse2"]= IN_ATTACK2,
["reload"]= IN_RELOAD,
["jump"]= IN_JUMP,
["speed"] = IN_SPEED,
["run"] = IN_SPEED,
["zoom"]= IN_ZOOM,
["walk"]= IN_WALK,
["turnleftkey"]= IN_LEFT,
["turnrightkey"]= IN_RIGHT,
["duck"]= IN_DUCK,
["use"]= IN_USE,
["cancel"]= IN_CANCEL,
}

local e2_all_Keys={}
local e2_all_MouseKeys={}
local KeyAct={}

for k=1, game.MaxPlayers() do
e2_all_Keys[k]={}
e2_all_MouseKeys[k]={}
end

concommand.Add("wire_e2_keypress",function(ply, cmd, argm)
	if tonumber(argm[2])==1 then
		e2_all_Keys[ply:EntIndex()][tonumber(argm[1])] = true
		ply.e2_last_key=tonumber(argm[1])
	else
		e2_all_Keys[ply:EntIndex()][tonumber(argm[1])] = nil
	end
end)

__e2setcost(20)
e2function number clKeyPress(number key)
	if e2_all_Keys[self.player:EntIndex()][key] then
		return 1
	else
		return 0
	end
end

e2function number clKeyPressVel(number key)
	if e2_all_Keys[self.player:EntIndex()][key] then
		e2_all_Keys[self.player:EntIndex()][key]=nil
		return 1
	else
		return 0
	end
end

e2function number clLastKeyPress()
	if self.player.e2_last_key then 
		local key=self.player.e2_last_key 
		self.player.e2_last_key=0
		return key 
	else 
		return 0 
	end
end

e2function void runOnKey(number active)
	if KeyAct[self.player]==active then return end
	if active==1 then
		umsg.Start("e2_key_run", self.player) 
		umsg.End()
	 	KeyAct[self.player]=1
	else
		umsg.Start("e2_key_stop", self.player) 
		umsg.End()
	 	KeyAct[self.player]=0
	end
end
__e2setcost(2000)
e2function void clkeyClearBuffer()
	table.remove(e2_all_Keys[self.player:EntIndex()])
	self.player.e2_last_key=0
end

__e2setcost(20)
e2function number keyPress(string key)
if self.player:KeyDown(keys[key:lower()]) then return 1 else return 0 end
end
--------------------MOUSE

local MouseKeyAct={}

concommand.Add("wire_e2_mousekeypress",function(ply, cmd, argm)
	if tonumber(argm[2])==1 then
		e2_all_MouseKeys[ply:EntIndex()][argm[1]] = true
		ply.e2_mouselast_key=argm[1]
	else
		e2_all_MouseKeys[ply:EntIndex()][argm[1]] = nil
	end
end)

__e2setcost(20)
e2function number clMouseKeyPress(string key)
	if e2_all_MouseKeys[self.player:EntIndex()][key] then
		return 1
	else
		return 0
	end
end

e2function number clMouseKeyPressVel(string key)
	if e2_all_MouseKeys[self.player:EntIndex()][key] then
		e2_all_MouseKeys[self.player:EntIndex()][key]=nil
		return 1
	else
		return 0
	end
end

e2function string clLastMouseKeyPress()
	if self.player.e2_mouselast_key then 
		local key=self.player.e2_mouselast_key 
		self.player.e2_mouselast_key="null"
		return key 
	else 
		return "null"
	end
end

__e2setcost(2000)
e2function void clMousekeyClearBuffer()
	table.remove(e2_all_MouseKeys[self.player:EntIndex()])
	self.player.e2_mouselast_key="null"
end

__e2setcost(20)

e2function void runOnMouseKey(number active)
	if MouseKeyAct[self.player]==active then return end
	if active==1 then
		umsg.Start("e2_mousekey_run", self.player) 
		umsg.End()
	 	MouseKeyAct[self.player]=1
	else
		umsg.Start("e2_mousekey_stop", self.player) 
		umsg.End()
	 	MouseKeyAct[self.player]=0
	end
end

e2function number entity:inUse()
	if !IsValid(this) then return 0 end
	local user=this.user
	this.user=nil
	if user!=nil then return 1 end
	return 0
end

e2function entity entity:inUseBy()
    if !IsValid(this) then return 0 end
	local user=this.user
	this.user=nil
	return user
end

function e2_use()
	for k,v in pairs ( player.GetAll() ) do
		if v:KeyDown(IN_USE) then
			local rv1=v:GetEyeTraceNoCursor().HitPos
			local rv2=v:GetShootPos()
			local rvd1, rvd2, rvd3 = rv1[1] - rv2[1], rv1[2] - rv2[2], rv1[3] - rv2[3]
	        local dis=(rvd1 * rvd1 + rvd2 * rvd2 + rvd3 * rvd3) ^ 0.5
			if dis<40 then
				local ent = v:GetEyeTraceNoCursor().Entity
	            if ent:IsValid() then
					ent.user=v
				end
			end
		end
	end
end 

hook.Add( "Think", "e2_use" ,e2_use) 
