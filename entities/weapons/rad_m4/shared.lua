if SERVER then

	AddCSLuaFile("shared.lua")
	
end

if CLIENT then

	SWEP.ViewModelFOV		= 74
	
	SWEP.PrintName = "M4A1"
	SWEP.IconLetter = "w"
	SWEP.Slot = 2
	SWEP.Slotpos = 2
	
	killicon.AddFont( "rad_m4", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) );
	
end

SWEP.HoldType = "ar2"

SWEP.Base = "rad_base"

SWEP.ViewModel = "models/weapons/v_rif_m4a1.mdl"
SWEP.WorldModel = "models/weapons/w_rif_m4a1.mdl"

SWEP.IronPos = Vector (6.024, 0.4309, 0.8493)
SWEP.IronAng = Vector (3.028, 1.3759, 3.5968)

SWEP.SprintPos = Vector (-0.9912, -2.0303, -1.101)
SWEP.SprintAng = Vector (-2.3297, -36.1396, 10.0951)

SWEP.IsSniper = false
SWEP.AmmoType = "Rifle"
SWEP.IronsightsFOV = 60

SWEP.Primary.Sound			= Sound( "Weapon_M4A1.Single" )
SWEP.Primary.Recoil			= 7.5
SWEP.Primary.Damage			= 35
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.030
SWEP.Primary.Delay			= 0.095

SWEP.Primary.ClipSize		= 30
SWEP.Primary.Automatic		= true

SWEP.Primary.ShellType = SHELL_762NATO
