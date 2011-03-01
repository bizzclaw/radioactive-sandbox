
local meta = FindMetaTable( "Player" )
if (!meta) then return end 

function meta:GetWeight()
	return self:GetNWFloat( "Weight", 0 ) 
end

function meta:SetWeight( num )
	self:SetNWFloat( "Weight", num )
end

function meta:AddWeight( num )
	self:SetWeight( self:GetWeight() + num ) 
end

function meta:GetAmmo( ammotype )
	return self:GetNWInt( "Ammo"..ammotype, 0 ) 
end

function meta:SetAmmo( ammotype, num )
	self:SetNWInt( "Ammo"..ammotype, num )
end

function meta:AddAmmo( ammotype, num, dropfunc )

	self:SetAmmo( ammotype, self:GetAmmo( ammotype ) + num ) 
	
	for k,v in pairs( item.GetByType( ITEM_AMMO ) ) do
		
		if v.Ammo == ammotype and num < 0 and not dropfunc then
			
			local count = math.floor( self:GetAmmo( ammotype ) / v.Amount )
	
			while self:HasItem( v.ID ) and self:GetItemCount( v.ID ) > count do
				
				self:RemoveFromInventory( v.ID )
			
			end
		
		end
	
	end
	
end

function meta:GetCash()
	return self:GetNWInt( "Cash", 0 ) 
end

function meta:SetCash( num )
	self:SetNWInt( "Cash", num )
end

function meta:AddCash( num, dropfunc )
	
	self:SetCash( self:GetCash() + num ) 
	self:EmitSound( Sound( "Chain.ImpactSoft" ), 100, math.random( 90, 110 ) )
	
	local count = math.floor( self:GetCash() / 20 )
	local tbl = item.GetByModel( "models/props/cs_assault/money.mdl" )
	
	if num < 0 and not dropfunc then
	
		while self:HasItem( tbl.ID ) and self:GetItemCount( tbl.ID ) > count do
				
			self:RemoveFromInventory( tbl.ID )
		
		end
	
	else
		
		while self:GetItemCount( tbl.ID ) < count do
			
			table.insert( self.Inventory, tbl.ID )
			self:AddWeight( tbl.Weight )
			
		end
		
		self:SynchInventory()
	
	end
	
end

function meta:GetStamina()
	return self:GetNWInt( "Stamina", 0 ) 
end

function meta:SetStamina( num )
	self:SetNWInt( "Stamina", math.Clamp( num, 0, 100 ) )
end

function meta:AddStamina( num )
	self:SetStamina( self:GetStamina() + num ) 
end

function meta:GetRadiation()
	return self:GetNWInt( "Radiation", 0 ) 
end

function meta:SetRadiation( num )
	self:SetNWInt( "Radiation", math.Clamp( num, 0, 5 ) )
end

function meta:AddRadiation( num )

	if self:Team() == TEAM_CONNECTING or self:Team() == TEAM_UNASSIGNED or self:Team() == TEAM_SPECTATOR then return end

	if self:HasItem( "models/items/combine_rifle_cartridge01.mdl" ) and num > 0 then return end

	self:SetRadiation( self:GetRadiation() + num ) 
	
end

function meta:AddHealth( num )
	
	if self:Health() + num <= 0 then
	
		self:Kill()
		return
	
	end

	self:SetHealth( math.Clamp( self:Health() + num, 1, self:GetMaxHealth() ) )
	
end

function meta:SetBleeding( bool )

	if bool and ValidEntity( self.Stash ) and ( string.find( self.Stash:GetClass(), "npc" ) or self.Stash:GetClass() == "info_storage" ) then return end

	self:SetNWBool( "Bleeding", bool )
	
end

function meta:IsBleeding()
	return self:GetNWBool( "Bleeding", false )
end

function meta:ViewBounce( scale )
	self:ViewPunch( Angle( math.Rand( -0.2, -0.1 ) * scale, math.Rand( -0.05, 0.05 ) * scale, 0 ) )
end

function meta:SetRadarStaticTarget( ent )

	self:SetDTEntity( 0, ent )
	
	umsg.Start( "StaticTarget", self )
	
	if ent == NULL then
	
		umsg.Vector( Vector(0,0,0) )
		
	else
	
		umsg.Vector( ent:GetPos() )
	
	end
	
	umsg.End()
	
end

