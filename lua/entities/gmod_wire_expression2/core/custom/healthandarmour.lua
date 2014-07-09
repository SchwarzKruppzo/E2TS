__e2setcost(20)
e2function void entity:setHealth(number Health)
     if !IsValid(this)  then return end
	if !isOwner(self, this)  then return end
	Health=math.Clamp(Health,0, 1000000000)
	this:SetHealth(Health)
end

e2function void entity:setArmor(number Armor)
	if !IsValid(this)  then return end
	if !isOwner(self, this)  then return end
	if !this:IsPlayer() then return end
	Armor=math.Clamp(Armor, 0, 1000000000)
	this:SetArmor(Armor)
end

e2function void entity:takeDamage(number Amount, entity Attacker, entity Inflictor)
	if !IsValid(this)  then return end
	if !isOwner(self, this)  then return end
	this:TakeDamage(Amount, Attacker, Inflictor)
end

e2function void entity:heal(number Health)
	if !IsValid(this)  then return end
	if !isOwner(self, this)  then return end
	if !this:IsPlayer() then return end
	Health=this:Health()+Health
	Health=math.Clamp(Health,0, 1000000000)
	this:SetHealth(Health)
end

e2function void entity:extinguish()
if !IsValid(this) then return end
if !isOwner(self,this)  then return end
this:Extinguish()
end

e2function void entity:ignite(number l)
if !IsValid(this) then return end
if !isOwner(self,this)  then return end
local _length	= math.Max( l , 2 )
this:Ignite( _length, 0 )
end

e2function void entity:setMaxHealth(number Health)
if !IsValid(this) then return end
--if !validPhysics(this) then return end
if !isOwner(self,this)  then return end
this:SetMaxHealth(Health)
this:SetHealth(Health)
end