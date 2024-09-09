--!Type(Module)

--!SerializeField
local fishTextures : {Texture} = nil

local Utils = require("Utils")
local itemMetaData = require("ItemMetaData")

FishDifficulties = {
    ["Common"] = 1,
    ["Uncommon"] = 1.5,
    ["Rare"] = 2,
    ["Legendary"] = 2.5,
    ["Mythical"] = 3
}
--[[
Q20xx - Common
Q30xx - Uncommon
Q40xx - Rare
Q50xx - Legendary
Q60xx - Mythical
]]

-- Separated tables for each attribute, keyed by fish ID

local FishBiomes = {
    ["black_crappie"] = {"Lake", "River"},
    ["yellow_perch"] = {"River", "Lake", "Ice"},
    ["blue_gill"] = {"River", "Lake"},
    ["pumpkinseed"] = {"Lake", "River"},
    ["boot_fish"] = {"Any"},
    ["can_fish"] = {"Any"},
    ["long_mouth_bass"] = {"River", "Lake", "Ice"},
    ["salmon"] = {"River", "Waterfall"},
    ["crystal_fairy_fish"] = {"Ice"},
    ["dragon_fish"] = {"Ocean", "Waterfall"},
    ["unicorn_fish"] = {"Lake"},
    ["anchovi_fish"] = {"Ocean"},
    ["angler_fish"] = {"Ocean"},
    ["arowana_fish"] = {"River", "Lake"},
    ["barred_knife_fish"] = {"River", "Lake"},
    ["beach_shark_fish"] = {"Ocean"},
    ["begginers_luck_fish"] = {"Any"},
    ["betta_fish"] = {"River", "Lake"},
    ["black_ghostshark"] = {"Ocean"},
    ["black_drum_fish"] = {"Ocean"},
    ["blue_whale"] = {"Ocean"},
    ["blue_tang"] = {"Ocean"},
    ["alley_cat_fish"] = {"River", "Lake"},
    ["catfish"] = {"River", "Lake"},
    ["chum_salmon_fish"] = {"River", "Waterfall"},
    ["clown_fish"] = {"Ocean"},
    ["coho_salmon_fish"] = {"River", "Waterfall"},
    ["common_carp_fish"] = {"River", "Lake"},
    ["crab"] = {"Ocean"},
    ["dolphin"] = {"Ocean"},
    ["rasta_drum_fish"] = {"Ocean"},
    ["dumbo_octopus"] = {"Ocean"},
    ["electric_eel"] = {"River", "Lake"},
    ["flounder_fish"] = {"Ocean"},
    ["tourist_fish"] = {"Any"},
    ["gold_fish"] = {"River", "Lake"},
    ["goliath_tiger_fish"] = {"River", "Lake", "Ocean"},
    ["jelly_fish"] = {"Ocean"},
    ["jogger_fish"] = {"River", "Lake"},
    ["killer_whale"] = {"Ocean"},
    ["king_catfish"] = {"River", "Lake"},
    ["king_mackerel"] = {"Ocean"},
    ["king_salmon"] = {"River", "Waterfall"},
    ["king_seahorse"] = {"Ocean"},
    ["koi_fish_samurai"] = {"River", "Lake"},
    ["koi_fish_large"] = {"River", "Lake"},
    ["large_stripped_bass"] = {"River", "Lake", "Ice"},
    ["lion_fish"] = {"Ocean"},
    ["freindly_local_fish"] = {"Any"},
    ["mouse_fish"] = {"River", "Lake"},
    ["newborn_salmon"] = {"River", "Waterfall"},
    ["nomadic_trout"] = {"River", "Lake", "Ice"},
    ["northern_pike"] = {"Ice"},
    ["octopus"] = {"Ocean"},
    ["oil_eater_fish"] = {"Ocean"},
    ["omnipotent_squid"] = {"Ocean"},
    ["pearl_perch_fish"] = {"Ocean"},
    ["peasant_fish"] = {"Any"},
    ["pink_salmon"] = {"River", "Waterfall"},
    ["piranha"] = {"Lake"},
    ["red_snapper_fish"] = {"Ocean"},
    ["rock_bass_fish"] = {"River", "Lake", "Ice"},
    ["royal_lake_fish"] = {"Lake"},
    ["salt_trader_fish"] = {"Ocean"},
    ["saw_fish"] = {"Ocean"},
    ["seahorse"] = {"Ocean"},
    ["servant_fish"] = {"Any"},
    ["small_common_trout"] = {"River", "Lake", "Ice"},
    ["rainbow_trout"] = {"River", "Lake", "Ice"},
    ["spotted_bass_fish"] = {"River", "Lake", "Ice"},
    ["squid"] = {"Ocean"},
    ["squirrel_fish"] = {"River", "Lake"},
    ["star_fish"] = {"Ocean"},
    ["sting_ray"] = {"Ocean"},
    ["sun_fish"] = {"Ocean"},
    ["surffer_fish"] = {"Ice", "Ocean"},
    ["sword_fish"] = {"Ocean"},
    ["tiger_pistol_shrimp"] = {"Any"},
    ["transparent_head_fish"] = {"Ocean"},
    ["buisness_fish"] = {"Any"},
    ["derp_fish"] = {"Any"},
    ["king_fish"] = {"Any"},
    ["walley_fish"] = {"River", "Lake", "Ice"},
    ["albino_catfish"] = {"River", "Lake"},
    ["yellow_watchman"] = {"Ocean"},
}

local FishNames = {
    ["black_crappie"] = "Black Crappie",
    ["yellow_perch"] = "Yellow Perch",
    ["blue_gill"] = "Blue Gill",
    ["pumpkinseed"] = "Pumpkinseed",
    ["boot_fish"] = "A Boot",
    ["can_fish"] = "A Tin Can",
    ["long_mouth_bass"] = "Long Mouth Bass",
    ["salmon"] = "Salmon",
    ["crystal_fairy_fish"] = "Crystal Fairy Fish",
    ["dragon_fish"] = "Dragon Fish",
    ["unicorn_fish"] = "Unicorn Fish",
    ["anchovi_fish"] = "Anchovi Fish",
    ["angler_fish"] = "Angler Fish",
    ["arowana_fish"] = "Arowana Fish",
    ["barred_knife_fish"] = "Barred Knife Fish",
    ["beach_shark_fish"] = "Beach Shark",
    ["begginers_luck_fish"] = "Beginner's Luck",
    ["betta_fish"] = "Betta Fish",
    ["black_ghostshark"] = "Black Ghostshark",
    ["black_drum_fish"] = "Black Drum Fish",
    ["blue_whale"] = "Blue Whale",
    ["blue_tang"] = "Blue Wish Fish",
    ["alley_cat_fish"] = "Alley Cat Fish",
    ["catfish"] = "Catfish",
    ["chum_salmon_fish"] = "Chum Salmon",
    ["clown_fish"] = "Clown Fish",
    ["coho_salmon_fish"] = "Coho Salmon",
    ["common_carp_fish"] = "Common Carp",
    ["crab"] = "Crab",
    ["dolphin"] = "Dolphin",
    ["rasta_drum_fish"] = "Rasta Drum Fish",
    ["dumbo_octopus"] = "Dumbo Octopus",
    ["electric_eel"] = "Electric Eel",
    ["flounder_fish"] = "Flounder Fish",
    ["tourist_fish"] = "Tourist Fish",
    ["gold_fish"] = "Gold Fish",
    ["goliath_tiger_fish"] = "Goliath Tiger Fish",
    ["jelly_fish"] = "Jelly Fish",
    ["jogger_fish"] = "Jogger Fish",
    ["killer_whale"] = "Killer Whale",
    ["king_catfish"] = "King Catfish",
    ["king_mackerel"] = "King Mackerel",
    ["king_salmon"] = "King Salmon",
    ["king_seahorse"] = "King Seahorse",
    ["koi_fish_samurai"] = "Koi Fish Samurai",
    ["koi_fish_large"] = "Large Koi",
    ["large_stripped_bass"] = "Large Stripped Bass",
    ["lion_fish"] = "Lion Fish",
    ["freindly_local_fish"] = "Friendly Local Fish",
    ["mouse_fish"] = "Mouse Fish",
    ["newborn_salmon"] = "Newborn Salmon",
    ["nomadic_trout"] = "Nomadic Trout",
    ["northern_pike"] = "Northern Pike",
    ["octopus"] = "Octopus",
    ["oil_eater_fish"] = "Oil Eater Fish",
    ["omnipotent_squid"] = "Omnipotent Squid",
    ["pearl_perch_fish"] = "Pearl Perch Fish",
    ["peasant_fish"] = "Peasant Fish",
    ["pink_salmon"] = "Pink Salmon",
    ["piranha"] = "Piranha",
    ["red_snapper_fish"] = "Red Snapper Fish",
    ["rock_bass_fish"] = "Rock Bass",
    ["royal_lake_fish"] = "Royal Lake Fish",
    ["salt_trader_fish"] = "Salt Trader Fish",
    ["saw_fish"] = "Saw Fish",
    ["seahorse"] = "Seahorse",
    ["servant_fish"] = "Servant Fish",
    ["small_common_trout"] = "Common Trout",
    ["rainbow_trout"] = "Rainbow Trout",
    ["spotted_bass_fish"] = "Spotted Bass",
    ["squid"] = "Squid",
    ["squirrel_fish"] = "Squirrel Fish",
    ["star_fish"] = "Star Fish",
    ["sting_ray"] = "Sting Ray",
    ["sun_fish"] = "Sun Fish",
    ["surffer_fish"] = "Surfer Fish",
    ["sword_fish"] = "Sword Fish",
    ["tiger_pistol_shrimp"] = "Tiger Pistol Shrimp",
    ["transparent_head_fish"] = "Transparent Head Fish",
    ["buisness_fish"] = "Business Fish",
    ["derp_fish"] = "Derp Fish",
    ["king_fish"] = "King Fish",
    ["walley_fish"] = "Walleye",
    ["albino_catfish"] = "Albino Catfish",
    ["yellow_watchman"] = "Yellow Watchman",
}