function meta:SetRadarTarget( ent )
	self:SetDTEntity( 0, ent )
end

function meta:GetRadarTarget()
	return self:GetDTEntity( 0 ) or NULL
end

function meta:GetTeamTrader()

	return team.GetTrader( self:Team() )

end

function meta:Notify( text )

	self:EmitSound( "npc/metropolice/vo/off1.wav", 50, 100 )
	self:SendLua( "chat.AddText( Color( 150, 150, 150 ), team.GetTraderName(), Color( 255, 255, 255 ), [[: " .. text .. "]] )" )

end

function meta:IsSheltered()

	local tr = util.TraceLine( util.GetPlayerTrace( self, Vector(0,0,1) ) )

	if tr.HitSky or not tr.Hit then return false end
	
	if tr.HitWorld then return true end
	
	for i=1,4 do
	
		local trace = {}
		trace.start = self:GetPos() + Vector(0,0,30)
		trace.endpos = trace.start + ( Angle( 0, 90 * i, 0 ):Forward() ) * 60
		trace.mask = MASK_PLAYERSOLID
		trace.filter = self
		
		local tr = util.TraceLine( trace )
		
		if tr.Hit then
		
			return true
		
		end
	
	end
	
	return false

end

function meta:OnSpawn()

	self:SetMaxHealth( 200 )
	self:SetHealth( 200 )
	
	self:SetStamina( 100 )
	
	self:SetWalkSpeed( 200 )
	self:SetRunSpeed( 300 )
	
	self:SetRadiation( 0 )
	self:SetBleeding( false )

end

function meta:OnLoadout()

	self:Give( "rad_knife" )
	self:Give( "rad_hands" )
	
	if GetConVar( "sv_radbox_allow_build" ):GetBool() then
	
		self:Give( "rad_buildtool" )
		self:Give( "weapon_physgun" )
	
	end
	
	if self:GetInventory()[1] then return end
	
	if not self:GetSavedItems()[1] then

		local model = "models/weapons/w_pist_p228.mdl"

		if self:Team() == TEAM_ARMY then
		
			model = "models/weapons/w_pistol.mdl"
		
		elseif self:Team() == TEAM_BANDOLIERS then
		
			model = "models/weapons/w_pist_glock18.mdl"
		
		end
		
		local gun = ents.Create( "prop_physics" )
		gun:SetPos( self:GetPos() )
		gun:SetModel( model )
		gun:Spawn()
			
		self:AddToInventory( gun )
		
	end
	
	local ammobox = ents.Create( "prop_physics" )
	ammobox:SetPos( self:GetPos() )
	ammobox:SetModel( "models/items/357ammo.mdl" )
	ammobox:Spawn()
	
	self:AddToInventory( ammobox )
	
	local loadout = team.GetItemLoadout( self:Team() )
	local items = {}
	
	for k,v in pairs( loadout ) do
	
		local tbl = item.RandomItem( v )
	
		table.insert( items, tbl.ID )
	
	end
	
	for k,v in pairs( self:GetSavedItems() ) do
	
		table.insert( items, v )
	
	end
	
	self:AddMultipleToInventory( items )
	
end

function meta:GetDroppedItems()

	if #self:GetInventory() < 4 then 
		
		self:SetSavedItems()
	
		return self:GetInventory() 
		
	end
	
	local inv = self:GetInventory()
	local keep = {}
	
	local price = 0
	local thing, pos
	
	for k,v in pairs( inv ) do
		
		local tbl = item.GetByID( v )
			
		if ( tbl.Price or 0 ) > price then
			
			thing = v
			pos = k
			price = tbl.Price
			
		end
		
	end
		
	table.insert( keep, thing )
	table.remove( inv, pos )
	
	self:SetSavedItems( keep )
	
	return inv

end

function meta:SetSavedItems( tbl )

	self.SavedItems = tbl

end

function meta:GetSavedItems()

	return self.SavedItems or {}

end

function meta:DropLoot()

	if not self:GetInventory() then return end
	
	if #self:GetInventory() < 1 then 
		
		self:SetSavedItems()
		
		return 
		
	end

	local ent = ents.Create( "sent_lootbag" )
	
	for k,v in pairs( self:GetDroppedItems() ) do
	
		ent:AddItem( v )
	
	end
	
	ent:SetPos( self:GetPos() + Vector(0,0,25) )
	ent:SetAngles( self:GetForward() )
	ent:SetRemoval( 60 * 5 )
	ent:Spawn()
	
