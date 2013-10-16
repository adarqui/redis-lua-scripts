require 'rubygems'
require 'redis'

r = Redis.new

LPUSHUNIQ = <<EOF
    local i = 1
    local res
	res = redis.call('LRANGE', KEYS[1], 0, -1)
	while true do
		if res[i] == nil then
			res = redis.call('LPUSH', KEYS[1], ARGV[1])
			return 0
		elseif res[i] == ARGV[1] then
			return i
		end
		i = i + 1
	end
	return 0
EOF

if ARGV.length < 2
    puts "Usage: ruby lpushuniq.rb <queue> <item>"
    exit(-1)
end

begin
	x = r.eval(LPUSHUNIQ, :keys => [ARGV[0]], :argv => [ARGV[1]])
rescue
	puts "Error."
end

	puts "Success: return value: #{x}"

	puts "#{ARGV[1]} is not an element of #{ARGV[0]}, performing lpush" if x == 0
	puts "#{ARGV[1]} already exists, refusing to lpush" if x != 0
