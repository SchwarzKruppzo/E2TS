/******************************************************************************\
Prop Core by MrFaul started by ZeikJT
report any wishes, issues to Mr.Faul@gmx.de (GER or ENG pls)
\******************************************************************************/

PropCore = {}
local sbox_E2_maxProps = CreateConVar( "sbox_E2_maxProps", "-1", FCVAR_ARCHIVE )
local sbox_E2_maxPropsPerSecond = CreateConVar( "sbox_E2_maxPropsPerSecond", "12", FCVAR_ARCHIVE )
local sbox_E2_PropCore = CreateConVar( "sbox_E2_PropCore", "2", FCVAR_ARCHIVE )

local E2totalspawnedprops = 0
local E2tempSpawnedProps = 0

timer.Create( "ResetTempProps", 1, 0, function()
E2tempSpawnedProps=0
end)

function PropCore.ValidSpawn()
	if E2tempSpawnedProps >= sbox_E2_maxPropsPerSecond:GetInt() then return false end
	if sbox_E2_maxProps:GetInt() <= -1 then
		return true
	elseif E2totalspawnedprops>=sbox_E2_maxProps:GetInt() then
		return false
	end
	return true
end

function PropCore.ValidAction(self, entity, cmd)
	if(cmd=="spawn" or cmd=="Tdelete") then return true end
	if !IsValid(entity)  then return false end
	if(!validPhysics(entity)) then return false end
	if !isOwner(self, entity)  then return false end
	if entity:IsPlayer() then return false end
	local ply = self.player
	return sbox_E2_PropCore:GetInt()==2 or (sbox_E2_PropCore:GetInt()==1 and ply:IsAdmin())
end

local function MakePropNoEffect(...)
	local backup = DoPropSpawnedEffect
	DoPropSpawnedEffect = function() end
	local ret = MakeProp(...)
	DoPropSpawnedEffect = backup
	return ret
end

function PropCore.CreateProp(self,model,pos,angles,freeze)
	if(!util.IsValidModel(model) || !util.IsValidProp(model) || not PropCore.ValidSpawn() )then
		return nil
	end
	local prop
	if self.data.propSpawnEffect then
		prop = MakeProp( self.player, pos, angles, model, {}, {} )
	else
		prop = MakePropNoEffect( self.player, pos, angles, model, {}, {} )
	end
	if not prop then return end
	prop:Activate()
	self.player:AddCleanup( "props", prop )
	undo.Create("e2_spawned_prop")
		undo.AddEntity( prop )
		undo.SetPlayer( self.player )
	undo.Finish()
	local phys = prop:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		if(freeze>0)then phys:EnableMotion( false ) end
	end
	prop.OnDieFunctions.GetCountUpdate.Function2 = prop.OnDieFunctions.GetCountUpdate.Function
	prop.OnDieFunctions.GetCountUpdate.Function =  function(self,player,class)
		if CLIENT then return end
		E2totalspawnedprops=E2totalspawnedprops-1
		self.OnDieFunctions.GetCountUpdate.Function2(self,player,class)
	end
	E2totalspawnedprops = E2totalspawnedprops+1
	E2tempSpawnedProps = E2tempSpawnedProps+1
	return prop
end

function PropCore.PhysManipulate(this, pos, rot, freeze, gravity, notsolid)
	if(notsolid!=nil) then this:SetNotSolid(notsolid ~= 0) end
	local phys = this:GetPhysicsObject()
	if(pos!=nil) then phys:SetPos(Vector(pos[1],pos[2],pos[3])) end
	if(rot!=nil) then phys:SetAngle(Angle(rot[1],rot[2],rot[3])) end
	if(freeze!=nil) then phys:EnableMotion(freeze == 0) end
	if(gravity!=nil) then phys:EnableGravity(gravity~=0) end
	phys:Wake()
	if(!phys:IsMoveable())then
		phys:EnableMotion(true)
		phys:EnableMotion(false)
	end
end

--------------------------------------------------------------------------------
e2function entity propSpawn(string model, number frozen)
	if not PropCore.ValidAction(self, nil, "spawn") then return nil end
	return PropCore.CreateProp(self,model,self.entity:GetPos()+self.entity:GetUp()*25,self.entity:GetAngles(),frozen)
