
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

ENT.Awaken = Sound( "ambient/atmosphere/cave_hit5.wav" )

ENT.WaitTime = 5
ENT.KillRadius = 2000
ENT.Damage = 20

function ENT:Initialize()
	
	self.Entity:SetMoveType( MOVETYPE_NONE )
	self.Entity:SetSolid( SOLID_NONE )
	
	self.Entity:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
	self.Entity:SetTrigger( true )
	self.Entity:SetNotSolid( true )
	self.Entity:DrawShadow( false )	
	
	self.Entity:EmitSound( self.Awaken, 500, 80 )
	
	self.Timer = CurTime() + self.WaitTime
	self.KillTime = CurTime() + 60
	self.DamageTimer = 0
	
	local trace = {}
	trace.start = self.Entity:GetPos()
	trace.endpos = trace.start + Vector(2500,2500,0)
	local tr = util.TraceLine( trace )
	
	self.Left = trace.start + Vector(2500,2500,0)
	
	if tr.Hit then
	
		self.Left = tr.HitPos
	
	end
	
	trace = {}
	trace.start = self.Entity:GetPos()
	trace.endpos = trace.start + Vector(-2500,-2500,0)
	tr = util.TraceLine( trace )
	
	self.Right = trace.start + Vector(-2500,-2500,0)
	
	if tr.Hit then
	
		self.Right = tr.HitPos
	
	end
	
	if math.Rand(0,1) < GAMEMODE.ArtifactRarity[ "biganomaly_deathfog" ] then
	
		local ent = ents.Create( "artifact_coral" )
		ent:SetPos( self.Entity:GetPos() )
		ent:Spawn()
		
		local phys = ent:GetPhysicsObject()
		
		if ValidEntity( phys ) then
		
			phys:SetDamping( 20, 20 )
			phys:Wake()
			
		end
		
		self.Artifact = ent

	end
	
end

function ENT:GetRadiationRadius()

	return 3000

end

function ENT:Think()

	if self.Timer > CurTime() then return end
	
	if self.KillTime < CurTime() then
	
		if ValidEntity( self.Artifact ) then
		
			timer.Simple( 30, function( ent ) if ValidEntity( ent ) then ent:Remove() end end, self.Artifact )
		
		end
	
		self.Entity:Remove()
	
	end
	
	for k,v in pairs( player.GetAll() ) do
	
		local pos = v:GetPos()
		pos.z = self.Entity:GetPos().z
		
		if pos:Distance( self.Entity:GetPos() ) < self.KillRadius then
		
			for i=1,3 do
			
				local vec = Vector( math.random( self.Right.x, self.Left.x ), math.random( self.Right.y, self.Left.y ), self.Entity:GetPos().z )
				
				local trace = {}
				trace.start = vec
				trace.endpos = v:GetPos() + Vector(0,0,30)
				trace.filter = self.Entity
				
				local tr = util.TraceLine( trace )
				
				if tr.Entity == v and not v:HasItem( "models/items/combine_rifle_cartridge01.mdl" ) then
				
					v.CoughTimer = v.CoughTimer or 0
					
					if v.CoughTimer < CurTime() then
					
						v:EmitSound( table.Random( GAMEMODE.Coughs ) )
						
						v.CoughTimer = CurTime() + math.Rand( 1.5, 3.0 )
					
					end
					
					if self.DamageTimer < CurTime() then
					
						local dmg = DamageInfo()
						dmg:SetDamage( self.Damage )
						dmg:SetDamageType( DMG_POISON )
						dmg:SetAttacker( self.Entity )
						dmg:SetInflictor( self.Entity )
						
						v:TakeDamageInfo( dmg )
						
					end
				
				end
			end
		end
	end
	
	if self.DamageTimer < CurTime() then
	
		self.DamageTimer = CurTime() + 3
	
	end
	
end
