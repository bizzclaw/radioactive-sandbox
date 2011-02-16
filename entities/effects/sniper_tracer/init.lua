
EFFECT.Mat = Material( "trails/smoke" )

function EFFECT:Init( data )

	self.Position = data:GetStart()
	self.WeaponEnt = data:GetEntity()
	self.Attachment = data:GetAttachment()
	
	// Keep the start and end pos - we're going to interpolate between them
	self.StartPos = self:GetTracerShootPos( self.Position, self.WeaponEnt, self.Attachment )
	self.EndPos = data:GetOrigin()
	
	self.Entity:SetRenderBoundsWS( self.StartPos, self.EndPos )
	
	self.Alpha = 100
	self.Color = Color( 150, 150, 150, self.Alpha )
	
	if LocalPlayer() == self.WeaponEnt.Owner and LocalPlayer():GetFOV() < 75 then
	
		self.StartPos = LocalPlayer():GetShootPos() + Vector(0,0,-10)
		
	end	

end

function EFFECT:Think( )

	self.Alpha = self.Alpha - FrameTime() * 100
	self.Color = Color( 150, 150, 150, self.Alpha )
	
	return self.Alpha > 0

end

function EFFECT:Render( )

	if self.Alpha < 1 then return end
	
	self.Length = ( self.StartPos - self.EndPos ):Length()
	
	render.SetMaterial( self.Mat )
	render.DrawBeam( self.StartPos, self.EndPos, ( 100 / self.Alpha ) * 0.5 + 0.5, 0, 0, self.Color )

end