end

e2function entity propSpawn(entity template, number frozen)
	if not PropCore.ValidAction(self, nil, "spawn") then return nil end
	if not IsValid(template) then return nil end
	return PropCore.CreateProp(self,template:GetModel(),self.entity:GetPos()+self.entity:GetUp()*25,self.entity:GetAngles(),frozen)
end

e2function entity propSpawn(string model, vector pos, number frozen)
	if not PropCore.ValidAction(self, nil, "spawn") then return nil end
	return PropCore.CreateProp(self,model,Vector(pos[1],pos[2],pos[3]),self.entity:GetAngles(),frozen)
end

e2function entity propSpawn(entity template, vector pos, number frozen)
	if not PropCore.ValidAction(self, nil, "spawn") then return nil end
	if not IsValid(template) then return nil end
	return PropCore.CreateProp(self,template:GetModel(),Vector(pos[1],pos[2],pos[3]),self.entity:GetAngles(),frozen)
end

e2function entity propSpawn(string model, angle rot, number frozen)
	if not PropCore.ValidAction(self, nil, "spawn") then return nil end
	return PropCore.CreateProp(self,model,self.entity:GetPos()+self.entity:GetUp()*25,Angle(rot[1],rot[2],rot[3]),frozen)
end

e2function entity propSpawn(entity template, angle rot, number frozen)
	if not PropCore.ValidAction(self, nil, "spawn") then return nil end
	if not IsValid(template) then return nil end
	return PropCore.CreateProp(self,template:GetModel(),self.entity:GetPos()+self.entity:GetUp()*25,Angle(rot[1],rot[2],rot[3]),frozen)
end

e2function entity propSpawn(string model, vector pos, angle rot, number frozen)
	if not PropCore.ValidAction(self, nil, "spawn") then return nil end
	return PropCore.CreateProp(self,model,Vector(pos[1],pos[2],pos[3]),Angle(rot[1],rot[2],rot[3]),frozen)
end

e2function entity propSpawn(entity template, vector pos, angle rot, number frozen)
	if not PropCore.ValidAction(self, nil, "spawn") then return nil end
	if not IsValid(template) then return nil end
	return PropCore.CreateProp(self,template:GetModel(),Vector(pos[1],pos[2],pos[3]),Angle(rot[1],rot[2],rot[3]),frozen)
end

e2function number propCanSpawn()
	if E2tempSpawnedProps >= sbox_E2_maxPropsPerSecond:GetInt() then return 0 end
	return 1
end
--------------------------------------------------------------------------------
e2function void entity:propDelete()
	if not PropCore.ValidAction(self, this, "delete") then return end
	this:Remove()
end

e2function void entity:propBreak()
	if not PropCore.ValidAction(self, this, "break") then return end
	this:Fire("break",1,0)
end

local function removeAllIn( self, tbl )
	local count = 0
	for k,v in pairs( tbl ) do
		if (IsValid(v) and isOwner(self,v) and !v:IsPlayer()) then
			count = count + 1
			v:Remove()
		end
	end
	return count
end

e2function number table:propDelete()
	if not PropCore.ValidAction(self, nil, "Tdelete") then return end

	local count = removeAllIn( self, this.s )
	count = count + removeAllIn( self, this.n )

	self.prf = self.prf + count

	return count
end

e2function number array:propDelete()
	if not PropCore.ValidAction(self, nil, "Tdelete") then return end

	local count = removeAllIn( self, this )

	self.prf = self.prf + count

	return count
end

--------------------------------------------------------------------------------
e2function void entity:propManipulate(vector pos, angle rot, number freeze, number gravity, number notsolid)
	if not PropCore.ValidAction(self, this, "manipulate") then return end
	PropCore.PhysManipulate(this, pos, rot, freeze, gravity, notsolid)
end

e2function void entity:propFreeze(number freeze)
	if not PropCore.ValidAction(self, this, "freeze") then return end
	PropCore.PhysManipulate(this, pos, rot, freeze, gravity, notsolid)
end

