
local PlayerNames = {}
PlayerNames[1] = { "Joseph", "Orest", "Koscha", "Lex", "Wolf", "Lukas", "Gabor", "Mikhail", "Mischa", "Nikolai" }
PlayerNames[2] = { "Leonid", "Scar", "Serjh", "Kalif", "Kobra", "Vlad", "Vladimir", "Yuri", "Johan", "Tolik" }
PlayerNames[3] = { "Maksim", "Petrenko", "Rudik", "Lars", "Ischenko", "Karl", "Ivan", "Jagori", "Lukash", "Igor" }
PlayerNames[4] = { "Kaz", "Sven", "Koslow", "Garik", "Vladik", "Moriz", "Stefan", "Pavlo", "Jaspar", "Avel" }
PlayerNames[5] = { "Fang", "Ivanov", "Damien", "Tobias", "Boris", "Danil", "Dominik", "Alek", "Kobus", "Arman" }
PlayerNames[6] = { "Lefty", "Alexander", "Jarec", "Wolfram", "Cheslav", "Seb", "Felix", "Gustaf", "Jakob", "Andrei" }
PlayerNames[7] = { "Yurik", "Pavel", "Jegor", "Vano", "Luthar", "Vasya", "Kruger", "Cardan", "Dutch", "Viktor" }
PlayerNames[8] = { "Sigil", "Marcus", "Sydric", "Nikolai", "Valentin", "Kostyan", "Dominic", "Syd", "Ilya", "Josef" }
PlayerNames[9] = { "Uri", "Kelthyr", "Barin", "Kilroy", "Sergei", "Ashot", "Senka", "Hans", "Milutin", "Anton" }
PlayerNames[10] = { "Mikesh", "Sigmund", "Borov", "Rurik", "Nikita", "Dimitri", "Aleksei", "Vadym", "Viktor", "Kolya" }

local LastNames = {}
LastNames[1] = { "Dubnikov", "Sacharin", "Larin", "Berdjansk", "Dawydov", "Sakharov", "Nevrin", "Charkow", "Nelidov", "Havlik" } 
LastNames[2] = { "Baranowski", "Lebedev", "Krylov", "Bellic", "Vicros", "Klimenko", "Kolovnik", "Lawrik", "Plochenko", "Petrovin" }
LastNames[3] = { "Limansk", "Sidorow", "Pechenkin", "Petchenko", "Tarasov", "Kudinov", "Davidov", "Stanislav", "Kilgore", "Dombrik" }
LastNames[4] = { "Lenskaya", "Schabenko", "Black", "Maslov", "Gatsula", "Degtyarev", "Makarenko", "Belenki", "Kitsenko", "Gusarov" }
LastNames[5] = { "Hunter", "Brevin", "Constantin", "Lepechin", "Saveliy", "Vadim", "Vargan", "Voronin", "Vasko", "Kozlov" }
LastNames[6] = { "Kruglov", "Fedorov", "Sidorov", "Sidorovich", "Petrov", "Alexandrov", "Timur", "Ruslan", "Arkadiy", "Lukovich" }
LastNames[7] = { "Soprovich", "Karolek", "Pavlik", "Moroshkin", "Gavrel", "Stanislov", "Kostya", "Brevich", "Solotar", "Berzin" }
LastNames[8] = { "Sidorenko", "Burjak", "Dotsenko", "Suslov", "Sacharov", "Nepritski", "Putschek", "Gritsenko", "Lachnit", "Luschkow" }
LastNames[9] = { "Stamitz", "Tolstoi", "Kurkow", "Leskow", "Sorokin", "Korolenko", "Rosoff", "Romanov", "Silvashko", "Oberst" }
LastNames[10] = { "Puktov", "Brodsky", "Kozerski", "Ragosin", "Moskitow", "Kovalsky", "Dubrovnik", "Trodnik", "Gavrilov", "Faustin" }

local TargetedEntity = nil
local TargetedName = nil
local TargetedTime = 0
local TargetedDist = Vector(0,0,0)

