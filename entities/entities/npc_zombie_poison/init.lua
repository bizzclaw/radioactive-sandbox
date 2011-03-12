AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')
	
ENT.Damage = 75

ENT.VoiceSounds = {}

ENT.VoiceSounds.Death = {"npc/zombie_poison/pz_die1.wav",
"npc/zombie_poison/pz_die2.wav",
"npc/zombie_poison/pz_idle2.wav",
"npc/zombie_poison/pz_warn2.wav"}

ENT.VoiceSounds.Pain = {"npc/zombie_poison/pz_idle3.wav",
"npc/zombie_poison/pz_idle4.wav",
"npc/zombie_poison/pz_pain1.wav",
"npc/zombie_poison/pz_pain2.wav",
"npc/zombie_poison/pz_pain3.wav",
"npc/zombie_poison/pz_warn1.wav"}

ENT.VoiceSounds.Taunt = {"npc/zombie_poison/pz_alert1.wav",
"npc/zombie_poison/pz_alert2.wav",
"npc/zombie_poison/pz_call1.wav",
"npc/zombie_poison/pz_throw2.wav",
"npc/zombie_poison/pz_throw3.wav"}

ENT.VoiceSounds.Attack = {"npc/zombie_poison/pz_throw2.wav",
"npc/zombie_poison/pz_throw3.wav",
"npc/zombie_poison/pz_alert2.wav"}

util.PrecacheModel( "models/zombie/poison.mdl" )

function ENT:Initialize()

	self.Entity:SetModel( "models/zombie/poison.mdl" )
	
	self.Entity:SetHullSizeNormal()
	self.Entity:SetHullType( HULL_HUMAN )
	
	self.Entity:SetSolid( SOLID_BBOX ) 
	self.Entity:SetMoveType( MOVETYPE_STEP )
	self.Entity:CapabilitiesAdd( CAP_MOVE_GROUND | CAP_INNATE_MELEE_ATTACK1 ) 
	
	self.Entity:SetMaxYawSpeed( 5000 )
	self.Entity:SetHealth( 350 )
	
	self.Entity:ClearSchedule()
	self.Entity:DropToFloor()
	
	self.Entity:UpdateEnemy( self.Entity:FindEnemy() )
	self.Entity:SetSchedule( SCHED_IDLE_WANDER ) 

end

function ENT:OnDamageEnemy( enemy )

	enemy:AddRadiation( 3 )
	enemy:SetBleeding( true )
	enemy:ViewBounce( 15 )

end
