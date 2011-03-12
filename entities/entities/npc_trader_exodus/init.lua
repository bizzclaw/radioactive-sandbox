AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

ENT.BuybackScale = 0.40
ENT.Team = TEAM_EXODUS

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
	
	for k,v in pairs( item.GetByType( ITEM_EXODUS ) ) do
	
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
	
	for k,v in pairs( item.GetByType( ITEM_WPN_EXODUS ) ) do
	
		self.Entity:AddItem( v.ID )
	
	end

end

function ENT:InitializeCharacter()

	self.Entity:SetModel( "models/kleiner.mdl" )
	
	self.Greet = {"vo/k_lab/kl_fewmoments01.wav",
	"vo/k_lab/kl_mygoodness01.wav",
	"vo/k_lab/kl_mygoodness03.wav",
	"vo/k_lab/kl_fiddlesticks.wav",
	"vo/k_lab/kl_whatisit.wav",
	"vo/k_lab/kl_holdup02.wav",
	"vo/k_lab2/kl_givenuphope.wav",
	"vo/k_lab2/kl_howandwhen02.wav",
	"vo/k_lab2/kl_cantleavelamarr.wav",
	"vo/trainyard/kl_morewarn01.wav",
	"vo/trainyard/kl_morewarn03.wav",
	"vo/trainyard/kl_whatisit02.wav"}

	self.Goodbye = {"vo/k_lab/kl_bonvoyage.wav",
	"vo/k_lab/kl_dearme.wav",
	"vo/k_lab/kl_excellent.wav",
	"vo/k_lab/kl_fewmoments02.wav",
	"vo/k_lab/kl_ohdear.wav",
	"vo/k_lab2/kl_notallhopeless_b.wav"}

	self.Thank = {"vo/k_lab/kl_excellent.wav",
	"vo/k_lab/kl_moduli02.wav",
	"vo/k_lab/kl_relieved.wav",
	"vo/k_lab/kl_almostforgot.wav",
	"vo/k_lab/kl_nownow02.wav",
	"vo/k_lab2/kl_slowteleport01.wav",
	"vo/k_lab2/kl_slowteleport02.wav"}
	
end