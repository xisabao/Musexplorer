FactoryGirl.define do
	factory :user do
		sequence :email do |n|
     	  "user#{n}@example.com"
    	end
		password FFaker::Internet.password
		username FFaker::Internet.user_name
		description FFaker::Lorem.paragraph
		teacher 0 

		factory :user_with_posts do
			transient do 
				posts_count 3
			end

			after(:create) do |user, evaluator|
				create_list(:post_with_replies, evaluator.posts_count, user: user)
			end
		end
	end
	factory :category do
		name FFaker::Lorem.words
		description FFaker::Lorem.paragraphs

		factory :category_with_posts do
			transient do
				posts_count 5
			end

			after(:create) do |category, evaluator|
				create_list(:post_with_replies, evaluator.posts_count, category: category)
			end
		end
	end

	factory :post do
		title FFaker::Lorem.words
		body FFaker::Lorem.paragraphs
		user

		factory :post_with_replies do
			transient do
				replies_count 3
			end

			after(:create) do |post, evaluator|
				create_list(:reply, evaluator.replies_count, post: post)
			end
		end
	end

	factory :reply do
		body FFaker::Lorem.paragraphs
		user
		post
	end

	factory :country do
		name FFaker::AddressUS.country
	end

	factory :instrument do
		name FFaker::Skill.tech_skills # lolwat
	end

	factory :era do
		name FFaker::HipsterIpsum.word
	end

	factory :composer do
		name FFaker::NameFR.name
		description FFaker::HipsterIpsum.paragraph

		before(:create) do |composer|
			composer.countries << create(:country)
			composer.eras << create(:era)
		end
	end	

	factory :piece do
		name FFaker::Lorem.words
		composer
		opus 1 + Random.rand(1000)
		level 1 + Random.rand(10)
		minutes 1 + Random.rand(40)
		concerto  [true, false].sample
		solo [true, false].sample
		free [true, false].sample
		sheet_music_link FFaker::Lorem.words
		youtube_embed FFaker::HTMLIpsum.a

		before(:create) do |piece|
			piece.instruments << create(:instrument)
			piece.tags << create(:tag)
			piece.users << create(:user)
		end
		factory :piece_with_tips do 
			transient do
				tips_count 3
			end
			after(:create) do |piece, evaluator|
				create_list(:tip, evaluator.tips_count, piece: piece)
			end
		end
		factory :piece_with_posts do
			transient do
				posts_count 3
			end
			after(:create) do |piece, evaluator|
				create_list(:post_with_replies, evaluator.posts_count)
			end
		end
	end
	factory :tip do 
		piece
		user
		body FFaker::Lorem.paragraph
	end
	factory :tag do
		name FFaker::HipsterIpsum.word
	end
end