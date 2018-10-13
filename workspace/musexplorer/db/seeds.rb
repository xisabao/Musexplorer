
Category.destroy_all

include Sprig::Helpers

sprig [Composer, Instrument, Piece, Country, Era]
# austria = Country.create(name: "Austria")
# germany = Country.create(name: "Germany")
# classical = Era.create(name: "Classical")
# romantic = Era.create(name: "Romantic")
# mozart = Composer.create(name: "Wolfgang Amadeus Mozart", countries: [austria], eras: [classical])
# beethoven = Composer.create(name: "Ludwig van Beethoven", countries: [germany], eras: [classical, romantic])
# flute = Instrument.create(name: "flute")
# piano = Instrument.create(name: "piano")
# p1 = Piece.new(name: "Flute Concerto in G major",
#   opus: 313,
#   level: 9,
#   minutes: 26,
#   concerto: true,
#   solo: false,
#   free: true,
#   sheet_music_link: "http://imslp.org/wiki/Flute_Concerto_in_G_major,_K.313/285c_(Mozart,_Wolfgang_Amadeus)",
#   youtube_embed: '<iframe width="560" height="315" src="https://www.youtube.com/embed/8zPkWVqdJXI" frameborder="0" allowfullscreen></iframe>',
#   composer: mozart)
# p1.instruments << flute
# p1.save
# p2 = Piece.new(name: "Fur Elise",
#   opus: 59,
#   level: 6,
#   minutes: 3,
#   concerto: false,
#   solo: true,
#   free: true,
#   sheet_music_link: "http://imslp.org/wiki/F%C3%BCr_Elise,_WoO_59_(Beethoven,_Ludwig_van)",
#   youtube_embed: '<iframe width="420" height="315" src="https://www.youtube.com/embed/k_UOuSklNL4" frameborder="0" allowfullscreen></iframe>',
#   composer: beethoven)
# p2.instruments << piano
# p2.save
Category.create(name: "General", description: "For general discussion.")
Category.create(name: "Cello", description: "Posts relating to the cello.")
Category.create(name: "Clarinet", description: "Forum for clarinet-related posts.")
Category.create(name: "Flute", description: "Any posts related to flute playing or music are welcomed here!")
Category.create(name: "Guitar", description: "Posts related to guitar.")
Category.create(name: "Piano", description: "A forum for anything and everything about the piano.")
Category.create(name: "Trumpet", description: "Place for posts about trumpet-playing.")
Category.create(name: "Viola", description: "Form for viola-related posts.")
Category.create(name: "Violin", description: "Forum for discussion about the violin.")
Category.create(name: "Voice", description: "Posts relating to the voice.")
