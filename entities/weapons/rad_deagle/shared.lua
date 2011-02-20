if SERVER then

	AddCSLuaFile("shared.lua")
	
end

if CLIENT then

	SWEP.ViewModelFOV		= 74
	SWEP.ViewModelFlip		= true
	
	SWEP.PrintName = "Desert Eagle"
	SWEP.IconLetter = "f"
	SWEP.Slot = 1
	SWEP.Slotpos = 1
	
	killicon.AddFont( "rad_deagle", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) );
	
end

SWEP.HoldType = "pistol"

SWEP.Base = "rad_base"

SWEP.ViewModel	= "models/weapons/v_pist_deagle.mdl"
SWEP.WorldModel = "models/weapons/w_pist_deagle.mdl"

SWEP.IronPos = Vector (5.1378, 1.6550, 2.6575)
SWEP.IronAng = Vector (0.3551, -0.1281, 0.4)

SWEP.SprintPos = Vector (-4.2232, -5.1203, -2.0386)
SWEP.SprintAng = Vector (12.7496, -52.6848, -7.5206)

SWEP.IsSniper = false
SWEP.AmmoType = "Pistol"

SWEP.Primary.Sound			= Sound( "Weapon_Deagle.Single" )
SWEP.Primary.Recoil			= 7.5
SWEP.Primary.Damage			= 32
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.030
SWEP.Primary.Delay			= 0.380

SWEP.Primary.ClipSize		= 7
SWEP.Primary.Automatic		= false

SWEP.Primary.ShellType = SHELL_57