local FishRarity = {
    ["black_crappie"] = "Common",
    ["yellow_perch"] = "Common",
    ["blue_gill"] = "Common",
    ["pumpkinseed"] = "Common",
    ["boot_fish"] = "Uncatchable",
    ["can_fish"] = "Uncatchable",
    ["long_mouth_bass"] = "Uncommon",
    ["salmon"] = "Uncommon",
    ["crystal_fairy_fish"] = "Legendary",
    ["dragon_fish"] = "Mythical",
    ["unicorn_fish"] = "Mythical",
    ["anchovi_fish"] = "Common",
    ["angler_fish"] = "Legendary",
    ["arowana_fish"] = "Uncommon",
    ["barred_knife_fish"] = "Rare",
    ["beach_shark_fish"] = "Legendary",
    ["begginers_luck_fish"] = "Legendary",
    ["betta_fish"] = "Rare",
    ["black_ghostshark"] = "Mythical",
    ["black_drum_fish"] = "Uncommon",
    ["blue_whale"] = "Mythical",
    ["blue_tang"] = "Rare",
    ["alley_cat_fish"] = "Uncommon",
    ["catfish"] = "Common",
    ["chum_salmon_fish"] = "Rare",
    ["clown_fish"] = "Common",
    ["coho_salmon_fish"] = "Uncommon",
    ["common_carp_fish"] = "Common",
    ["crab"] = "Common",
    ["dolphin"] = "Legendary",
    ["rasta_drum_fish"] = "Mythical",
    ["dumbo_octopus"] = "Rare",
    ["electric_eel"] = "Uncommon",
    ["flounder_fish"] = "Common",
    ["tourist_fish"] = "Legendary",
    ["gold_fish"] = "Rare",
    ["goliath_tiger_fish"] = "Uncommon",
    ["jelly_fish"] = "Mythical",
    ["jogger_fish"] = "Common",
    ["killer_whale"] = "Legendary",
    ["king_catfish"] = "Legendary",
    ["king_mackerel"] = "Legendary",
    ["king_salmon"] = "Legendary",
    ["king_seahorse"] = "Legendary",
    ["koi_fish_samurai"] = "Mythical",
    ["koi_fish_large"] = "Rare",
    ["large_stripped_bass"] = "Uncommon",
    ["lion_fish"] = "Mythical",
    ["freindly_local_fish"] = "Legendary",
    ["mouse_fish"] = "Rare",
    ["newborn_salmon"] = "Rare",
    ["nomadic_trout"] = "Legendary",
    ["northern_pike"] = "Uncommon",
    ["octopus"] = "Mythical",
    ["oil_eater_fish"] = "Rare",
    ["omnipotent_squid"] = "Mythical",
    ["pearl_perch_fish"] = "Common",
    ["peasant_fish"] = "Mythical",
    ["pink_salmon"] = "Uncommon",
    ["piranha"] = "Legendary",
    ["red_snapper_fish"] = "Rare",
    ["rock_bass_fish"] = "Common",
    ["royal_lake_fish"] = "Legendary",
    ["salt_trader_fish"] = "Mythical",
    ["saw_fish"] = "Rare",
    ["seahorse"] = "Rare",
    ["servant_fish"] = "Uncommon",
    ["small_common_trout"] = "Common",
    ["rainbow_trout"] = "Rare",
    ["spotted_bass_fish"] = "Uncommon",
    ["squid"] = "Legendary",
    ["squirrel_fish"] = "Uncommon",
    ["star_fish"] = "Mythical",
    ["sting_ray"] = "Rare",
    ["sun_fish"] = "Common",
    ["surffer_fish"] = "Legendary",
    ["sword_fish"] = "Mythical",
    ["tiger_pistol_shrimp"] = "Legendary",
    ["transparent_head_fish"] = "Mythical",
    ["buisness_fish"] = "Legendary",
    ["derp_fish"] = "Rare",
    ["king_fish"] = "Uncommon",
    ["walley_fish"] = "Uncommon",
    ["albino_catfish"] = "Rare",
    ["yellow_watchman"] = "Mythical",
}

local FishWorth = {
    ["black_crappie"] = 7,
    ["yellow_perch"] = 5,
    ["blue_gill"] = 7,
    ["pumpkinseed"] = 5,
    ["boot_fish"] = 0,
    ["can_fish"] = 0,
    ["long_mouth_bass"] = 15,
    ["salmon"] = 15,
    ["crystal_fairy_fish"] = 200,
    ["dragon_fish"] = 7500,
    ["unicorn_fish"] = 10000,
    ["anchovi_fish"] = 5,
    ["angler_fish"] = 100,
    ["arowana_fish"] = 20,
    ["barred_knife_fish"] = 30,
    ["beach_shark_fish"] = 100,
    ["begginers_luck_fish"] = 150,
    ["betta_fish"] = 50,
    ["black_ghostshark"] = 500,
    ["black_drum_fish"] = 15,
    ["blue_whale"] = 500,
    ["blue_tang"] = 30,
    ["alley_cat_fish"] = 20,
    ["catfish"] = 5,
    ["chum_salmon_fish"] = 30,
    ["clown_fish"] = 7,
    ["coho_salmon_fish"] = 15,
    ["common_carp_fish"] = 7,
    ["crab"] = 5,
    ["dolphin"] = 100,
    ["rasta_drum_fish"] = 100,
    ["dumbo_octopus"] = 30,
    ["electric_eel"] = 20,
    ["flounder_fish"] = 5,
    ["tourist_fish"] = 150,
    ["gold_fish"] = 50,
    ["goliath_tiger_fish"] = 15,
    ["jelly_fish"] = 100,
    ["jogger_fish"] = 5,
    ["killer_whale"] = 100,
    ["king_catfish"] = 150,
    ["king_mackerel"] = 100,
    ["king_salmon"] = 100,
    ["king_seahorse"] = 100,
    ["koi_fish_samurai"] = 10000,
    ["koi_fish_large"] = 50,
    ["large_stripped_bass"] = 15,
    ["lion_fish"] = 500,
    ["freindly_local_fish"] = 100,
    ["mouse_fish"] = 30,
    ["newborn_salmon"] = 50,
    ["nomadic_trout"] = 100,
    ["northern_pike"] = 25,
    ["octopus"] = 750,
    ["oil_eater_fish"] = 30,
    ["omnipotent_squid"] = 500,
    ["pearl_perch_fish"] = 5,
    ["peasant_fish"] = 1,
    ["pink_salmon"] = 20,
    ["piranha"] = 150,
    ["red_snapper_fish"] = 30,
    ["rock_bass_fish"] = 5,
    ["royal_lake_fish"] = 100,
    ["salt_trader_fish"] = 500,
    ["saw_fish"] = 30,
    ["seahorse"] = 30,
    ["servant_fish"] = 15,
    ["small_common_trout"] = 5,
    ["rainbow_trout"] = 30,
    ["spotted_bass_fish"] = 15,
    ["squid"] = 100,
    ["squirrel_fish"] = 30,
    ["star_fish"] = 500,
    ["sting_ray"] = 30,
    ["sun_fish"] = 7,
    ["surffer_fish"] = 100,
    ["sword_fish"] = 500,
    ["tiger_pistol_shrimp"] = 150,
    ["transparent_head_fish"] = 750,
    ["buisness_fish"] = 150,
    ["derp_fish"] = 30,
    ["king_fish"] = 15,
    ["walley_fish"] = 15,
    ["albino_catfish"] = 30,
    ["yellow_watchman"] = 500,
}

