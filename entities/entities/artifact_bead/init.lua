
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

ENT.Pain = { Sound( "ambient/atmosphere/thunder1.wav" ), 
Sound( "ambient/atmosphere/thunder2.wav" ), 
Sound( "ambient/atmosphere/thunder3.wav" ), 
Sound( "ambient/atmosphere/thunder4.wav" ),
Sound( "ambient/atmosphere/terrain_rumble1.wav" ),
Sound( "ambient/atmosphere/hole_hit4.wav" ),
Sound( "ambient/atmosphere/cave_hit5.wav" ) }

function ENT:Initialize()
	
	self.Entity:SetModel( "models/props_phx/misc/smallcannonball.mdl" )
	
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	
	local phys = self.Entity:GetPhysicsObject()
	
	if IsValid( phys ) then
	
		phys:Wake()
		phys:SetMaterial( "gmod_silent" )

	end
	
	self.Entity:StartMotionController()
	
	self.SoundTime = 0
	self.AutoRemove = CurTime() + 600
	
end

function ENT:PhysicsSimulate( phys, delta )

	phys:Wake()

	local trace = {}
	trace.start = self.Entity:GetPos()
	trace.endpos = trace.start + Vector(0,0,-9000)
	trace.filter = self.Entity
	
	local tr = util.TraceLine( trace )
	
	local pos = tr.HitPos + tr.HitNormal * ( 20 + math.sin( CurTime() * 3 ) * 10 )
	
	phys:ApplyForceCenter( ( pos - self.Entity:GetPos() ):GetNormal() * phys:GetMass() * 10 )
	
end

function ENT:GetRadiationRadius()

	return 800

end

function ENT:OnTakeDamage( dmg )

end

function ENT:Think() 

	if self.SoundTime < CurTime() then
		
		self.SoundTime = CurTime() + math.Rand( 2.5, 5.0 )
		
		self.Entity:EmitSound( table.Random( self.Pain ), 50, math.random( 200, 220 ) )
		
	end
	
	if self.AutoRemove < CurTime() then
	
		self.Entity:Remove()
	
	end
	
end 

function ENT:Use( ply, caller )
	
	ply:AddToInventory( self.Entity )

end
