# ARGV[0] = INPUT FILE
# ARGV[1] = OUTPUT FILE
require 'json'

records = []
File.open(ARGV[0], "r") do |f|
	f.each_line do |line|
		records << JSON.parse(line)
	end
end

hash = { "records" => records }

File.open(ARGV[1], "w") do |f|
	f.write JSON.pretty_generate(hash)
end