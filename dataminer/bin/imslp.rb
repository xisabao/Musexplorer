require 'open-uri'
require 'nokogiri'
require 'uri'
require_relative 'google'

TIME_PERIOD_REGEX = /Time Period=([A-z 0-9]+)/
NATIONALITY_REGEX = /Nationality=([A-z]+)/
EDIT_URL_REGEX = /editurl=\"(.+)">/
AMPERSAND_REGEX = /&amp;/
COMPOSER_REGEX = /^([A-ZÀ-Ú]{1}[A-zÀ-ú'\- ]+) ([A-ZÀ-Ú]{1}[A-zÀ-ú'\-]+){1,2}$/
URL_REGEX = /(Category:[A-ZÀ-Ú]{1}[A-zÀ-ú'\- ,%0-9]+)/
ESCAPE_REGEX = /%[A-Z0-9]{1,4}/
module Imslp
	def Imslp.composer_search(composer)
		editurl = ""
		url = Google.composer_search(composer)
		if url
			if url.match(ESCAPE_REGEX)
				url = URI.unescape(url)
			end
			if url && (urlmatch = url.match(URL_REGEX))
				name = urlmatch.captures[0]
				
				begin
					open("http://imslp.org/api.php?action=query&prop=categoryinfo|info&titles=#{name}&inprop=url&format=xml") do |f|
						line = ""
						f.each_line { |l| line = l }
						lm = line.match(EDIT_URL_REGEX)
						editurl = lm.captures[0].gsub(AMPERSAND_REGEX, '&') if lm
					end
				rescue OpenURI::HTTPError => error
					p response.status.inspect
					return nil, nil
				end
			end	
			if editurl != ""
				doc = Nokogiri::HTML(open(editurl))

		 		content = doc.at_css('#wpTextbox1').to_s

		 		periodmatch = content.match(TIME_PERIOD_REGEX)
		 		countrymatch = content.match(NATIONALITY_REGEX)
				
				if periodmatch && countrymatch
		 			return periodmatch.captures[0], countrymatch.captures[0]
		 		end
			end
		end
		return nil, nil
	end
	def Imslp.piece_search(unformatted_composer, piece)
		return Google.piece_search(unformatted_composer, piece)
	end
end
# p Imslp.composer_search("Frédéric Chopin")
# puts Imslp.piece_search("Chopin, Frédéric", "Nocturne in B Major, op. 62, no. 1")
