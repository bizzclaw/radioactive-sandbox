if SERVER then

	AddCSLuaFile("shared.lua")
	
end

if CLIENT then

	SWEP.ViewModelFOV		= 74
	SWEP.ViewModelFlip		= true
	
	SWEP.PrintName = "Glock 18"
	SWEP.IconLetter = "c"
	SWEP.Slot = 1
	SWEP.Slotpos = 1
	
	killicon.AddFont( "rad_glock", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) );
	
end

SWEP.HoldType = "pistol"

SWEP.Base = "rad_base"

SWEP.ViewModel	= "models/weapons/v_pist_glock18.mdl"
SWEP.WorldModel = "models/weapons/w_pist_glock18.mdl"

SWEP.IronPos = Vector (4.3618, 0.5381, 2.8266)
SWEP.IronAng = Vector (0.4921, 0.0041, 0)

SWEP.SprintPos = Vector (0.6553, 0.446, 3.2583)
SWEP.SprintAng = Vector (-15.5938, -2.8864, -1.5457)

SWEP.IsSniper = false
SWEP.AmmoType = "Pistol"

SWEP.Primary.Sound			= Sound( "Weapon_Glock.Single" )
SWEP.Primary.Recoil			= 5.5
SWEP.Primary.Damage			= 24
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.050
SWEP.Primary.Delay			= 0.100

SWEP.Primary.ClipSize		= 17
SWEP.Primary.Automatic		= false

SWEP.Primary.ShellType = SHELL_9MM
