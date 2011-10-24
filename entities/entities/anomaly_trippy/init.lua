
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

ENT.Trip = {"ambient/creatures/seagull_idle1.wav",
"ambient/creatures/seagull_idle2.wav",
"ambient/creatures/seagull_idle3.wav",
"ambient/creatures/seagull_pain1.wav",
"ambient/creatures/seagull_pain2.wav",
"ambient/creatures/seagull_pain3.wav",
"ambient/creatures/flies1.wav",
"ambient/creatures/flies2.wav",
"ambient/creatures/flies3.wav",
"ambient/creatures/flies4.wav",
"ambient/creatures/flies5.wav",
"ambient/creatures/rats1.wav",
"ambient/creatures/rats2.wav",
"ambient/creatures/rats3.wav",
"ambient/creatures/rats4.wav",
"ambient/creatures/teddy.wav",
"ambient/voices/f_scream1.wav",
"ambient/voices/playground_memory.wav",
"npc/barnacle/barnacle_bark1.wav",
"npc/barnacle/barnacle_bark2.wav",
"npc/antlion/attack_single1.wav",
"npc/antlion/attack_double1.wav",
"npc/antlion/attack_double2.wav",
"npc/antlion/attack_double3.wav",
"npc/fast_zombie/fz_frenzy1.wav",
"npc/fast_zombie/fz_scream1.wav",
"npc/headcrab/alert1.wav",
"player/death1.wav",
"player/death2.wav",
"player/death3.wav",
"player/death4.wav",
"player/death5.wav"}

function ENT:Initialize()
	
	self.Entity:SetMoveType( MOVETYPE_NONE )
	self.Entity:SetSolid( SOLID_NONE )
	
	self.Entity:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
	self.Entity:SetTrigger( true )
	self.Entity:SetNotSolid( true )
	self.Entity:DrawShadow( false )	
	
	self.Entity:SetCollisionBounds( Vector( -250, -250, -250 ), Vector( 250, 250, 250 ) )
	self.Entity:PhysicsInitBox( Vector( -250, -250, -250 ), Vector( 250, 250, 250 ) )
	
end

function ENT:SetArtifact( ent )

	self.Artifact = ent

end

function ENT:GetArtifact()

	return self.Artifact or NULL

end

function ENT:GetRadiationRadius()

	return 250

end

function ENT:Touch( ent ) 
	
	if self.SetOff then return end
	
	if ent:IsPlayer() or string.find( ent:GetClass(), "npc" ) or ( string.find( ent:GetClass(), "prop_phys" ) and ent != self.Entity:GetArtifact() ) then
	
		self.SetOff = CurTime() + 3
		
		self.Entity:EmitSound( table.Random( self.Trip ), 100, math.random(20,40) )
		
	end
	
end 

function ENT:Think()
	
	if self.SetOff and self.SetOff < CurTime() then
		
		self.SetOff = nil
	
	end

end
