
include('shared.lua')

function ENT:Initialize()

	self.Timer = 0

end

function ENT:OnRemove()

end

function ENT:Think()

	if self.Timer < CurTime() then
	
		self.Timer = CurTime() + math.Rand( 0.1, 2.5 )
	
		local dlight = DynamicLight( self.Entity:EntIndex() )
	
		if dlight then
		
			dlight.Pos = self.Entity:LocalToWorld( self.Entity:OBBCenter() ) + VectorRand() * 10
			dlight.r = 255
			dlight.g = 255
			dlight.b = 255
			dlight.Brightness = 3
			dlight.Decay = 2048
			
			if self.Entity:GetNWBool( "Explode", false ) then
			
				dlight.size = 512
				
			else
			
				dlight.size = 1024
				
				self.Timer = CurTime() + math.Rand( 0.1, 1.0 )
			
			end
			
			dlight.DieTime = CurTime() + 2
			
		end
	
	end
	
end

function ENT:Draw()

	if self.Entity:GetNWBool( "Explode", false ) then
	
		self.Entity:SetModelScale( Vector( math.Rand( 0.8, 1.2 ), math.Rand( 0.8, 1.2 ), math.Rand( 0.8, 1.2 ) ) )
		
	else
	
		self.Entity:SetModelScale( Vector( math.Rand( 0.9, 1.1 ), math.Rand( 0.9, 1.1 ), math.Rand( 0.9, 1.1 ) ) )
	
	end
	
	self.Entity:DrawModel()

end