local FishQuestID = {
    ["black_crappie"] = "Q2001",
    ["yellow_perch"] = "Q2002",
    ["blue_gill"] = "Q2003",
    ["pumpkinseed"] = "Q2004",
    ["boot_fish"] = "Q2005",
    ["can_fish"] = "Q2006",
    ["long_mouth_bass"] = "Q3001",
    ["salmon"] = "Q3002",
    ["crystal_fairy_fish"] = "Q5001",
    ["dragon_fish"] = "Q6001",
    ["unicorn_fish"] = "Q6002",
    ["anchovi_fish"] = "Q2007",
    ["angler_fish"] = "Q5002",
    ["arowana_fish"] = "Q3003",
    ["barred_knife_fish"] = "Q4002",
    ["beach_shark_fish"] = "Q5003",
    ["begginers_luck_fish"] = "Q5004",
    ["betta_fish"] = "Q4003",
    ["black_ghostshark"] = "Q6003",
    ["black_drum_fish"] = "Q3004",
    ["blue_whale"] = "Q6004",
    ["blue_tang"] = "Q4004",
    ["alley_cat_fish"] = "Q3005",
    ["catfish"] = "Q2008",
    ["chum_salmon_fish"] = "Q4005",
    ["clown_fish"] = "Q2009",
    ["coho_salmon_fish"] = "Q3006",
    ["common_carp_fish"] = "Q2010",
    ["crab"] = "Q2011",
    ["dolphin"] = "Q5005",
    ["rasta_drum_fish"] = "Q6005",
    ["dumbo_octopus"] = "Q4006",
    ["electric_eel"] = "Q3007",
    ["flounder_fish"] = "Q2012",
    ["tourist_fish"] = "Q5006",
    ["gold_fish"] = "Q4007",
    ["goliath_tiger_fish"] = "Q3008",
    ["jelly_fish"] = "Q6006",
    ["jogger_fish"] = "Q2013",
    ["killer_whale"] = "Q5007",
    ["king_catfish"] = "Q5008",
    ["king_mackerel"] = "Q5009",
    ["king_salmon"] = "Q5010",
    ["king_seahorse"] = "Q5011",
    ["koi_fish_samurai"] = "Q6007",
    ["koi_fish_large"] = "Q4008",
    ["large_stripped_bass"] = "Q3009",
    ["lion_fish"] = "Q6008",
    ["freindly_local_fish"] = "Q5012",
    ["mouse_fish"] = "Q4009",
    ["newborn_salmon"] = "Q4010",
    ["nomadic_trout"] = "Q5013",
    ["northern_pike"] = "Q3010",
    ["octopus"] = "Q6010",
    ["oil_eater_fish"] = "Q4011",
    ["omnipotent_squid"] = "Q6011",
    ["pearl_perch_fish"] = "Q2014",
    ["peasant_fish"] = "Q6012",
    ["pink_salmon"] = "Q3011",
    ["piranha"] = "Q5014",
    ["red_snapper_fish"] = "Q4012",
    ["rock_bass_fish"] = "Q2015",
    ["royal_lake_fish"] = "Q5015",
    ["salt_trader_fish"] = "Q6013",
    ["saw_fish"] = "Q4013",
    ["seahorse"] = "Q4014",
    ["servant_fish"] = "Q3012",
    ["small_common_trout"] = "Q2016",
    ["rainbow_trout"] = "Q4015",
    ["spotted_bass_fish"] = "Q3013",
    ["squid"] = "Q5016",
    ["squirrel_fish"] = "Q3014",
    ["star_fish"] = "Q6014",
    ["sting_ray"] = "Q4016",
    ["sun_fish"] = "Q2017",
    ["surffer_fish"] = "Q5017",
    ["sword_fish"] = "Q6015",
    ["tiger_pistol_shrimp"] = "Q5018",
    ["transparent_head_fish"] = "Q6016",
    ["buisness_fish"] = "Q5019",
    ["derp_fish"] = "Q4017",
    ["king_fish"] = "Q5020",
    ["walley_fish"] = "Q3015",
    ["albino_catfish"] = "Q4018",
    ["yellow_watchman"] = "Q6017",
}

