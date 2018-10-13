# First arg: txt file
# Second arg: json file
require 'json'
LEVEL_REGEX = /^Level ([0-9]+)|Grade ([0-9]+)/
COMPOSER_REGEX = /^([A-ZÀ-Ú]{1}[A-zÀ-ú'-]+){1,2}, ([A-ZÀ-Ú]{1}[a-zà-ú'\- ]+[A-ZÀ-Ú]{0,1}[a-zà-ú'\- ]*[A-ZÀ-Ú]{0,1}[a-zà-ú'\- ]*[A-ZÀ-Ú]{0,1}[a-zà-ú'\- ]*[A-ZÀ-Ú]{0,1}[a-zà-ú'\- ]*)/
ANON_REGEX = /^Anonymous/
TRADITIONAL_REGEX = /^Traditional/
NAME_REGEX = /^[lu●\(cid:88\)]+[ \t]+([A-ZÀ-Ú]{1}[A-zÀ-ú\.,0-9 ]+[^\(\):;]+)|^(Concerto [A-zÀ-ú ,.0-9]*)|^(Sonat[A-zÀ-ú ,.0-9]*)|^(Partita[A-zÀ-ú ,.0-9]*)|^(Suite[A-zÀ-ú ,.0-9]*)|^([A-z]+ Concerto[A-zÀ-ú ,.0-9]*)/
ARCT_REGEX = /ARCT/
class Piece
	attr_accessor :name, :level, :composer, :unformatted_composer, :instrument
	def initialize(name, level, composer, unformatted_composer, instrument)
		@name = name
		@level = level
		@composer = composer
		@unformatted_composer = unformatted_composer
		@instrument = instrument
	end
	def to_json
		{
			"json_class" => self.class.name,
			"data" => {"instrument" => @instrument, "name" => @name, "level" => @level, "composer" => @composer, "unformatted_composer" => @unformatted_composer}
		}.to_json
	end
	def clean
		@name.slice!(/ [A-Z&]{3}/)
	end
end

arr = []
File.open(ARGV[0], "r") do |f|
	f.each_line do |line|
		arr << line.strip!
	end
end

parr = []

level = 0
lvl = 0
composer = ""
unformatted_composer = ""
instrument = arr[0].strip

arr.each_with_index do |line, i|
	if line && !line.empty?
		lvlmatch = line.match(LEVEL_REGEX)
		if lvlmatch
			lvlmatch.captures.each do |c|
				lvl = c.to_i if c
			end
			if lvl
				if lvl == 1 || lvl == 2
					level = 1
				else
					level = lvl - 1
				end
			end
		end
		arctmatch = line.match(ARCT_REGEX)
		level = 10 if arctmatch
		if (composermatch = line.match(COMPOSER_REGEX))
			composer = composermatch.captures[1] + " " + composermatch.captures[0]
			unformatted_composer = composermatch.captures[0] + ", " + composermatch.captures[1]
		end
		anonmatch = line.match(ANON_REGEX)
		composer = "Anonymous" if anonmatch
		
		traditionalmatch = line.match(TRADITIONAL_REGEX)
		composer = "Traditional" if traditionalmatch
		unformatted_composer = composer if anonmatch || traditionalmatch

		if (namematch = line.match(NAME_REGEX))
			namecapture = ""
			namematch.captures.each do |c|
				namecapture = c if c
			end

			parr << Piece.new(namecapture, level, composer, unformatted_composer, instrument)
		end
	end
end


puts parr.length.to_s + " pieces"
File.open(ARGV[1], 'w') do |s|
	parr.each do |p|
		p.clean
		s.puts p.to_json
	end
end