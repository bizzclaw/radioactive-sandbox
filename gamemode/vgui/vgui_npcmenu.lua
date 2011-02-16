local PANEL = {}

function PANEL:Init()

	self:SetTitle( "" )
	self:ShowCloseButton( false )
	self:ChooseParent()
	
	self.Items = {}
	self.TitleText = "Menu"
	
end

function PANEL:AddOption( icon, text, func )

	local button = vgui.Create( "DImageButton", self )
	button:SetImage( icon )
	button:SetSize( 50, 50 )
	button.OnMousePressed = function() func() self:Remove() gui.EnableScreenClicker( false ) end
			
	local label = vgui.Create( "DLabel", self )
	label:SetWrap( true )
	label:SetText( text )
	label:SetFont( "ItemDisplayFont" )
	label:SetSize( 200, 50 )
	
	table.insert( self.Items, { button, label } )
	
	self:InvalidateLayout()

end

function PANEL:SetTitleText( text )

	self.TitleText = text

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
		v[2]:SetPos( x + 50 + self:GetPadding(), y )
		
		y = y + 50 + self:GetPadding()
	
	end
	
	self:SetSize( 250 + self:GetPadding() * 3, y )

end

function PANEL:Paint()

	draw.RoundedBox( 4, 0, 0, self:GetWide(), self:GetTall(), Color( 0, 0, 0, 255 ) )
	draw.RoundedBox( 4, 1, 1, self:GetWide() - 2, self:GetTall() - 2, Color( 150, 150, 150, 150 ) )
	
	draw.SimpleText( self.TitleText, "ItemDisplayFont", self:GetWide() * 0.5, 10, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

end

derma.DefineControl( "NPCMenu", "A NPC menu.", PANEL, "PanelBase" )
