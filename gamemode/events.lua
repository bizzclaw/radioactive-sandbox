
module( "event", package.seeall )

local Events = {}

function Register( tbl )

	table.insert( Events, tbl )

end

function GetRandom()

	return table.Random( Events )

end