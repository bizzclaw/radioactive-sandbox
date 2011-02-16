local PANEL = {}

function PANEL:Init()

	self:ChooseParent()
	self.Stashable = false
	self.StashStyle = "Stash"
	self.PriceScale = 1
	
end

function PANEL:ChooseParent()
	
end

function PANEL:SetPriceScale( scale )

	self.PriceScale = scale

end

function PANEL:SetStashable( bool, style, localinv )

	self.Stashable = bool
	self.StashStyle = style
	self.IsLocalInv = localinv
	
	for k,v in pairs( self:GetItems() ) do
	
		v:SetPriceScale( self.PriceScale )
		v:SetStashable( bool, style )
	
	end

end

function PANEL:HasItem( id )

	for k,v in pairs( self:GetItems() ) do
	
		if v:GetID() == id then
		
			return v
		
		end
	
	end

end

function PANEL:RefreshItems( tbl )

	self:Clear( true )
		
	for k,v in pairs( tbl ) do
	
		local pnl = self:HasItem( v )
	
		if pnl and pnl:IsStackable() then
		
			pnl:AddCount( 1 )
		
		else
		
			local pnl = vgui.Create( "ItemPanel" )
			pnl:SetItemTable( item.GetByID( v ) )
			pnl:SetCount( 1 )
			pnl:SetPriceScale( self.PriceScale )
			pnl:SetStashable( self.Stashable, self.StashStyle )
		
			self:AddItem( pnl )
		
		end
		
	end
	
	if self.StashButton then
	
		self.StashButton:Remove()
		self.StashButton = nil
		
	end
		
	if ( self.StashStyle == "Stash" or self.StashStyle == "Take" ) and not self.IsLocalInv and #self:GetItems() > 0 then
		
		self.StashButton = vgui.Create( "DButton", self )
		self.StashButton:SetText( "Take All" )
		self.StashButton.OnMousePressed = function()
			
			if #self:GetItems() < 1 then return end

			for k,v in pairs( self:GetItems() ) do
				
				RunConsoleCommand( "inv_take", v:GetID(), v:GetCount() )
				
			end
		
		end
	
	end

end

function PANEL:Rebuild()

	local Offset = 0
	
	if ( self.Horizontal ) then
	
		local x, y = self.Padding, self.Padding;
		for k, panel in pairs( self.Items ) do
		
			if ( panel:IsVisible() ) then
			
				local w = 64
				local h = 64
				
				if ( x + w  > self:GetWide() ) then
				
					x = self.Padding
					y = y + h + self.Spacing
				
				end
				
				panel:SetPos( x, y )
				
				x = x + w + self.Spacing
				Offset = y + h + self.Spacing
			
			end
		
		end
	
	else
	
		for k, panel in pairs( self.Items ) do
		
			if ( panel:IsVisible() ) then
				
				if ( self.m_bNoSizing ) then
					panel:SizeToContents()
					panel:SetPos( (self:GetCanvas():GetWide() - panel:GetWide()) * 0.5, self.Padding + Offset )
				else
					panel:SetSize( self:GetCanvas():GetWide() - self.Padding * 2, panel:GetTall() )
					panel:SetPos( self.Padding, self.Padding + Offset )
				end
		
				panel:InvalidateLayout( true )
				
				Offset = Offset + panel:GetTall() + self.Spacing
				
			end
		
		end
		
		Offset = Offset + self.Padding
		
	end
	
	self:GetCanvas():SetTall( self:GetTall() + Offset - self.Spacing ) 

	if ( self.m_bNoSizing && self:GetCanvas():GetTall() < self:GetTall() ) then

		self:GetCanvas():SetPos( 0, (self:GetTall()-self:GetCanvas():GetTall()) * 0.5 )
	
	end
	
	if self.StashButton then
	
		self.StashButton:SetSize( 48, 18 )
		self.StashButton:SetPos( self:GetWide() - self:GetPadding() * 2 - self.StashButton:GetWide(), self:GetTall() - self:GetPadding() * 2 - self.StashButton:GetTall() )
	
	end
	
end

function PANEL:Paint()

	draw.RoundedBox( 4, 0, 0, self:GetWide(), self:GetTall(), Color( 0, 0, 0, 255 ) )
	draw.RoundedBox( 4, 1, 1, self:GetWide() - 2, self:GetTall() - 2, Color( 150, 150, 150, 100 ) )

end

derma.DefineControl( "ItemSheet", "A sheet for storing HUD elements", PANEL, "DPanelList" )
