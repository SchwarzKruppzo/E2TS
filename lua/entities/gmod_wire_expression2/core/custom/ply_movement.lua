__e2setcost(20)

e2function void entity:plyRunSpeed(number speed)
	if !IsValid(this)  then return end
	if !isOwner(self, this)  then return end
	if !this:IsPlayer() then return end
	speed=math.Clamp(speed, 0, 90000)
	if (speed > 0) then
		this:SetRunSpeed(speed)
	else
		this:SetRunSpeed(500)
	end
end

e2function void entity:plyWalkSpeed(number speed)
	if !IsValid(this)  then return end
	if !isOwner(self, this)  then return end
	if !this:IsPlayer() then return end
	speed=math.Clamp(speed, 0, 90000)
	if (speed > 0) then
		this:SetWalkSpeed(speed)
	else
		this:SetWalkSpeed(250)
	end
end

e2function void entity:plyJumpPower(number power)
	if !IsValid(this)  then return end
	if !isOwner(self, this)  then return end
	if !this:IsPlayer() then return end
	power=math.Clamp(power, 0, 90000)
	if (power > 0) then
		this:SetJumpPower(power)
	else
		this:SetJumpPower(160)
	end
end

e2function void entity:plyCrouchWalkSpeed(number speed)
	if !IsValid(this)  then return end
	if !isOwner(self, this)  then return end
	if !this:IsPlayer() then return end
	speed=math.Clamp(speed, 0.01, 10)
	this:SetCrouchedWalkSpeed(speed)
end

e2function number entity:plyGetMaxSpeed()
	if not IsValid(this) then return end
	if (!this:IsPlayer()) then return end
	return this:GetMaxSpeed()
end

e2function number entity:plyGetJumpPower()
	if not IsValid(this) then return end
	if (!this:IsPlayer()) then return end
	return this:GetJumpPower()
end
