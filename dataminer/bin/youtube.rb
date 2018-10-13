require 'google/api_client'

DEVELOPER_KEY = 'AIzaSyCSiCxS6xYv7jf2H7hUADtFiwuCEsu1oSg'
YOUTUBE_API_SERVICE_NAME = 'youtube'
YOUTUBE_API_VERSION = 'v3'
LENGTH_REGEX = /([0-9]{1,2})M([0-9]{1,2})S/
module Youtube
	def Youtube.get_service
		client = Google::APIClient.new(
			key: DEVELOPER_KEY,
			authorization: nil,
			application_name: 'Musexplorer',
			application_version: '1.0.0'
			)
		youtube = client.discovered_api(YOUTUBE_API_SERVICE_NAME, YOUTUBE_API_VERSION)
		return client, youtube
	end

	def Youtube.search(term)
		max_results = 1

		client, youtube = Youtube.get_service

		begin

		search_response = client.execute!(
			api_method: youtube.search.list,
			parameters: {
				part: 'snippet',
				q: term,
				maxResults: max_results
				}
			)
		videos = []
		videoIds = []

		search_response.data.items.each do |search_result|
			if search_result.id.kind == 'youtube#video'
				videos << "#{search_result.snippet.title} (#{search_result.id.videoId})"
				videoIds << search_result.id.videoId
			end
		end

		video_response = client.execute!(
			api_method: youtube.videos.list,
			parameters: {
				id: "#{videoIds[0]}",
				part: "player, contentDetails"
			}
		)

		video_result = video_response.data.items[0]
		if video_result
			durationmatch = video_result["contentDetails"]["duration"].match(LENGTH_REGEX)
			minutes =  durationmatch.captures[0] if durationmatch
			seconds = durationmatch.captures[1] if durationmatch
			embed = video_result["player"]["embedHtml"]
			minutes = minutes.to_i
			minutes = 1 if minutes < 1

			return minutes, embed
		end
		rescue Google::APIClient::TransmissionError => e
			puts e.result.body
		end
		return nil, nil
	end	
end
# puts Youtube.search("Capriccio in F sharp Minor, op. 76, no. 1").inspect