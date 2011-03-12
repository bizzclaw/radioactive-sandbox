if SERVER then

	AddCSLuaFile("shared.lua")
	
end

if CLIENT then

	SWEP.ViewModelFOV		= 74
	SWEP.ViewModelFlip		= true
	
	SWEP.PrintName = "AWP"
	SWEP.IconLetter = "r"
	SWEP.Slot = 2
	SWEP.Slotpos = 2
	
	killicon.AddFont( "rad_awp", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) );
	
end

SWEP.HoldType = "ar2"

SWEP.Base = "rad_base"

SWEP.ViewModel	= "models/weapons/v_snip_awp.mdl"
SWEP.WorldModel = "models/weapons/w_snip_awp.mdl"

SWEP.SprintPos = Vector(-2.4134, -2.7816, 0.4499)
SWEP.SprintAng = Vector(-4.2748, -48.8937, -0.0962)

SWEP.IronPos = Vector(5.3144, -5.1664, 1.6497)
SWEP.IronAng = Vector(-0.0817, -3.7401, 0.351)

SWEP.ZoomModes = { 0, 35, 5 }
SWEP.ZoomSpeeds = { 0.25, 0.30, 0.30 }

SWEP.IsSniper = true
SWEP.AmmoType = "Sniper"

SWEP.Primary.Sound			= Sound( "Weapon_AWP.Single" )
SWEP.Primary.Recoil			= 15.5
SWEP.Primary.Damage			= 140
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.001
SWEP.Primary.Delay			= 1.500

SWEP.Primary.ClipSize		= 10
SWEP.Primary.Automatic		= false

SWEP.Primary.ShellType = SHELL_50CAL
