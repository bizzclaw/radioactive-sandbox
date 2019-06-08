
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

ENT.Burn = Sound( "Weapon_FlareGun.Burn" )
ENT.Explode = Sound( "weapons/flashbang/flashbang_explode1.wav" )

function ENT:Initialize()

	self.Entity:SetModel( Model( "models/props_c17/trappropeller_lever.mdl" ) )
	
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	
	self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	self.Entity:DrawShadow( false )
	
	self.Entity:SetNWFloat( "BurnDelay", CurTime() + 3 )
	
	local phys = self.Entity:GetPhysicsObject()
	
	if IsValid( phys ) then
	
		phys:Wake()
		phys:SetDamping( 0, 10 )
	
	end
	
	self.DieTime = CurTime() + 60 * 5
	
	self.Entity:EmitSound( "Weapon_SMG1.Special1", 100, 80 )
	
end

function ENT:Think()

	if self.Entity:GetNWFloat( "BurnDelay", 0 ) < CurTime() then
		
		if not self.Burning then
		
			self.Burning = true
			self.Entity:EmitSound( self.Burn )
			self.Entity:EmitSound( self.Explode, 100, math.random(90,110) )
		
		end
	
	end
	
	if self.DieTime < CurTime() then
	
		self.Entity:Remove()
	
	end

end

function ENT:OnRemove()

	self.Entity:StopSound( self.Burn )

end

function ENT:OnTakeDamage( dmginfo )
	
end

function ENT:PhysicsCollide( data, phys )
	
end

function ENT:UpdateTransmitState()

	return TRANSMIT_ALWAYS 

end

