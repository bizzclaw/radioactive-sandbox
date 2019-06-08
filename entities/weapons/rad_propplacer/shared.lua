if SERVER then

	AddCSLuaFile( "shared.lua" )
	
	SWEP.Weight				= 1
	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false
	
end

if CLIENT then

	SWEP.DrawAmmo			= true
	SWEP.DrawCrosshair		= true
	SWEP.CSMuzzleFlashes	= true

	SWEP.ViewModelFOV		= 74
	SWEP.ViewModelFlip		= false
	
	SWEP.PrintName = "Prop Placement Tool"
	SWEP.Slot = 5
	SWEP.Slotpos = 7
	
	function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
		
	end
	
end

SWEP.HoldType = "pistol"

SWEP.ViewModel	= "models/weapons/v_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"

SWEP.Primary.Swap           = Sound( "weapons/clipempty_rifle.wav" )
SWEP.Primary.Sound			= Sound( "NPC_CombineCamera.Click" )
SWEP.Primary.Delete			= Sound( "Weapon_StunStick.Melee_HitWorld" )

SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= 99999
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.AmmoType = "Knife"

SWEP.PropList = { "models/props_c17/oildrum001.mdl",
"models/props_c17/canister02a.mdl",
"models/props_c17/furniturewashingmachine001a.mdl",
"models/props_c17/pulleywheels_large01.mdl",
"models/props_c17/pulleywheels_small01.mdl",
"models/props_c17/chair02a.mdl",
"models/props_c17/concrete_barrier001a.mdl",
"models/props_c17/door01_left.mdl",
"models/props_c17/fence01a.mdl",
"models/props_c17/fence01b.mdl",
"models/props_c17/fence03a.mdl",
"models/props_c17/lockers001a.mdl",
"models/props_c17/traffic_light001a.mdl",
"models/props_c17/trappropeller_engine.mdl",
"models/props_c17/furniturebathtub001a.mdl",
"models/props_c17/furniturefridge001a.mdl",
"models/props_interiors/refrigerator01a.mdl",
"models/props_interiors/refrigeratordoor01a.mdl",
"models/props_wasteland/cargo_container01.mdl",
"models/props_wasteland/controlroom_storagecloset001a.mdl",
"models/props_wasteland/laundry_cart001.mdl",
"models/props_wasteland/controlroom_chair001a.mdl",
"models/props_wasteland/controlroom_desk001a.mdl",
"models/props_wasteland/controlroom_desk001b.mdl",
"models/props_wasteland/controlroom_filecabinet002a.mdl",
"models/props_wasteland/controlroom_filecabinet001a.mdl",
"models/props_wasteland/laundry_cart002.mdl",
"models/props_wasteland/dockplank01b.mdl",
"models/props_wasteland/barricade001a.mdl",
"models/props_wasteland/barricade002a.mdl",
"models/props_wasteland/wheel01.mdl",
"models/props_wasteland/buoy01.mdl",
"models/props_wasteland/prison_bedframe001b.mdl",
"models/props_vehicles/car001a_hatchback.mdl",
"models/props_vehicles/car001b_hatchback.mdl",
"models/props_vehicles/car002a_physics.mdl",
"models/props_vehicles/car002b_physics.mdl",
"models/props_vehicles/car003a_physics.mdl",
"models/props_vehicles/car003b_physics.mdl",
"models/props_vehicles/car004a_physics.mdl",
"models/props_vehicles/car004b_physics.mdl",
"models/props_vehicles/car005b_physics.mdl",
"models/props_vehicles/van001a_physics.mdl",
"models/props_vehicles/generatortrailer01.mdl",
"models/props_vehicles/trailer002a.mdl",
"models/props_vehicles/truck001a.mdl",
"models/props_vehicles/carparts_door01a.mdl",
"models/props_vehicles/carparts_wheel01a.mdl",
"models/props_vehicles/carparts_tire01a.mdl",
"models/props_vehicles/carparts_axel01a.mdl",
"models/props_vehicles/tire001b_truck.mdl",
"models/props_vehicles/tire001a_tractor.mdl",
"models/props_trainstation/train003.mdl",
"models/props_canal/boat001a.mdl",
"models/props_canal/boat001b.mdl",
"models/props_canal/boat002b.mdl",
"models/props_debris/metal_panel01a.mdl",
"models/props_debris/metal_panel02a.mdl",
"models/props_junk/trashdumpster02b.mdl",
"models/props_junk/ravenholmsign.mdl",
"models/props_junk/ibeam01a.mdl",
"models/props_junk/ibeam01a_cluster01.mdl",
"models/props_junk/wood_pallet001a.mdl",
"models/props_junk/propanecanister001a.mdl",
"models/props_junk/pushcart01a.mdl",
"models/props_junk/cinderblock01a.mdl",
"models/props_junk/wood_crate001a.mdl",
"models/props_junk/wood_crate002a.mdl",
"models/props_junk/trashdumpster01a.mdl",
"models/props_junk/wheebarrow01a.mdl",
"models/props_junk/metalgascan.mdl",
"models/props/de_train/barrel.mdl",
"models/props/de_train/pallet_barrels.mdl",
"models/props/de_prodigy/tirestack.mdl",
"models/props/de_prodigy/tirestack2.mdl",
"models/props/de_prodigy/tirestack3.mdl",
"models/props/de_prodigy/concretebags.mdl",
"models/props/de_prodigy/concretebags2.mdl",
"models/props/de_prodigy/concretebags3.mdl",
"models/props/de_prodigy/concretebags4.mdl",
"models/props/de_prodigy/pushcart.mdl",
"models/props/de_prodigy/spoolwire.mdl",
"models/props/de_prodigy/spool.mdl",
"models/props/de_prodigy/ammo_can_02.mdl",
"models/props/de_prodigy/ammo_can_01.mdl",
"models/props/de_prodigy/ammo_can_03.mdl",
"models/props/de_nuke/cinderblock_stack.mdl",
"models/props/cs_militia/militiarock05.mdl",
"models/props/cs_militia/sawhorse.mdl",
"models/props/cs_militia/table_kitchen.mdl",
"models/props/cs_militia/footlocker01_open.mdl",
"models/props/cs_militia/footlocker01_closed.mdl",
"models/props_junk/MetalBucket01a.mdl",
"models/props_junk/MetalBucket02a.mdl",
"models/props_junk/plasticbucket001a.mdl",
"models/props_wasteland/kitchen_shelf001a.mdl",
"models/props_c17/chair_stool01a.mdl",
"models/props_c17/chair_office01a.mdl",
"models/props_c17/SuitCase001a.mdl",
"models/props_interiors/Radiator01a.mdl",
"models/props_junk/bicycle01a.mdl",
"models/props_lab/citizenradio.mdl",
"models/props_lab/kennel_physics.mdl",
"models/props_lab/partsbin01.mdl",
"models/props_vehicles/carparts_muffler01a.mdl",
"models/props/cs_office/Shelves_metal.mdl",
"models/props_phx/construct/concrete_barrier01.mdl",
"models/props_phx/construct/concrete_barrier00.mdl",
"models/props/cs_assault/HandTruck.mdl",
"models/props/de_nuke/NuclearContainerBoxClosed.mdl",
"models/props/de_nuke/crate_small.mdl",
"models/props_vehicles/trailer001a.mdl",
"models/props_lab/lockers.mdl",
"models/props_trainstation/train002.mdl",
"models/props_vehicles/wagon001a.mdl",
"models/props_wasteland/gear01.mdl",
"models/props_wasteland/cafeteria_bench001a.mdl",
"models/props_wasteland/cafeteria_table001a.mdl",
"models/props/CS_militia/crate_extrasmallmill.mdl",
"models/props/CS_militia/microwave01.mdl",
"models/props/CS_militia/paintbucket01.mdl",
"models/props/CS_militia/refrigerator01.mdl",
"models/props/CS_militia/toilet.mdl",
"models/props/CS_militia/wood_table.mdl",
"models/props/cs_italy/it_mkt_table2.mdl",
"models/props/de_inferno/wine_barrel.mdl",
"models/props_c17/streetsign004f.mdl",
"models/props_c17/FurnitureDresser001a.mdl",
"models/props_vehicles/truck003a.mdl",
"models/Items/car_battery01.mdl",
"models/props_c17/canister_propane01a.mdl",
"models/props_junk/metal_paintcan001b.mdl"}

