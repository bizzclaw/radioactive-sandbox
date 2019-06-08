
include('shared.lua')

function ENT:Initialize()

end

function ENT:Think()
	
end

function ENT:Draw()

	self.Entity:SetModelScale( math.sin( CurTime() * 3 ) * 0.1, 0 )
	self.Entity:DrawModel()
	
end

