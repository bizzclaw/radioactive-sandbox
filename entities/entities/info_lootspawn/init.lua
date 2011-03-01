

ENT.Type 			= "anim"
ENT.Base 			= "base_point"

function ENT:Initialize()

	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_NONE )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	
	self.Entity:DrawShadow( false )

end

function ENT:KeyValue( key, value )

end
