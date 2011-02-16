AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

ENT.BuybackScale = 0.50
ENT.Team = TEAM_ARMY

function ENT:GenerateInventory()

	self.Items = {}

	for i=1, 4 do
		
		local tbl = item.RandomItem( ITEM_FOOD )
			
		while table.HasValue( self.Items, tbl.ID ) do
			
			tbl = item.RandomItem( ITEM_FOOD )
			
		end
			
		self.Entity:AddItem( tbl.ID )
	
	end
	
	for k,v in pairs( item.GetByType( ITEM_SUPPLY ) ) do
	
		self.Entity:AddItem( v.ID )
	
	end
	
	for k,v in pairs( item.GetByType( ITEM_BUYABLE ) ) do
	
		self.Entity:AddItem( v.ID )
	
	end
	
	for k,v in pairs( item.GetByType( ITEM_MISC ) ) do
	
		self.Entity:AddItem( v.ID )
	
	end
	
	for k,v in pairs( item.GetByType( ITEM_AMMO ) ) do
	
		self.Entity:AddItem( v.ID )
	
	end
	
	for k,v in pairs( item.GetByType( ITEM_WPN_COMMON ) ) do
	
		self.Entity:AddItem( v.ID )
	
	end
	
	for k,v in pairs( item.GetByType( ITEM_WPN_ARMY ) ) do
	
		self.Entity:AddItem( v.ID )
	
	end

end

function ENT:InitializeCharacter()

	self.Entity:SetModel( "models/barney.mdl" )
	
	self.Greet = {"vo/k_lab/ba_thereheis.wav",
	"vo/k_lab/ba_thereyouare.wav",
	"vo/k_lab2/ba_goodnews_b.wav",
	"vo/streetwar/rubble/ba_illbedamned.wav",
	"vo/npc/barney/ba_losttouch.wav",
	"vo/npc/barney/ba_imwithyou.wav"}

	self.Goodbye = {"vo/k_lab/ba_myshift01.wav",
	"vo/streetwar/nexus/ba_done.wav",
	"vo/trainyard/ba_goodluck01.wav",
	"vo/trainyard/ba_meetyoulater01.wav",
	"vo/trainyard/ba_exitnag03.wav",
	"vo/trainyard/ba_exitnag04.wav",
	"vo/trainyard/ba_exitnag05.wav",
	"vo/streetwar/rubble/ba_nag_wall04.wav"}

	self.Thank = {"vo/k_lab/ba_geethanks.wav",
	"vo/k_lab/ba_thingaway01.wav",
	"vo/npc/barney/ba_ohyeah.wav",
	"vo/npc/barney/ba_yell.wav",
	"vo/npc/barney/ba_laugh01.wav",
	"vo/npc/barney/ba_laugh02.wav",
	"vo/npc/barney/ba_laugh03.wav",
	"vo/npc/barney/ba_laugh04.wav"}
	
end