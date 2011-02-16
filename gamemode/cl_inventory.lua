
LocalInventory = {}
LocalStash = {}
PreviewStyle = "Stash"
PreviewPriceScale = 1

function Inv_HasItem( id )

	for k,v in pairs( LocalInventory ) do
	
		local tbl = item.GetByID( v )
	
		if ( type( id ) == "number" and tbl.ID == id ) or ( type( id ) == "string" and tbl.Model == id ) then
		
			return tbl
		
		end
	
	end

end

function Inv_ItemCount( id )

	local count = 0
	
	for k,v in pairs( LocalInventory ) do
	
		if v == id then
		
			count = count + 1
		
		end
	
	end
	
	return count

end
