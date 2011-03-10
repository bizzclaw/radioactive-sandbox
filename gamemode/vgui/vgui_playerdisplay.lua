local PANEL = {}

function PANEL:Init()

	self:ShowCloseButton( false )
	self:SetKeyboardInputEnabled( false )
	self:SetDraggable( false ) 
	
	self.Text = "" 
	self.Title = ""
	self.LastModel = "" 
	
end

function PANEL:SetupCam( campos, origin )

	self.CamPos = campos
	self.Origin = origin
	
end

function PANEL:SetModel( campos, origin )

	if not self.ModelPanel then
	
		self.ModelPanel = vgui.Create( "GoodModelPanel", self )
		
	end
	
	self.ModelPanel:SetModel( LocalPlayer():GetModel() )
	
	if campos then
	
		self.ModelPanel:SetCamPos( campos )
		
	end
	
	if origin then
	
		self.ModelPanel:SetLookAt( origin )
		
	end
	
	self:InvalidateLayout()

end

function PANEL:Think()

	if not ValidEntity( LocalPlayer() ) then return end

	if self.LastModel != LocalPlayer():GetModel() then
	
		self:SetModel( self.CamPos, self.Origin )
		self.LastModel = LocalPlayer():GetModel()
	
	end

end

function PANEL:PerformLayout()
	
	if self.ModelPanel then
	
		local size = math.Min( self:GetWide(), self:GetTall() * 0.85 )
		local pos = ( self:GetWide() - size ) / 2
	
		self.ModelPanel:SetPos( pos, 0 )
		self.ModelPanel:SetSize( size, size )
	
	end

	self:SizeToContents()
	
end

function PANEL:GetStats()

	local tbl = {}
	local weight = math.Round( LocalPlayer():GetNWFloat( "Weight", 0 ) * 100 ) / 100
	
	if weight < GAMEMODE.OptimalWeight then
	
		table.insert( tbl, { "Weight: " .. weight .. " lbs", Color(255,255,255) } )
		
	elseif weight < GAMEMODE.MaxWeight then
	
		table.insert( tbl, { "Weight: " .. weight .. " lbs", Color(255,150,50) } )
		
	else
	
		table.insert( tbl, { "Weight: " .. weight .. " lbs", Color(255,100,100) } )
		
	end
	
	if LocalPlayer():GetNWBool( "Bleeding", false ) then
	
		table.insert( tbl, { "Health Status: Bleeding", Color(255,100,100) } )
		
	elseif LocalPlayer():Health() < 75 then
	
		table.insert( tbl, { "Health Status: Critical", Color(255,100,100) } )
	
	elseif LocalPlayer():Health() < 200 then
	
		table.insert( tbl, { "Health Status: Injured", Color(255,150,50) } )
	
	else
	
		table.insert( tbl, { "Health Status: Normal", Color(255,255,255) } )
		
	end
	
	if LocalPlayer():GetNWInt( "Radiation", 0 ) > 2 then
	
		table.insert( tbl, { "Radiation Levels: Lethal", Color(255,100,100) } )
	
	elseif LocalPlayer():GetNWInt( "Radiation", 0 ) > 0 then
	
		table.insert( tbl, { "Radiation Levels: Elevated", Color(255,150,50) } )
	
	else
	
		table.insert( tbl, { "Radiation Levels: Normal", Color(255,255,255) } )
	
	end
	
	return tbl

end

function PANEL:Paint()

	if not ValidEntity( LocalPlayer() ) then return end

	draw.RoundedBox( 4, 0, 0, self:GetWide(), self:GetTall(), Color( 0, 0, 0, 255 ) )
	draw.RoundedBox( 4, 1, 1, self:GetWide() - 2, self:GetTall() - 2, Color( 150, 150, 150, 100 ) )
	
	surface.SetFont( "ItemDisplayFont" )
	
	for k,v in pairs( self:GetStats() ) do
	
		draw.SimpleText( v[1], "ItemDisplayFont", self:GetWide() * 0.5, self:GetTall() * 0.85 + ( ( k - 1 ) * 18 ), v[2], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	
	end
	
	draw.SimpleText( "Faction: "..team.GetName( LocalPlayer():Team() ), "ItemDisplayFont", self:GetWide() * 0.5, 15, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

end

derma.DefineControl( "PlayerDisplay", "A HUD Element with a big model in the middle and player stats.", PANEL, "PanelBase" )