function SWEP:Initialize()

	if SERVER then
	
		self.Weapon:SetWeaponHoldType( self.HoldType )
		
	end
	
end

function SWEP:Deploy()

	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	
	return true
	
end  

function SWEP:Think()	

	if CLIENT then return end

	if self.Owner:KeyDown( IN_USE ) and ( ( self.NextDel or 0 ) < CurTime() ) then
	
		self.NextDel = CurTime() + 1
		
		local tr = util.TraceLine( util.GetPlayerTrace( self.Owner ) )
		
		local closest
		local dist = 1000
		
		for k,v in pairs( ents.FindByClass( "prop_physics" ) ) do
		
			if v:GetPos():Distance( tr.HitPos ) < dist and v.AdminPlaced then
			
				dist = v:GetPos():Distance( tr.HitPos )
				closest = v
			
			end
		
		end
		
		if IsValid( closest ) then
		
			closest:Remove()
			
			self.Owner:EmitSound( self.Primary.Delete )
		
		end
		
	end

end

function SWEP:Reload()

	if CLIENT then return end
	
	for k,v in pairs( ents.FindByClass( "prop_physics" ) ) do
	
		if v.AdminPlaced then
	
			v:Remove()
			
		end
	
	end
	
	self.Owner:EmitSound( self.Primary.Delete )
	
