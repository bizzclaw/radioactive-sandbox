
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

ENT.Damage = 15
ENT.Blast = Sound( "ambient/fire/ignite.wav" )
ENT.Death = Sound( "ambient/fire/mtov_flame2.wav" )
ENT.Burn = Sound( "Fire.Plasma" )

function ENT:Initialize()
	
	self.Entity:SetMoveType( MOVETYPE_NONE )
	self.Entity:SetSolid( SOLID_NONE )
	
	self.Entity:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
	self.Entity:SetTrigger( true )
	self.Entity:SetNotSolid( true )
	self.Entity:DrawShadow( false )	
	
	self.Entity:SetCollisionBounds( Vector( -100, -100, -100 ), Vector( 100, 100, 100 ) )
	self.Entity:PhysicsInitBox( Vector( -100, -100, -100 ), Vector( 100, 100, 100 ) )
	
	self.BurnTime = 0
	
end

function ENT:GetRadiationRadius()

	return 200

end

function ENT:Think()

	if self.BurnTime and self.BurnTime >= CurTime() then
		
		local tbl = player.GetAll()
		tbl = table.Add( tbl, ents.FindByClass( "npc*" ) )
		
		for k,ent in pairs( tbl ) do
		
			if ent:GetPos():Distance( self.Entity:GetPos() ) < 150 then
		
				if ent:IsPlayer() then
				
					local dmg = DamageInfo()
					dmg:SetDamage( self.Damage )
					dmg:SetDamageType( DMG_ACID )
					dmg:SetAttacker( self.Entity )
					dmg:SetInflictor( self.Entity )
					
					ent:TakeDamageInfo( dmg )
				
				elseif string.find( ent:GetClass(), "npc" ) then
				
					ent:TakeDamage( self.Damage )
					
				end
				
			end
		
		end
	
	elseif self.BurnTime and self.BurnTime < CurTime() then
	
		self.BurnTime = nil
		
		self.Entity:StopSound( self.Burn )
		self.Entity:EmitSound( self.Death, 150, 100 )
		
		self.Entity:SetNWBool( "Burn", false )
	
	end

end

function ENT:Touch( ent ) 

	if self.BurnTime != nil then

		if self.BurnTime >= CurTime() then 
			
			return 
			
		end
	
	end
	
	self.BurnTime = CurTime() + 10
	
	self.Entity:SetNWBool( "Burn", true )
	
	self.Entity:EmitSound( self.Blast, 150, 100 )
	self.Entity:EmitSound( self.Burn )
	
end 

function ENT:UpdateTransmitState()

	return TRANSMIT_ALWAYS 

end