local FishDescriptions = {
    ["black_crappie"] = "The Black Crappie loves to play hide and seek in the lake weeds!",
    ["yellow_perch"] = "A vibrant fish with a taste for adventure, and anything else it can munch!",
    ["blue_gill"] = "This colorful little fish is the social butterfly of the pond!",
    ["pumpkinseed"] = "This fish looks like a piece of swimming autumn with its splash of orange and green!",
    ["boot_fish"] = "A boot that somehow ended up in the water.",
    ["can_fish"] = "well... at least it's tuna.",
    ["long_mouth_bass"] = "Known for its large mouth and aggressive strikes.",
    ["salmon"] = "The Salmon is a world traveler, swimming from the ocean to the river for its grand finale!",
    ["crystal_fairy_fish"] = "A legendary fish with crystal-like scales and magical properties.",
    ["dragon_fish"] = "With a mouth full of fangs, the Dragonfish is the sea's fiercest little dragon!",
    ["unicorn_fish"] = "The Unicorn Fish is a majestic swimmer that makes every dive feel like a fairytale!",
    ["anchovi_fish"] = "Your pizza’s missing ingredient has arrived—straight from the sea with a dash of salty charm!",
    ["angler_fish"] = "The Anglerfish is the ocean’s dark magician, luring in its prey with an eerie light!",
    ["arowana_fish"] = "This majestic fish is the underwater equivalent of a high-speed rocket, cutting through the water with style!",
    ["barred_knife_fish"] = "This fish wears its bold bars like a prison uniform, cutting through water with a rebellious flair!",
    ["beach_shark_fish"] = "The Beach Shark is the ultimate sun-seeker, cruising the surf like it owns the shoreline!",
    ["begginers_luck_fish"] = "A deceptivly difficult fish to catch. Found in all biomes.",
    ["betta_fish"] = "This little fish is a fierce fashion competitor with a dazzling wardrobe of flowing, colorful fins!",
    ["black_ghostshark"] = "This sharks all about spooky vibes and stealthy moves, cruising the depths like a shadowy enigma!",
    ["black_drum_fish"] = "This fish’s bold look and solid build make it the heavyweight champion of the coastal concert!",
    ["blue_whale"] = "As the largest creature on Earth, the Blue Whale is a true oceanic giant with a heart as big as its size!",
    ["blue_tang"] = "The Blue Wish Fish is the reef’s radiant gem, turning every glance into a moment of enchantment!",
    ["alley_cat_fish"] = "Sporting a mischievous grin, the Alley Cat Fish navigates the reef like a feline on a midnight prowl!",
    ["catfish"] = "With its whiskered face and laid-back attitude, the Catfish is the cool cat of the aquatic world!",
    ["chum_salmon_fish"] = "With a name like 'Chum,' this salmon’s all about hanging out and making a splash in the river!",
    ["clown_fish"] = "With its bold stripes and cheerful demeanor, the Clown Fish is the reef’s ultimate entertainer!",
    ["coho_salmon_fish"] = "The Coho Salmon is the stylish swimmer of the river, flaunting its sleek silvery scales like a high-fashion model!",
    ["common_carp_fish"] = "This fish is the go-to guest of any pond party, known for its hearty appetite and friendly demeanor!",
    ["crab"] = "The Crab is the charmingly clumsy critter of the shore, turning every tide into a playful adventure!",
    ["dolphin"] = "The Dolphin is the sea’s acrobatic genius, always ready to show off with a splash and a spin!",
    ["rasta_drum_fish"] = "The Rasta Drum Fish brings a splash of reggae flair to the reef, drumming up good times with every swim!",
    ["dumbo_octopus"] = "With its big, floppy fins and whimsical wiggle, the Dumbo Octopus is the ocean’s most endearing explorer!",
    ["electric_eel"] = "This eel’s got a zap-tastic personality, electrifying the underwater world with every swim!",
    ["flounder_fish"] = "This fish keeps a low profile with its unique sideways style, blending seamlessly into the sea floor!",
    ["tourist_fish"] = "With its vibrant colors and curious nature, the Tourist Fish is the ocean’s most enthusiastic vacationer!",
    ["gold_fish"] = "This fish brings a touch of elegance to the tank with its golden glow and playful antics!",
    ["goliath_tiger_fish"] = "This fish combines a fearsome bite with a majestic look, making it the king of the watery jungle!",
    ["jelly_fish"] = "With its wobbly, glowing tentacles and otherworldly presence, the Jellyfish is the deep sea’s shimmering enigma!",
    ["jogger_fish"] = "This fish keeps fit by trotting through the currents, proving that even in the water, you can have a workout routine!",
    ["killer_whale"] = "Known for its strategic hunting and impressive size, the Killer Whale is the ocean’s supreme ruler of the hunt!",
    ["king_catfish"] = "Sporting impressive whiskers and a regal demeanor, the King Catfish is the undisputed monarch of the aquatic realm!",
    ["king_mackerel"] = "Sporting a streamlined body and a commanding presence, the King Mackerel is the ultimate sea speedster!",
    ["king_salmon"] = "Sporting a regal presence and impressive stamina, the King Salmon commands respect on every migration!",
    ["king_seahorse"] = "With a shimmering tail and noble demeanor, the King Seahorse commands the reef like true underwater royalty!",
    ["koi_fish_samurai"] = "With its vibrant scales and a warrior's spirit, the Koi Fish Samurai glides through the pond with honor and grace!",
    ["koi_fish_large"] = "The Large Koi Fish turns heads with its oversized charm and brilliant hues, ruling the pond with elegance!",
    ["large_stripped_bass"] = "With its distinctive stripes and robust build, the Large Striped Bass is the lake’s iconic standout!",
    ["lion_fish"] = "The Lionfish prowls the reef with a majestic flair and venomous charm, reigning as the oceans elegant predator!",
    ["freindly_local_fish"] = "This fish is the reefs go-to buddy, always there to greet newcomers and share the best spots!",
    ["mouse_fish"] = "This fish might be small, but its curious nature and quick movements make it the reef’s cutest explorer!",
    ["newborn_salmon"] = "Fresh out of the egg and full of zest, the Newborn Salmon is the river’s tiny dynamo with big dreams!",
    ["nomadic_trout"] = "The Nomadic Trout is the river’s roving wanderer, always seeking new currents and adventures!",
    ["northern_pike"] = "Sporting a torpedo-shaped body and a keen hunting instinct, the Northern Pike is the ultimate freshwater hunter!",
    ["octopus"] = "With its eight agile arms and clever mind, the Octopus is the ocean’s ultimate shape-shifter and escape artist!",
    ["oil_eater_fish"] = "With a diet that includes oil, this fish is the reef’s dedicated recycler, keeping the waters cleaner one meal at a time!",
    ["omnipotent_squid"] = "With its boundless abilities and mesmerizing ink, the Omnipotent Squid is the ocean’s ultimate mastermind!",
    ["pearl_perch_fish"] = "Sporting a lustrous sheen and a graceful glide, the Pearl Perch Fish is the ocean’s own living treasure!",
    ["peasant_fish"] = "Simple yet charming, the Peasant Fish swims with a humble grace, proving that beauty doesn’t need to be flashy!",
    ["pink_salmon"] = "With a poodle-like poof and a grumpy frown, this salmon’s charm is as striking as its attitude!",
    ["piranha"] = "This fish’s sharp teeth and bold attitude make the Piranha the underwater worlds notorious chomper!",
    ["red_snapper_fish"] = "This fish stands out with its brilliant red color and lively personality, making every swim a dazzling display!",
    ["rock_bass_fish"] = "This fish is built like a tank and ready for action, making the Rock Bass Fish the ultimate freshwater heavyweight!",
    ["royal_lake_fish"] = "This fish swims with a royal air and a grand style, making every ripple in the water a display of underwater royalty!",
    ["salt_trader_fish"] = "The Salt Trader Fish navigates the seas with the precision of a merchant, trading in salt like it’s second nature!",
    ["saw_fish"] = "This fish's unique saw-shaped snout makes it the underwater world’s most innovative and formidable hunter!",
    ["seahorse"] = "With its delicate frame and mesmerizing movements, the Seahorse adds a touch of magical charm to the coral reef!",
    ["servant_fish"] = "A helpful fish that is always ready to lend a fin.",
    ["small_common_trout"] = "With its modest size and lively swim, the Small Common Trout is the charming go-getter of the stream!",
    ["rainbow_trout"] = "This trout shines bright with its array of colors, making every splash a spectacular show of aquatic brilliance!",
    ["spotted_bass_fish"] = "With its unique spots and agile moves, the Spotted Bass Fish makes a bold splash in every lake it inhabits!",
    ["squid"] = "With its mesmerizing movements and ink-blasting skills, the Squid turns every underwater adventure into a high-speed thrill!",
    ["squirrel_fish"] = "Sporting a bushy look and a cheeky personality, the Squirrel Fish is the reef’s most energetic and quirky resident!",
    ["star_fish"] = "A five-armed party master, keeping the underwater rave alive!",
    ["sting_ray"] = "An underwater party superstar, electrifying the deep with its moves!",
    ["sun_fish"] = "The sea solar-powered party animal, lighting up the ocean with its glow!",
    ["surffer_fish"] = "Underwaters gnarly wave master, making every crest a party!",
    ["sword_fish"] = "Sea’s speedy knight, slicing through waves with a sharp sense of adventure!",
    ["tiger_pistol_shrimp"] = "A large and powerful crustacean known for its sonic boom.",
    ["transparent_head_fish"] = "Seas invisible wonder, floating through the deep with a ghostly glow!",
    ["buisness_fish"] = "A large and powerful fish known for its financial acumen.",
    ["derp_fish"] = "Sea’s charmingly clueless buddy, making everyone smile with its quirky antics!",
    ["king_fish"] = "This fish just has the blues.",
    ["walley_fish"] = "The oceans stealthy stalker, blending in and making every hunt a success!",
    ["albino_catfish"] = "The ocean’s elusive gem, standing out with a pristine, otherworldly shine!",
    ["yellow_watchman"] = "A rare and elusive deep sea fish known for kepping an eye out.",
}

local FishSizeRange = {
    ["black_crappie"] = {min = 6, max = 15},
    ["yellow_perch"] = {min = 6, max = 15},
    ["blue_gill"] = {min = 6, max = 15},
    ["pumpkinseed"] = {min = 3, max = 8},
    ["boot_fish"] = {min = 7, max = 12},
    ["can_fish"] = {min = 2, max = 4},
    ["long_mouth_bass"] = {min = 14, max = 30},
    ["salmon"] = {min = 15, max = 35},
    ["crystal_fairy_fish"] = {min = 6, max = 19},
    ["dragon_fish"] = {min = 20, max = 40},
    ["unicorn_fish"] = {min = 15, max = 35},
    ["anchovi_fish"] = {min = 2, max = 5},
    ["angler_fish"] = {min = 10, max = 38},
    ["arowana_fish"] = {min = 15, max = 30},
    ["barred_knife_fish"] = {min = 10, max = 30},
    ["beach_shark_fish"] = {min = 20, max = 80},
    ["begginers_luck_fish"] = {min = 2, max = 5},
    ["betta_fish"] = {min = 5, max = 10},
    ["black_ghostshark"] = {min = 20, max = 40},
    ["black_drum_fish"] = {min = 15, max = 30},
    ["blue_whale"] = {min = 500, max = 1080},
    ["blue_tang"] = {min = 5, max = 12},
    ["alley_cat_fish"] = {min = 5, max = 10},
    ["catfish"] = {min = 15, max = 30},
    ["chum_salmon_fish"] = {min = 15, max = 30},
    ["clown_fish"] = {min = 3, max = 8},
    ["coho_salmon_fish"] = {min = 15, max = 30},
    ["common_carp_fish"] = {min = 10, max = 25},
    ["crab"] = {min = 3, max = 8},
    ["dolphin"] = {min = 100, max = 200},
    ["rasta_drum_fish"] = {min = 20, max = 40},
    ["dumbo_octopus"] = {min = 10, max = 30},
    ["electric_eel"] = {min = 15, max = 30},
    ["flounder_fish"] = {min = 5, max = 15},
    ["tourist_fish"] = {min = 2, max = 5},
    ["gold_fish"] = {min = 5, max = 10},
    ["goliath_tiger_fish"] = {min = 15, max = 60},
    ["jelly_fish"] = {min = 20, max = 40},
    ["jogger_fish"] = {min = 3, max = 8},
    ["killer_whale"] = {min = 100, max = 200},
    ["king_catfish"] = {min = 15, max = 30},
    ["king_mackerel"] = {min = 15, max = 30},
    ["king_salmon"] = {min = 15, max = 30},
    ["king_seahorse"] = {min = 5, max = 15},
    ["koi_fish_samurai"] = {min = 20, max = 40},
    ["koi_fish_large"] = {min = 5, max = 10},
    ["large_stripped_bass"] = {min = 15, max = 30},
    ["lion_fish"] = {min = 20, max = 40},
    ["freindly_local_fish"] = {min = 2, max = 5},
    ["mouse_fish"] = {min = 5, max = 10},
    ["newborn_salmon"] = {min = 1, max = 3},
    ["nomadic_trout"] = {min = 15, max = 30},
    ["northern_pike"] = {min = 8, max = 30},
    ["octopus"] = {min = 20, max = 40},
    ["oil_eater_fish"] = {min = 10, max = 30},
    ["omnipotent_squid"] = {min = 30, max = 100},
    ["pearl_perch_fish"] = {min = 3, max = 8},
    ["peasant_fish"] = {min = 2, max = 5},
    ["pink_salmon"] = {min = 15, max = 30},
    ["piranha"] = {min = 10, max = 30},
    ["red_snapper_fish"] = {min = 10, max = 30},
    ["rock_bass_fish"] = {min = 5, max = 15},
    ["royal_lake_fish"] = {min = 15, max = 30},
    ["salt_trader_fish"] = {min = 20, max = 40},
    ["saw_fish"] = {min = 10, max = 30},
    ["seahorse"] = {min = 5, max = 15},
    ["servant_fish"] = {min = 5, max = 10},
    ["small_common_trout"] = {min = 5, max = 10},
    ["rainbow_trout"] = {min = 10, max = 30},
    ["spotted_bass_fish"] = {min = 15, max = 30},
    ["squid"] = {min = 20, max = 40},
    ["squirrel_fish"] = {min = 5, max = 10},
    ["star_fish"] = {min = 20, max = 40},
    ["sting_ray"] = {min = 10, max = 30},
    ["sun_fish"] = {min = 10, max = 30},
    ["surffer_fish"] = {min = 15, max = 30},
    ["sword_fish"] = {min = 20, max = 40},
    ["tiger_pistol_shrimp"] = {min = 10, max = 30},
    ["transparent_head_fish"] = {min = 20, max = 40},
    ["buisness_fish"] = {min = 15, max = 30},
    ["derp_fish"] = {min = 5, max = 10},
    ["king_fish"] = {min = 15, max = 30},
    ["walley_fish"] = {min = 15, max = 30},
    ["albino_catfish"] = {min = 10, max = 30},
    ["yellow_watchman"] = {min = 20, max = 40},
}

