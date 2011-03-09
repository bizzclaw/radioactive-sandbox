
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

ENT.Teleport = Sound( "ambient/levels/labs/teleport_weird_voices1.wav" )
ENT.Teleport2 = Sound( "ambient/levels/citadel/portal_beam_shoot6.wav" )
ENT.Appear = Sound( "ambient/levels/citadel/weapon_disintegrate4.wav" )
ENT.Triggered = Sound( "npc/turret_floor/active.wav" )

ENT.ZapRadius = 400
ENT.SetOffDelay = 0.5

function ENT:Initialize()
	
	self.Entity:SetMoveType( MOVETYPE_NONE )
	self.Entity:SetSolid( SOLID_NONE )
	
	self.Entity:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
	self.Entity:SetTrigger( true )
	self.Entity:SetNotSolid( true )
	self.Entity:DrawShadow( false )	
	
	self.Entity:SetCollisionBounds( Vector( -150, -150, -150 ), Vector( 150, 150, 150 ) )
	self.Entity:PhysicsInitBox( Vector( -150, -150, -150 ), Vector( 150, 150, 150 ) )
	
	self.NextSetOff = 0
	
end

function ENT:SetArtifact( ent )

	self.Artifact = ent
	self.SetOffDelay = 0.8
	
	ent:SetPos( self.Entity:GetPos() + Vector(0,0,22) )

end

function ENT:GetArtifact()

	return self.Artifact or NULL

end

function ENT:GetRadiationRadius()

	return 200

end

function ENT:Touch( ent ) 
	
	if self.SetOff then return end
	
	if self.NextSetOff > CurTime() then return end
	
	if ent == self.Entity:GetArtifact() then return end
	
	if ent:IsPlayer() or string.find( ent:GetClass(), "npc" ) or string.find( ent:GetClass(), "prop_phys" ) then
	
		self.SetOff = CurTime() + self.SetOffDelay
		
		self.Entity:EmitSound( self.Triggered, 100, math.random(90,110) )
		
	end
	
end 

function ENT:Think()

	if self.SetOff and self.SetOff < CurTime() then
	
		self.Entity:EmitSound( self.Teleport2, 100, math.random(110,130) )
	
		local tbl = ents.FindByClass( "prop_phys*" )
		tbl = table.Add( tbl, ents.FindByClass( "prop_veh*" ) )
		tbl = table.Add( tbl, ents.FindByClass( "npc*" ) )
		tbl = table.Add( tbl, ents.FindByClass( "sent_lootbag" ) )
		tbl = table.Add( tbl, player.GetAll() )
		
		for k,v in pairs( tbl ) do
			
			if v:GetPos():Distance( self.Entity:GetPos() ) < self.ZapRadius and v != self.Entity:GetArtifact() then
				
				self.Entity:TeleportEnt( v )
				
			end
			
		end
		
		self.SetOff = nil
		self.NextSetOff = CurTime() + 2
	
	end

end

function ENT:ChooseDestination()

	local min, max

	for k,v in pairs( ents.FindByClass( "info_lootspawn" ) ) do
	
		local trace = {}
		trace.start = v:GetPos()
		trace.endpos = trace.start + Vector(0,0,90000)
		trace.filter = v
		
		local tr = util.TraceLine( trace )
	
		if tr.HitSky then 
		
			local count = 0
			local pos = self.Entity:GetPos()
			
			while count < 20 and pos:Distance( self.Entity:GetPos() ) < 500 do
		
				local left = {}
				left.start = tr.HitPos
				left.endpos = left.start + Vector( 90000, 0, 0 )
				
				local right = {}
				right.start = tr.HitPos
				right.endpos = right.start + Vector( -90000, 0, 0 )
				
				local ltr = util.TraceLine( left )
				local rtr = util.TraceLine( right )
				
				local north = {}
				north.start = ltr.HitPos
				north.endpos = north.start + Vector( 0, 90000, 0 )
				
				local south = {}
				south.start = rtr.HitPos
				south.endpos = south.start + Vector( 0, -90000, 0 )
				
				local ntr = util.TraceLine( north )
				local str = util.TraceLine( south )
				
				local max = Vector( ltr.HitPos.x, ntr.HitPos.y, tr.HitPos.z - 5 )
				local min = Vector( rtr.HitPos.x, str.HitPos.y, tr.HitPos.z - 5 )
				
				local trace = {}
				trace.start = Vector( math.random( min.x, max.x ), math.random( min.y, max.y ), min.z )
				trace.endpos = Vector( math.random( min.x, max.x ), math.random( min.y, max.y ), min.z - 90000 )
					
				local tr = util.TraceLine( trace )
				
				pos = tr.HitPos 
				count = count + 1

			end
			
			return pos + Vector( 0, 0, 100 )
		
		end
	
	end

end

function ENT:TeleportEnt( ent )

	local min, max = ent:WorldSpaceAABB()

	local ed = EffectData()
	ed:SetOrigin( min )
	ed:SetStart( max )
	ed:SetMagnitude( ent:BoundingRadius() )
	util.Effect( "prop_teleport", ed )

	if string.find( ent:GetClass(), "prop" ) or ent:GetClass() == "sent_lootbag" then
	
		local phys = ent:GetPhysicsObject()
		
		if not ValidEntity( phys ) or not phys:IsMoveable() then return end
	
		ent:SetPos( self.Entity:ChooseDestination() )
		
		local phys = ent:GetPhysicsObject()
		
		if ValidEntity( phys ) then
		
			local vec = VectorRand()
			vec.z = 0.1
		
			phys:ApplyForceCenter( vec * 1000 )
		
		end
	
	else
	
		if ent:IsPlayer() and ValidEntity( ent:GetVehicle() ) and ent:Alive() then

			umsg.Start( "GrenadeHit", ent )
			umsg.End()
		
			ent:SetDSP( 47 )
			ent:EmitSound( self.Teleport, 100, math.random(150,170) )
			ent:EmitSound( self.Appear, 100, math.random(90,110) )
			ent:TakeDamage( 25, self.Entity, self.Entity )
			
			timer.Simple( 5, function( ply ) if ValidEntity( ply ) then ply:SetDSP( 0 ) end end, ent )
			
			local dest = self.Entity:ChooseDestination() + Vector(0,0,300)
			
			ent:GetVehicle():SetPos( dest )
			ent:SetPos( dest )
		
			return 
			
		end
		
		ent:SetPos( self.Entity:ChooseDestination() )
		
		local vec = VectorRand()
		vec.z = 0.1
		
		ent:SetVelocity( vec * 1000 )
		
		if ent:IsPlayer() and ent:Alive() then
		
			umsg.Start( "GrenadeHit", ent )
			umsg.End()
		
			ent:SetDSP( 47 )
			ent:EmitSound( self.Teleport, 100, math.random(150,170) )
			ent:TakeDamage( 50, self.Entity, self.Entity )
			
			timer.Simple( 5, function( ply ) if ValidEntity( ply ) then ply:SetDSP( 0 ) end end, ent )
		
		end
	
	end
	
	ent:EmitSound( self.Appear, 100, math.random(90,110) )
	
end

