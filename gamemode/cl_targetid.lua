
local PlayerNames = {}
PlayerNames[1] = { "Joseph", "Strelok", "Koscha", "Lex", "Wolf", "Lukas", "Gabor", "Mikhail", "Mischa", "Nikolai" }
PlayerNames[2] = { "Roman", "Scar", "Serjh", "Kalif", "Kobra", "Vlad", "Vladimir", "Yuri", "Johan", "Tolik" }
PlayerNames[3] = { "Maksim", "Petrenko", "Rudik", "Lars", "Ischenko", "Ivan", "Karl", "Borat", "Jagori", "Igor" }
PlayerNames[4] = { "Kaz", "Sven", "Koslow", "Peter", "Vladik", "Moriz", "Stefan", "Pavlo", "Jaspar", "Avel" }
PlayerNames[5] = { "Fang", "Ivanov", "Damien", "Tobias", "Boris", "Danil", "Dominik", "Alek", "Kobus", "Arman" }
PlayerNames[6] = { "Jerome", "Alexander", "Jarec", "Wolfram", "Xavier", "Seb", "Felix", "Gustaf", "Jakob", "Andrei" }
PlayerNames[7] = { "Yurik", "Pavel", "Jegor", "Vic", "Luthar", "Hawk", "Kruger", "Danko", "Dutch", "Viktor" }
PlayerNames[8] = { "Sigil", "Marcus", "Sydric", "Nikolai", "Valentin", "Yakim", "Dominic", "Syd", "Ilya", "Josef" }
PlayerNames[9] = { "Uri", "Kelthyr", "Erik", "Kilroy", "Sergei", "Duke", "Fredrik", "Hans", "Denis", "Anton" }
PlayerNames[10] = { "Mikesh", "Sigmund", "Silas", "Rurik", "Nikita", "Dimitri", "Aleksei", "Vadym", "Viktor", "Kolya" }

local LastNames = {}
LastNames[1] = { "Dubnikov", "Sacharin", "Larin", "Berdjansk", "Dawydov", "Sakharov", "Nevrin", "Charkow", "Markov", "Havlik" } 
LastNames[2] = { "Baranowski", "Lebedev", "Krylov", "Bellic", "Vicros", "Klimenko", "Kolovnik", "Lawrik", "Plochenko", "Klepacki" }
LastNames[3] = { "Limansk", "Sidorow", "Pechenkin", "Petchenko", "Tarasov", "Kudinov", "Davidov", "Stanislav", "Kilgore", "Dombrik" }
LastNames[4] = { "Ezrin", "Schabenko", "Black", "Maslov", "Gatsula", "Degtyarev", "Makarenko", "Viekko", "Burec", "Gusarov" }
LastNames[5] = { "Hunter", "Brevin", "Constantin", "Lepechin", "Saveliy", "Vadim", "Vargan", "Vasek", "Vasko", "Yakov" }
LastNames[6] = { "Kruglov", "Fedorov", "Sidorov", "Sidorovich", "Petrov", "Alexandrov", "Timur", "Ruslan", "Arkadiy", "Lukovich" }
LastNames[7] = { "Soprovich", "Karolek", "Pavlik", "Moroshkin", "Gavrel", "Stanislov", "Kostya", "Brevich", "Solotar", "Berzin" }
LastNames[8] = { "Sidorenko", "Burjak", "Dotsenko", "Dostovei", "Sacharov", "Nepritski", "Putschek", "Gritsenko", "Lachnit", "Luschkow" }
LastNames[9] = { "Stamitz", "Tolstoi", "Kurkow", "Leskow", "Sorokin", "Korolenko", "Rosoff", "Romanov", "Silvashko", "Oberst" }
LastNames[10] = { "Puktov", "Brodsky", "Nabokov", "Ragosin", "Moskitow", "Kerenski", "Dubrovnik", "Gauss", "Gavrilov", "Faustin" }

local TargetedEntity = nil
local TargetedTime = 0

function GM:GetEntityID( ent )

	local dist = ent:GetPos():Distance( LocalPlayer():GetPos() )
	
	if dist > 1000 then return end
	
	TargetedEntity = ent
	TargetedTime = CurTime() + 5

end

function GM:GetPlayerGayName( ply, name )

	if not ValidEntity( LocalPlayer() ) then return "" end

	if GetConVar( "sv_radbox_custom_names" ) and GetConVar( "sv_radbox_custom_names" ):GetBool() and ply:GetNWString( "GayName", "" ) != "" then
	
		return ply:GetNWString( "GayName", "" )
	
	end

	local crc = string.Explode( "", tostring( util.CRC( name ) ) )
	local firstname = PlayerNames[ tonumber( crc[2] ) + 1 ][ tonumber( crc[3] + 1 ) ] 
	local lastname = LastNames[ tonumber( crc[4] ) + 1 ][ tonumber( crc[5] + 1 ) ]
	
	if ply:IsPlayer() and ply:Team() == TEAM_ARMY then
	
		local tbl = { "Sgt.", "Cpl.", "Lt.", "Pvt." }
	
		firstname = tbl[ math.Clamp( tonumber( crc[6] ), 1, 4 ) ] .. " " .. firstname
	
	end

	return firstname .. " " .. lastname

