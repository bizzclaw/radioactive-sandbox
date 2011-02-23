
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

ENT.ExplodeSound = { 1, 2, 4, 5, 6, 8 }
ENT.DebrisSound = Sound( "weapons/c4/c4_exp_deb2.wav" )
ENT.DebrisSound2 = Sound( "weapons/debris2.wav" )
ENT.BeepSound = Sound( "weapons/c4/c4_beep1.wav" )
ENT.Damage = 400
ENT.Radius = 600

function ENT:Initialize()

	self.Entity:SetModel( Model( "models/weapons/w_c4.mdl" ) )
	
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	
	self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	self.Entity:DrawShadow( false )
	
	self.Delay = CurTime() + 10
	self.Beep = CurTime() + 1
	
	local phys = self.Entity:GetPhysicsObject()
	
	if ValidEntity( phys ) then
	
		phys:Wake()
	
	end
	
end

function ENT:SetSpeed( num )

	self.Speed = num

end

function ENT:Think()

	if self.Delay < CurTime() then
	
		self.Entity:Explode()
	
	end

	if self.Beep < CurTime() then
	
		self.Beep = CurTime() + 1
		
		self.Entity:EmitSound( self.BeepSound, 100, 120 )
	
	end
	
end

function ENT:Explode()

	self.Entity:EmitSound( "explode_" .. table.Random( self.ExplodeSound ), 300, 100 )
	self.Entity:EmitSound( self.DebrisSound, 300, 100 )
	self.Entity:EmitSound( self.DebrisSound2, 300, 100 )

	local ed = EffectData()
	ed:SetOrigin( self.Entity:GetPos() )
	util.Effect( "c4_explosion", ed, true, true )
	
	local trace = {}
	trace.start = self.Entity:GetPos()
	trace.endpos = trace.start + Vector( 0, 0, -200 )
	trace.filter = self.Entity
	
	local tr = util.TraceLine( trace )

	if tr.HitWorld then
	
		local ed = EffectData()
		ed:SetOrigin( tr.HitPos )
		ed:SetMagnitude( 1.25 )
		util.Effect( "smoke_crater", ed, true, true )
		
		util.Decal( "Scorch", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal )
	
	end
	
	if ValidEntity( self.Entity:GetOwner() ) then
	
		util.BlastDamage( self.Entity, self.Entity:GetOwner(), self.Entity:GetPos(), self.Radius, self.Damage )
		
	end
	
	for k,v in pairs( player.GetAll() ) do
	
		if v:Team() != self.Entity:GetOwner():Team() and v:GetPos():Distance( self.Entity:GetPos() ) < self.Radius then
		
			v:SetBleeding( true )
		
		end
	
	end
	
	self.Entity:Remove()

end

function ENT:OnRemove()

end

function ENT:OnTakeDamage( dmginfo )
	
end

function ENT:PhysicsCollide( data, phys )
	
end

