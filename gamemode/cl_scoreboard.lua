
function GM:ScoreboardShow()

	if not GAMEMODE.ScoreBoard then
	
		GAMEMODE:CustomizeScoreboard()
		GAMEMODE.ScoreBoard = vgui.Create( "ScoreBoard" )
		
	end
	
	GAMEMODE.ScoreBoard:SetVisible( true )
	GAMEMODE.ScoreboardVisible = true
	
	gui.EnableScreenClicker( true )
	
end

function GM:ScoreboardHide()

	GAMEMODE.ScoreBoard:SetVisible( false )
	GAMEMODE.ScoreboardVisible = false
	
	gui.EnableScreenClicker( false )
	
end

function GM:GetPlayerStats( ply )

	if not ply then 
	
		return { "Deaths", "Kills", "Character" } 
	else
	
		return { ply:Deaths(), ply:Frags(), GAMEMODE:GetPlayerGayName( ply, tostring( ply:Deaths() + 1 ) .. ply:Name() ) } 
		
	end
	
end

function GM:CustomizeScoreboard()

	// these fonts are used in the header on the top of the scoreboard
	surface.CreateFont( "Graffiare", 30, 600, true, false, "MenuTitle" )
	surface.CreateFont( "Verdana", 16, 800, true, false, "MenuDesc" )
	
	// scoreboard fonts
	surface.CreateFont( "Tahoma", 14, 1000, true, false, "ScoreboardLabel" )
	surface.CreateFont( "Verdana", 14, 1000, true, false, "ScoreboardTeamName" )
	surface.CreateFont( "Arial", 14, 600, true, false, "ScoreboardPlayerText" )
	
	// colors used on the scoreboard
	GAMEMODE.TitleColor = Color( 255, 255, 255, 255 ) // title text color
	GAMEMODE.TitleShadow = Color( 0, 0, 0, 100 ) // title shadow color
	
	GAMEMODE.DescColor = Color( 255, 255, 255, 255 ) // subtext color
	GAMEMODE.DescShadow = Color( 50, 50, 50, 100 ) // subtext shadow color
	
	GAMEMODE.TeamTextColor = Color( 0, 0, 0, 255 ) // text color for team bar
	GAMEMODE.TeamShadowColor = Color( 255, 255, 255, 0 ) // text shadow color for team bar
	
	GAMEMODE.TitleBackground = Color( 100, 100, 100, 150 ) // background color for the title and subtext
	GAMEMODE.ScreenBackground = Color( 50, 50, 50, 50 ) //background color for the rest of the screen
	
	GAMEMODE.ScoreBackground = Color( 200, 200, 200, 100 ) // background for team score panel
	GAMEMODE.PlayerBackground = Color( 60, 60, 60, 100 ) // background for player score panel
	
end

function GM:GetDefaultPlayerStats(ply)
	
	return ply:Nick(), ply:Ping()
	
end

local MENUBASE = {}

function MENUBASE:Init()
	
	self.TitleText = ""
	self.DescText = ""
	
	self:SetPos( 0, 0 )
	self:SetSize( ScrW(), ScrH() )
	
	self:SetTitle("")
	self:ShowCloseButton(false)
	
end

function MENUBASE:SetTitleText( text )
	self.TitleText = text
end

function MENUBASE:SetDescText( text )
	self.DescText = text
end

function MENUBASE:Paint()

	Derma_DrawBackgroundBlur( self )

	surface.SetDrawColor( GAMEMODE.ScreenBackground.r, GAMEMODE.ScreenBackground.g, GAMEMODE.ScreenBackground.b, GAMEMODE.ScreenBackground.a )
	surface.DrawRect( 0, 80, ScrW(), ScrH() - 80 )
	
	surface.SetDrawColor( GAMEMODE.TitleBackground.r, GAMEMODE.TitleBackground.g, GAMEMODE.TitleBackground.b, GAMEMODE.TitleBackground.a )
	surface.DrawRect( 0, 0, ScrW(), 80 )
	
	if self.TitleText == "" then
		self.TitleText = GetGlobalString( "ServerName" )
	end
	
	draw.SimpleText( self.TitleText, "MenuTitle", 22, 22, GAMEMODE.TitleShadow, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT )
	draw.SimpleText( self.TitleText, "MenuTitle", 20, 20, GAMEMODE.TitleColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT )
	
	draw.SimpleText( self.DescText, "MenuDesc", 22, 57, GAMEMODE.DescShadow, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT )
	draw.SimpleText( self.DescText, "MenuDesc", 20, 55, GAMEMODE.DescColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT )
	
end

vgui.Register( "MenuBase", MENUBASE, "DFrame" )

local PANEL = {}

