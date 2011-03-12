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
	
	SWEP.PrintName = "Anomaly Test Tool"
	SWEP.Slot = 5
	SWEP.Slotpos = 9
	
	function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
		
	end
	
end

SWEP.HoldType = "pistol"

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

SWEP.ItemTypes = { "anomaly_whiplash", 
				"anomaly_electro", 
				"anomaly_vortex", 
				"anomaly_warp", 
				"anomaly_hoverstone", 
				"anomaly_deathpearl", 
				"anomaly_cooker",
				"biganomaly_vortex",
				"biganomaly_deathfog"}

function SWEP:Initialize()
	
end

function SWEP:Deploy()

	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	
	return true
	
end  

function SWEP:Think()	

end

function SWEP:Reload()
	
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

	local itemtype = self.ItemTypes[ self.Weapon:GetNWInt( "ItemType", 1 ) ]
	
	local tr = util.TraceLine( util.GetPlayerTrace( self.Owner ) )
	
	local ent = ents.Create( itemtype )
	ent:SetPos( tr.HitPos + tr.HitNormal * 50 )
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
		
		if self.Weapon:GetNWInt( "ItemType", 1 ) > #self.ItemTypes then
		
			self.Weapon:SetNWInt( "ItemType", 1 )
		
		end
	
	end
	
end

function SWEP:DrawHUD()

	draw.SimpleText( "PRIMARY FIRE: Place Anomaly          SECONDARY FIRE: Change Anomaly Type          +USE: Delete Nearest Item Of Current Type          RELOAD: Remove All Of Current Item Type", "AmmoFontSmall", ScrW() * 0.5, ScrH() - 120, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	draw.SimpleText( "CURRENT ANOMALY TYPE: "..self.ItemTypes[ self.Weapon:GetNWInt( "ItemType", 1 ) ], "AmmoFontSmall", ScrW() * 0.5, ScrH() - 100, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	
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