end

function meta:Think()

	if not self:Alive() then return end
	
	if self.InQuest then
	
		local quest = GAMEMODE:GetQuest( self:GetQuestID() )
		
		quest.StatusThink( self )
	
	end
	
	if self:HasItem( "models/items/battery.mdl" ) then
	
		local tbl = ents.FindByClass( "anomaly*" )
		tbl = table.Add( tbl, ents.FindByClass( "biganomaly*" ) )
		tbl = table.Add( tbl, ents.FindByClass( "point_radiation" ) )
	
		for k,v in pairs( tbl ) do
		
			local dist = v:GetPos():Distance( self:GetPos() )
		
			if dist < v:GetRadiationRadius() + 300 and ( v:GetClass() != "point_radiation" or v:IsActive() ) then 
			
				if ( self.WarningTime or 0 ) < CurTime() then
				
					local scale = math.Clamp( ( dist - v:GetRadiationRadius() ) / 300, 0.1, 1.0 )
				
					self.WarningTime = CurTime() + 0.1 + scale * 1.25
					
					self:EmitSound( "radbox/warning.wav", 50, 100 + ( 1 - scale ) * 20 )
				
				end
			
			end
		
		end
	
	end
	
	if ( self.PoisonTime or 0 ) < CurTime() and self:GetRadiation() > 0 then
	
		self.PoisonTime = CurTime() + 1.5
		
		local paintbl = { 0, -1, -2, -3, -3 }
		local stamtbl = { -2, -3, -4, -4, -5 }
	
		self:AddHealth( paintbl[ self:GetRadiation() ] )
		self:AddStamina( stamtbl[ self:GetRadiation() ] )
		
		if self:KeyDown( IN_SPEED ) and self:GetVelocity():Length() > 0 then
		
			self:AddStamina( -2 )
		
		end
	
	end

	if ( self.HealTime or 0 ) < CurTime() then

		self.HealTime = CurTime() + 1.5
		
		if self:IsBleeding() and self:Health() < 100 then
		
			self:AddHealth( -1 )
		
		elseif not self:IsBleeding() then
		
			self:AddHealth( 1 )
		
		end
	
	end
	
	if self:GetRadiation() > 0 then return end
	
	if ( self.StamTime or 0 ) < CurTime() then
		
		if self:GetStamina() < 10 and ( !self:KeyDown( IN_SPEED ) and self:GetVelocity():Length() < 1 ) then
		
			self.StamTime = CurTime() + 2.5
		
		end
		
		if self:KeyDown( IN_SPEED ) and self:GetVelocity():Length() > 0 and self:GetWeight() < GAMEMODE.MaxWeight then
		
			self:AddStamina( -2 )
			self.StamTime = CurTime() + 0.5
		
		elseif self:GetWeight() < GAMEMODE.OptimalWeight then
		
			self:AddStamina( 2 )
			self.StamTime = CurTime() + 1.0
			
		elseif self:GetWeight() < GAMEMODE.MaxWeight then
		
			self:AddStamina( 1 )
			self.StamTime = CurTime() + 1.0
		
		end
	
	end

end

function meta:InitializeInventory()

	self.Inventory = {}
	self:SynchInventory()

end

function meta:GetInventory()

	return self.Inventory or {}
	
end

function meta:SynchInventory()

	datastream.StreamToClients( { self }, "InventorySynch", self:GetInventory() )

end

function meta:AddMultipleToInventory( items )

	for k,v in pairs( items ) do

		local tbl = item.GetByID( v )
		
		if tbl then
		
			if ( tbl.PickupFunction and tbl.PickupFunction( self, tbl.ID ) ) or not tbl.PickupFunction then
			
				table.insert( self.Inventory, tbl.ID )
				self:AddWeight( tbl.Weight )
	
			end
		
		end
	
	end
	
	self:SynchInventory()
	self:EmitSound( Sound( "items/itempickup.wav" ) )

end

function meta:RemoveMultipleFromInventory( items )

	for k,v in pairs( items ) do
	
		local tbl = item.GetByID( v )
	
		for c,d in pairs( self:GetInventory() ) do
		
			if d == v then
				
				self:AddWeight( -tbl.Weight )
		
				table.remove( self.Inventory, c )
				
				break
				
			end
		
		end
	
	end
	
	self:SynchInventory()

