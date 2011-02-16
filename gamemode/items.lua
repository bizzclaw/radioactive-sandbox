
module( "item", package.seeall )

local ItemTables = {}
local ID = 1

function Register( tbl )
	
	tbl.ID = ID
	ItemTables[ ID ] = tbl
	
	ID = ID + 1
	
end

function GetList()

	return ItemTables

end

function GetByID( id )

	if not id then return end
	
	if !ItemTables[ id ] then return end

	return ItemTables[ id ]
	
end

function GetByModel( model )
	
	for k,v in pairs( ItemTables ) do
		
		if string.lower( v.Model ) == string.lower( model ) then
		
			return v
		
		end
		
	end

end

function GetByType( itemtype )

	local tbl = {}
	
	for k,v in pairs( ItemTables ) do
		
		if v.Type == itemtype then
		
			table.insert( tbl, v )
		
		end
		
	end
	
	return tbl

end

function RandomItem( itemtype )

	if not itemtype then return table.Random( ItemTables ) end

	local tbl = GetByType( itemtype )
	local rand = table.Random( tbl )
	
	while math.Rand(0,1) < rand.Rarity do
	
		rand = table.Random( tbl )
	
	end

	return rand

end






