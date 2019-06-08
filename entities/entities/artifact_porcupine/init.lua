
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

function ENT:Initialize()
	
	self.Entity:SetModel( "models/srp/items/art_crystalthorn.mdl" )
	
	self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	
	local phys = self.Entity:GetPhysicsObject()
	
	if IsValid( phys ) then

		phys:Wake()

	end
	
	self.Distance = 50
	self.AutoRemove = CurTime() + 600

end

function ENT:Think() 

	for k,v in pairs( player.GetAll() ) do
	
		if v:GetPos():Distance( self.Entity:GetPos() ) < self.Distance then
		
			local phys = self.Entity:GetPhysicsObject()
			
			if IsValid( phys ) then
			
				local dir = ( self.Entity:GetPos() - v:GetPos() ):Normalize()
			
				phys:ApplyForceCenter( dir * phys:GetMass() * 100 )
			
			end
		
		end
	
	end
	
end 

function ENT:Use( ply, caller )
	
	ply:AddToInventory( self.Entity )

end
