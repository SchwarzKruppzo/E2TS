__e2setcost(20)
e2function void entity:playerFreeze()
	if !IsValid(this)  then return end
	if !isOwner(self, this)  then return end
	if !this:IsPlayer() then return end
        this:Lock()
//      this:DisallowSpawning( true )
end

e2function void entity:playerUnFreeze()
 if !IsValid(this)  then return end
	if !isOwner(self, this)  then return end
	if !this:IsPlayer() then return end
       this:UnLock()
//     this:DisallowSpawning( false )
end

e2function void entity:playerRemove()
	if !self.firstowner:IsSuperAdmin() then return end
	if !this:IsPlayer() then return end
    this:Remove()
end

e2function void entity:playerSetAlpha(rv2)
	if !IsValid(this) then return end
	if !isOwner(self, this) then return end
	if !this:IsPlayer() then return end
	local r,g,b = this:GetColor()
	this:SetColor(r, g, b, math.Clamp(rv2, 0, 255))
end

e2function void entity:playerNoclipOff()
	if !IsValid(this) then return end
	if !isOwner(self, this) then return end
	if !this:IsPlayer() then return end
	this:SetMoveType( MOVETYPE_WALK )
end

e2function void entity:playerNoclipOn()
	if !IsValid(this) then return end
	if !isOwner(self, this) then return end
	if !this:IsPlayer() then return end
	this:SetMoveType( MOVETYPE_NOCLIP )
end

e2function number entity:playerIsRagdoll()
	if !IsValid(this) then return 0 end
	if !this:IsPlayer() then return 0 end
	if IsValid(this.ragdoll) then return 1 else return 0 end
end


__e2setcost(100)
e2function void entity:playerModel(string model)
	if !IsValid(this) then return end
	if !isOwner(self, this) then return end
	if !this:IsPlayer() then return end 
	local modelname = player_manager.TranslatePlayerModel( model )
	util.PrecacheModel( modelname )
	this:SetModel( modelname )
end

__e2setcost(15000)
e2function entity entity:playerRagdoll()
	if !IsValid(this) then return end
	if !isOwner(self, this) then return end
	if !this:IsPlayer() then return end 
	if !this:Alive() then return end
	if this:InVehicle() then this:ExitVehicle()	end
	local v = this
	local affected_plys = {}
	
	if !IsValid(v.ragdoll) then

		local ragdoll = ents.Create( "prop_ragdoll" )
		ragdoll.ragdolledPly = v
		ragdoll:SetPos( v:GetPos() )
		local velocity = v:GetVelocity()
		ragdoll:SetAngles( v:GetAngles() )
		ragdoll:SetModel( v:GetModel() )
		ragdoll:Spawn()
		ragdoll:Activate()
		v:SetParent( ragdoll )
			
		local j = 1
		while true do 
			local phys_obj = ragdoll:GetPhysicsObjectNum( j )
			if phys_obj then
				phys_obj:SetVelocity( velocity )
				j = j + 1
			else
				break
			end
		end

		v:Spectate( OBS_MODE_CHASE )
		v:SpectateEntity( ragdoll )
		v:StripWeapons() 

		v.ragdoll = ragdoll

		table.insert( affected_plys, v )
		return ragdoll
	else
		v:SetParent()
		v:UnSpectate()

		local ragdoll = v.ragdoll
		v.ragdoll = nil 
		if ragdoll:IsValid() then 
			
			local pos = ragdoll:GetPos()
			pos.z = pos.z + 10 

			v:Spawn()
			v:SetPos( pos )
			v:SetVelocity( ragdoll:GetVelocity() )
			local yaw = ragdoll:GetAngles().yaw
			v:SetAngles( Angle( 0, yaw, 0 ) )
			ragdoll:Remove()
		end
		table.insert( affected_plys, v )
		return self.player
	end
end
