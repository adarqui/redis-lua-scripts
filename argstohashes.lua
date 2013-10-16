function string:split(delimiter)
	local result = { }
	local from  = 1
	local delim_from, delim_to = string.find( self, delimiter, from  )
	while delim_from do
		table.insert( result, string.sub( self, from , delim_from-1 ) )
		from  = delim_to + 1
		delim_from, delim_to = string.find( self, delimiter, from  )
	end
	table.insert( result, string.sub( self, from  ) )
	return result
end

local pids = ARGV[1]
local posts = {}
local i = 0
local s = string.split(pids,',')
for i = 0, #s, 1 do
	local post_token = "post:" .. tostring(s[i])
	local ret = redis.call('hgetall', post_token)
	posts[i] = ret
end
return posts