end

function SWEP:Holster()

	return true

end

function SWEP:ShootEffects()	
	
	self.Owner:MuzzleFlash()								
	self.Owner:SetAnimation( PLAYER_ATTACK1 )	
	
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK ) 
	
end

function SWEP:PlaceItem()
	
	if not self.Owner:IsAdmin() or not self.Owner:IsSuperAdmin() then return end
	
	if not self.Owner.PropPos then self.Owner.PropPos = 1 end
	
	if self.Owner.PropPos < 1 or self.Owner.PropPos > #self.PropList then return end
	
	local tr = util.TraceLine( util.GetPlayerTrace( self.Owner ) )
	
	local ent = ents.Create( "prop_physics" )
	ent:SetPos( tr.HitPos + tr.HitNormal * 50 )
	ent:SetModel( self.PropList[ self.Owner.PropPos ] ) 
	ent:SetSkin( math.random( 0, 6 ) )
	ent:Spawn()
	ent.AdminPlaced = true
	
end

function SWEP:PrimaryAttack()

	self.Weapon:SetNextPrimaryFire( CurTime() + 1 )
	self.Weapon:EmitSound( self.Primary.Sound, 100, math.random(95,105) )
	self.Weapon:ShootEffects()
	
	if SERVER then
	
		self.Weapon:PlaceItem()
		
	end

end

function SWEP:SecondaryAttack()

	self.Weapon:SetNextSecondaryFire( CurTime() + 0.5 )
	
	self.Weapon:EmitSound( self.Primary.Swap )
	
	if CLIENT then
	
		self.Weapon:Menu()
	
	end
	
end

function SWEP:DrawHUD()

	draw.SimpleText( "PRIMARY FIRE: Create Prop          SECONDARY FIRE: Choose Prop Model          +USE: Delete Nearest Prop          RELOAD: Remove All Placed Props", "Default", ScrW() * 0.5, ScrH() - 100, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	
end

if CLIENT then 

	function SWEP:Menu()
	
		if ( self.MenuTime or 0 ) > CurTime() then return end
		
		self.MenuTime = CurTime() + 1
	
		gui.EnableScreenClicker( true )
		
		local frame = vgui.Create( "PanelBase" )
		frame:SetSize( 300, 370 )
		frame:Center()
		frame:ShowCloseButton( false )
		
		local plist = vgui.Create( "DPanelList", frame )
		plist:SetPos( 15, 15 )
		plist:SetSize( 270, 340 )
		plist:SetSpacing( 0 )
		plist:EnableHorizontal( true )
		plist:EnableVerticalScrollbar( true ) 
		
		for k, v in pairs( self.PropList ) do
		
			local icon = vgui.Create( "SpawnIcon", plist )
			icon:SetModel( v )
			icon:SetToolTip()
			icon:SetSize( 64, 64 )
			icon.OnMousePressed = function( mc )
			
				RunConsoleCommand( "chooseprop", tostring( k ) )
				
				gui.EnableScreenClicker( false ) 
				surface.PlaySound( Sound( "buttons/button14.wav" ) )
				
				frame:Remove()
				
			end
			
			plist:AddItem( icon )
			
		end
	
	end

	return 
	
end

function ChooseProp( ply, cmd, args )

	ply.PropPos = tonumber( args[1] )

end

concommand.Add( "chooseprop", ChooseProp )
