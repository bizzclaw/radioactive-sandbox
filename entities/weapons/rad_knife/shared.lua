if SERVER then

	AddCSLuaFile("shared.lua")
	
end

if CLIENT then

	SWEP.ViewModelFOV		= 70
	SWEP.ViewModelFlip		= false
	
	SWEP.PrintName = "Knife"
	SWEP.IconLetter = "j"
	SWEP.Slot = 0
	SWEP.Slotpos = 0
	
	killicon.AddFont( "rad_knife", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) );
	
end

SWEP.HoldType = "slam"

SWEP.Base = "rad_base"

SWEP.ViewModel			= "models/weapons/v_knife_t.mdl"
SWEP.WorldModel			= "models/weapons/w_knife_t.mdl"

SWEP.SprintPos = Vector(-16.4658, -7.0428, 6.9355)
SWEP.SprintAng = Vector(35.5242, -9.9353, -113.3797)

SWEP.IsSniper = false
SWEP.AmmoType = "Knife"

SWEP.Primary.Hit            = Sound( "Weapon_Knife.HitWall" )
SWEP.Primary.HitFlesh		= Sound( "Weapon_Knife.Stab" )
SWEP.Primary.Sound			= Sound( "Weapon_Knife.Slash" )
SWEP.Primary.Recoil			= 3.5
SWEP.Primary.Damage			= 95
SWEP.Primary.NumShots		= 1
SWEP.Primary.Delay			= 1.100

SWEP.Primary.ClipSize		= 1
SWEP.Primary.Automatic		= true

function SWEP:SecondaryAttack()

end

function SWEP:PrimaryAttack()

	if self.Owner:KeyDown( IN_SPEED ) and self.Owner:GetVelocity():Length() > 0 then return end

	self.Owner:SetLuaAnimation( "shank" )
	
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:MeleeTrace( self.Primary.Damage )
	
end

function SWEP:Think()	

	if self.Owner:GetVelocity():Length() > 0 then
	
		if self.Owner:KeyDown( IN_SPEED ) and self.Owner:GetNWFloat( "Weight", 0 ) < 50 then
		
			self.LastRunFrame = CurTime() + 0.3
			
			if self.InIron and not self.IsSniper then
		
				self.Weapon:SetIron( false )
			
			end
		
		end
		
		if self.Weapon:GetZoomMode() != 1 then
		
			self.Weapon:UnZoom()
			
		end
		
	end
	
	if self.MoveTime and self.MoveTime < CurTime() and SERVER then
	
		self.MoveTime = nil
		self.Weapon:SetZoomMode( self.Weapon:GetZoomMode() + 1 )
		self.Owner:DrawViewModel( false )
		
	end

end

function SWEP:MeleeTrace( dmg )
	
	self.Weapon:SendWeaponAnim( ACT_VM_MISSCENTER )
	
	if CLIENT then return end
	
	local pos = self.Owner:GetShootPos()
	local aim = self.Owner:GetAimVector() * 64
	
	local tr = {}
	tr.start = pos
	tr.endpos = pos + aim
	tr.filter = self.Owner
	tr.mins = Vector(-16,-16,-16)
	tr.maxs = Vector(16,16,16)

	local trace = util.TraceHull( tr )
	local ent = trace.Entity

	if not ValidEntity( ent ) then 
		
		self.Owner:EmitSound( self.Primary.Sound, 100, math.random(90,110) )
		return 
		
	elseif not ent:IsWorld() then
	
		self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )
		
		if ent:IsPlayer() and ent:Team() != self.Owner:Team() then
		
			ent:TakeDamage( dmg, self.Owner, self.Weapon )
			ent:SetBleeding( true )
			ent:EmitSound( self.Primary.HitFlesh, 100, math.random(90,110) )
			
		elseif string.find( ent:GetClass(), "npc" ) then
		
			ent:TakeDamage( 60, self.Owner, self.Weapon )
			ent:EmitSound( self.Primary.HitFlesh, 100, math.random(90,110) )
		
		elseif !ent:IsPlayer() then 
		
			ent:EmitSound( self.Primary.Hit, 100, math.random(90,110) )
			
			local phys = ent:GetPhysicsObject()
			
			if ValidEntity( phys ) then
			
				ent:SetPhysicsAttacker( self.Owner )
				phys:Wake()
				phys:ApplyForceCenter( self.Owner:GetAimVector() * phys:GetMass() * 200 )
				
			end
			
		end
		
	end

end

function SWEP:DrawHUD()
	
end