end

function GM:HUDDrawTargetID()

	if not ValidEntity( LocalPlayer() ) then return end
	if not LocalPlayer():Alive() then return end
	
	if not F3Item:IsVisible() and LocalPlayer():GetNWBool( "InIron", false ) == false then
		
		F3Item:SetVisible( true )
		F4Item:SetVisible( true )
		
	end
	
	GAMEMODE:DrawPlayerChat()
	
	local tr = util.TraceLine( util.GetPlayerTrace( LocalPlayer() ) )
	
	if ValidEntity( tr.Entity ) then
	
		GAMEMODE:GetEntityID( tr.Entity )
		
	end
	
	if ValidEntity( TargetedEntity ) and ( !TargetedEntity:IsPlayer() or TargetedEntity:Alive() ) and TargetedTime > CurTime() then

		if string.find( TargetedEntity:GetClass(), "npc" ) or TargetedEntity:IsPlayer() then
			
			TargetScreen:SetEntity( TargetedEntity )
			return
			
		end
	
		local pos = ( TargetedEntity:GetPos() + Vector(0,0,10) ):ToScreen()
		
		if pos.visible then
		
			local name = ""
			
			if string.find( TargetedEntity:GetClass(), "loot" ) then
			
				name = "Loot"
				
			elseif string.find( TargetedEntity:GetClass(), "stash" ) then
			
				name = "Stash"
				
			end
			
			draw.SimpleTextOutlined( name, "AmmoFontSmall", pos.x, pos.y, Color( 80, 150, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
			
		end
	
	end

end

function GM:DrawPlayerChat()

	for k,v in pairs( player.GetAll() ) do
	
		if v.ChatWords then
		
			for k,v in pairs( v.ChatWords or {} ) do
				
				if v.Time < CurTime() then
						
					v.Alpha = math.Approach( v.Alpha, 0, 10 )
						
				end
						
			end
		
			if v:GetPos():Distance( LocalPlayer():GetPos() ) < 1000 and v != LocalPlayer() and v.ChatWords then
			
				local pos = ( v:GetPos() + Vector(0,0,75) ):ToScreen()
				
				if pos.visible then
				
					for k,v in pairs( v.ChatWords ) do
				
						draw.SimpleTextOutlined( v.Text, "TargetIDFont", pos.x, pos.y - ( ( k - 1 ) * 12 ), Color( 255, 255, 255, v.Alpha ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0, v.Alpha ) )
						
					end
				
				end
			
			end
			
		end
	
	end

end

local LocalChatDist = 1000
local HushDist = 400
local LocalOOC = "//"
local LocalMe = "/me"
local Whisper = "/w"
local LocalChat = "/"

function GM:OnPlayerChat( ply, text, isteam, isdead )

	for k,v in pairs( { LocalOOC, LocalMe, Whisper, LocalChat } ) do

		local expl = string.Left( text, string.len( v ) )
		
		if expl == v then 
		
			text = string.Trim( string.Right( text, string.len( text ) - string.len( v ) ) )
			ply.ChatWords = ply.ChatWords or {}
			
			if LocalPlayer():GetPos():Distance( ply:GetPos() ) < LocalChatDist then
			
				if v == LocalChat then
			
					if ( isteam and LocalPlayer():Team() == ply:Team() ) or not isteam then
					
						chat.AddText( Color( 255, 255, 255 ), "(LOCAL) ", team.GetColor( ply:Team() ), GAMEMODE:GetPlayerGayName( ply, tostring( ply:Deaths() + 1 ) .. ply:Name() ), Color( 255, 255, 255 ), ": ", text )
						
						if table.Count( ply.ChatWords ) >= 5 then
				
							table.remove( ply.ChatWords, 5 )
				
						end
				
						table.insert( ply.ChatWords, 1, { Text = text, Time = CurTime() + 5, Alpha = 255 } )
					
					end
					
				elseif v == LocalOOC then
				
					chat.AddText( ply, Color( 255, 255, 255 ), ": ", text )
					
				elseif v == Whisper then
				
					if LocalPlayer():GetPos():Distance( ply:GetPos() ) < HushDist then
					
						chat.AddText( Color( 255, 255, 255 ), "(WHISPER) ", team.GetColor( ply:Team() ), GAMEMODE:GetPlayerGayName( ply, tostring( ply:Deaths() + 1 ) .. ply:Name() ), Color( 255, 255, 255 ), ": ", text )
					
					else
					
						chat.AddText( team.GetColor( ply:Team() ), GAMEMODE:GetPlayerGayName( ply, tostring( ply:Deaths() + 1 ) .. ply:Name() ), Color( 255, 255, 255 ), " whispered something..." )
					
					end
				
				else
				
					chat.AddText( team.GetColor( ply:Team() ), GAMEMODE:GetPlayerGayName( ply, tostring( ply:Deaths() + 1 ) .. ply:Name() ), Color( 255, 255, 255 ), " ", text )
				
				end
			
			end
	
			return true
		
		end
		
	end
	
	return self.BaseClass:OnPlayerChat( ply, text, isteam, isdead ) 

end
 

