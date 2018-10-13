# Args:
# data, composer, country, era, instrument, piece
require_relative 'imslp'
require_relative 'youtube'

OPUS_REGEX = /op ([0-9]+)|op. ([0-9]+)|K ([0-9]+)|BWV ([0-9]+)|HWV ([0-9]+)/
CONCERTO_REGEX = /concerto/i
NAME_ESCAPE_REGEX = /[!\?]/

interrupt = false

trap("INT") {
	interrupt = true
}

composer_file = ARGV[1]
country_file = ARGV[2]
era_file = ARGV[3]
instrument_file = ARGV[4]
piece_file = ARGV[5]


class Instrument
	attr_reader :name, :sprig_id
	@@id = 1
	def initialize(name)
		@name = name
		@sprig_id = @@id
		@@id +=1
	end
	def obj
		{
			"sprig_id" => @sprig_id,
			"name" => @name
		}
	end
	def to_json
		obj.to_json
	end
	def self.set_id(id)
		@@id = id
	end
end
class Composer
	attr_reader :name, :sprig_id
	@@id = 1
	def initialize(name, country_id, era_id)
		@sprig_id = @@id
		@name = name
		@country_id = country_id
		@era_id = era_id
		@@id += 1
	end
	def obj
		c_str = nil
		e_str = nil
		c_str = "<%= sprig_record(Country, #{@country_id}).id %>" if @country_id
		e_str = "<%= sprig_record(Era, #{@era_id}).id %>" if @era_id
		return {
			"sprig_id" => @sprig_id,
			"name" => @name, 
			"country_ids" => [c_str],
			"era_ids" => [e_str]
		}
	end
	def to_json
		obj.to_json
	end
	def self.set_id(id)
		@@id = id
	end
end

class Era
	attr_reader :name, :sprig_id
	@@id = 1
	def initialize(name)
		@sprig_id = @@id
		@name = name
		@@id += 1
	end
	def obj
		{
			"sprig_id" => @sprig_id,
			"name" => @name
		}
	end
	def to_json
		obj.to_json
	end
	def self.set_id(id)
		@@id = id
	end
end

class Country
	attr_reader :name, :sprig_id
	@@id = 1
	def initialize(name)
		@sprig_id = @@id
		@name = name
		@@id += 1
	end
	def obj
		{
			"sprig_id" => @sprig_id,
			"name" => @name
		}
	end
	def to_json
		obj.to_json
	end
	def self.set_id(id)
		@@id = id
	end
end

class Piece
	attr_accessor :composer_id, :instrument_id
	@@id = 1
	def initialize(name, opus, level, minutes, concerto, solo, free, sheet_music_link, youtube_embed, composer_id, instrument_id)
		@sprig_id = @@id
		@name = name
		@opus = opus
		@level = level
		@minutes = minutes
		@concerto = concerto
		@solo = solo
		@free = free
		@sheet_music_link = sheet_music_link
		@youtube_embed = youtube_embed
		@composer_id = composer_id
		@instrument_id = instrument_id
		@@id += 1
	end
	def obj
		{
			"sprig_id" => @sprig_id,
			"name" => @name,
			"opus" => @opus,
			"level" => @level, 
			"minutes" => @minutes,
			"concerto" => @concerto,
			"solo" => @solo,
			"free" => @free,
			"sheet_music_link" => @sheet_music_link,
			"youtube_embed" => @youtube_embed,
			"composer_id" => "<%= sprig_record(Composer, #{@composer_id}).id %>",
			"instrument_ids" => ["<%= sprig_record(Instrument, #{@instrument_id}).id %>"]
		}
	end
	def to_json
		obj.to_json
	end
	def clean
		opus = nil
		@concerto = false
		@free = false
		if (opusmatch = @name.match(OPUS_REGEX))
			opusmatch.captures.each do |c|
				opus = c if c
			end
		end
		if (concertomatch = @name.match(CONCERTO_REGEX))
			@concerto = true
		end
		@opus = opus
		@free = true if @sheet_music_link
		@solo = false if @concerto
	end
	def self.set_id(id)
		@@id = id
	end