local FishSpecialAttributes = {
    ["black_crappie"] = "High catch rate.",
    ["yellow_perch"] = "Often found in schools.",
    ["blue_gill"] = "Quick and agile.",
    ["pumpkinseed"] = "Often found near vegetation.",
    ["boot_fish"] = "Not a fish.",
    ["can_fish"] = "Not a fish.",
    ["long_mouth_bass"] = "Strong and difficult to catch.",
    ["salmon"] = "Endurance swimmer.",
    ["crystal_fairy_fish"] = "Rare spawn, gives special rewards.",
    ["dragon_fish"] = "Emits a glowing aura.",
    ["unicorn_fish"] = "Hard to find, gives luck bonus.",
    ["anchovi_fish"] = "Often found in schools.",
    ["angler_fish"] = "Lures other fish.",
    ["arowana_fish"] = "Strong and difficult to catch.",
    ["barred_knife_fish"] = "Hard to catch.",
    ["beach_shark_fish"] = "Rare spawn, gives special rewards.",
    ["begginers_luck_fish"] = "Great for beginners.",
    ["betta_fish"] = "Hard to catch.",
    ["black_ghostshark"] = "Hard to find, gives luck bonus.",
    ["black_drum_fish"] = "Strong and difficult to catch.",
    ["blue_whale"] = "Rare spawn, gives special rewards.",
    ["blue_tang"] = "Hard to catch.",
    ["alley_cat_fish"] = "Quick and agile.",
    ["catfish"] = "Strong and difficult to catch.",
    ["chum_salmon_fish"] = "Hard to catch.",
    ["clown_fish"] = "Quick and agile.",
    ["coho_salmon_fish"] = "Strong and difficult to catch.",
    ["common_carp_fish"] = "Strong and difficult to catch.",
    ["crab"] = "Quick and agile.",
    ["dolphin"] = "Rare spawn, gives special rewards.",
    ["rasta_drum_fish"] = "Hard to find, gives luck bonus.",
    ["dumbo_octopus"] = "Hard to catch.",
    ["electric_eel"] = "Strong and difficult to catch.",
    ["flounder_fish"] = "Quick and agile.",
    ["tourist_fish"] = "Great for beginners.",
    ["gold_fish"] = "Hard to catch.",
    ["goliath_tiger_fish"] = "Strong and difficult to catch.",
    ["jelly_fish"] = "Hard to find, gives luck bonus.",
    ["jogger_fish"] = "Quick and agile.",
    ["killer_whale"] = "Rare spawn, gives special rewards.",
    ["king_catfish"] = "Hard to catch.",
    ["king_mackerel"] = "Strong and difficult to catch.",
    ["king_salmon"] = "Strong and difficult to catch.",
    ["king_seahorse"] = "Rare spawn, gives special rewards.",
    ["koi_fish_samurai"] = "Hard to find, gives luck bonus.",
    ["koi_fish_large"] = "Hard to catch.",
    ["large_stripped_bass"] = "Strong and difficult to catch.",
    ["lion_fish"] = "Hard to find, gives luck bonus.",
    ["freindly_local_fish"] = "Great for beginners.",
    ["mouse_fish"] = "Hard to catch.",
    ["newborn_salmon"] = "Hard to catch.",
    ["nomadic_trout"] = "Rare spawn, gives special rewards.",
    ["northern_pike"] = "Strong and difficult to catch.",
    ["octopus"] = "Hard to find, gives luck bonus.",
    ["oil_eater_fish"] = "Hard to catch.",
    ["omnipotent_squid"] = "Hard to find, gives luck bonus.",
    ["pearl_perch_fish"] = "Quick and agile.",
    ["peasant_fish"] = "Great for beginners.",
    ["pink_salmon"] = "Strong and difficult to catch.",
    ["piranha"] = "Rare spawn, gives special rewards.",
    ["red_snapper_fish"] = "Hard to catch.",
    ["rock_bass_fish"] = "Quick and agile.",
    ["royal_lake_fish"] = "Rare spawn, gives special rewards.",
    ["salt_trader_fish"] = "Hard to find, gives luck bonus.",
    ["saw_fish"] = "Hard to catch.",
    ["seahorse"] = "Quick and agile.",
    ["servant_fish"] = "Strong and difficult to catch.",
    ["small_common_trout"] = "Quick and agile.",
    ["rainbow_trout"] = "Hard to catch.",
    ["spotted_bass_fish"] = "Strong and difficult to catch.",
    ["squid"] = "Rare spawn, gives special rewards.",
    ["squirrel_fish"] = "Hard to catch.",
    ["star_fish"] = "Hard to find, gives luck bonus.",
    ["sting_ray"] = "Hard to catch.",
    ["sun_fish"] = "Quick and agile.",
    ["surffer_fish"] = "Rare spawn, gives special rewards.",
    ["sword_fish"] = "Hard to find, gives luck bonus.",
    ["tiger_pistol_shrimp"] = "Rare spawn, gives special rewards.",
    ["transparent_head_fish"] = "Hard to find, gives luck bonus.",
    ["buisness_fish"] = "Rare spawn, gives special rewards.",
    ["derp_fish"] = "Hard to catch.",
    ["king_fish"] = "Rare spawn, gives special rewards.",
    ["walley_fish"] = "Strong and difficult to catch.",
    ["albino_catfish"] = "Hard to catch.",
    ["yellow_watchman"] = "Hard to find, gives luck bonus.",
}

