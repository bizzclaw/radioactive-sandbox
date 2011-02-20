if SERVER then

	AddCSLuaFile("shared.lua")
	
end

if CLIENT then

	SWEP.ViewModelFOV		= 74
	
	SWEP.PrintName = "AK-47"
	SWEP.IconLetter = "b"
	SWEP.Slot = 2
	SWEP.Slotpos = 2
	
	killicon.AddFont( "rad_ak47", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) );
	
end

SWEP.HoldType = "ar2"

SWEP.Base = "rad_base"

SWEP.ViewModel = "models/weapons/v_rif_ak47.mdl"
SWEP.WorldModel = "models/weapons/w_rif_ak47.mdl"

SWEP.IronPos = Vector (6.0826, -6.62, 2.4372)
SWEP.IronAng = Vector (2.4946, -0.1113, -0.0844)

SWEP.SprintPos = Vector (-1.3057, -4.167, 0.3971)
SWEP.SprintAng = Vector (-9.8658, -38.0733, 13.8555)

SWEP.IsSniper = false
SWEP.AmmoType = "Rifle"
SWEP.IronsightsFOV = 60

SWEP.Primary.Sound			= Sound( "Weapon_AK47.Single" )
SWEP.Primary.Recoil			= 6.5
SWEP.Primary.Damage			= 32
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.035
SWEP.Primary.Delay			= 0.100

SWEP.Primary.ClipSize		= 30
SWEP.Primary.Automatic		= true

SWEP.Primary.ShellType = SHELL_556
