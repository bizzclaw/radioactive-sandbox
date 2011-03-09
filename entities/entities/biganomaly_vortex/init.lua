
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

ENT.PreSuck = Sound( "ambient/levels/labs/teleport_mechanism_windup5.wav" )
ENT.SuckExplode = Sound( "weapons/mortar/mortar_explode2.wav" )
ENT.SuckBang = Sound( "ambient/levels/labs/teleport_postblast_thunder1.wav" )

ENT.WaitTime = 3
ENT.SuckTime = 6
ENT.SuckRadius = 3200
ENT.KillRadius = 600

function ENT:Initialize()
	
	self.Entity:SetMoveType( MOVETYPE_NONE )
	self.Entity:SetSolid( SOLID_NONE )
	
	self.Entity:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
	self.Entity:SetTrigger( true )
	self.Entity:SetNotSolid( true )
	self.Entity:DrawShadow( false )	
		
	self.Entity:SetCollisionBounds( Vector( -4800, -4800, -4800 ), Vector( 4800, 4800, 4800 ) )
	self.Entity:PhysicsInitBox( Vector( -4800, -4800, -4800 ), Vector( 4800, 4800, 4800 ) )
	
	self.VortexPos = self.Entity:GetPos() + Vector( 0, 0, 2000 )
	
end

function ENT:GetRadiationRadius()

	return 5100

end

function ENT:Touch( ent ) 
	
	if self.SetOff then return end
	
	if ent:IsPlayer() or string.find( ent:GetClass(), "npc" ) or string.find( ent:GetClass(), "prop_phys" ) or ent:GetClass() == "sent_lootbag" then
	
		self.SetOff = CurTime() + self.WaitTime
		
		self.Entity:EmitSound( self.PreSuck, 500, 90 )
		self.Entity:SetNWBool( "Suck", true )
		
	end
	
end 

function ENT:Think()

	if self.SetOff and self.SetOff < CurTime() and not self.VortexTime then
	
		self.VortexTime = CurTime() + self.SuckTime
		self.Entity:SetNWBool( "Suck", false )
	
	end
	
	if self.VortexTime and self.VortexTime > CurTime() then
	
		local tbl = ents.FindByClass( "prop_phys*" )
		tbl = table.Add( tbl, ents.FindByClass( "prop_veh*" ) )
		tbl = table.Add( tbl, ents.FindByClass( "npc*" ) )
		tbl = table.Add( tbl, ents.FindByClass( "sent_lootbag" ) )
		tbl = table.Add( tbl, player.GetAll() )
		
		for k,v in pairs( tbl ) do
			
			if v:GetPos():Distance( self.Entity:GetPos() ) < self.SuckRadius then
			
				local vel = ( self.VortexPos - v:GetPos() ):Normalize()
			
				if ( v:IsPlayer() and v:Alive() ) or ( string.find( v:GetClass(), "npc" ) and not string.find( v:GetClass(), "trade" ) ) then
					
					local scale = math.Clamp( ( self.SuckRadius - v:GetPos():Distance( self.VortexPos ) ) / self.SuckRadius, 0.2, 1.0 )
					
					if v:GetPos():Distance( self.VortexPos ) > 80 then
					
						v:SetVelocity( vel * ( scale * 500 ) )
					
					else
					
						v:SetLocalVelocity( vel * ( scale * 500 ) )
					
					end

				else
				
					local phys = v:GetPhysicsObject()
					
					if ValidEntity( phys ) then
					
						phys:ApplyForceCenter( vel * ( phys:GetMass() * 500 ) )
					
					end
				
				end
				
			end
			
		end
			
	elseif self.VortexTime and self.VortexTime < CurTime() then
	
		self.VortexTime = nil
		self.SetOff = nil
		
		self.Entity:EmitSound( self.SuckExplode, 500, math.random(100,120) )
		self.Entity:EmitSound( self.SuckBang, 500, math.random(120,140) )
		
		local ed = EffectData()
		ed:SetOrigin( self.VortexPos )
		util.Effect( "vortex_bigexplode", ed, true, true )
		
		local tbl = ents.FindByClass( "prop_phys*" )
		tbl = table.Add( tbl, ents.FindByClass( "prop_veh*" ) )
		tbl = table.Add( tbl, ents.FindByClass( "npc*" ) )
		tbl = table.Add( tbl, ents.FindByClass( "sent_lootbag" ) )
		tbl = table.Add( tbl, player.GetAll() )
		
		for k,v in pairs( tbl ) do
		
			if v:GetPos():Distance( self.VortexPos ) < self.KillRadius then
			
				if v:IsPlayer() then
				
					if v:Alive() then
				
						v.Inventory = {}
						v:SetModel( "models/shells/shell_9mm.mdl" )
						v:Kill()
						
					end
					
				else
				
					v:Remove()
				
				end
			
			end
		
		end
		
		self.Entity:Remove()
	
	end
	
	self.Entity:NextThink( CurTime() )
	
    return true

end
