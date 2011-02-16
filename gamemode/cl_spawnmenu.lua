
function GM:InitVGUI()
	
	InventoryScreen = vgui.Create( "ItemSheet" )
	InventoryScreen:SetSize( ScrW() * 0.5 - 10, ScrH() * 0.5 - 10 )
	InventoryScreen:SetPos( 5, ScrH() * 0.5 + 5 )
	InventoryScreen:SetSpacing( 2 )
	InventoryScreen:SetPadding( 3 )
	InventoryScreen:EnableHorizontal( true )
	InventoryScreen:SetVisible( false )
		
	InfoScreen = vgui.Create( "ItemDisplay" )
	InfoScreen:SetSize( ScrW() * 0.3 - 10, ScrH() * 0.5 - 5 )
	InfoScreen:SetPos( 5, 5 )
	InfoScreen:SetVisible( false )
	
	PlayerScreen = vgui.Create( "PlayerDisplay" )
	PlayerScreen:SetSize( ScrW() * 0.3 - 10, ScrH() * 0.5 - 5 )
	PlayerScreen:SetPos( ScrW() * 0.7 + 5, 5 )
	PlayerScreen:SetVisible( false )
	PlayerScreen:SetupCam( Vector(0,96,36), Vector(0,0,36) )
		
	StashScreen = vgui.Create( "ItemSheet" )
	StashScreen:SetSize( ScrW() * 0.5 - 10, ScrH() * 0.5 - 10 )
	StashScreen:SetPos( ScrW() * 0.5 + 5, ScrH() * 0.5 + 5 )
	StashScreen:SetSpacing( 2 )
	StashScreen:SetPadding( 3 )
	StashScreen:EnableHorizontal( true )
	StashScreen:SetVisible( false )
	StashScreen:SetStashable( true, "Take" )
	
	TargetScreen = vgui.Create( "TargetID" )
	TargetScreen:SetPos( 5, 5 )
	TargetScreen:SetSize( 150, 180 )
    TargetScreen:SetVisible( false )	
	
	F3Item = vgui.Create( "QuickSlot" )
	F3Item:SetText( "F3" )
	F3Item:SetPos( ScrW() + 100, 0 )
	F3Item:SetVisible( true )
	
	F4Item = vgui.Create( "QuickSlot" )
	F4Item:SetText( "F4" )
	F4Item:SetPos( ScrW() + 100, 0 )
	F4Item:SetVisible( true )
	
end

function GM:OnSpawnMenuClose()
	
	if not LocalPlayer():Alive() then return end
	if StashScreen:IsVisible() then return end
	
	if not InventoryScreen:IsVisible() then
	
		InventoryScreen:SetSize( ScrW() - 10, ScrH() * 0.5 - 10 )
		InventoryScreen:SetStashable( false, "Stash", true )
		InventoryScreen:RefreshItems( LocalInventory )
		InventoryScreen:SetVisible( true )
		InfoScreen:SetVisible( true )
		PlayerScreen:SetVisible( true )
		
		gui.EnableScreenClicker( true )
	
	else
	
		InventoryScreen:SetVisible( false )
		InfoScreen:SetVisible( false )
		PlayerScreen:SetVisible( false )
		
		gui.EnableScreenClicker( false )
	
	end

end

function StashMenu( msg )

	local open = msg:ReadBool()
	
	if InventoryScreen:IsVisible() and open then return end
	
	StashScreen:SetStashable( open, "Take" )
	StashScreen:SetVisible( open )
	
	InventoryScreen:SetSize( ScrW() * 0.5 - 10, ScrH() * 0.5 - 10 )
	InventoryScreen:SetStashable( open, "Stash", true )
	InventoryScreen:SetVisible( open )
	InfoScreen:SetVisible( open )
	PlayerScreen:SetVisible( open )
	
	gui.EnableScreenClicker( open )
	
	if open then
	
		StashScreen:RefreshItems( LocalStash )
		
	end
	
end
usermessage.Hook( "StashMenu", StashMenu )

function StoreMenu( msg )

	local open = msg:ReadBool()
	local scale = msg:ReadFloat()
	
	if InventoryScreen:IsVisible() and open then return end
	
	StashScreen:SetStashable( open, "Buy" )
	StashScreen:SetVisible( open )
	
	InventoryScreen:SetSize( ScrW() * 0.5 - 10, ScrH() * 0.5 - 10 )
	InventoryScreen:SetPriceScale( scale )
	InventoryScreen:SetStashable( open, "Sell", true )
	InventoryScreen:SetVisible( open )
	InfoScreen:SetVisible( open )
	PlayerScreen:SetVisible( open )
	
	gui.EnableScreenClicker( open )
	
	if open then
	
		StashScreen:RefreshItems( LocalStash )
		
	end

end
usermessage.Hook( "StoreMenu", StoreMenu )

function NPCMenu( msg )

	local inquest = msg:ReadBool()
	
	local window = vgui.Create( "NPCMenu" )
	window:SetTitleText( "Trader Menu" )
	window:AddOption( "radbox/menu_trade", "Show me your wares.", function() RunConsoleCommand( "tradermenu" ) end )
	
	if inquest then
	
		window:AddOption( "radbox/menu_quest", "I've finished the job.", function() RunConsoleCommand( "endquest" ) end )
		window:AddOption( "radbox/menu_quest", "I cannot finish the job.", function() RunConsoleCommand( "cancelquest" ) end )
	
	else
	
		window:AddOption( "radbox/menu_quest", "Do you have any jobs for me?", function() QuestMenu() end )
	
	end
	
	window:AddOption( "radbox/menu_save", "I'd like to store my items.", function() RunConsoleCommand( "inv_save" ) end )
	window:AddOption( "radbox/menu_cancel", "Never mind.", function() RunConsoleCommand( "closetradermenu" ) end )
	window:MakePopup()
	window:Center()

	gui.EnableScreenClicker( true )

end
usermessage.Hook( "NPCMenu", NPCMenu )

function QuestMenu()

	local window = vgui.Create( "NPCMenu" )
	window:SetTitleText( "Mission Menu" )
	
	for k,v in pairs( GAMEMODE.Quests ) do
	
		window:AddOption( v.Picture, v.Text, function() RunConsoleCommand( "startquest", tostring( k ) ) end )
	
	end
	
	window:AddOption( "radbox/menu_cancel", "Never mind.", function() RunConsoleCommand( "closetradermenu" ) end )
	window:MakePopup()
	window:Center()
	
	gui.EnableScreenClicker( true )

end

function Dialogue( msg )

	local text = msg:ReadString()
	
	local window = vgui.Create( "Dialogue" )
	window:SetText( text )
	window:Center()
	window:MakePopup()

	gui.EnableScreenClicker( true )

end
usermessage.Hook( "Dialogue", Dialogue )

function GM:SetItemToPreview( id, style, scale )

	PreviewTable = table.Copy( item.GetByID( id ) )
	
	if scale and style then
	
		PreviewStyle = style
		PreviewPriceScale = scale
		
	end

end

function GM:GetItemToPreview()

	return PreviewTable, PreviewStyle, PreviewPriceScale

end