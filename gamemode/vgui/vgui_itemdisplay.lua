local PANEL = {}

function PANEL:Init()

	self:ShowCloseButton( false )
	self:SetKeyboardInputEnabled( false )
	self:SetDraggable( false ) 
	
	self.Text = "Click an item to see its description." 
	self.Title = ""
	self.Style = "Stash"
	self.PriceScale = 1
	self.Price = 0
	self.Weight = 0
	
end

function PANEL:SetItemDesc( text, title, style, scale, price, weight )

	self.Text = text
	self.Title = title
	self.Style = style
	self.PriceScale = scale
	self.Price = price
	self.Weight = weight

end

function PANEL:SetModel( model, campos, origin )

	if not self.ModelPanel then
	
		self.ModelPanel = vgui.Create( "GoodModelPanel", self )
		
	end
	
	self.ModelPanel:SetModel( model )
	self.ModelPanel:SetCamPos( Vector(20,10,5) )
	self.ModelPanel:SetLookAt( Vector(0,0,0) )
	
	if string.find( model, "models/weapons/w_" ) then
	
		self.ModelPanel.LayoutEntity = function( this, ent ) if IsValid( ent ) then ent:SetAngles( Angle( 0, 0, 0 ) ) end end
		
	else
	
		self.ModelPanel.LayoutEntity = function( this, ent ) if IsValid( ent ) then ent:SetAngles( Angle( 0, RealTime() * 10, 0 ) ) end end
	
	end
	
	if campos then
	
		self.ModelPanel:SetCamPos( campos )
		
	end
	
	if origin then
	
		self.ModelPanel:SetLookAt( origin )
		
	end
	
	self:InvalidateLayout()

end

function PANEL:OnMousePressed( mc )

end

function PANEL:Think()

	local tbl, style, scale = GAMEMODE:GetItemToPreview()
	
	if tbl then
		
		self:SetModel( tbl.Model, tbl.CamPos, tbl.CamOrigin )
		self:SetItemDesc( tbl.Description, tbl.Name, style, scale, tbl.Price, tbl.Weight )
		
		GAMEMODE:SetItemToPreview()
		
	end

end

function PANEL:PerformLayout()
	
	if self.ModelPanel then
	
		local size = math.Min( self:GetWide(), self:GetTall() * 0.85 )
		local pos = ( self:GetWide() - size ) / 2
	
		self.ModelPanel:SetPos( pos, 10 )
		self.ModelPanel:SetSize( size, size )
	
	end

	self:SizeToContents()
	
end

function PANEL:Paint()

	draw.RoundedBox( 4, 0, 0, self:GetWide(), self:GetTall(), Color( 0, 0, 0, 255 ) )
	draw.RoundedBox( 4, 1, 1, self:GetWide() - 2, self:GetTall() - 2, Color( 150, 150, 150, 100 ) )
	
	draw.RoundedBox( 4, 10, ( self:GetTall() * 0.85 ) - 10, self:GetWide() - 20, self:GetTall() * 0.15, Color( 0, 0, 0, 255 ) )
	draw.RoundedBox( 4, 11, ( self:GetTall() * 0.85 ) - 9, self:GetWide() - 22, self:GetTall() * 0.15 - 2, Color( 150, 150, 150, 150 ) )
	
	surface.SetFont( "Trebuchet18" )
	
	local tbl = string.Explode( " ", self.Text )
	local str = { "" } 
	local pos = 1
	
	for k,v in pairs( tbl ) do
		
		local test = str[pos] .. " " .. v
		local size = surface.GetTextSize( test )
		
		if size > self:GetWide() - 40 then
		
			str[pos] = string.Trim( str[pos] )
			pos = pos + 1
			str[pos] = ( str[pos] or "" ) .. v
		
		else
		
			str[pos] = str[pos] .. " " .. v
		
		end
		
	end
	
	for k,v in pairs( str ) do
	
		draw.SimpleText( v, "Trebuchet18", 20, self:GetTall() * 0.85 + ( ( k - 1 ) * 15 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT )
	
	end
	
	draw.SimpleText( self.Title, "Trebuchet18", self:GetWide() * 0.5, 10, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	
	if self.Style == "Buy" then
	
		if not self.Price or self.Price == 0 then
		
			draw.SimpleText( "Cost: N/A", "Trebuchet18", self:GetWide() * 0.5, 25, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		
		else
	
			draw.SimpleText( "Cost: $"..self.Price, "Trebuchet18", self:GetWide() * 0.5, 25, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			
		end
		
	elseif self.Title != "" then
	
		if not self.Price or self.Price == 0 then
		
			draw.SimpleText( "Selling price: N/A", "Trebuchet18", self:GetWide() * 0.5, 25, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			
		else
	
			draw.SimpleText( "Selling price: $"..math.Round( self.Price * self.PriceScale ), "Trebuchet18", self:GetWide() * 0.5, 25, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			
		end
	
	end
	
	if self.Title != "" then
	
		draw.SimpleText( "Weight: "..self.Weight.." lbs", "Trebuchet18", self:GetWide() * 0.5, 40, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	
	end

end

derma.DefineControl( "ItemDisplay", "A HUD Element with a big model in the middle and a label", PANEL, "PanelBase" )
