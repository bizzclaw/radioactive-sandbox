
include('shared.lua')

ENT.Size = 10

function ENT:Initialize()

	self.Alpha = 0

end

function ENT:Think()

end

local matGlow = Material( "effects/yellowflare" )

function ENT:Draw()

	self.Entity:DrawModel()
	
	self.Alpha = 100 + math.sin( CurTime() ) * 100

	render.SetMaterial( matGlow )
	render.DrawSprite( self.Entity:LocalToWorld( self.Entity:OBBCenter() ), self.Size + math.sin( CurTime() * 2 ) * 2, self.Size + math.sin( CurTime() * 2 ) * 2, Color( 150, 0, 255, self.Alpha ) )
	
end