if SERVER then

	AddCSLuaFile("shared.lua")
	
	SWEP.HoldType = "smg"
	
end

if CLIENT then

	SWEP.ViewModelFOV		= 74
	SWEP.ViewModelFlip		= true
	
	SWEP.PrintName = "HK UMP45"
	SWEP.IconLetter = "q"
	SWEP.Slot = 2
	SWEP.Slotpos = 2
	
	killicon.AddFont( "rad_ump45", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) );
	
end

SWEP.Base = "rad_base"

SWEP.ViewModel			= "models/weapons/v_smg_ump45.mdl"
SWEP.WorldModel			= "models/weapons/w_smg_ump45.mdl"

SWEP.SprintPos = Vector (-1.0859, -4.2523, -1.1534)
SWEP.SprintAng = Vector (-4.8822, -38.3984, 14.6527)

SWEP.IronPos = Vector (7.3048, -3.8881, 3.1879)
SWEP.IronAng = Vector (-1.2547, 0.2029, 1.6303)

SWEP.IsSniper = false
SWEP.AmmoType = "SMG"

SWEP.Primary.Sound			= Sound( "Weapon_UMP45.Single" )
SWEP.Primary.Recoil			= 6.5
SWEP.Primary.Damage			= 18
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.045
SWEP.Primary.Delay			= 0.110

SWEP.Primary.ClipSize		= 25
SWEP.Primary.Automatic		= true

SWEP.Primary.ShellType = SHELL_57
