require 'google-search'
require 'fuzzy_match'
module Google
	def Google.composer_search(composer)
		search = Google::Search::Web.new({query: "site:imslp.org #{composer}"})
		results = search.get_response.hash["responseData"]["results"]
		result = ""
		results.each do |r|
			if r["titleNoFormatting"].match(/^Category:/)
				return r["url"]
			end
		end
		return nil
	end
	def Google.piece_search(unformatted_composer, piece)
		search = Google::Search::Web.new({query: "site:imslp.org #{unformatted_composer} #{piece}"})
		result = search.get_response.hash["responseData"]["results"][0]
		if result
			f = FuzzyMatch.new([result["titleNoFormatting"]])
			similarity = f.find_with_score("#{piece} (#{unformatted_composer})")
			return result["url"] if similarity && similarity[2] > 0.3
		end
		return nil
	end

end

# puts Google.composer_search("Franz Schubert")
# puts Google.composer_search("Klaus Huber")
# puts Google.piece_search("Johann Christian Bach", "Aria in F Major, Anh. 131")