--[[ Empty FishTable
local EmptyFishDataTable = {
    ["black_crappie"] = 1,
    ["yellow_perch"] = 1,
    ["blue_gill"] = 1,
    ["pumpkinseed"] = 1,
    ["boot_fish"] = 1,
    ["can_fish"] = 1,
    ["long_mouth_bass"] = 1,
    ["salmon"] = 1,
    ["crystal_fairy_fish"] = 1,
    ["dragon_fish"] = 1,
    ["unicorn_fish"] = 1,
    ["anchovi_fish"] = 1,
    ["angler_fish"] = 1,
    ["arowana_fish"] = 1,
    ["barred_knife_fish"] = 1,
    ["beach_shark_fish"] = 1,
    ["begginers_luck_fish"] = 1,
    ["betta_fish"] = 1,
    ["black_ghostshark"] = 1,
    ["black_drum_fish"] = 1,
    ["blue_whale"] = 1,
    ["blue_tang"] = 1,
    ["alley_cat_fish"] = 1,
    ["catfish"] = 1,
    ["chum_salmon_fish"] = 1,
    ["clown_fish"] = 1,
    ["coho_salmon_fish"] = 1,
    ["common_carp_fish"] = 1,
    ["crab"] = 1,
    ["dolphin"] = 1,
    ["rasta_drum_fish"] = 1,
    ["dumbo_octopus"] = 1,
    ["electric_eel"] = 1,
    ["flounder_fish"] = 1,
    ["tourist_fish"] = 1,
    ["gold_fish"] = 1,
    ["goliath_tiger_fish"] = 1,
    ["jelly_fish"] = 1,
    ["jogger_fish"] = 1,
    ["killer_whale"] = 1,
    ["king_catfish"] = 1,
    ["king_mackerel"] = 1,
    ["king_salmon"] = 1,
    ["king_seahorse"] = 1,
    ["koi_fish_samurai"] = 1,
    ["koi_fish_large"] = 1,
    ["large_stripped_bass"] = 1,
    ["lion_fish"] = 1,
    ["freindly_local_fish"] = 1,
    ["mouse_fish"] = 1,
    ["newborn_salmon"] = 1,
    ["nomadic_trout"] = 1,
    ["northern_pike"] = 1,
    ["octopus"] = 1,
    ["oil_eater_fish"] = 1,
    ["omnipotent_squid"] = 1,
    ["pearl_perch_fish"] = 1,
    ["peasant_fish"] = 1,
    ["pink_salmon"] = 1,
    ["piranha"] = 1,
    ["red_snapper_fish"] = 1,
    ["rock_bass_fish"] = 1,
    ["royal_lake_fish"] = 1,
    ["salt_trader_fish"] = 1,
    ["saw_fish"] = 1,
    ["seahorse"] = 1,
    ["servant_fish"] = 1,
    ["small_common_trout"] = 1,
    ["rainbow_trout"] = 1,
    ["spotted_bass_fish"] = 1,
    ["squid"] = 1,
    ["squirrel_fish"] = 1,
    ["star_fish"] = 1,
    ["sting_ray"] = 1,
    ["sun_fish"] = 1,
    ["surffer_fish"] = 1,
    ["sword_fish"] = 1,
    ["tiger_pistol_shrimp"] = 1,
    ["transparent_head_fish"] = 1,
    ["buisness_fish"] = 1,
    ["derp_fish"] = 1,
    ["king_fish"] = 1,
    ["walley_fish"] = 1,
    ["albino_catfish"] = 1,
    ["yellow_watchman"] = 1,
}]]

local HookSensitivity = {
    ["black_crappie"] = 1,
    ["yellow_perch"] = 1,
    ["blue_gill"] = 1,
    ["pumpkinseed"] = 1,
    ["boot_fish"] = 1.5,
    ["can_fish"] = 1,
    ["long_mouth_bass"] = 1.5,
    ["salmon"] = 2,
    ["crystal_fairy_fish"] = 2.5,
    ["dragon_fish"] = 2.5,
    ["unicorn_fish"] = 2.5,
    ["anchovi_fish"] = 1,
    ["angler_fish"] = 2,
    ["arowana_fish"] = 1.5,
    ["barred_knife_fish"] = 2,
    ["beach_shark_fish"] = 3,
    ["begginers_luck_fish"] = 1,
    ["betta_fish"] = 1.5,
    ["black_ghostshark"] = 2.5,
    ["black_drum_fish"] = 1.5,
    ["blue_whale"] = 3,
    ["blue_tang"] = 1.5,
    ["alley_cat_fish"] = 1.5,
    ["catfish"] = 1,
    ["chum_salmon_fish"] = 1.5,
    ["clown_fish"] = 1.2,
    ["coho_salmon_fish"] = 1.5,
    ["common_carp_fish"] = 1.2,
    ["crab"] = 1.2,
    ["dolphin"] = 3,
    ["rasta_drum_fish"] = 2.5,
    ["dumbo_octopus"] = 1.5,
    ["electric_eel"] = 1.5,
    ["flounder_fish"] = 1.2,
    ["tourist_fish"] = 1,
    ["gold_fish"] = 1.5,
    ["goliath_tiger_fish"] = 1.5,
    ["jelly_fish"] = 2.5,
    ["jogger_fish"] = 1.2,
    ["killer_whale"] = 3,
    ["king_catfish"] = 1.5,
    ["king_mackerel"] = 1.5,
    ["king_salmon"] = 1.2,
    ["king_seahorse"] = 3,
    ["koi_fish_samurai"] = 2.5,
    ["koi_fish_large"] = 1.5,
    ["large_stripped_bass"] = 1.5,
    ["lion_fish"] = 2.5,
    ["freindly_local_fish"] = 1,
    ["mouse_fish"] = 1.5,
    ["newborn_salmon"] = 1.5,
    ["nomadic_trout"] = 3,
    ["northern_pike"] = 1.5,
    ["octopus"] = 2.5,
    ["oil_eater_fish"] = 1.5,
    ["omnipotent_squid"] = 2.5,
    ["pearl_perch_fish"] = 1.2,
    ["peasant_fish"] = 1,
    ["pink_salmon"] = 1.5,
    ["piranha"] = 2.5,
    ["red_snapper_fish"] = 1.5,
    ["rock_bass_fish"] = 1.2,
    ["royal_lake_fish"] = 3,
    ["salt_trader_fish"] = 2.5,
    ["saw_fish"] = 1.5,
    ["seahorse"] = 1.2,
    ["servant_fish"] = 1.5,
    ["small_common_trout"] = 1.2,
    ["rainbow_trout"] = 1.5,
    ["spotted_bass_fish"] = 1.5,
    ["squid"] = 2.5,
    ["squirrel_fish"] = 1.5,
    ["star_fish"] = 2.5,
    ["sting_ray"] = 1.5,
    ["sun_fish"] = 1.2,
    ["surffer_fish"] = 3,
    ["sword_fish"] = 2.5,
    ["tiger_pistol_shrimp"] = 2.5,
    ["transparent_head_fish"] = 2.5,
    ["buisness_fish"] = 3,
    ["derp_fish"] = 1.5,
    ["king_fish"] = 3,
    ["walley_fish"] = 1.5,
    ["albino_catfish"] = 1.5,
    ["yellow_watchman"] = 2.5,
}

local FishImage = {
    ["black_crappie"] = fishTextures[1],
    ["yellow_perch"] = fishTextures[2],
    ["blue_gill"] = fishTextures[3],
    ["pumpkinseed"] = fishTextures[4],
    ["boot_fish"] = fishTextures[5],
    ["can_fish"] = fishTextures[6],
    ["long_mouth_bass"] = fishTextures[7],
    ["salmon"] = fishTextures[8],
    ["crystal_fairy_fish"] = fishTextures[9],
    ["dragon_fish"] = fishTextures[10],
    ["unicorn_fish"] = fishTextures[11],
    ["anchovi_fish"] = fishTextures[12],
    ["angler_fish"] = fishTextures[13],
    ["arowana_fish"] = fishTextures[14],
    ["barred_knife_fish"] = fishTextures[15],
    ["beach_shark_fish"] = fishTextures[16],
    ["begginers_luck_fish"] = fishTextures[17],
    ["betta_fish"] = fishTextures[18],
    ["black_ghostshark"] = fishTextures[19],
    ["black_drum_fish"] = fishTextures[20],
    ["blue_whale"] = fishTextures[21],
    ["blue_tang"] = fishTextures[22],
    ["alley_cat_fish"] = fishTextures[23],
    ["catfish"] = fishTextures[24],
    ["chum_salmon_fish"] = fishTextures[25],
    ["clown_fish"] = fishTextures[26],
    ["coho_salmon_fish"] = fishTextures[27],
    ["common_carp_fish"] = fishTextures[28],
    ["crab"] = fishTextures[29],
    ["dolphin"] = fishTextures[30],
    ["rasta_drum_fish"] = fishTextures[31],
    ["dumbo_octopus"] = fishTextures[32],
    ["electric_eel"] = fishTextures[33],
    ["flounder_fish"] = fishTextures[34],
    ["tourist_fish"] = fishTextures[35],
    ["gold_fish"] = fishTextures[36],
    ["goliath_tiger_fish"] = fishTextures[37],
    ["jelly_fish"] = fishTextures[38],
    ["jogger_fish"] = fishTextures[39],
    ["killer_whale"] = fishTextures[40],
    ["king_catfish"] = fishTextures[41],
    ["king_mackerel"] = fishTextures[42],
    ["king_salmon"] = fishTextures[43],
    ["king_seahorse"] = fishTextures[44],
    ["koi_fish_samurai"] = fishTextures[45],
    ["koi_fish_large"] = fishTextures[46],
    ["large_stripped_bass"] = fishTextures[47],
    ["lion_fish"] = fishTextures[48],
    ["freindly_local_fish"] = fishTextures[49],
    ["mouse_fish"] = fishTextures[50],
    ["newborn_salmon"] = fishTextures[51],
    ["nomadic_trout"] = fishTextures[52],
    ["northern_pike"] = fishTextures[53],
    ["octopus"] = fishTextures[54],
    ["oil_eater_fish"] = fishTextures[55],
    ["omnipotent_squid"] = fishTextures[56],
    ["pearl_perch_fish"] = fishTextures[57],
    ["peasant_fish"] = fishTextures[58],
    ["pink_salmon"] = fishTextures[59],
    ["piranha"] = fishTextures[60],
    ["red_snapper_fish"] = fishTextures[61],
    ["rock_bass_fish"] = fishTextures[62],
    ["royal_lake_fish"] = fishTextures[63],
    ["salt_trader_fish"] = fishTextures[64],
    ["saw_fish"] = fishTextures[65],
    ["seahorse"] = fishTextures[66],
    ["servant_fish"] = fishTextures[67],
    ["small_common_trout"] = fishTextures[68],
    ["rainbow_trout"] = fishTextures[69],
    ["spotted_bass_fish"] = fishTextures[70],
    ["squid"] = fishTextures[71],
    ["squirrel_fish"] = fishTextures[72],
    ["star_fish"] = fishTextures[73],
    ["sting_ray"] = fishTextures[74],
    ["sun_fish"] = fishTextures[75],
    ["surffer_fish"] = fishTextures[76],
    ["sword_fish"] = fishTextures[77],
    ["tiger_pistol_shrimp"] = fishTextures[78],
    ["transparent_head_fish"] = fishTextures[79],
    ["buisness_fish"] = fishTextures[80],
    ["derp_fish"] = fishTextures[81],
    ["king_fish"] = fishTextures[82],
    ["walley_fish"] = fishTextures[83],
    ["albino_catfish"] = fishTextures[84],
    ["yellow_watchman"] = fishTextures[85],
}

