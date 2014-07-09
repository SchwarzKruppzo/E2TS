include('shared.lua')     

function ENT:Initialize()
	self.Glow = Material(self:GetMaterial())
	self.Glow:SetMaterialInt("$spriterendermode",9)
	self.Glow:SetMaterialInt("$ignorez",1)
	self.Glow:SetMaterialInt("$illumfactor",8)
	self.Glow:SetMaterialFloat("$alpha",0.6)
	self.Glow:SetMaterialInt("$nocull",1)
		
	self.x=self:GetNWFloat("x")
	self.y=self:GetNWFloat("y")
	self.r,self.g,self.b,self.a = self:GetColor()
end

function ENT:Think()
	self.r,self.g,self.b,self.a = self:GetColor()
	self.x=self:GetNWFloat("x")
	self.y=self:GetNWFloat("y")
end

function ENT:Draw()
	render.SetMaterial(self.Glow)
	render.DrawQuadEasy( self:GetPos(),self:GetUp( ), self.x, self.y,Color( self.r,self.g,self.b,self.a ),90) 
end