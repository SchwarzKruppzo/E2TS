--made by [G-moder]FertNoN
---------------------------------------------EFFECT SPAWN

local sbox_E2_maxEffectPerSecond = CreateConVar( "sbox_e2_maxEffectPerSecond", "100", FCVAR_ARCHIVE )
local EffectInSecond=0

timer.Create( "ResetTempEffect", 0.1, 0, function()
EffectInSecond=0
end)

function E2_Spawn_Effect(self, effect, this, pos, start, normal, rot, size)
	
	--if ent!=nil then
	--	if !IsValid(ent)  then return end
	--	if !isOwner(self,ent)  then return end
	--end
	if EffectInSecond >= sbox_E2_maxEffectPerSecond:GetInt() then return end
	local effectdata = EffectData()
	
	if pos!=nil then effectdata:SetOrigin( Vector(pos[1],pos[2],pos[3]) ) end
	if rot!=nil then effectdata:SetAngle(Angle(rot[1],rot[2],rot[3])) end
	if normal!=nil then effectdata:SetNormal( Vector(normal[1],normal[2],normal[3]) ) end
	if size!=nil then effectdata:SetScale( size ) end
	if start!=nil then effectdata:SetStart(Vector(start[1],start[2],start[3])) end
	if this!=nil then effectdata:SetEntity( this ) end

	util.Effect( effect , effectdata )
	
	EffectInSecond=EffectInSecond+1
end

e2function void entity:effectSpawn(string effect,vector pos,vector normal)
	E2_Spawn_Effect(self, effect, this, pos, start, normal, rot, size)
end

e2function void entity:effectSpawn(string effect,vector pos,vector start,angle rot,number size)	
	E2_Spawn_Effect(self, effect, this, pos, start, normal, rot, size)
end

e2function void entity:effectSpawn(string effect,vector pos,vector start,vector normal,number size)	
	E2_Spawn_Effect(self, effect, this, pos, start, normal, rot, size)
end

e2function void entity:effectSpawn(string effect,vector pos,vector normal,number size)	
	E2_Spawn_Effect(self, effect, this, pos, start, normal, rot, size)
end

e2function void effectSpawn(string effect,vector pos,number size)	
	E2_Spawn_Effect(self, effect, this, pos, start, normal, rot, size)
end

e2function void entity:effectSpawn(string effect,vector pos,number size)	
	E2_Spawn_Effect(self, effect, this, pos, start, normal, rot, size)
end

e2function void entity:effectSpawn(string effect,number size)	
	E2_Spawn_Effect(self, effect, this, pos, start, normal, rot, size)
end

----------------------ParticleEffect
local attach = { 
[1]=PATTACH_ABSORIGIN, 
[2]=PATTACH_ABSORIGIN_FOLLOW, 
[3]=PATTACH_CUSTOMORIGIN, 
[4]=PATTACH_POINT, 
[5]=PATTACH_POINT_FOLLOW, 
[6]=PATTACH_WORLDORIGIN }


local sbox_E2_maxParticleEffectPerSecond = CreateConVar( "sbox_e2_maxParticleEffectPerSecond", "100", FCVAR_ARCHIVE )
local ParticleEffectInSecond=0

timer.Create( "ResetTempParticleEffect", 0.1, 0, function()
ParticleEffectInSecond=0
end)

function E2_Spawn_ParticleEffect(self, effect, this, pos, angle)
	
	if ParticleEffectInSecond >= sbox_E2_maxParticleEffectPerSecond:GetInt() then return nil end
	ParticleEffectInSecond=ParticleEffectInSecond+1
	
	if pos!=nil then 
		pos = Vector(pos[1],pos[2],pos[3])
		angle = Angle(angle[1],angle[2],angle[3])
	else
		if !this:IsValid() then return end
		ParticleEffectAttach( effect, PATTACH_ABSORIGIN_FOLLOW, this, 0 )
		return this
	end
	if this==nil then  
		this = ents.Create("e2_empty")
		this:Spawn()
		if not IsValid(this) then return nil end
		this:SetPos(pos)
		this:SetAngles(angle)
		this:SetOwner(self.player)
		
		undo.Create("e2_particleeffect")
			undo.AddEntity( this )
			undo.SetPlayer( self.player )
		undo.Finish()
	end
	ParticleEffect( effect, pos, angle, this )
	return this
end


e2function void entity:particleEffect(string effect,vector pos,angle angle)
	if !IsValid(this) then return end 
	E2_Spawn_ParticleEffect(self, effect, this, pos, angle)
end

e2function entity particleEffect(string effect,vector pos,angle angle)
	return E2_Spawn_ParticleEffect(self, effect, this, pos, angle)
end

e2function void entity:particleEffect(string effect)
	if !IsValid(this) then return end 
	E2_Spawn_ParticleEffect(self, effect, this, pos, angle)
end

e2function void entity:particleEffectStop()
	if !IsValid(this) then return end 
	this:StopParticles()
	if this:GetClass()=="e2_empty" then this:Remove() end
end