AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

ENT.BuybackScale = 0.50
ENT.Team = TEAM_BANDOLIERS

function ENT:Initialize()

	self.Entity:InitializeCharacter()
	
	self.Entity:SetHullSizeNormal()
	self.Entity:SetHullType( HULL_HUMAN )
	
	self.Entity:SetSolid( SOLID_BBOX ) 
	self.Entity:SetMoveType( MOVETYPE_STEP )
	
	self.Entity:SetMaxYawSpeed( 5000 )
	
	self.Entity:CapabilitiesAdd( bit.bor(CAP_ANIMATEDFACE, CAP_TURN_HEAD) )
	
	self.Entity:DropToFloor()
	
	self.LastUse = 0

end

function ENT:InitializeCharacter()

	self.Entity:SetModel( "models/monk.mdl" )
	self.Entity:Give( "weapon_annabelle" )
	
	self.Greet = {"vo/ravenholm/pyre_anotherlife.wav",
	"vo/ravenholm/monk_mourn04.wav",
	"vo/ravenholm/monk_overhere.wav",
	"vo/ravenholm/shotgun_bettergun.wav",
	"vo/ravenholm/shotgun_closer.wav",
	"vo/ravenholm/shotgun_overhere.wav",
	"vo/ravenholm/wrongside_howcome.wav",
	"vo/ravenholm/wrongside_town.wav",
	"vo/ravenholm/yard_greetings.wav",
	"vo/ravenholm/bucket_thereyouare.wav",
	"vo/ravenholm/engage01.wav",
	"vo/ravenholm/engage02.wav",
	"vo/ravenholm/engage03.wav"}

	self.Goodbye = {"vo/ravenholm/pyre_keepeye.wav",
	"vo/ravenholm/bucket_guardwell.wav",
	"vo/ravenholm/monk_kill10.wav",
	"vo/ravenholm/monk_rant17.wav",
	"vo/ravenholm/monk_danger03.wav",
	"vo/ravenholm/exit_goquickly.wav",
	"vo/ravenholm/monk_mourn03.wav"}

	self.Thank = {"vo/ravenholm/firetrap_welldone.wav",
	"vo/ravenholm/madlaugh01.wav",
	"vo/ravenholm/madlaugh02.wav",
	"vo/ravenholm/madlaugh04.wav",
	"vo/ravenholm/shotgun_stirreduphell.wav",
	"vo/ravenholm/cartrap_better.wav"}
	
end

function ENT:GetTraderTeam()

	return self.Team 
	
end

function ENT:GetBuybackScale() 

	return self.BuybackScale

end

function ENT:GetItems()

	return self.Items
	
end

function ENT:AddItem( id )

	self.Items = self.Items or {}

	table.insert( self.Items, id )

end

function ENT:GenerateInventory()

end

function ENT:Think() 
	
	if ( self.ResetInventory or 0 ) < CurTime() then
	
		self.ResetInventory = CurTime() + ( 60 * 5 )
		
		self.Entity:GenerateInventory()
	
	end
	
end 

function ENT:OnUsed( ply )
	
	if ply:Team() == TEAM_LONER then
	
		ply:SetTeam( self.Team )
		ply:SetModel( team.GetPlayerModel( self.Team ) )
		ply:ChatPrint( "You have joined a faction." )
		
		return
	
	end

	if ply:Team() != self.Team then return end
	if ( self.LastUse or 0 ) > CurTime() then return end
	
	local ang = ( ply:GetPos() - self.Entity:GetPos() ):Normalize():Angle()
	ang.p = 0
	
	self.Entity:SetAngles( ang )
	self.Entity:VoiceSound( self.Greet )
	
	ply:NPCMenu()
	ply.Stash = self.Entity
	
	self.LastUse = CurTime() + 1.0

end

function ENT:OnExit( ply )

	if ply:Team() != self.Team then return end
	if ( self.LastUse or 0 ) > CurTime() then return end
	
	self.Entity:VoiceSound( self.Goodbye )
	ply:ToggleStashMenu( self.Entity, false, "StoreMenu", self.Entity:GetBuybackScale() )
	ply.Stash = nil
	
	self.LastUse = CurTime() + 1.0

end

function ENT:VoiceSound( tbl )

	if ( self.VoiceTime or 0 ) > CurTime() then return end

	self.VoiceTime = CurTime() + 3
	
	self.Entity:EmitSound( Sound( table.Random( tbl ) ) )
	
end

function ENT:OnTakeDamage( dmginfo )

	dmginfo:ScaleDamage( 0 )
	
end 

function ENT:GetRelationship( entity )

	return D_LI
	
end

function ENT:SelectSchedule()

	self.Entity:SetSchedule( SCHED_NONE ) 

end