end

function meta:AddIDToInventory( id )

	local tbl = item.GetByID( id )
	
	if not tbl then return end
	
	if tbl.PickupFunction then
	
		if not tbl.PickupFunction( self, id ) then return end
	
	end

	table.insert( self.Inventory, id )
	self:AddWeight( tbl.Weight )
	
	self:SynchInventory()
	self:EmitSound( Sound( "items/itempickup.wav" ) )
	
end

function meta:AddToInventory( prop )

	local tbl = item.GetByModel( prop:GetModel() )
	
	if not tbl then return end
	
	if tbl.PickupFunction then
	
		if not tbl.PickupFunction( self, tbl.ID ) then 
		
			if ValidEntity( prop ) then
	
				prop:Remove()
	
			end
		
			return 
			
		end
	
	end

	table.insert( self.Inventory, tbl.ID )
	self:AddWeight( tbl.Weight )
	
	if ValidEntity( prop ) then
	
		prop:Remove()
	
	end
	
	self:SynchInventory()
	self:EmitSound( Sound( "items/itempickup.wav" ) )
	
end

function meta:RemoveFromInventory( id )

	for k,v in pairs( self:GetInventory() ) do
	
		if v == id then		
		
			local tbl = item.GetByID( id )
		
			table.remove( self.Inventory, k )
			
			self:SynchInventory()
			self:AddWeight( -tbl.Weight )
			
			return
		
		end
	
	end

end

function meta:GetItemDropPos()

	local trace = {}
	trace.start = self:GetShootPos()
	trace.endpos = trace.start + self:GetAimVector() * 30
	trace.filter = self
	
	local tr = util.TraceLine( trace )
	
	return tr.HitPos

end

function meta:GetItemCount( id )

	local count = 0

	for k,v in pairs( self:GetInventory() ) do
	
		if v == id then
		
			count = count + 1
		
		end
	
	end
	
	return count

end

function meta:HasItem( thing )

	for k,v in pairs( ( self:GetInventory() ) ) do
	
		local tbl = item.GetByID( v )
	
		if ( type( thing ) == "number" and v == thing ) or ( type( thing ) == "string" and string.lower( tbl.Model ) == string.lower( thing ) ) then
		
			return true
			
		end
		
	end
	
	return false
	
end

function meta:SynchStash( ent )

	datastream.StreamToClients( { self }, "StashSynch", ent:GetItems() )

end

function meta:ToggleStashMenu( ent, open, menutype, pricemod )
	
	if open then
	
		self:SetMoveType( MOVETYPE_NONE )
		self:SynchInventory()
		self:SynchStash( ent )
		self.Stash = ent
	
	else
	
		self:SetMoveType( MOVETYPE_WALK )
		self.Stash = nil
	
	end
	
	umsg.Start( menutype, self )
	umsg.Bool( open )
	
	if pricemod then
		umsg.Float( pricemod )
	end
	
	umsg.End()

end

function meta:DialogueWindow( text )

	umsg.Start( "Dialogue", self )
	umsg.String( text )
	umsg.End()

end

function meta:NPCMenu()

	umsg.Start( "NPCMenu", self )
	umsg.Bool( self.InQuest or false )
	umsg.End()

end

function meta:SetInQuest( bool, num )

	self.InQuest = bool
	self.QuestID = num

end

function meta:GetQuestID()
	return self.QuestID or 0
end

function meta:OnDeath()

	if ValidEntity( self.Stash ) then
	
		self:ToggleStashMenu( self.Stash, false, "StashMenu" )
	
	end

	umsg.Start( "DeathScreen", self )
	umsg.End()
	
	self.Stash = nil
	self.NextSpawn = CurTime() + 15
	
	self:EmitSound( table.Random( GAMEMODE.DeathSounds ) )
	self:DropLoot()
	self:SetWeight( 0 )
	self:SetCash( 0 )
	self.Inventory = {}
	self:SynchInventory()
	
	for k,v in pairs{ "Buckshot", "Rifle", "SMG", "Pistol", "Sniper" } do
	
		self:SetAmmo( v, 0 )
	
	end
	
	local quest = GAMEMODE:GetQuest( self:GetQuestID() )
	
	if quest then
	
		quest.Cancel( self )
		
	end

end