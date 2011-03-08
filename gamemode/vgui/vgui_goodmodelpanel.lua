/*   _                                
    ( )                               
   _| |   __   _ __   ___ ___     _ _ 
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_) sucks shit

*/
local PANEL = {}

AccessorFunc( PANEL, "m_fAnimSpeed", 	"AnimSpeed" )
AccessorFunc( PANEL, "Entity", 			"Entity" )
AccessorFunc( PANEL, "vCamPos", 		"CamPos" )
AccessorFunc( PANEL, "fFOV", 			"FOV" )
AccessorFunc( PANEL, "vLookatPos", 		"LookAt" )
AccessorFunc( PANEL, "colAmbientLight", "AmbientLight" )
AccessorFunc( PANEL, "colColor", 		"Color" )
AccessorFunc( PANEL, "bAnimated", 		"Animated" )

function PANEL:Init()

	self.Entity = nil
	self.NextModel = ""
	self.StopRender = false
	self.NextSetModel = nil
	self.LastPaint = 0
	self.DirectionalLight = {}
	
	self:SetCamPos( Vector( 50, 50, 50 ) )
	self:SetLookAt( Vector( 0, 0, 40 ) )
	self:SetFOV( 70 )
	
	self:SetText( "" )
	self:SetAnimSpeed( 0.5 )
	self:SetAnimated( false )
	
	self:SetAmbientLight( Color( 50, 50, 50 ) )
	
	self:SetDirectionalLight( BOX_TOP, Color( 255, 255, 255 ) )
	self:SetDirectionalLight( BOX_FRONT, Color( 255, 255, 255 ) )
	
	self:SetColor( Color( 255, 255, 255, 255 ) )

end

function PANEL:SetModel( model )

	if self.NextModel == model then return end
	
	self.NextModel = model
	self.StopRender = true
	self.NextSetModel = CurTime() + 0.01

end

function PANEL:Think()

	if self.NextSetModel and self.NextSetModel < CurTime() then
	
		self:SpecialSetModel( self.NextModel )
		self.StopRender = false
		self.NextSetModel = nil
	
	end

end

function PANEL:SpecialSetModel( model )
	
	if IsValid( self.Entity ) then
	
		self.Entity:Remove()
		self.Entity = nil		
		
	end
	
	if not ClientsideModel then return end
	
	self.LastModel = model
	self.Entity = ClientsideModel( model, RENDERGROUP_OPAQUE )
	
	if not IsValid( self.Entity ) then return end
	
	self.Entity:SetNoDraw( true )
	
	local seq = self:ChooseSequence( model )
	
	if seq > 0 then self.Entity:ResetSequence( seq ) end
	
end

function PANEL:GetSequenceList()

	return { "walk_all", "WalkUnarmed_all", "walk_all_moderate", "idle" }

end

function PANEL:ExcludedModels()

	return { "player", "models/human", "eli", "police" }

end

function PANEL:ChooseSequence( model )

	local seq = 0

	for k,v in pairs( self:ExcludedModels() ) do
		
		if string.find( model, v ) then
			
			return self.Entity:LookupSequence( "idle" ) 
			
		end
		
	end
	
	for k,v in pairs( self:GetSequenceList() ) do
		
		if seq <= 0 then seq = self.Entity:LookupSequence( v ) end
		
	end
	
	return seq

end

function PANEL:Paint()

	if ( !IsValid( self.Entity ) ) then return end
	if self.StopRender then return end
	
	local x, y = self:LocalToScreen( 0, 0 )
	
	self:LayoutEntity( self.Entity )
	
	cam.Start3D( self.vCamPos, (self.vLookatPos-self.vCamPos):Angle(), self.fFOV, x, y, self:GetWide(), self:GetTall() )
	cam.IgnoreZ( true )
	
	render.SuppressEngineLighting( true )
	render.SetLightingOrigin( self.Entity:GetPos() )
	render.ResetModelLighting( self.colAmbientLight.r / 255, self.colAmbientLight.g / 255, self.colAmbientLight.b / 255 )
	render.SetColorModulation( self.colColor.r / 255, self.colColor.g / 255, self.colColor.b / 255 )
	render.SetBlend( self.colColor.a / 255 )
	
	for i=0, 6 do
		local col = self.DirectionalLight[ i ]
		if ( col ) then
			render.SetModelLighting( i, col.r / 255, col.g / 255, col.b / 255 )
		end
	end
	
	if ValidEntity( self.Entity ) then
	
		self.Entity:DrawModel()
		
	end
	
	render.SuppressEngineLighting( false )
	cam.IgnoreZ( false )
	cam.End3D()
	
	self.LastPaint = RealTime()
	
end

function PANEL:LayoutEntity( Entity )

	if self.StopRender then return end

	if ( self.bAnimated ) then
		self:RunAnimation()
	end
	
	Entity:SetAngles( Angle( 0, RealTime() * 10,  0) )

end

derma.DefineControl( "GoodModelPanel", "A panel containing a model that isn't broken and gay", PANEL, "DModelPanel" )
