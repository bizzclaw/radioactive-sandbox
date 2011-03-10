if SERVER then

	AddCSLuaFile("shared.lua")
	
end

if CLIENT then

	SWEP.ViewModelFOV		= 74
	SWEP.ViewModelFlip		= true
	
	SWEP.PrintName = "P228 Compact"
	SWEP.IconLetter = "y"
	SWEP.Slot = 1
	SWEP.Slotpos = 1
	
	killicon.AddFont( "rad_p228", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) );
	
end

SWEP.HoldType = "pistol"

SWEP.Base = "rad_base"

SWEP.ViewModel	= "models/weapons/v_pist_p228.mdl"
SWEP.WorldModel = "models/weapons/w_pist_p228.mdl"

SWEP.SprintPos = Vector(-0.8052, 0, 3.0657)
SWEP.SprintAng = Vector(-16.9413, -5.786, 4.0159)

SWEP.IronPos = Vector(4.7607, 0.2693, 2.9149)
SWEP.IronAng = Vector(-0.7388, 0.0586, 0)

SWEP.IsSniper = false
SWEP.AmmoType = "Pistol"

SWEP.Primary.Sound			= Sound( "Weapon_P228.Single" )
SWEP.Primary.Recoil			= 4.5
SWEP.Primary.Damage			= 25
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.038
SWEP.Primary.Delay			= 0.110

SWEP.Primary.ClipSize		= 12
SWEP.Primary.Automatic		= false

SWEP.Primary.ShellType = SHELL_9MM
