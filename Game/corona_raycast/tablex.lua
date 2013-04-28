module(..., package.seeall)

local insert = table.insert

-- removes all entries from a table
function clear(table)
	for k, v in pairs(table) do
		table[k] = nil	
	end
	return table
end

function count(t)
	local count = 0
	for _,v in pairs(t) do
		count = count + 1
	end
	return count
end

function icount(t)
	local i = 0
	for _, v in ipairs(t) do
		i = i + 1
	end
	return i
end	