e2function void entity:propNotSolid(number notsolid)
	if not PropCore.ValidAction(self, this, "solid") then return end
	PropCore.PhysManipulate(this, pos, rot, freeze, gravity, notsolid)
end

e2function void entity:propGravity(number gravity)
	if not PropCore.ValidAction(self, this, "gravity") then return end
	PropCore.PhysManipulate(this, pos, rot, freeze, gravity, notsolid)
end

e2function void entity:propSleep()
	if not PropCore.ValidAction(self, this, "gravity") then return end
	this:GetPhysicsObject():Sleep()
end
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------

local function parent_check( child, parent )
	while IsValid( parent ) do
		if (child == parent) then
			return false
		end
		parent = parent:GetParent()
	end
	return true
end

e2function void entity:parentTo(entity target)
	if not PropCore.ValidAction(self, this, "parent") then return end
	if not IsValid(target) then return nil end
	if(!isOwner(self, target)) then return end
	if this == target then return end
	if (!parent_check( this, target )) then return end
	this:SetParent(target)
end

e2function void entity:deparent()
	if not PropCore.ValidAction(self, this, "deparent") then return end
	this:SetParent( nil )
end

e2function void propSpawnEffect(number on)
	self.data.propSpawnEffect = on ~= 0
end

registerCallback("construct", function(self)
	self.data.propSpawnEffect = true
end)


-------------------------------PROP_DYN
--Props_dynamic
--prop_dynamic
local sbox_E2_maxProps_dynamicPerSecond = CreateConVar( "sbox_E2_maxProps_dynamicPerSecond", "12", FCVAR_ARCHIVE )
local sbox_E2_maxProps_dynamic = CreateConVar( "sbox_E2_maxProps_dynamic", "300", FCVAR_ARCHIVE )
local Props_dynamicSpawnInSecond=0
local Props_dynamicCount=0

timer.Create( "ResetTempProps_dynamic", 1, 0, function()
Props_dynamicSpawnInSecond=0
end)

function E2_spawn_prop_dynamic(self,this,pos,size,radius)
	
	if Props_dynamicSpawnInSecond >= sbox_E2_maxProps_dynamicPerSecond:GetInt() then return end
	if Props_dynamicCount >= sbox_E2_maxProps_dynamic:GetInt() then return end

	local prop_dynamic=ents.Create("e2_prop_dynamic")
	prop_dynamic:SetModel("models/effects/teleporttrail.mdl")
	prop_dynamic:SetPos(Vector(pos[1],pos[2],pos[3]))
	--prop_dynamic:SetAngles(Angle(0,0,0))
	prop_dynamic:SetColor(255,255,255,0)
	prop_dynamic:SetOwner(self.player)
	if IsValid(this) and isOwner(self,this) then
		prop_dynamic:SetParent( this )
	end
	prop_dynamic.sphere=radius
	if size!=nil then prop_dynamic.size=Vector(size[1],size[2],size[3]) end
	
	prop_dynamic:Spawn()
	prop_dynamic:Activate()
	
	prop_dynamic:CallOnRemove("minus_prop_dynamic",function()
		Props_dynamicCount=Props_dynamicCount-1
	end)
	
	Props_dynamicSpawnInSecond=Props_dynamicSpawnInSecond+1
	Props_dynamicCount=Props_dynamicCount+1

	undo.Create("E2_prop_dynamic")
		undo.AddEntity(prop_dynamic)
		undo.SetPlayer(self.player)
	undo.Finish()

return prop_dynamic
end


__e2setcost(200)
e2function entity entity:propDynamicSpawn(vector pos,vector size)
if !IsValid(this) then return nil end  
if !isOwner(self,this) then return nil end  
return E2_spawn_prop_dynamic(self,this,pos,size,radius)
end

e2function entity propDynamicSpawn(vector pos,vector size)
return E2_spawn_prop_dynamic(self,this,pos,size,radius)
end

e2function entity entity:propDynamicSpawn(vector pos,radius)
if !IsValid(this) then return nil end  
if !isOwner(self,this) then return nil end  
return E2_spawn_prop_dynamic(self,this,pos,size,radius)
end

e2function entity propDynamicSpawn(vector pos,radius)
return E2_spawn_prop_dynamic(self,this,pos,size,radius)
end
