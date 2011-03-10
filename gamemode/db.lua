db = {}

function db.AccountID( steamid )

	if steamid == "BOT" then return 69420 end
	if not steamid then return 69420 end

	local splode = string.Explode( ":", string.lower( steamid ) )
	return tonumber( ( splode[3] or 1 ) * 2 + ( splode[2] or 1 ) )
	
end

function db.Initialize()

	GAMEMODE.PlayerInventories = {}

	if !sql.TableExists( "radbox_inv" ) then
	
		sql.Query( "CREATE TABLE radbox_inv ( uid INTERGER, inv TEXT, cash INTERGER )" )
		
	end

end

function db.GetInventory( pl )
	
	local aid = db.AccountID( pl:SteamID() )
	
	local res = sql.QueryRow( "SELECT * FROM radbox_inv WHERE uid = " .. aid )
	
	if res then
	
		return res['inv'], tonumber( res['cash'] )
		
	else

		sql.Query( "INSERT INTO radbox_inv ( `uid`, `inv`, `cash` ) VALUES ( " .. aid .. ", '', '' )" )
		return false
		
	end
	
end

function db.SetInventory( pl, inv, cash )

	local aid = db.AccountID( pl:SteamID() )
	
	sql.Query( "UPDATE radbox_inv SET inv = '" .. inv .. "', cash = '" .. cash .. "' WHERE uid = " .. aid )

end

function db.DeleteInventory( steamid )

	local aid = db.AccountID( steamid )
	
	sql.Query( "DELETE FROM radbox_inv WHERE uid = " .. aid )

end

function db.Wipe()

	MsgN( "Erasing all radbox player profiles..." )
	
	sql.Query( "DROP TABLE radbox_inv" )

end