function GM:GetEntityID( ent )
	
	if ent:GetClass() == "prop_physics" or string.find( ent:GetClass(), "artifact" ) then
	
		local tbl = item.GetByModel( ent:GetModel() )
		
		if tbl then
	
			TargetedName = tbl.Name
			TargetedEntity = ent
			TargetedTime = CurTime() + 5
			TargetedDist = Vector( 0, 0, TargetedEntity:OBBCenter():Distance( TargetedEntity:OBBMaxs() ) )
		
		end
		
	elseif ent:GetClass() == "sent_droppedgun" then
	
		local tbl = item.GetByModel( ent:GetModel() )
		
		if tbl then
	
			TargetedName = tbl.Name
			TargetedEntity = ent
			TargetedTime = CurTime() + 5
			TargetedDist = Vector( 0, 0, 10 )
		
		end
	
	elseif ent:GetClass() == "sent_lootbag" then
	
		TargetedName = "Loot"
		TargetedEntity = ent
		TargetedTime = CurTime() + 5
		TargetedDist = Vector( 0, 0, 10 )
		
	elseif ent:GetClass() == "sent_cash" then
	
		TargetedName = "Money: $" .. ent:GetNWInt( "Cash", 10 )
		TargetedEntity = ent
		TargetedTime = CurTime() + 5
		TargetedDist = Vector( 0, 0, 5 )
	
	elseif ent:GetClass() == "point_stash" then
	
		TargetedName = "Stash"
		TargetedEntity = ent
		TargetedTime = CurTime() + 5
		TargetedDist = Vector( 0, 0, 10 )
	
	elseif string.find( ent:GetClass(), "npc" ) or ent:IsPlayer() then
	
		TargetedName = nil
		TargetedEntity = ent
		TargetedTime = CurTime() + 5
		TargetedDist = Vector( 0, 0, 10 )
	
	end
	
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
	
	if ValidEntity( tr.Entity ) and tr.Entity:GetPos():Distance( LocalPlayer():GetPos() ) < 1000 then
	
		GAMEMODE:GetEntityID( tr.Entity )
		
	end
	
	if ValidEntity( TargetedEntity ) and ( !TargetedEntity:IsPlayer() or TargetedEntity:Alive() ) and TargetedTime > CurTime() then

		if string.find( TargetedEntity:GetClass(), "npc" ) or TargetedEntity:IsPlayer() then
			
			TargetScreen:SetEntity( TargetedEntity )
			return
			
		end
	
		local pos = ( TargetedEntity:LocalToWorld( TargetedEntity:OBBCenter() ) + TargetedDist ):ToScreen()
		
		if pos.visible and TargetedName then
			
			draw.SimpleTextOutlined( TargetedName, "AmmoFontSmall", pos.x, pos.y, Color( 80, 150, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
			
		end
	
	end

end

function GM:GetPlayerGayName( ply, name )

	if not ValidEntity( LocalPlayer() ) then return "" end

	if GetConVar( "sv_radbox_custom_names" ):GetBool() and ply:GetNWString( "GayName", "" ) != "" then
	
		return ply:GetNWString( "GayName", "" )
	
	end

	local crc = tostring( util.CRC( name ) )
	local firstname = PlayerNames[ tonumber( crc[2] ) + 1 ][ tonumber( crc[3] + 1 ) ] 
	local lastname = LastNames[ tonumber( crc[4] ) + 1 ][ tonumber( crc[5] + 1 ) ]
	
	if ply:IsPlayer() and ply:Team() == TEAM_ARMY then
	
		local tbl = { "Sgt.", "Cpl.", "Lt.", "Pvt." }
	
		firstname = tbl[ math.Clamp( tonumber( crc[6] ), 1, 4 ) ] .. " " .. firstname
	
	end

	return firstname .. " " .. lastname

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

GM.ChatBoxes = {}
GM.ChatMode = GM.ChatModes.OOC

function GM:StartChat( isteam )

	if not GetConVar( "sv_radbox_roleplay" ):GetBool() then return end

	local x, y = chat.GetChatBoxPos()
	
	for k,v in pairs{ { "OOC", GAMEMODE.ChatModes.OOC, 50, 0 }, 
						{ "Emote", GAMEMODE.ChatModes.LocalMe, 120, 55 }, 
						{ "Whisper", GAMEMODE.ChatModes.Whisper, 130, 120 }, 
						{ "Radio", GAMEMODE.ChatModes.Radio, 120, 190 }, 
						{ "Local", GAMEMODE.ChatModes.Local, 120, 250 } } do

		local box = vgui.Create( "DCheckBoxLabel" )
		box:SetPos( x + 10 + v[4], y - 20 )
		box:SetText( v[1] )
		box:SetWide( v[3] )
		box.Button.OnChange = function( pnl, value )
		
			if value then
			
				for k,v in pairs( GAMEMODE.ChatBoxes ) do
				
					if v != box and v.Button then
				
						v.Button:SetValue( false )
						
					end
				
				end
				
				RunConsoleCommand( "cl_radbox_chatmode", v[2] )
				GAMEMODE.ChatMode = v[2]
			
			end
		
		end
		
		if GAMEMODE.ChatMode == v[2] then
		
			box.Button:SetValue( true )
		
		end
		
		table.insert( GAMEMODE.ChatBoxes, box )		
		
	end
	
	gui.SetMousePos( 100, ScrH() * 0.65 )

end

function GM:FinishChat()

	for k,v in pairs( GAMEMODE.ChatBoxes ) do
	
		if v then
		
			v:Remove()
		
		end
	
	end

end

function GM:OnPlayerChat( ply, text, isteam, isdead )

	if not ValidEntity( ply ) or not GetConVar( "sv_radbox_roleplay" ):GetBool() then return self.BaseClass:OnPlayerChat( ply, text, isteam, isdead ) end

	for k,v in pairs{ GAMEMODE.ChatModes.LocalMe, GAMEMODE.ChatModes.Whisper, GAMEMODE.ChatModes.Radio, GAMEMODE.ChatModes.Local } do

		local expl = string.Left( text, string.len( v ) )
		
		if expl == v and not isdead then 
		
			text = string.Trim( string.Right( text, string.len( text ) - string.len( v ) ) )
			ply.ChatWords = ply.ChatWords or {}
			
			if v == GAMEMODE.ChatModes.Local then
			
				if LocalPlayer():GetPos():Distance( ply:GetPos() ) < GAMEMODE.LocalDist and ( ( isteam and LocalPlayer():Team() == ply:Team() ) or ( !isteam and LocalPlayer():GetPos():Distance( ply:GetPos() ) < GAMEMODE.HushDist ) ) then
					
					if Drunkness > 2 then
					
						text = Drunkify( text )
					
					end
					
					chat.AddText( Color( 255, 255, 255 ), "(LOCAL) ", team.GetColor( ply:Team() ), GAMEMODE:GetPlayerGayName( ply, tostring( ply:Deaths() + 1 ) .. ply:Name() ), Color( 255, 255, 255 ), ": ", text )
					
					if table.Count( ply.ChatWords ) >= 5 then
				
						table.remove( ply.ChatWords, 5 )
				
					end
				
					table.insert( ply.ChatWords, 1, { Text = text, Time = CurTime() + 5, Alpha = 255 } )
					
				end
				
				return true
				
			elseif v == GAMEMODE.ChatModes.Radio then
			
				if ply != LocalPlayer() then
				
					surface.PlaySound( Sound( "npc/combine_soldier/vo/on1.wav" ) ) 
				
				end
				
				if Drunkness > 2 then
					
					text = Drunkify( text )
					
				end
				
				chat.AddText( Color( 255, 255, 255 ), "(RADIO) ", team.GetColor( ply:Team() ), GAMEMODE:GetPlayerGayName( ply, tostring( ply:Deaths() + 1 ) .. ply:Name() ), Color( 255, 255, 255 ), ": ", text )
				
				return true
				
			elseif v == GAMEMODE.ChatModes.Whisper then
				
				if LocalPlayer():GetPos():Distance( ply:GetPos() ) < GAMEMODE.HushDist then
				
					if Drunkness > 2 then
					
						text = Drunkify( text )
					
					end
					
					chat.AddText( Color( 255, 255, 255 ), "(WHISPER) ", team.GetColor( ply:Team() ), GAMEMODE:GetPlayerGayName( ply, tostring( ply:Deaths() + 1 ) .. ply:Name() ), Color( 255, 255, 255 ), ": ", text )
					
				elseif LocalPlayer():GetPos():Distance( ply:GetPos() ) < GAMEMODE.LocalDist then
					
					chat.AddText( team.GetColor( ply:Team() ), GAMEMODE:GetPlayerGayName( ply, tostring( ply:Deaths() + 1 ) .. ply:Name() ), Color( 255, 255, 255 ), " whispered something..." )
					
				end
					
				return true
				
			elseif v == GAMEMODE.ChatModes.LocalMe then 
			
				if LocalPlayer():GetPos():Distance( ply:GetPos() ) < GAMEMODE.LocalDist then
				
					chat.AddText( team.GetColor( ply:Team() ), GAMEMODE:GetPlayerGayName( ply, tostring( ply:Deaths() + 1 ) .. ply:Name() ), Color( 255, 255, 255 ), " ", text )
					
				end
				
				return true
				
			end
		
		elseif expl == v and isdead then

			return true
		
		end
		
	end
	
	if ( isteam or ( LocalPlayer():Team() != ply:Team() and LocalPlayer():GetPos():Distance( ply:GetPos() ) < GAMEMODE.HushDist ) ) and not isdead then
	
		if ply != LocalPlayer() then
			
			surface.PlaySound( Sound( "npc/combine_soldier/vo/on2.wav" ) ) 
			
		end
	
		chat.AddText( Color( 255, 255, 255 ), "(FACTION) ", team.GetColor( ply:Team() ), GAMEMODE:GetPlayerGayName( ply, tostring( ply:Deaths() + 1 ) .. ply:Name() ), Color( 255, 255, 255 ), ": ", text )
		
		return true
	
	end
	
	chat.AddText( ply, Color( 255, 255, 255 ), ": ", text ) --// OOC
	
	return true

end
 
function Drunkify( txt )

	txt = string.gsub( txt, "%sthe%s", " due " )
	txt = string.gsub( txt, "h", "" )
	txt = string.gsub( txt, "s", "sh" )
	txt = string.gsub( txt, "ce", "sh" )
	txt = string.gsub( txt, "ck", "ggh" )
	txt = string.gsub( txt, "k%s", "gh " )
	txt = string.gsub( txt, "t%s", "g " )
	txt = string.gsub( txt, "ing", "ig" )
	
	return txt

end
