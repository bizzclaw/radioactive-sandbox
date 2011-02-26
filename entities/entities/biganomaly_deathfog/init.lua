
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

ENT.Awaken = Sound( "ambient/atmosphere/cave_hit5.wav" )

ENT.Coughs = { Sound( "ambient/voices/cough1.wav" ),
Sound( "ambient/voices/cough2.wav" ),
Sound( "ambient/voices/cough3.wav" ),
Sound( "ambient/voices/cough4.wav" ),
Sound( "ambient/voices/citizen_beaten3.wav" ),
Sound( "ambient/voices/citizen_beaten4.wav" ) }

ENT.WaitTime = 5
ENT.KillRadius = 2000
ENT.Damage = 15

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
	
end

function ENT:GetRadiationRadius()

	return 3000

end

function ENT:Think()

	if self.Timer > CurTime() then return end
	
	if self.KillTime < CurTime() then
	
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
					
						v:EmitSound( table.Random( self.Coughs ) )
						
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