local FishBaits = {
    ["black_crappie"] = {"Any"},
    ["yellow_perch"] = {"Any"},
    ["blue_gill"] = {"Any"},
    ["pumpkinseed"] = {"Any"},
    ["boot_fish"] = {"Any"},
    ["can_fish"] = {"Any"},
    ["long_mouth_bass"] = {"sadworm_bait"},
    ["salmon"] = {"maggot_bait"},
    ["crystal_fairy_fish"] = {"hotdog_bait"},
    ["dragon_fish"] = {"squid_bait"},
    ["unicorn_fish"] = {"steak_bait"},
    ["anchovi_fish"] = {"Any"},
    ["angler_fish"] = {"pizza_bait"},
    ["arowana_fish"] = {"sadworm_bait"},
    ["barred_knife_fish"] = {"broccoli_bait"},
    ["beach_shark_fish"] = {"hotdog_bait"},
    ["begginers_luck_fish"] = {"hotdog_bait"},
    ["betta_fish"] = {"bacon_bait"},
    ["black_ghostshark"] = {"steak_bait"},
    ["black_drum_fish"] = {"corn_bait"},
    ["blue_whale"] = {"steak_bait"},
    ["blue_tang"] = {"broccoli_bait"},
    ["alley_cat_fish"] = {"maggot_bait"},
    ["catfish"] = {"Any"},
    ["chum_salmon_fish"] = {"corn_bait"},
    ["clown_fish"] = {"Any"},
    ["coho_salmon_fish"] = {"corn_bait"},
    ["common_carp_fish"] = {"Any"},
    ["crab"] = {"Any"},
    ["dolphin"] = {"pizza_bait"},
    ["rasta_drum_fish"] = {"squid_bait"},
    ["dumbo_octopus"] = {"toast_bait"},
    ["electric_eel"] = {"maggot_bait"},
    ["flounder_fish"] = {"Any"},
    ["tourist_fish"] = {"pizza_bait"},
    ["gold_fish"] = {"egg_bait"},
    ["goliath_tiger_fish"] = {"sadworm_bait"},
    ["jelly_fish"] = {"maggot_bait"},
    ["jogger_fish"] = {"Any"},
    ["killer_whale"] = {"pizza_bait"},
    ["king_catfish"] = {"pizza_bait"},
    ["king_mackerel"] = {"pizza_bait"},
    ["king_salmon"] = {"hotdog_bait"},
    ["king_seahorse"] = {"pizza_bait"},
    ["koi_fish_samurai"] = {"donut_bait"},
    ["koi_fish_large"] = {"bacon_bait"},
    ["large_stripped_bass"] = {"plastic_bait"},
    ["lion_fish"] = {"shrimp_bait"},
    ["freindly_local_fish"] = {"pizza_bait"},
    ["mouse_fish"] = {"chicken_bait"},
    ["newborn_salmon"] = {"bacon_bait"},
    ["nomadic_trout"] = {"pizza_bait"},
    ["northern_pike"] = {"plastic_bait"},
    ["octopus"] = {"broccoli_bait"},
    ["oil_eater_fish"] = {"toast_bait"},
    ["omnipotent_squid"] = {"shrimp_bait"},
    ["pearl_perch_fish"] = {"Any"},
    ["peasant_fish"] = {"shrimp_bait"},
    ["pink_salmon"] = {"plastic_bait"},
    ["piranha"] = {"hotdog_bait"},
    ["red_snapper_fish"] = {"broccoli_bait"},
    ["rock_bass_fish"] = {"Any"},
    ["royal_lake_fish"] = {"hotdog_bait"},
    ["salt_trader_fish"] = {"steak_bait"},
    ["saw_fish"] = {"egg_bait"},
    ["seahorse"] = {"toast_bait"},
    ["servant_fish"] = {"grub_bait"},
    ["small_common_trout"] = {"Any"},
    ["rainbow_trout"] = {"chicken_bait"},
    ["spotted_bass_fish"] = {"corn_bait"},
    ["squid"] = {"hotdog_bait"},
    ["squirrel_fish"] = {"corn_bait"},
    ["star_fish"] = {"squid_bait"},
    ["sting_ray"] = {"toast_bait"},
    ["sun_fish"] = {"Any"},
    ["surffer_fish"] = {"hotdog_bait"},
    ["sword_fish"] = {"donut_bait"},
    ["tiger_pistol_shrimp"] = {"hotdog_bait"},
    ["transparent_head_fish"] = {"shrimp_bait"},
    ["buisness_fish"] = {"pizza_bait"},
    ["derp_fish"] = {"chicken_bait"},
    ["king_fish"] = {"sadworm_bait"},
    ["walley_fish"] = {"corn_bait"},
    ["albino_catfish"] = {"bacon_bait"},
    ["yellow_watchman"] = {"donut_bait"},
}

local RarityReelResistances = {
    ["Common"] = 1,
    ["Uncommon"] = 1.1,
    ["Rare"] = 1.2,
    ["Legendary"] = 1.3,
    ["Mythical"] = 1.4,
}

local RarityStrengthResistances = {
    ["Common"] = 1,
    ["Uncommon"] = 1.05,
    ["Rare"] = 1.1,
    ["Legendary"] = 1.15,
    ["Mythical"] = 1.2,
}

local RarityExperianceValue = {
    ["Common"] = 10,
    ["Uncommon"] = 50,
    ["Rare"] = 100,
    ["Legendary"] = 250,
    ["Mythical"] = 1000,
}