end
#sheetmusicplus links
#solo?
class Builder
	attr_accessor :pieces, :instruments, :composers, :eras, :countries, :last_index
	def initialize(composer_file, country_file, era_file, instrument_file, piece_file)
		composer_file_read = File.open(composer_file, "r")
		country_file_read = File.open(country_file, "r")
		era_file_read = File.open(era_file, "r")
		instrument_file_read = File.open(instrument_file, "r")
		piece_file_read = File.open(piece_file, "r")
		off_file_read = File.open("data/leftoff.txt", "r")
		@last_index = off_file_read.read
		@last_index = @last_index.to_i
		@pieces = []
		piece_file_read.readlines.each { |l| @pieces << JSON.parse(l) }
		@instruments = []
		instrument_file_read.readlines.each { |l| @instruments << JSON.parse(l) }
		@composers = []
		composer_file_read.readlines.each { |l| @composers << JSON.parse(l) }
		@eras = []
		era_file_read.readlines.each { |l| @eras << JSON.parse(l) }
		@countries = []
		country_file_read.readlines.each { |l| @countries << JSON.parse(l) }
		composer_file_read.close 
		country_file_read.close
		era_file_read.close 
		instrument_file_read.close 
		piece_file_read.close
		off_file_read.close

		Piece.set_id(@pieces.last["sprig_id"] + 1) if !@pieces.empty?
		Instrument.set_id(@instruments.last["sprig_id"] + 1) if !@instruments.empty?
		Composer.set_id(@composers.last["sprig_id"] + 1) if !@composers.empty?
		Era.set_id(@eras.last["sprig_id"] + 1) if !@eras.empty?
		Country.set_id(@countries.last["sprig_id"] + 1) if !@countries.empty?

		@composer_file = composer_file
		@country_file = country_file
		@era_file = era_file
		@instrument_file = instrument_file
		@piece_file = piece_file
	end
	def build_piece(line)
		name = line["data"]["name"]
		level = line["data"]["level"]
		composer = line["data"]["composer"]
		instrument = line["data"]["instrument"]
		unformatted_composer = line["data"]["unformatted_composer"]
		name = name.gsub(NAME_ESCAPE_REGEX, "")
		name.strip!
		era, country = Imslp.composer_search(composer)
		sheet_music_link = Imslp.piece_search(unformatted_composer, name)
		minutes, youtube_embed = Youtube.search("#{name} #{composer} #{instrument}")
		# Could use results from Youtube somehow

		instrument_id = find_or_build_instrument(instrument)
		composer_id = find_or_build_composer(composer, era, country)

		piece = Piece.new(name, nil, level, minutes, nil, nil, nil, sheet_music_link, youtube_embed, composer_id, instrument_id)
		piece.clean
		@pieces << piece.obj
	end

	# all return object id
	def find_or_build_instrument(instrument)
		@instruments.each do |i|
			if i["name"] == instrument
				return i["sprig_id"]
			end
		end
		new_instrument = Instrument.new(instrument)
		@instruments << new_instrument.obj
		return new_instrument.sprig_id
	end

	def find_or_build_composer(composer, era, country)
		@composers.each do |c|
			if c["name"] == composer
				return c["sprig_id"]
			end
		end
		era_id = nil
		country_id = nil
		era_id = find_or_build_era(era) if era
		country_id = find_or_build_country(country) if country


		new_composer = Composer.new(composer, country_id, era_id)
		@composers << new_composer.obj
		return new_composer.sprig_id
	end

	def find_or_build_era(era)
		@eras.each do |e|
			if e["name"] == era
				return e["sprig_id"]
			end
		end
		new_era = Era.new(era)
		@eras << new_era.obj
		return new_era.sprig_id
	end

	def find_or_build_country(country)
		@countries.each do |c|
			if c["name"] == country
				return c["sprig_id"]
			end
		end
		new_country = Country.new(country)
		@countries << new_country.obj
		return new_country.sprig_id
	end
	def print_all
		composer_file = File.open(@composer_file, "w")
		country_file = File.open(@country_file, "w")
		era_file = File.open(@era_file, "w")
		instrument_file = File.open(@instrument_file, "w")
		piece_file = File.open(@piece_file, "w")
		@countries.each { |c| country_file.puts c.to_json }
		@eras.each { |e| era_file.puts e.to_json }
		@composers.each { |c| composer_file.puts c.to_json }
		@instruments.each { |i| instrument_file.puts i.to_json }
		@pieces.each { |p| piece_file.puts p.to_json}
		composer_file.close
		country_file.close
		era_file.close
		instrument_file.close
		piece_file.close
	end
end

builder = Builder.new(composer_file, country_file, era_file, instrument_file, piece_file)

p builder.last_index
j = builder.last_index
File.open(ARGV[0], "r") do |f|
	f.each_line do |line|
		if $. > j
			builder.build_piece(JSON.parse(line))
			j += 1
			p $. if $. % 10 == 0
		end
		break if interrupt
	end
end

if interrupt 
	builder.print_all
	off_file_write = File.open("data/leftoff.txt", "w")
	off_file_write.write j
	off_file_write.close
	puts "Record " + j.to_s
	exit
end
builder.print_all
puts "Finished"




