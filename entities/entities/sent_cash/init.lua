
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

function ENT:Initialize()
	
	self.Entity:SetModel( Model( "models/props/cs_assault/money.mdl" ) )
	
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	
	self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	
	local phys = self.Entity:GetPhysicsObject()
	
	if IsValid( phys ) then
	
		phys:Wake()

	end
	
	self.Cash = 0
	self.NPCThink = 0
	self.RemoveTime = CurTime() + 10 * 60

end

function ENT:Think() 

	if self.NPCThink < CurTime() then
	
		self.NPCThink = CurTime() + 10
		
		for k,v in pairs( ents.FindByClass( "npc_trader*" ) ) do
		
			if v:GetPos():Distance( self.Entity:GetPos() ) < 50 then
			
				local phys = self.Entity:GetPhysicsObject()
				
				if IsValid( phys ) then
				
					phys:ApplyForceCenter( ( self.Entity:GetPos() - v:GetPos() ):Normalize() * phys:GetMass() * 100 )
					
					return
				
				end
			
			end
		
		end
		
		if self.RemoveTime < CurTime() then
		
			self.Entity:Remove()
		
		end
	
	end
	
end 

function ENT:SetCash( amt )

	self.Cash = amt
	
	self.Entity:SetNWInt( "Cash", amt )
	
end

function ENT:GetCash()

	return self.Cash

end

function ENT:Use( ply, caller )
	
	ply:AddCash( self.Cash )
	
	self.Entity:Remove()

end