fish_keys = {
    -- Common
    "jogger_fish",        -- Common
    --"boot_fish",          -- Common (Not a fish)
    "catfish",            -- Common
    "black_crappie",      -- Common
    "pearl_perch_fish",   -- Common
    "anchovi_fish",       -- Common
    --"can_fish",           -- Common (Not a fish)
    "small_common_trout", -- Common
    "sun_fish",           -- Common
    "clown_fish",          -- Common
    "pumpkinseed",        -- Common
    "rock_bass_fish",     -- Common
    "flounder_fish",      -- Common
    "crab",               -- Common
    "common_carp_fish",   -- Common
    "yellow_perch",       -- Common
    "blue_gill",          -- Common

    -- Uncommon
    "salmon",             -- Uncommon
    "squirrel_fish",      -- Uncommon
    "electric_eel",       -- Uncommon
    "long_mouth_bass",    -- Uncommon
    "spotted_bass_fish",  -- Uncommon
    "alley_cat_fish",     -- Uncommon
    "walley_fish",        -- Uncommon
    "black_drum_fish",    -- Uncommon
    "goliath_tiger_fish", -- Uncommon
    "servant_fish",       -- Uncommon
    "pink_salmon",        -- Uncommon
    "coho_salmon_fish",   -- Uncommon
    "arowana_fish",       -- Uncommon
    "northern_pike",      -- Uncommon
    "large_stripped_bass", -- Uncommon

    -- Rare
    "dumbo_octopus",      -- Rare
    "derp_fish",          -- Rare
    "oil_eater_fish",     -- Rare
    "mouse_fish",         -- Rare
    "koi_fish_large",     -- Rare
    "newborn_salmon",     -- Rare
    "barred_knife_fish",  -- Rare
    "saw_fish",           -- Rare
    "seahorse",           -- Rare
    "sting_ray",          -- Rare
    "albino_catfish",     -- Rare
    "gold_fish",          -- Rare
    "betta_fish",         -- Rare
    "rainbow_trout",      -- Rare
    "red_snapper_fish",   -- Rare
    "blue_tang",          -- Rare
    "chum_salmon_fish",   -- Rare

    -- Legendary
    "dolphin",            -- Legendary
    "king_mackerel",      -- Legendary
    "killer_whale",       -- Legendary
    "king_fish",          -- Legendary
    "begginers_luck_fish",-- Legendary
    "king_salmon",        -- Legendary
    "beach_shark_fish",   -- Legendary
    "angler_fish",        -- Legendary
    "nomadic_trout",      -- Legendary
    "tiger_pistol_shrimp",-- Legendary
    "surffer_fish",       -- Legendary
    "freindly_local_fish",-- Legendary
    "crystal_fairy_fish", -- Legendary
    "buisness_fish",      -- Legendary
    "king_catfish",       -- Legendary
    "piranha",            -- Legendary
    "tourist_fish",       -- Legendary
    "royal_lake_fish",    -- Legendary
    "squid",              -- Legendary
    "king_seahorse",      -- Legendary

    -- Mythical
    "dragon_fish",        -- Mythical
    "jelly_fish",         -- Mythical
    "unicorn_fish",       -- Mythical
    "black_ghostshark",   -- Mythical
    "sword_fish",         -- Mythical
    "rasta_drum_fish",    -- Mythical
    "yellow_watchman",    -- Mythical
    "lion_fish",          -- Mythical
    "transparent_head_fish",-- Mythical
    "star_fish",          -- Mythical
    "peasant_fish",       -- Mythical
    "octopus",            -- Mythical
    "omnipotent_squid",   -- Mythical
    "blue_whale",         -- Mythical
    "koi_fish_samurai",   -- Mythical
    "salt_trader_fish"   -- Mythical
}

-- Create an entry for each fish pulling data from the tables above
fish_metadata = {}
for _, fishKey in ipairs(fish_keys) do
    fish_metadata[fishKey] = {
        Name = FishNames[fishKey],
        Description = FishDescriptions[fishKey],
        Rarity = FishRarity[fishKey],
        Biomes = FishBiomes[fishKey],
        Baits = FishBaits[fishKey],
        HookSensitivity = HookSensitivity[fishKey],
        FishImage = FishImage[fishKey],
        Worth = FishWorth[fishKey],
        Quest_ID = FishQuestID[fishKey],
        SizeRange = FishSizeRange[fishKey],
        Special_Attribute = FishSpecialAttributes[fishKey]
    }
end

-- Function to roll for rarity based on weights
local function rollForRarity(rarityWeights, bait)
    if itemMetaData.bait_metadata[bait] == nil or bait == nil then
        --print("Bait is nil so defaulting to Common")
        return "Common"  -- Default to common
    end
    -- Get the bait's rarity from the metadata
    local baitRarity = itemMetaData.bait_metadata[bait].ItemRarity
    --print("Bait Rarity: " .. baitRarity)
    
    -- Define an ordered list of rarities
    local rarityOrder = {"Common", "Uncommon", "Rare", "Legendary", "Mythical"}
    
    -- Filter the rarityWeights to include only rarities up to the bait's rarity
    local filteredRarityWeights = {}
    for _, rarity in ipairs(rarityOrder) do
        if rarity == baitRarity then
            filteredRarityWeights[rarity] = rarityWeights[rarity]
            --print("Adding rarity (final): " .. rarity .. " with weight: " .. tostring(rarityWeights[rarity]))  -- Print the final rarity added
            break
        elseif rarityWeights[rarity] then
            filteredRarityWeights[rarity] = rarityWeights[rarity]
            --print("Adding rarity: " .. rarity .. " with weight: " .. tostring(rarityWeights[rarity]))  -- Print each rarity as it is added
        end
    end


    -- Calculate the total weight of the filtered rarities
    local totalWeight = 0
    for _, weight in pairs(filteredRarityWeights) do
        totalWeight = totalWeight + weight
    end
    --print("Total Weight: " .. tostring(totalWeight))
    
    -- Generate the roll
    local roll = math.random(0, totalWeight-1) + math.random()  -- Add a random decimal to the roll for unpredictability
    local cumulativeWeight = 0
    --print("Roll: " .. tostring(roll))
    
    -- Determine the rarity based on the roll using the correct order
    for _, rarity in ipairs(rarityOrder) do
        if filteredRarityWeights[rarity] then
            cumulativeWeight = cumulativeWeight + filteredRarityWeights[rarity]
            if roll <= cumulativeWeight then
                --print("Selected Rarity: " .. rarity)
                return rarity
            end
        end
    end
    
    return "Common"  -- Default to common if something goes wrong
end

local function CheckBiome(fishName, Biome)
    for each, _biome in fish_metadata[fishName].Biomes do
        if _biome == Biome or Biome == "Any" or _biome == "Any" then
            return true
        end
    end
    return false
end

local function CheckBait(fishName, Bait)
    for each, _reqBait in fish_metadata[fishName].Baits do
        if _reqBait == Bait or Bait == "Any" then
            return true
        end
    end
    return false
end

function GetRandomFish(Biome, Bait)
    math.randomseed(os.time())
    Biome = Biome or "Any"
    Bait = Bait or "nil"
    local rarityWeights = {
        ["Common"] = 54.5,  -- 54.5% chance
        ["Uncommon"] = 25, -- 25% chance
        ["Rare"] = 15, -- 15% chance
        ["Legendary"] = 5, -- 5% chance
        ["Mythical"] = .5, -- .5% chance
    }
    
    -- Determine rarity based on weighted roll
    local chosenRarity = rollForRarity(rarityWeights, Bait)
    --print("Chosen Rarity: " .. chosenRarity)
    local fishList = {}
    
    -- Gather fish matching the chosen Rartiy, Biome, and Bait
    for fishName, fishData in fish_metadata do
        if fishData.Rarity == chosenRarity and CheckBiome(fishName, Biome) then
            table.insert(fishList, fishName)
            -- if the fish matches the chosen bait add it in the table again to increase its odds
            if CheckBait(fishName, Bait) then
                table.insert(fishList, fishName)
            end
        end
    end

    --Print the fishList
    for i, fish in ipairs(fishList) do
        --print("FishList[" .. i .. "]: " .. fish)
    end
    
    -- If no fish match the chosen rarity, Biome, and Bait, then pick any common fish that matches the chosen biome and bait
    if #fishList == 0 then

        --print("[ERROR] No fish found for: " .. chosenRarity .. " in " .. Biome .. ".Defaulting to Common fish that doesnt need bait.")

        for fishName, fishData in fish_metadata do
            if CheckBiome(fishName, Biome) and (fishData.Rarity == "Common") then
                table.insert(fishList, fishName)
            end
        end
        if #fishList == 0 then
            --print("[ERROR] No Common fish found for: " .. Biome)
            table.insert(fishList, "blue_gill") -- Default to boot fish if no common fish are found
        end
    end

    -- Select a random fish from the filtered list
    local randomFish = fishList[math.random(1, #fishList)]
    --print("Selected a fish: " .. randomFish .. "with rarity: " .. fish_metadata[randomFish].Rarity .. " and Biome: " .. Biome .. " and Bait: " .. Bait)
    return randomFish
end


function IsFish(item)
    return Utils.is_in_table(fish_keys, item)
end

function GetFishData(fishName : string)
    local fishData = fish_metadata[fishName]
    return fishData
end

function GetFishSize(fishName : string)
    local fishData = fish_metadata[fishName]
    local integerPart = math.random(fishData.SizeRange.min, fishData.SizeRange.max)
    local decimalPart = math.random()

    -- Chance to shrink the fish making it harder to catch the bigger ones
    local roll = math.random()
    if roll < .60 then
        integerPart = integerPart - 2 * math.random()
    end

    local size = integerPart + decimalPart
    local roundedSize = math.floor(size * 10 + 0.5) / 10

    return roundedSize
end

function GetFishReelResistance(fishName : string)
    local fishRarity = fish_metadata[fishName].Rarity
    local reelResistance = RarityReelResistances[fishRarity]

    return reelResistance
end

function GetFishStrengthResistance(fishName : string)
    local fishRarity = fish_metadata[fishName].Rarity
    local strengthResistance = RarityStrengthResistances[fishRarity]

    return strengthResistance
end

function GetFishExperianceValue(fishName : string)
    local fishRarity = fish_metadata[fishName].Rarity
    local experianceValue = RarityExperianceValue[fishRarity]

    return experianceValue
end