function PANEL:Init()

	self.BaseClass.SetTitleText( self, GetGlobalString( "ServerName" ) )
	self.BaseClass.SetDescText( self, GAMEMODE.Name .. "  -  ".. game.GetMap() )
	
	self.PanelList = vgui.Create( "DPanelList", self )
	self.PanelList:SetSize( ScrW() - 40, ScrH() - 130 )
	self.PanelList:SetPos( 20, 105 )
	self.PanelList:SetSpacing( 0 )
	self.PanelList:EnableVerticalScrollbar( true )
	self.PanelList:EnableHorizontal( false )
	self.PanelList.Paint = function() end
	
	self.Canvas = vgui.Create( "Panel" ) 
	self.Canvas.OnMousePressed = function( self, code ) self:GetParent():OnMousePressed( code ) end 
	self.Canvas:SetMouseInputEnabled( true )
	self.Canvas.InvalidateLayout = function() self:InvalidateLayout() end
	self.Canvas:SetSize( ScrW() - 40, 200 )
	self.Canvas:SetPos( 0, 0 )
	self.Canvas.Paint = function() end
	
	self.PanelList:AddItem(self.Canvas)

	self.Teams = {}
	
	local teams = team.GetAllTeams()
	
	for k,v in pairs( teams ) do
	
		if k > 0 and k < 1001 then
		
			if k == TEAM_LONER then
			
				if GetConVar( "sv_radbox_allow_loners" ) and GetConVar( "sv_radbox_allow_loners" ):GetBool() then
				
					table.insert( self.Teams, k )
				
				end
				
			else
		
				table.insert( self.Teams, k )
				
			end
			
		end
		
	end
	
end

function PANEL:Paint()

	self.BaseClass.Paint(self)
	
	self.CanvasSize = 0
	
	if not self.TeamPanels then
	
		self.TeamPanels = {}
		local ypos = 0
		
		for k,v in pairs( self.Teams ) do
		
			self.TeamPanels[k] = vgui.Create( "TeamScore", self.Canvas )
			self.TeamPanels[k]:SetPos( 0, ypos )
			self.TeamPanels[k]:SetSize( ScrW() - 56, self.TeamPanels[k]:GetVerticalSize() )
			self.TeamPanels[k]:SetTeam( v )
			ypos = ypos + self.TeamPanels[k]:GetVerticalSize()
			self.CanvasSize = self.CanvasSize + self.TeamPanels[k]:GetVerticalSize()
			
		end
		
	else
	
		local ypos = 0
		
		for k,v in pairs( self.TeamPanels ) do
		
			v:SetPos( 0, ypos )
			v:SetSize( ScrW() - 56, v:GetVerticalSize() )
			ypos = ypos + v:GetVerticalSize()
			self.CanvasSize = self.CanvasSize + v:GetVerticalSize()
			
		end
		
	end
	
	self.Canvas:SetSize( ScrW() - 40, self.CanvasSize )
	self.PanelList:InvalidateLayout( true ) 
	
end

vgui.Register( "ScoreBoard", PANEL, "MenuBase" )

local TFRAME = {}

function TFRAME:Init( )

	self:SetPaintBackgroundEnabled( true )
	self:SetPaintBackgroundEnabled( false )
	self:SetPaintBorderEnabled( false )
	self.CleanUp = 0
	self.Size = 40
	
end

function TFRAME:SetTeam( teamid )

	self.TeamID = teamid
	self.Players = {}
	self.Rows = {}
	
end

