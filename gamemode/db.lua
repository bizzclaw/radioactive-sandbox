db = {}

local function AccountID( steamid )

	local splode = string.Explode( ":", steamid )
	return tonumber( splode[3] * 2 + splode[2] )
	
end

function db.Initialize()

	GAMEMODE.PlayerInventories = {}

	if !sql.TableExists( "radbox_inv" ) then
	
		sql.Query( "CREATE TABLE radbox_inv ( uid INTERGER, inv TEXT )" )
		
	end

end

function db.GetInventory( pl )
	
	local aid = AccountID( pl:SteamID() )
	
	local res = sql.QueryRow( "SELECT * FROM radbox_inv WHERE uid = " .. aid )
	
	if res then
	
		return res['inv']
		
	else

		sql.Query( "INSERT INTO radbox_inv (`uid`, `inv`)VALUES (" .. aid .. ", '')" )
		return false
		
	end
	
end

function db.SetInventory( pl, inv )

	local aid = AccountID( pl:SteamID() )
	
	sql.Query( "UPDATE radbox_inv SET inv = '" .. inv .. "' WHERE uid = " .. aid )

end

function db.DeleteInventory( steamid )

	local aid = AccountID( steamid )
	
	sql.Query( "DELETE FROM radbox_inv WHERE uid = " .. aid )

end