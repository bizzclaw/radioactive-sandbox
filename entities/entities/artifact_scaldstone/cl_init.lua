
include('shared.lua')

ENT.Size = 15

function ENT:Initialize()

	self.Alpha = 0

end

function ENT:Think()

end

local matRefract = Material( "sprites/heatwave" )

function ENT:Draw()
	
	self.Entity:DrawModel()
	
	if render.GetDXLevel() >= 80 then
		
		render.UpdateRefractTexture()
		render.SetMaterial( matRefract )
		render.DrawQuadEasy( self.Entity:LocalToWorld( self.Entity:OBBCenter() ),
					 ( EyePos() - self.Entity:GetPos() ):GetNormal(),
					 self.Size + math.sin( CurTime() ) * 10, self.Size + math.sin( CurTime() ) * 10,
					 Color( 255, 255, 255, 255 ) )
		
	end
	
end