function TFRAME:Paint( )

	if not self.TeamID then return end
	
	local col = team.GetColor( self.TeamID )
	surface.SetDrawColor( col.r, col.g, col.b, 255 )
	surface.DrawRect( 0, 0, self:GetWide(), 25 )
	
	surface.SetDrawColor( 0, 0, 0, 255 )
	surface.DrawOutlinedRect( 0, 0, self:GetWide(), 25 )
	
	surface.SetDrawColor( GAMEMODE.ScoreBackground.r, GAMEMODE.ScoreBackground.g, GAMEMODE.ScoreBackground.b, GAMEMODE.ScoreBackground.a )
	surface.DrawRect( 0, 25, self:GetWide(), self:GetTall() - 25 )
	
	local text = " Member )"
	
	if team.NumPlayers( self.TeamID ) > 1 or team.NumPlayers( self.TeamID ) == 0 then
	
		text = " Members )"
		
	end
	
	local teamcol = GAMEMODE.TeamTextColor
	local teamshad = GAMEMODE.TeamShadowColor
	
	draw.SimpleText( team.GetName( self.TeamID ).." ( "..team.NumPlayers( self.TeamID )..text, "ScoreboardTeamName", 10, 3, Color( teamshad.r, teamshad.g, teamshad.b, teamshad.a ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT )
	draw.SimpleText( team.GetName( self.TeamID ).." ( "..team.NumPlayers( self.TeamID )..text, "ScoreboardTeamName", 9, 3, Color( teamcol.r, teamcol.g, teamcol.b, teamcol.a ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT )
	
	local tbl = GAMEMODE:GetPlayerStats()
	local pos = 10
	
	draw.SimpleText( "Ping", "ScoreboardLabel", self:GetWide() - pos, 3, Color( teamshad.r, teamshad.g, teamshad.b, teamshad.a ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_LEFT )
	draw.SimpleText( "Ping", "ScoreboardLabel", self:GetWide() - pos - 1, 3, Color( teamcol.r, teamcol.g, teamcol.b, teamcol.a ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_LEFT )
	
	for k,v in pairs( tbl ) do
	
		pos = pos + 70
		draw.SimpleText( v, "ScoreboardLabel", self:GetWide() - pos, 3, Color( teamshad.r, teamshad.g, teamshad.b, teamshad.a ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_LEFT )
		draw.SimpleText( v, "ScoreboardLabel", self:GetWide() - pos - 1, 3, Color( teamcol.r, teamcol.g, teamcol.b, teamcol.a ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_LEFT )
		
	end
	
	local size = 40
	self.Players = team.GetPlayers( self.TeamID )
	
	for k, v in pairs( self.Players ) do
	
		local inserted
		
		for c, d in pairs( self.Rows ) do
		
			if d.Ply == v then
			
				inserted = true
				
			end
			
		end
		
		if not inserted then
		
			local row = vgui.Create( "PlayerRow", self )
			row:SetPlayer( v )
			row:SetSize( self:GetWide() - 15, 30 )
			row.Ply = v
			
			table.insert( self.Rows, row )
			
		end
		
	end
	
	for k, v in pairs( self.Rows ) do
	
		v:SetPos( 5, ( k * 37 ) )
		size = size + 37
		
	end
	
	if self.CleanUp < CurTime() then
	
		for k, v in pairs( self.Rows ) do
		
			if not v.Ply or not v.Ply:IsValid() or v.Ply:Team() != self.TeamID then
			
				local row = v
				table.remove( self.Rows, k )
				row:Remove()
				size = size - 37
				
			end
			
		end
		
		self.CleanUp = CurTime() + 0.3
		
	end
	
	self.Size = size
	
end

function TFRAME:GetVerticalSize()

	return self.Size
	
end

vgui.Register( "TeamScore", TFRAME, "DPanel" )

local PFRAME = {}

function PFRAME:Init()

	self.Avatar = vgui.Create( "AvatarImage", self )
	self.Avatar:SetPos( 5, 0 )
	self.Avatar:SetSize( 32, 32 )
	self.Invalid = 0
	
end

function PFRAME:SetPlayer( ply )

	if not ply or not ply:IsValid() then
	
		return false
		
	end
	
	self.Player = ply
	self.Avatar:SetPlayer( ply )
	
end

function PFRAME:Paint( )
	
	if not self.Player or not self.Player:IsValid() then
	
		return
		
	end
	
	local ply = self.Player
	
	local name, ping = GAMEMODE:GetDefaultPlayerStats(ply)
	local stats = GAMEMODE:GetPlayerStats(ply)
	local tbl = GAMEMODE:GetPlayerStats()
	
	local pos = 0
	
	surface.SetDrawColor( GAMEMODE.PlayerBackground.r,GAMEMODE.PlayerBackground.g, GAMEMODE.PlayerBackground.b, GAMEMODE.PlayerBackground.a )
	surface.DrawRect( 5, 0, self:GetWide(), self:GetTall() )
	
	draw.SimpleText( name, "ScoreboardPlayerText", 45, 8, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT )
	draw.SimpleText( name, "ScoreboardPlayerText", 44, 8, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT )
	draw.SimpleText( tostring( ping ), "ScoreboardPlayerText", self:GetWide(), 8, Color( 0, 0, 0, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_LEFT )
	draw.SimpleText( tostring( ping ), "ScoreboardPlayerText", self:GetWide() - 1, 8, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_LEFT )
	
	for k,v in pairs( stats ) do
	
		pos = pos + 70
		draw.SimpleText( tostring( v ), "ScoreboardPlayerText", self:GetWide() - pos, 8, Color( 0, 0, 0, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_LEFT )
		draw.SimpleText( tostring( v ), "ScoreboardPlayerText", self:GetWide() - pos - 1, 8, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_LEFT )
		
	end
	
end

vgui.Register( "PlayerRow", PFRAME, "DPanel" )
