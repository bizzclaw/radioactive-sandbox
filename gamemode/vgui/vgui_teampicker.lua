local PANEL = {}

function PANEL:Init()

	self:SetTitle( "" )
	self:ShowCloseButton( false )
	self:ChooseParent()
	
	self.Items = {}
	
	local allteams = team.GetAllTeams()
	
	for id, info in pairs( allteams ) do
	
		if id != TEAM_CONNECTING and id != TEAM_UNASSIGNED and id != TEAM_SPECTATOR then
		
			local img, tbl = team.GetDescription( id )
		
			local button = vgui.Create( "DImageButton", self )
			button:SetImage( img )
			button:SetSize( 100, 100 )
			button.OnMousePressed = function() RunConsoleCommand( "changeteam", id ) self:Remove() end
			button.ID = id
			
			local text = ""
			
			for k,v in pairs( tbl ) do
			
				text = text..v
			
			end
			
			local label = vgui.Create( "DLabel", self )
			label:SetWrap( true )
			label:SetText( text )
			label:SetFont( "ItemDisplayFont" )
			label:SetSize( 300, 100 )
			
			table.insert( self.Items, { button, label } )
		
		end
		
	end
	
end

function PANEL:ChooseParent()
	
end

function PANEL:GetPadding()
	return 5
end

function PANEL:PerformLayout()

	local x,y = self:GetPadding(), self:GetPadding() + 50

	for k,v in pairs( self.Items ) do
	
		v[1]:SetPos( x, y )
		v[2]:SetPos( x + 100 + self:GetPadding(), y )
		
		y = y + 100 + self:GetPadding()
	
	end
	
	self:SizeToContents()

end

function PANEL:Paint()

	draw.RoundedBox( 4, 0, 0, self:GetWide(), self:GetTall(), Color( 0, 0, 0, 255 ) )
	draw.RoundedBox( 4, 1, 1, self:GetWide() - 2, self:GetTall() - 2, Color( 150, 150, 150, 150 ) )
	
	draw.SimpleText( "Faction Menu", "ItemDisplayFont", self:GetWide() * 0.5, 10, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

end

derma.DefineControl( "TeamPicker", "A team picker menu.", PANEL, "PanelBase" )
