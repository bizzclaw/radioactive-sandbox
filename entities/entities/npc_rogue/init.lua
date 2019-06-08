AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

ENT.RemoveTime = 0
ENT.RemovePos = Vector(0,0,0)

function ENT:Initialize()

	self.Entity:InitializeCharacter()
	
	self.Entity:SetHullSizeNormal()
	self.Entity:SetHullType( HULL_HUMAN )
	
	self.Entity:SetSolid( SOLID_BBOX ) 
	self.Entity:SetMoveType( MOVETYPE_STEP )
	
	self.Entity:SetMaxYawSpeed( 5000 )
	self.Entity:SetHealth( 100 )
	
	self.Entity:CapabilitiesAdd( bit.bor(CAP_MOVE_GROUND, CAP_TURN_HEAD, CAP_USE_WEAPONS, CAP_AIM_GUN, CAP_WEAPON_RANGE_ATTACK1, CAP_MOVE_SHOOT, CAP_OPEN_DOORS) ) 
	
	self.Entity:DropToFloor()
	self.Entity:Give( "rad_npcgun" .. math.random(1,2) )

end

function ENT:InitializeCharacter()

	self.Entity:SetModel( "models/Humans/Group03/Male_0" .. math.random( 1, 9 ) .. ".mdl" )
	
	self.Items = {}
	
	local tbl = { ITEM_FOOD, ITEM_SUPPLY, ITEM_LOOT, ITEM_AMMO, ITEM_MISC, ITEM_EXODUS, ITEM_WPN_COMMON }
	local chancetbl = { 1.00,    0.80,        0.20,      0.40,     0.60,       0.05,          0.05 }
	
	for i=1, math.random(3,6) do
	
		local num = math.Rand(0,1)
		local choice = math.random(1,7)
	
		while num > chancetbl[ choice ] do
		
			num = math.Rand(0,1)
			choice = math.random(1,7)
		
		end
		
		local rand = item.RandomItem( tbl[choice] )
	
		table.insert( self.Items, rand.ID )
	
	end
	
end

function ENT:Think()

	if self.RemoveTimer and self.RemoveTimer < CurTime() then
	
		self.Entity:Remove()
	
	end
	
	if self.RemoveTime < CurTime() then
	
		if self.Entity:GetPos() == self.RemovePos then

			self.Entity:Remove()
			
		end
		
		self.RemoveTime = CurTime() + 30
		self.RemovePos = self.Entity:GetPos()
	
	end
	
	if self.Entity:GetCurrentSchedule() == SCHED_RANGE_ATTACK1 then
	
		local wep = self.Entity:GetActiveWeapon()
		
		if IsValid( wep ) then
		
			wep:PrimaryAttack()
			
		end
	
	end
	
end

function ENT:SpawnRagdoll( att, model )
	
	self.Entity:Fire( "BecomeRagdoll", "", 0 )
	
	if not IsValid( att ) or not att:IsPlayer() then return end
	
	local ent = ents.Create( "sent_lootbag" )
	
	for k,v in pairs( self.Items ) do
	
		ent:AddItem( v )
	
	end
	
	ent:SetPos( self.Entity:GetPos() + Vector(0,0,25) )
	ent:SetRemoval( 60 * 3 )
	ent:Spawn()

end

function ENT:DoDeath( dmginfo )

	if self.Dying then return end
	
	self.Dying = true
	self.RemoveTimer = CurTime() + 1

	if not dmginfo then
	
		self.Entity:SpawnRagdoll( self.Entity )
	
	else
	
		self.Entity:SpawnRagdoll( dmginfo:GetAttacker() )
	
	end
	
	self.Entity:Give( "rad_npcdummy" )
	self.Entity:VoiceSound( GAMEMODE.DeathSounds )
	self.Entity:SetSchedule( SCHED_FALL_TO_GROUND )
	
end

function ENT:VoiceSound( tbl )

	if ( self.VoiceTime or 0 ) > CurTime() then return end

	self.VoiceTime = CurTime() + 2
	
	self.Entity:EmitSound( Sound( table.Random( tbl ) ) )
	
end

function ENT:OnTakeDamage( dmginfo )
	
	self.Entity:SetHealth( math.Clamp( self.Entity:Health() - dmginfo:GetDamage(), 0, 1000 ) )
	
	if self.Entity:Health() < 1 then
	
		self.Entity:DoDeath( dmginfo )
		
	end
	
end 

function ENT:GetRelationship( entity )

	if entity:IsPlayer() or string.find( entity:GetClass(), "npc_zombie" ) then
	
		return D_HT
	
	end

	return D_LI
	
end

function ENT:UpdateEnemy( enemy )

	if IsValid( enemy ) and ( ( enemy:IsPlayer() and enemy:Alive() ) or string.find( enemy:GetClass(), "npc_zombie" ) ) then
		
		self.Entity:SetEnemy( enemy, true ) 
		self.Entity:UpdateEnemyMemory( enemy, enemy:GetPos() ) 
		
	else
		
		self.Entity:SetEnemy( NULL )
		
	end

end

function ENT:FindEnemy()

	local tbl = ents.FindByClass( "npc_zombie*" )
	tbl = table.Add( tbl, player.GetAll() )

	if #tbl < 1 then
		
		return NULL
		
	else
	
		local enemy = NULL
		local dist = 99999
		
		for k,v in pairs( tbl ) do
		
			local compare = v:GetPos():Distance( self.Entity:GetPos() )
			
			if compare < dist and ( ( v:IsPlayer() and v:Alive() and v:Team() != TEAM_UNASSIGNED ) or string.find( v:GetClass(), "npc" ) ) then
			
				enemy = v
				dist = compare
				
			end
			
		end
		
		return enemy
		
	end
	
end

function ENT:SelectSchedule()

	local enemy = self.Entity:GetEnemy()
	local sched = SCHED_IDLE_WANDER 
	
	if IsValid( enemy ) and enemy:GetPos():Distance( self.Entity:GetPos() ) < 2000 then
	
		if self.Entity:HasCondition( COND_CAN_RANGE_ATTACK1 or 21 ) then 
		
			sched = SCHED_RANGE_ATTACK1
			
		else
		
			sched = SCHED_CHASE_ENEMY
			
		end
		
	else
	
		self.Entity:UpdateEnemy( self.Entity:FindEnemy() )
		
	end

	self.Entity:SetSchedule( sched ) 
	self.Entity:SetCurrentSchedule( sched )

end

function ENT:SetCurrentSchedule( sched )

	self.CurrSched = sched
	
end

function ENT:GetCurrentSchedule() 

	return self.CurrSched or SCHED_IDLE_WANDER 
	
end
