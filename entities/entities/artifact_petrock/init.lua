
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

function ENT:Initialize()
	
	self.Entity:SetModel( "models/props_debris/concrete_chunk05g.mdl" )
	
	self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	
	local phys = self.Entity:GetPhysicsObject()
	
	if IsValid( phys ) then
	
		phys:SetMaterial( "wood" )
		phys:Wake()

	end
	
	self.Entity:StartMotionController()
	
	self.Active = false
	self.Distance = 100
	self.Scale = 10
	self.AutoRemove = CurTime() + 600

end

function ENT:PhysicsSimulate( phys, delta )

	if not self.Active then return SIM_NOTHING end
	
	if self.ReActivate then
	
		self.ReActivate = false
		
		phys:ApplyForceCenter( Vector( 0, 0, 1 ) * ( phys:GetMass() * self.Scale ) )
	
	end
	
	local trace = {}
	trace.start = self.Entity:GetPos()
	trace.endpos = trace.start + Vector( 0, 0, -1000 )
	trace.filter = self.Entity
	
	local tr = util.TraceLine( trace )
	
	local dist = tr.HitPos:Distance( tr.StartPos )
	local scale = math.Clamp( self.Distance - dist, 0.25, self.Distance ) / self.Distance
	
	if tr.Hit then
	
		phys:ApplyForceCenter( tr.HitNormal * ( phys:GetMass() * ( scale * self.Scale ) ) )
	
	end

end

function ENT:Think() 

	local active = false

	for k,v in pairs( player.GetAll() ) do
	
		if v:GetPos():Distance( self.Entity:GetPos() ) < 2000 then
		
			active = true
		
		end
	
	end
	
	self.Active = active
	
	if active == false then
	
		self.ReActivate = true
	
	else
	
		local phys = self.Entity:GetPhysicsObject()
	
		if IsValid( phys ) then
	
			phys:Wake()

		end
	
	end
	
	if self.AutoRemove < CurTime() then
	
		self.Entity:Remove()
	
	end
	
end 

function ENT:Use( ply, caller )
	
	ply:AddToInventory( self.Entity )

end
