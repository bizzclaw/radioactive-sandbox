if SERVER then

	AddCSLuaFile( "shared.lua" )
	
	SWEP.Weight				= 1
	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false
	
	SWEP.HoldType = "pistol"
	
end

if CLIENT then

	SWEP.DrawAmmo			= true
	SWEP.DrawCrosshair		= true
	SWEP.CSMuzzleFlashes	= true

	SWEP.ViewModelFOV		= 74
	SWEP.ViewModelFlip		= false
	
	SWEP.PrintName = "Item Placement Tool"
	SWEP.Slot = 5
	SWEP.Slotpos = 5
	
	function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
		
	end
	
end

SWEP.ViewModel	= "models/weapons/v_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"

SWEP.Primary.Swap           = Sound( "weapons/clipempty_rifle.wav" )
SWEP.Primary.Sound			= Sound( "NPC_CombineCamera.Click" )
SWEP.Primary.Delete1		= Sound( "Weapon_StunStick.Melee_Hit" )
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

SWEP.ItemTypes = { "info_player_loner",
"info_player_bandoliers",
"info_player_army",
"info_player_exodus",
"npc_trader_bandoliers",
"npc_trader_army",
"npc_trader_exodus",
"info_lootspawn",
"info_npcspawn",
"point_stash",
"point_radiation" }

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
		
		for k,v in pairs( ents.FindByClass( self.ItemTypes[ self.Weapon:GetNWInt( "ItemType", 1 ) ] ) ) do
		
			if v:GetPos():Distance( tr.HitPos ) < dist then
			
				dist = v:GetPos():Distance( tr.HitPos )
				closest = v
			
			end
		
		end
		
		if ValidEntity( closest ) then
		
			closest:Remove()
			
			self.Owner:EmitSound( self.Primary.Delete1 )
		
		end
		
	end

end

function SWEP:Reload()

	if CLIENT then return end
	
	for k,v in pairs( ents.FindByClass( self.ItemTypes[ self.Weapon:GetNWInt( "ItemType", 1 ) ] ) ) do
	
		v:Remove()
	
	end
	
	self.Owner:EmitSound( self.Primary.Delete )
	
end

function SWEP:Holster()

	if SERVER then
	
		GAMEMODE:SaveAllEnts()
	
	end

	return true

end

function SWEP:ShootEffects()	
	
	self.Owner:MuzzleFlash()								
	self.Owner:SetAnimation( PLAYER_ATTACK1 )	
	
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK ) 
	
end

function SWEP:PlaceItem()

	local itemtype = self.ItemTypes[ self.Weapon:GetNWInt( "ItemType", 1 ) ]
	
	local tr = util.TraceLine( util.GetPlayerTrace( self.Owner ) )
	
	local ent = ents.Create( itemtype )
	ent:SetPos( tr.HitPos + tr.HitNormal * 5 )
	ent:Spawn()

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
	
	if SERVER then
	
		self.Weapon:SetNWInt( "ItemType", self.Weapon:GetNWInt( "ItemType", 1 ) + 1 )
		
		if self.Weapon:GetNWInt( "ItemType", 1 ) > 10 then
		
			self.Weapon:SetNWInt( "ItemType", 1 )
		
		end
	
	end
	
end

function SWEP:DrawHUD()

	draw.SimpleText( "PRIMARY FIRE: Place Item          SECONDARY FIRE: Change Item Type          +USE: Delete Nearest Item Of Current Type          RELOAD: Remove All Of Current Item Type", "AmmoFontSmall", ScrW() * 0.5, ScrH() - 120, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	draw.SimpleText( "CURRENT ITEM TYPE: "..self.ItemTypes[ self.Weapon:GetNWInt( "ItemType", 1 ) ], "AmmoFontSmall", ScrW() * 0.5, ScrH() - 100, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	
	for k,v in pairs( self.ItemTypes ) do

		for c,d in pairs( ents.FindByClass( v ) ) do
		
			local pos = d:GetPos():ToScreen()
			
			if pos.visible then
			
				draw.SimpleText( v, "AmmoFontSmall", pos.x, pos.y - 15, Color(80,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				draw.RoundedBox( 0, pos.x - 2, pos.y - 2, 4, 4, Color(255,255,255) )
			
			end
		
		end
	
	end
	
end

