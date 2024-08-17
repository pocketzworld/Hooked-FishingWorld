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

baitGroups = {
    common_baits1 = 
    {
        "sadworm_bait",
        "grub_bait",
        "maggot_bait",
        "plastic_bait",
        "corn_bait"
    },
    common_baits2 = 
    {
        "corn_bait",
        "sadworm_bait",
        "grub_bait",
        "maggot_bait",
        "plastic_bait"
    },

    uncommon_baits1 = 
    {
        "bacon_bait",
        "egg_bait",
        "grub_bait"
    },
    uncommon_baits2 = 
    {
        "chicken_bait",
        "broccoli_bait",
        "toast_bait",
        "maggot_bait"
    },
    rare_baits1 = 
    {
        "hotdog_bait"
    },
    rare_baits2 = 
    {
        "pizza_bait"
    },
    legendary_baits1 = 
    {
        "steak_bait",
        "donut_bait"
    },
    legendary_baits2 = 
    {
        "shrimp_bait",
        "squid_bait"
    }
}

fish_metadata = {
    ["black_crappie"] = {
        Baits = {"Any"},
        Name = "Black Crappie", 
        Biomes = {"Lake", "River"}, 
        Rarity = "Common",
        Worth = 7,
        Quest_ID = "Q2001", 
        Description = "The Black Crappie loves to play hide and seek in the lake weeds!", 
        SizeRange = {min = 6, max = 15}, 
        Special_Attribute = "High catch rate.",
        fishDifficulty = 1,
        FishMod = 1,
        FishImage = fishTextures[1]
    },
    ["yellow_perch"] = {
        Baits = {"Any"}, 
        Name = "Yellow Perch",
        Biomes = {"River", "Lake", "Ice"}, 
        Rarity = "Common",
        Worth = 5,
        Quest_ID = "Q2002", 
        Description = "A vibrant fish with a taste for adventure, and anything else it can munch!", 
        SizeRange = {min = 6, max = 15}, 
        Special_Attribute = "Often found in schools.",
        fishDifficulty = 1,
        FishMod = 1,
        FishImage = fishTextures[2]
    },
    ["blue_gill"] = {
        Baits = {"Any"}, 
        Name = "Blue Gill", 
        Biomes = {"River", "Lake"}, 
        Rarity = "Common",
        Worth = 7,
        Quest_ID = "Q2003", 
        Description = "This colorful little fish is the social butterfly of the pond!", 
        SizeRange = {min = 6, max = 15}, 
        Special_Attribute = "Quick and agile.",
        fishDifficulty = 1,
        FishMod = 1,
        FishImage = fishTextures[3]
    },
    ["pumpkinseed"] = {
        Baits = {"Any"}, 
        Name = "Pumpkinseed", 
        Biomes = {"Lake", "River"}, 
        Rarity = "Common",
        Worth = 5,
        Quest_ID = "Q2004", 
        Description = "This fish looks like a piece of swimming autumn with its splash of orange and green!", 
        SizeRange = {min = 3, max = 8},
        Special_Attribute = "Often found near vegetation.",
        fishDifficulty = 1,
        FishMod = 1,
        FishImage = fishTextures[4]
    },
    ["boot_fish"] = {
        Baits = {"Any"}, 
        Name = "A Boot", 
        Biomes = {"Any"}, 
        Rarity = "Uncatchable",
        Worth = 0,
        Quest_ID = "Q2005", 
        Description = "A boot that somehow ended up in the water.", 
        SizeRange = {min = 7, max = 12}, 
        Special_Attribute = "Not a fish.",
        fishDifficulty = 1,
        FishMod = 1.5,
        FishImage = fishTextures[5]
    },
    ["can_fish"] = {
        Baits = {"Any"}, 
        Name = "A Tin Can", 
        Biomes = {"Any"}, 
        Rarity = "Uncatchable",
        Worth = 0,
        Quest_ID = "Q2006", 
        Description = "well... at least it's tuna.", 
        SizeRange = {min = 2, max = 4}, 
        Special_Attribute = "Not a fish.",
        fishDifficulty = 1,
        FishMod = 1,
        FishImage = fishTextures[6]
    },
    ["long_mouth_bass"] = {
        Baits = {"sadworm_bait"}, 
        Name = "Long Mouth Bass", 
        Biomes = {"River", "Lake", "Ice"}, 
        Rarity = "Uncommon",
        Worth = 15,
        Quest_ID = "Q3001", 
        Description = "Known for its large mouth and aggressive strikes.", 
        SizeRange = {min = 14, max = 30},
        Special_Attribute = "Strong and difficult to catch.",
        fishDifficulty = 1,
        FishMod = 1.5,
        FishImage = fishTextures[7]
    },
    ["salmon"] = {
        Baits = {"maggot_bait"}, 
        Name = "Salmon", 
        Biomes = {"River", "Waterfall"}, 
        Rarity = "Uncommon",
        Worth = 15,
        Quest_ID = "Q3002", 
        Description = "The Salmon is a world traveler, swimming from the ocean to the river for its grand finale!", 
        SizeRange = {min = 15, max = 35}, 
        Special_Attribute = "Endurance swimmer.",
        fishDifficulty = 1,
        FishMod = 2,
        FishImage = fishTextures[8]
    },
    ["crystal_fairy_fish"] = {
        Baits = {"hotdog_bait"},
        Name = "Crystal Fairy Fish", 
        Biomes = {"Ice"}, 
        Rarity = "Legendary",
        Worth = 200,
        Quest_ID = "Q5001", 
        Description = "A legendary fish with crystal-like scales and magical properties.", 
        SizeRange = {min = 6, max = 19}, 
        Special_Attribute = "Rare spawn, gives special rewards.",
        fishDifficulty = 1,
        FishMod = 2.5,
        FishImage = fishTextures[9]
    },
    ["dragon_fish"] = {
        Baits = {"squid_bait"},
        Name = "Dragon Fish",
        Biomes = {"Ocean", "Waterfall"}, 
        Rarity = "Mythical",
        Worth = 7500,
        Quest_ID = "Q6001", 
        Description = "With a mouth full of fangs, the Dragonfish is the sea's fiercest little dragon!", 
        SizeRange = {min = 20, max = 40},
        Special_Attribute = "Emits a glowing aura.",
        fishDifficulty = 1,
        FishMod = 2.5,
        FishImage = fishTextures[10]
    },
    ["unicorn_fish"] = {
        Baits = {"steak_bait"},
        Name = "Unicorn Fish", 
        Biomes = {"Lake"}, 
        Rarity = "Mythical",
        Worth = 10000,
        Quest_ID = "Q6002", 
        Description = "The Unicorn Fish is a majestic swimmer that makes every dive feel like a fairytale!", 
        SizeRange = {min = 15, max = 35},
        Special_Attribute = "Hard to find, gives luck bonus.",
        fishDifficulty = 1,
        FishMod = 2.5,
        FishImage = fishTextures[11]
    },
    ["anchovi_fish"] = {
        Baits = {"Any"}, 
        Name = "Anchovi Fish", 
        Biomes = {"Ocean"}, 
        Rarity = "Common",
        Worth = 5,
        Quest_ID = "Q2007", 
        Description = "Your pizza’s missing ingredient has arrived—straight from the sea with a dash of salty charm!",
        SizeRange = {min = 2, max = 5},
        Special_Attribute = "Often found in schools.",
        fishDifficulty = 1,
        FishMod = 1,
        FishImage = fishTextures[12]
    },
    ["angler_fish"] = {
        Baits = {"pizza_bait"},
        Name = "Angler Fish", 
        Biomes = {"Ocean"}, 
        Rarity = "Legendary",
        Worth = 100,
        Quest_ID = "Q5002",
        Description = "The Anglerfish is the ocean’s dark magician, luring in its prey with an eerie light!",
        SizeRange = {min = 10, max = 38},
        Special_Attribute = "Lures other fish.",
        fishDifficulty = 1,
        FishMod = 2,
        FishImage = fishTextures[13]
    },
    ["arowana_fish"] = {
        Baits = {"sadworm_bait"},
        Name = "Arowana Fish",
        Biomes = {"River", "Lake"},
        Rarity = "Uncommon",
        Worth = 20,
        Quest_ID = "Q3003",
        Description = "This majestic fish is the underwater equivalent of a high-speed rocket, cutting through the water with style!",
        SizeRange = {min = 15, max = 30},
        Special_Attribute = "Strong and difficult to catch.",
        fishDifficulty = 1,
        FishMod = 1.5,
        FishImage = fishTextures[14]
    },
    ["barred_knife_fish"] = {
        Baits = {"broccoli_bait"},
        Name = "Barred Knife Fish",
        Biomes = {"River", "Lake"},
        Rarity = "Rare",
        Worth = 30,
        Quest_ID = "Q4002",
        Description = "This fish wears its bold bars like a prison uniform, cutting through water with a rebellious flair!",
        SizeRange = {min = 10, max = 30},
        Special_Attribute = "Hard to catch.",
        fishDifficulty = 1,
        FishMod = 2,
        FishImage = fishTextures[15]
    },
    ["beach_shark_fish"] = {
        Baits = {"hotdog_bait"},
        Name = "Beach Shark",
        Biomes = {"Ocean"},
        Rarity = "Legendary",
        Worth = 100,
        Quest_ID = "Q5003",
        Description = "The Beach Shark is the ultimate sun-seeker, cruising the surf like it owns the shoreline!",
        SizeRange = {min = 20, max = 80},
        Special_Attribute = "Rare spawn, gives special rewards.",
        fishDifficulty = 1,
        FishMod = 3,
        FishImage = fishTextures[16]
    },
    ["begginers_luck_fish"] = {
        Baits = {"hotdog_bait"},
        Name = "Beginner's Luck",
        Biomes = {"Any"},
        Rarity = "Legendary",
        Worth = 150,
        Quest_ID = "Q5004",
        Description = "A deceptivly difficult fish to catch. Found in all biomes.",
        SizeRange = {min = 2, max = 5},
        Special_Attribute = "Great for beginners.",
        fishDifficulty = 1,
        FishMod = 1,
        FishImage = fishTextures[17]
    },
    ["betta_fish"] = {
        Baits = {"bacon_bait"},
        Name = "Betta Fish",
        Biomes = {"River", "Lake"},
        Rarity = "Rare",
        Worth = 50,
        Quest_ID = "Q4003",
        Description = "This little fish is a fierce fashion competitor with a dazzling wardrobe of flowing, colorful fins!",
        SizeRange = {min = 5, max = 10},
        Special_Attribute = "Hard to catch.",
        fishDifficulty = 1,
        FishMod = 1.5,
        FishImage = fishTextures[18]
    },
    ["black_ghostshark"] = {
        Baits = {"steak_bait"},
        Name = "Black Ghostshark",
        Biomes = {"Ocean"},
        Rarity = "Mythical",
        Worth = 500,
        Quest_ID = "Q6003",
        Description = "This sharks all about spooky vibes and stealthy moves, cruising the depths like a shadowy enigma!",
        SizeRange = {min = 20, max = 40},
        Special_Attribute = "Hard to find, gives luck bonus.",
        fishDifficulty = 1,
        FishMod = 2.5,
        FishImage = fishTextures[19]
    },
    ["black_drum_fish"] = {
        Baits = {"corn_bait"},
        Name = "Black Drum Fish",
        Biomes = {"Ocean"},
        Rarity = "Uncommon",
        Worth = 15,
        Quest_ID = "Q3004",
        Description = "This fish’s bold look and solid build make it the heavyweight champion of the coastal concert!",
        SizeRange = {min = 15, max = 30},
        Special_Attribute = "Strong and difficult to catch.",
        fishDifficulty = 1,
        FishMod = 1.5,
        FishImage = fishTextures[20]
    },
    ["blue_whale"] = {
        Baits = {"steak_bait"},
        Name = "Blue Whale",
        Biomes = {"Ocean"},
        Rarity = "Mythical",
        Worth = 500,
        Quest_ID = "Q6004",
        Description = "As the largest creature on Earth, the Blue Whale is a true oceanic giant with a heart as big as its size!",
        SizeRange = {min = 500, max = 1080},
        Special_Attribute = "Rare spawn, gives special rewards.",
        fishDifficulty = 1,
        FishMod = 3,
        FishImage = fishTextures[21]
    },
    ["blue_tang"] = {
        Baits = {"broccoli_bait"},
        Name = "Blue Wish Fish",
        Biomes = {"Ocean"},
        Rarity = "Rare",
        Worth = 30,
        Quest_ID = "Q4004",
        Description = "The Blue Wish Fish is the reef’s radiant gem, turning every glance into a moment of enchantment!",
        SizeRange = {min = 5, max = 12},
        Special_Attribute = "Hard to catch.",
        fishDifficulty = 1,
        FishMod = 1.5,
        FishImage = fishTextures[22]
    },
    ["alley_cat_fish"] = {
        Baits = {"maggot_bait"},
        Name = "Alley Cat Fish",
        Biomes = {"River", "Lake"},
        Rarity = "Uncommon",
        Worth = 20,
        Quest_ID = "Q3005",
        Description = "Sporting a mischievous grin, the Alley Cat Fish navigates the reef like a feline on a midnight prowl!",
        SizeRange = {min = 5, max = 10},
        Special_Attribute = "Quick and agile.",
        fishDifficulty = 1,
        FishMod = 1.5,
        FishImage = fishTextures[23]
    },
    ["catfish"] = {
        Baits = {"Any"},
        Name = "Catfish",
        Biomes = {"River", "Lake"},
        Rarity = "Common",
        Worth = 5,
        Quest_ID = "Q2008",
        Description = "With its whiskered face and laid-back attitude, the Catfish is the cool cat of the aquatic world!",
        SizeRange = {min = 15, max = 30},
        Special_Attribute = "Strong and difficult to catch.",
        fishDifficulty = 1,
        FishMod = 1,
        FishImage = fishTextures[24]
    },
    ["chum_salmon_fish"] = {
        Baits = {"corn_bait"},
        Name = "Chum Salmon",
        Biomes = {"River", "Waterfall"},
        Rarity = "Rare",
        Worth = 30,
        Quest_ID = "Q4005",
        Description = "With a name like 'Chum,' this salmon’s all about hanging out and making a splash in the river!",
        SizeRange = {min = 15, max = 30},
        Special_Attribute = "Hard to catch.",
        fishDifficulty = 1,
        FishMod = 1.5,
        FishImage = fishTextures[25]
    },
    ["clown_fish"] = {
        Baits = {"Any"},
        Name = "Clown Fish",
        Biomes = {"Ocean"},
        Rarity = "Common",
        Worth = 7,
        Quest_ID = "Q2009",
        Description = "With its bold stripes and cheerful demeanor, the Clown Fish is the reef’s ultimate entertainer!",
        SizeRange = {min = 3, max = 8},
        Special_Attribute = "Quick and agile.",
        fishDifficulty = 1,
        FishMod = 1.2,
        FishImage = fishTextures[26]
    },
    ["coho_salmon_fish"] = {
        Baits = {"corn_bait"},
        Name = "Coho Salmon",
        Biomes = {"River", "Waterfall"},
        Rarity = "Uncommon",
        Worth = 15,
        Quest_ID = "Q3006",
        Description = "The Coho Salmon is the stylish swimmer of the river, flaunting its sleek silvery scales like a high-fashion model!",
        SizeRange = {min = 15, max = 30},
        Special_Attribute = "Strong and difficult to catch.",
        fishDifficulty = 1,
        FishMod = 1.5,
        FishImage = fishTextures[27]
    },
    ["common_carp_fish"] = {
        Baits = {"Any"},
        Name = "Common Carp",
        Biomes = {"River", "Lake"},
        Rarity = "Common",
        Worth = 7,
        Quest_ID = "Q2010",
        Description = "This fish is the go-to guest of any pond party, known for its hearty appetite and friendly demeanor!",
        SizeRange = {min = 10, max = 25},
        Special_Attribute = "Strong and difficult to catch.",
        fishDifficulty = 1,
        FishMod = 1.2,
        FishImage = fishTextures[28]
    },
    ["crab"] = {
        Baits = {"Any"},
        Name = "Crab",
        Biomes = {"Ocean"},
        Rarity = "Common",
        Worth = 5,
        Quest_ID = "Q2011",
        Description = "The Crab is the charmingly clumsy critter of the shore, turning every tide into a playful adventure!",
        SizeRange = {min = 3, max = 8},
        Special_Attribute = "Quick and agile.",
        fishDifficulty = 1,
        FishMod = 1.2,
        FishImage = fishTextures[29]
    },
    ["dolphin"] = {
        Baits = {"pizza_bait"},
        Name = "Dolphin",
        Biomes = {"Ocean"},
        Rarity = "Legendary",
        Worth = 100,
        Quest_ID = "Q5005",
        Description = "The Dolphin is the sea’s acrobatic genius, always ready to show off with a splash and a spin!",
        SizeRange = {min = 100, max = 200},
        Special_Attribute = "Rare spawn, gives special rewards.",
        fishDifficulty = 1,
        FishMod = 3,
        FishImage = fishTextures[30]
    },
    ["rasta_drum_fish"] = {
        Baits = {"squid_bait"},
        Name = "Rasta Drum Fish",
        Biomes = {"Ocean"},
        Rarity = "Mythical",
        Worth = 100,
        Quest_ID = "Q6005",
        Description = "The Rasta Drum Fish brings a splash of reggae flair to the reef, drumming up good times with every swim!",
        SizeRange = {min = 20, max = 40},
        Special_Attribute = "Hard to find, gives luck bonus.",
        fishDifficulty = 1,
        FishMod = 2.5,
        FishImage = fishTextures[31]
    },
    ["dumbo_octopus"] = {
        Baits = {"toast_bait"},
        Name = "Dumbo Octopus",
        Biomes = {"Ocean"},
        Rarity = "Rare",
        Worth = 30,
        Quest_ID = "Q4006",
        Description = "With its big, floppy fins and whimsical wiggle, the Dumbo Octopus is the ocean’s most endearing explorer!",
        SizeRange = {min = 10, max = 30},
        Special_Attribute = "Hard to catch.",
        fishDifficulty = 1,
        FishMod = 1.5,
        FishImage = fishTextures[32]
    },
    ["electric_eel"] = {
        Baits = {"maggot_bait"},
        Name = "Electric Eel",
        Biomes = {"River", "Lake"},
        Rarity = "Uncommon",
        Worth = 20,
        Quest_ID = "Q3007",
        Description = "This eel’s got a zap-tastic personality, electrifying the underwater world with every swim!",
        SizeRange = {min = 15, max = 30},
        Special_Attribute = "Strong and difficult to catch.",
        fishDifficulty = 1,
        FishMod = 1.5,
        FishImage = fishTextures[33]
    },
    ["flounder_fish"] = {
        Baits = {"Any"},
        Name = "Flounder Fish",
        Biomes = {"Ocean"},
        Rarity = "Common",
        Worth = 5,
        Quest_ID = "Q2012",
        Description = "This fish keeps a low profile with its unique sideways style, blending seamlessly into the sea floor!",
        SizeRange = {min = 5, max = 15},
        Special_Attribute = "Quick and agile.",
        fishDifficulty = 1,
        FishMod = 1.2,
        FishImage = fishTextures[34]
    },
    ["tourist_fish"] = {
        Baits = {"pizza_bait"},
        Name = "Tourist Fish",
        Biomes = {"Any"},
        Rarity = "Legendary",
        Worth = 150,
        Quest_ID = "Q5006",
        Description = "With its vibrant colors and curious nature, the Tourist Fish is the ocean’s most enthusiastic vacationer!",
        SizeRange = {min = 2, max = 5},
        Special_Attribute = "Great for beginners.",
        fishDifficulty = 1,
        FishMod = 1,
        FishImage = fishTextures[35]
    },
    ["gold_fish"] = {
        Baits = {"egg_bait"},
        Name = "Gold Fish",
        Biomes = {"River", "Lake"},
        Rarity = "Rare",
        Worth = 50,
        Quest_ID = "Q4007", 
        Description = "This fish brings a touch of elegance to the tank with its golden glow and playful antics!",
        SizeRange = {min = 5, max = 10},
        Special_Attribute = "Hard to catch.",
        fishDifficulty = 1,
        FishMod = 1.5,
        FishImage = fishTextures[36]
    },
    ["goliath_tiger_fish"] = {
        Baits = {"sadworm_bait"},
        Name = "Goliath Tiger Fish",
        Biomes = {"River", "Lake", "Ocean"},
        Rarity = "Uncommon",
        Worth = 15,
        Quest_ID = "Q3008",
        Description = "This fish combines a fearsome bite with a majestic look, making it the king of the watery jungle!",
        SizeRange = {min = 15, max = 60},
        Special_Attribute = "Strong and difficult to catch.",
        fishDifficulty = 1,
        FishMod = 1.5,
        FishImage = fishTextures[37]
    },
    ["jelly_fish"] = {
        Baits = {"maggot_bait"},
        Name = "Jelly Fish",
        Biomes = {"Ocean"},
        Rarity = "Uncommon",
        Worth = 100,
        Quest_ID = "Q6006",
        Description = "With its wobbly, glowing tentacles and otherworldly presence, the Jellyfish is the deep sea’s shimmering enigma!",
        SizeRange = {min = 20, max = 40},
        Special_Attribute = "Hard to find, gives luck bonus.",
        fishDifficulty = 1,
        FishMod = 2.5,
        FishImage = fishTextures[38]
    },
    ["jogger_fish"] = {
        Baits = {"Any"},
        Name = "Jogger Fish",
        Biomes = {"River", "Lake"},
        Rarity = "Common",
        Worth = 5,
        Quest_ID = "Q2013",
        Description = "This fish keeps fit by trotting through the currents, proving that even in the water, you can have a workout routine!",
        SizeRange = {min = 3, max = 8},
        Special_Attribute = "Quick and agile.",
        fishDifficulty = 1,
        FishMod = 1.2,
        FishImage = fishTextures[39]
    },
    ["killer_whale"] = {
        Baits = {"pizza_bait"},
        Name = "Killer Whale",
        Biomes = {"Ocean"},
        Rarity = "Legendary",
        Worth = 100,
        Quest_ID = "Q5007",
        Description = "Known for its strategic hunting and impressive size, the Killer Whale is the ocean’s supreme ruler of the hunt!",
        SizeRange = {min = 100, max = 200},
        Special_Attribute = "Rare spawn, gives special rewards.",
        fishDifficulty = 1,
        FishMod = 3,
        FishImage = fishTextures[40]
    },
    ["king_catfish"] = {
        Baits = {"pizza_bait"},
        Name = "King Catfish",
        Biomes = {"River", "Lake"},
        Rarity = "Legendary",
        Worth = 150,
        Quest_ID = "Q5008",
        Description = "porting impressive whiskers and a regal demeanor, the King Catfish is the undisputed monarch of the aquatic realm!",
        SizeRange = {min = 15, max = 30},
        Special_Attribute = "Hard to catch.",
        fishDifficulty = 1,
        FishMod = 1.5,
        FishImage = fishTextures[41]
    },
    ["king_mackerel"] = {
        Baits = {"pizza_bait"},
        Name = "King Mackerel",
        Biomes = {"Ocean"},
        Rarity = "Legendary",
        Worth = 100,
        Quest_ID = "Q5009",
        Description = "porting a streamlined body and a commanding presence, the King Mackerel is the ultimate sea speedster!",
        SizeRange = {min = 15, max = 30},
        Special_Attribute = "Strong and difficult to catch.",
        fishDifficulty = 1,
        FishMod = 1.5,
        FishImage = fishTextures[42]
    },
    ["king_salmon"] = {
        Baits = {"hotdog_bait"},
        Name = "King Salmon",
        Biomes = {"River", "Waterfall"},
        Rarity = "Legendary",
        Worth = 100,
        Quest_ID = "Q5010",
        Description = "Sporting a regal presence and impressive stamina, the King Salmon commands respect on every migration!",
        SizeRange = {min = 15, max = 30},
        Special_Attribute = "Strong and difficult to catch.",
        fishDifficulty = 1,
        FishMod = 1.2,
        FishImage = fishTextures[43]
    },
    ["king_seahorse"] = {
        Baits = {"pizza_bait"},
        Name = "King Seahorse",
        Biomes = {"Ocean"},
        Rarity = "Legendary",
        Worth = 100,
        Quest_ID = "Q5011",
        Description = "With a shimmering tail and noble demeanor, the King Seahorse commands the reef like true underwater royalty!",
        SizeRange = {min = 5, max = 15},
        Special_Attribute = "Rare spawn, gives special rewards.",
        fishDifficulty = 1,
        FishMod = 3,
        FishImage = fishTextures[44]
    },
    ["koi_fish_samurai"] = {
        Baits = {"donut_bait"},
        Name = "Koi Fish Samurai",
        Biomes = {"River", "Lake"},
        Rarity = "Mythical",
        Worth = 10000,
        Quest_ID = "Q6007",
        Description = "With its vibrant scales and a warrior's spirit, the Koi Fish Samurai glides through the pond with honor and grace!",
        SizeRange = {min = 20, max = 40},
        Special_Attribute = "Hard to find, gives luck bonus.",
        fishDifficulty = 1,
        FishMod = 2.5,
        FishImage = fishTextures[45]
    },
    ["koi_fish_large"] = {
        Baits = {"bacon_bait"},
        Name = "Large koi",
        Biomes = {"River", "Lake"},
        Rarity = "Rare",
        Worth = 50,
        Quest_ID = "Q4008",
        Description = "The Large Koi Fish turns heads with its oversized charm and brilliant hues, ruling the pond with elegance!",
        SizeRange = {min = 5, max = 10},
        Special_Attribute = "Hard to catch.",
        fishDifficulty = 1,
        FishMod = 1.5,
        FishImage = fishTextures[46]        
    },
    ["large_stripped_bass"] = {
        Baits = {"plastic_bait"},
        Name = "Large Stripped Bass",
        Biomes = {"River", "Lake", "Ice"},
        Rarity = "Uncommon",
        Worth = 15,
        Quest_ID = "Q3009",
        Description = "With its distinctive stripes and robust build, the Large Striped Bass is the lake’s iconic standout!",
        SizeRange = {min = 15, max = 30},
        Special_Attribute = "Strong and difficult to catch.",
        fishDifficulty = 1,
        FishMod = 1.5,
        FishImage = fishTextures[47]
    },
    ["lion_fish"] = {
        Baits = {"shrimp_bait"},
        Name = "Lion Fish",
        Biomes = {"Ocean"},
        Rarity = "Mythical",
        Worth = 500,
        Quest_ID = "Q6008",
        Description = "The Lionfish prowls the reef with a majestic flair and venomous charm, reigning as the oceans elegant predator!",
        SizeRange = {min = 20, max = 40},
        Special_Attribute = "Hard to find, gives luck bonus.",
        fishDifficulty = 1,
        FishMod = 2.5,
        FishImage = fishTextures[48]
    },
    ["freindly_local_fish"] = {
        Baits = {"pizza_bait"},
        Name = "Friendly Local Fish",
        Biomes = {"Any"},
        Rarity = "Legendary",
        Worth = 100,
        Quest_ID = "Q5012",
        Description = "This fish is the reefs go-to buddy, always there to greet newcomers and share the best spots!",
        SizeRange = {min = 2, max = 5},
        Special_Attribute = "Great for beginners.",
        fishDifficulty = 1,
        FishMod = 1,
        FishImage = fishTextures[49]
    },
    ["mouse_fish"] = {
        Baits = {"chicken_bait"},
        Name = "Mouse Fish",
        Biomes = {"River", "Lake"},
        Rarity = "Rare",
        Worth = 30,
        Quest_ID = "Q4009",
        Description = "This fish might be small, but its curious nature and quick movements make it the reef’s cutest explorer!",
        SizeRange = {min = 5, max = 10},
        Special_Attribute = "Hard to catch.",
        fishDifficulty = 1,
        FishMod = 1.5,
        FishImage = fishTextures[50]
    },
    ["newborn_salmon"] = {
        Baits = {"bacon_bait"},
        Name = "Newborn Salmon",
        Biomes = {"River", "Waterfall"},
        Rarity = "Rare",
        Worth = 50,
        Quest_ID = "Q4010",
        Description = "Fresh out of the egg and full of zest, the Newborn Salmon is the river’s tiny dynamo with big dreams!",
        SizeRange = {min = 1, max = 3},
        Special_Attribute = "Hard to catch.",
        fishDifficulty = 1,
        FishMod = 1.5,
        FishImage = fishTextures[51]
    },
    ["nomadic_trout"] = {
        Baits = {"pizza_bait"},
        Name = "Nomadic Trout",
        Biomes = {"River", "Lake", "Ice"},
        Rarity = "Legendary",
        Worth = 100,
        Quest_ID = "Q5013",
        Description = "The Nomadic Trout is the river’s roving wanderer, always seeking new currents and adventures!",
        SizeRange = {min = 15, max = 30},
        Special_Attribute = "Rare spawn, gives special rewards.",
        fishDifficulty = 1,
        FishMod = 3,
        FishImage = fishTextures[52]
    },
    ["northern_pike"] = {
        Baits = {"plastic_bait"},
        Name = "Northern Pike",
        Biomes = {"Ice"},
        Rarity = "Uncommon",
        Worth = 25,
        Quest_ID = "Q3010",
        Description = "Sporting a torpedo-shaped body and a keen hunting instinct, the Northern Pike is the ultimate freshwater hunter!",
        SizeRange = {min = 8, max = 30},
        Special_Attribute = "Strong and difficult to catch.",
        fishDifficulty = 1,
        FishMod = 1.5,
        FishImage = fishTextures[53]
    },
    ["octopus"] = {
        Baits = {"broccoli_bait"},
        Name = "Octopus",
        Biomes = {"Ocean"},
        Rarity = "Mythical",
        Worth = 750,
        Quest_ID = "Q6010",
        Description = "With its eight agile arms and clever mind, the Octopus is the ocean’s ultimate shape-shifter and escape artist!",
        SizeRange = {min = 20, max = 40},
        Special_Attribute = "Hard to find, gives luck bonus.",
        fishDifficulty = 1,
        FishMod = 2.5,
        FishImage = fishTextures[54]
    },
    ["oil_eater_fish"] = {
        Baits = {"toast_bait"},
        Name = "Oil Eater Fish",
        Biomes = {"Ocean"},
        Rarity = "Rare",
        Worth = 30,
        Quest_ID = "Q4011",
        Description = "With a diet that includes oil, this fish is the reef’s dedicated recycler, keeping the waters cleaner one meal at a time!",
        SizeRange = {min = 10, max = 30},
        Special_Attribute = "Hard to catch.",
        fishDifficulty = 1,
        FishMod = 1.5,
        FishImage = fishTextures[55]
    },
    ["omnipotent_squid"] = {
        Baits = {"shrimp_bait"},
        Name = "Omnipotent Squid",
        Biomes = {"Ocean"},
        Rarity = "Mythical",
        Worth = 500,
        Quest_ID = "Q6011",
        Description = "With its boundless abilities and mesmerizing ink, the Omnipotent Squid is the ocean’s ultimate mastermind!",
        SizeRange = {min = 30, max = 100},
        Special_Attribute = "Hard to find, gives luck bonus.",
        fishDifficulty = 1,
        FishMod = 2.5,
        FishImage = fishTextures[56]
    },
    ["pearl_perch_fish"] = {
        Baits = {"Any"},
        Name = "Pearl Perch Fish",
        Biomes = {"Ocean"},
        Rarity = "Common",
        Worth = 5,
        Quest_ID = "Q2014",
        Description = "Sporting a lustrous sheen and a graceful glide, the Pearl Perch Fish is the ocean’s own living treasure!",
        SizeRange = {min = 3, max = 8},
        Special_Attribute = "Quick and agile.",
        fishDifficulty = 1,
        FishMod = 1.2,
        FishImage = fishTextures[57]
    },
    ["peasant_fish"] = {
        Baits = {"shrimp_bait"},
        Name = "Peasant Fish",
        Biomes = {"Any"},
        Rarity = "Mythical",
        Worth = 1,
        Quest_ID = "Q6012",
        Description = "Simple yet charming, the Peasant Fish swims with a humble grace, proving that beauty doesn’t need to be flashy!",
        SizeRange = {min = 2, max = 5},
        Special_Attribute = "Great for beginners.",
        fishDifficulty = 1,
        FishMod = 1,
        FishImage = fishTextures[58]
    },
    ["pink_salmon"] = {
        Baits = {"plastic_bait"},
        Name = "Pink Salmon",
        Biomes = {"River", "Waterfall"},
        Rarity = "Uncommon",
        Worth = 20,
        Quest_ID = "Q3011",
        Description = "With a poodle-like poof and a grumpy frown, this salmon’s charm is as striking as its attitude!",
        SizeRange = {min = 15, max = 30},
        Special_Attribute = "Strong and difficult to catch.",
        fishDifficulty = 1,
        FishMod = 1.5,
        FishImage = fishTextures[59]
    },
    ["piranha"] = {
        Baits = {"hotdog_bait"},
        Name = "Piranha",
        Biomes = {"Lake"},
        Rarity = "Legendary",
        Worth = 150,
        Quest_ID = "Q5014",
        Description = "This fish’s sharp teeth and bold attitude make the Piranha the underwater worlds notorious chomper!",
        SizeRange = {min = 10, max = 30},
        Special_Attribute = "Rare spawn, gives special rewards.",
        fishDifficulty = 1,
        FishMod = 2.5,
        FishImage = fishTextures[60]
    },
    ["red_snapper_fish"] = {
        Baits = {"broccoli_bait"},
        Name = "Red Snapper Fish",
        Biomes = {"Ocean"},
        Rarity = "Rare",
        Worth = 30,
        Quest_ID = "Q4012",
        Description = "This fish stands out with its brilliant red color and lively personality, making every swim a dazzling display!",
        SizeRange = {min = 10, max = 30},
        Special_Attribute = "Hard to catch.",
        fishDifficulty = 1,
        FishMod = 1.5,
        FishImage = fishTextures[61]
    },
    ["rock_bass_fish"] = {
        Baits = {"Any"},
        Name = "Rock Bass",
        Biomes = {"River", "Lake", "Ice"},
        Rarity = "Common",
        Worth = 5,
        Quest_ID = "Q2015",
        Description = "This fish is built like a tank and ready for action, making the Rock Bass Fish the ultimate freshwater heavyweight!",
        SizeRange = {min = 5, max = 15},
        Special_Attribute = "Quick and agile.",
        fishDifficulty = 1,
        FishMod = 1.2,
        FishImage = fishTextures[62]
    },
    ["royal_lake_fish"] = {
        Baits = {"hotdog_bait"},
        Name = "Royal Lake Fish",
        Biomes = {"Lake"},
        Rarity = "Legendary",
        Worth = 100,
        Quest_ID = "Q5015",
        Description = "This fish swims with a royal air and a grand style, making every ripple in the water a display of underwater royalty!",
        SizeRange = {min = 15, max = 30},
        Special_Attribute = "Rare spawn, gives special rewards.",
        fishDifficulty = 1,
        FishMod = 3,
        FishImage = fishTextures[63]
    },
    ["salt_trader_fish"] = {
        Baits = {"steak_bait"},
        Name = "Salt Trader Fish",
        Biomes = {"Ocean"},
        Rarity = "Mythical",
        Worth = 500,
        Quest_ID = "Q6013",
        Description = "The Salt Trader Fish navigates the seas with the precision of a merchant, trading in salt like it’s second nature!",
        SizeRange = {min = 20, max = 40},
        Special_Attribute = "Hard to find, gives luck bonus.",
        fishDifficulty = 1,
        FishMod = 2.5,
        FishImage = fishTextures[64]
    },
    ["saw_fish"] = {
        Baits = {"egg_bait"},
        Name = "Saw Fish",
        Biomes = {"Ocean"},
        Rarity = "Rare",
        Worth = 30,
        Quest_ID = "Q4013",
        Description = "This fish's unique saw-shaped snout makes it the underwater world’s most innovative and formidable hunter!",
        SizeRange = {min = 10, max = 30},
        Special_Attribute = "Hard to catch.",
        fishDifficulty = 1,
        FishMod = 1.5,
        FishImage = fishTextures[65]
    },
    ["seahorse"] = {
        Baits = {"toast_bait"},
        Name = "Seahorse",
        Biomes = {"Ocean"},
        Rarity = "Rare",
        Worth = 30,
        Quest_ID = "Q4014",
        Description = "With its delicate frame and mesmerizing movements, the Seahorse adds a touch of magical charm to the coral reef!",
        SizeRange = {min = 5, max = 15},
        Special_Attribute = "Quick and agile.",
        fishDifficulty = 1,
        FishMod = 1.2,
        FishImage = fishTextures[66]
    },
    ["servant_fish"] = {
        Baits = {"grub_bait"},
        Name = "Servant Fish",
        Biomes = {"Any"},
        Rarity = "Uncommon",
        Worth = 15,
        Quest_ID = "Q3012",
        Description = "A helpful fish that is always ready to lend a fin.",
        SizeRange = {min = 5, max = 10},
        Special_Attribute = "Strong and difficult to catch.",
        fishDifficulty = 1,
        FishMod = 1.5,
        FishImage = fishTextures[67]
    },
    ["small_common_trout"] = {
        Baits = {"Any"},
        Name = "Common Trout",
        Biomes = {"River", "Lake", "Ice"},
        Rarity = "Common",
        Worth = 5,
        Quest_ID = "Q2016",
        Description = "With its modest size and lively swim, the Small Common Trout is the charming go-getter of the stream!",
        SizeRange = {min = 5, max = 10},
        Special_Attribute = "Quick and agile.",
        fishDifficulty = 1,
        FishMod = 1.2,
        FishImage = fishTextures[68]
    },
    ["rainbow_trout"] = {
        Baits = {"chicken_bait"},
        Name = "Rainbow Trout",
        Biomes = {"River", "Lake", "Ice"},
        Rarity = "Rare",
        Worth = 30,
        Quest_ID = "Q4015",
        Description = "This trout shines bright with its array of colors, making every splash a spectacular show of aquatic brilliance!",
        SizeRange = {min = 10, max = 30},
        Special_Attribute = "Hard to catch.",
        fishDifficulty = 1,
        FishMod = 1.5,
        FishImage = fishTextures[69]
    },
    ["spotted_bass_fish"] = {
        Baits = {"corn_bait"},
        Name = "Spotted Bass",
        Biomes = {"River", "Lake", "Ice"},
        Rarity = "Uncommon",
        Worth = 15,
        Quest_ID = "Q3013",
        Description = "With its unique spots and agile moves, the Spotted Bass Fish makes a bold splash in every lake it inhabits!",
        SizeRange = {min = 15, max = 30},
        Special_Attribute = "Strong and difficult to catch.",
        fishDifficulty = 1,
        FishMod = 1.5,
        FishImage = fishTextures[70]
    },
    ["squid"] = {
        Baits = {"hotdog_bait"},
        Name = "Squid",
        Biomes = {"Ocean"},
        Rarity = "Legendary",
        Worth = 100,
        Quest_ID = "Q5016",
        Description = "With its mesmerizing movements and ink-blasting skills, the Squid turns every underwater adventure into a high-speed thrill!",
        SizeRange = {min = 20, max = 40},
        Special_Attribute = "Rare spawn, gives special rewards.",
        fishDifficulty = 1,
        FishMod = 2.5,
        FishImage = fishTextures[71]
    },
    ["squirrel_fish"] = {
        Baits = {"corn_bait"},
        Name = "Squirrel Fish",
        Biomes = {"River", "Lake"},
        Rarity = "Uncommon",
        Worth = 30,
        Quest_ID = "Q3014",
        Description = "Sporting a bushy look and a cheeky personality, the Squirrel Fish is the reef’s most energetic and quirky resident!",
        SizeRange = {min = 5, max = 10},
        Special_Attribute = "Hard to catch.",
        fishDifficulty = 1,
        FishMod = 1.5,
        FishImage = fishTextures[72]
    },
    ["star_fish"] = {
        Baits = {"squid_bait"},
        Name = "Star Fish",
        Biomes = {"Ocean"},
        Rarity = "Mythical",
        Worth = 500,
        Quest_ID = "Q6014",
        Description = "A five-armed party master, keeping the underwater rave alive!",
        SizeRange = {min = 20, max = 40},
        Special_Attribute = "Hard to find, gives luck bonus.",
        fishDifficulty = 1,
        FishMod = 2.5,
        FishImage = fishTextures[73]
    },
    ["sting_ray"] = {
        Baits = {"toast_bait"},
        Name = "Sting Ray",
        Biomes = {"Ocean"},
        Rarity = "Rare",
        Worth = 30,
        Quest_ID = "Q4016",
        Description = "An underwater party superstar, electrifying the deep with its moves!",
        SizeRange = {min = 10, max = 30},
        Special_Attribute = "Hard to catch.",
        fishDifficulty = 1,
        FishMod = 1.5,
        FishImage = fishTextures[74]
    },
    ["sun_fish"] = {
        Baits = {"Any"},
        Name = "Sun Fish",
        Biomes = {"Ocean"},
        Rarity = "Common",
        Worth = 7,
        Quest_ID = "Q2017",
        Description = "The sea solar-powered party animal, lighting up the ocean with its glow!",
        SizeRange = {min = 10, max = 30},
        Special_Attribute = "Quick and agile.",
        fishDifficulty = 1,
        FishMod = 1.2,
        FishImage = fishTextures[75]
    },
    ["surffer_fish"] = {
        Baits = {"hotdog_bait"},
        Name = "Surfer Fish",
        Biomes = {"Ice", "Ocean"},
        Rarity = "Legendary",
        Worth = 100,
        Quest_ID = "Q5017",
        Description = "Underwaters gnarly wave master, making every crest a party!",
        SizeRange = {min = 15, max = 30},
        Special_Attribute = "Rare spawn, gives special rewards.",
        fishDifficulty = 1,
        FishMod = 3,
        FishImage = fishTextures[76]
    },
    ["sword_fish"] = {
        Baits = {"donut_bait"},
        Name = "Sword Fish",
        Biomes = {"Ocean"},
        Rarity = "Mythical",
        Worth = 500,
        Quest_ID = "Q6015",
        Description = "Sea’s speedy knight, slicing through waves with a sharp sense of adventure!",
        SizeRange = {min = 20, max = 40},
        Special_Attribute = "Hard to find, gives luck bonus.",
        fishDifficulty = 1,
        FishMod = 2.5,
        FishImage = fishTextures[77]
    },
    ["tiger_pistol_shrimp"] = {
        Baits = {"hotdog_bait"},
        Name = "Tiger Pistol Shrimp",
        Biomes = {"Any"},
        Rarity = "Legendary",
        Worth = 150,
        Quest_ID = "Q5018",
        Description = "A large and powerful crustacean known for its sonic boom.",
        SizeRange = {min = 10, max = 30},
        Special_Attribute = "Rare spawn, gives special rewards.",
        fishDifficulty = 1,
        FishMod = 2.5,
        FishImage = fishTextures[78]
    },
    ["transparent_head_fish"] = {
        Baits = {"shrimp_bait"},
        Name = "Transparent Head Fish",
        Biomes = {"Ocean"},
        Rarity = "Mythical",
        Worth = 750,
        Quest_ID = "Q6016",
        Description = "Seas invisible wonder, floating through the deep with a ghostly glow!",
        SizeRange = {min = 20, max = 40},
        Special_Attribute = "Hard to find, gives luck bonus.",
        fishDifficulty = 1,
        FishMod = 2.5,
        FishImage = fishTextures[79]
    },
    ["buisness_fish"] = {
        Baits = {"pizza_bait"},
        Name = "Buisness Fish",
        Biomes = {"Any"},
        Rarity = "Legendary",
        Worth = 150,
        Quest_ID = "Q5019",
        Description = "A large and powerful fish known for its financial acumen.",
        SizeRange = {min = 15, max = 30},
        Special_Attribute = "Rare spawn, gives special rewards.",
        fishDifficulty = 1,
        FishMod = 3,
        FishImage = fishTextures[80]
    },
    ["derp_fish"] = {
        Baits = {"chicken_bait"},
        Name = "Derp Fish",
        Biomes = {"Any"},
        Rarity = "Rare",
        Worth = 30,
        Quest_ID = "Q4017",
        Description = "Sea’s charmingly clueless buddy, making everyone smile with its quirky antics!",
        SizeRange = {min = 5, max = 10},
        Special_Attribute = "Hard to catch.",
        fishDifficulty = 1,
        FishMod = 1.5,
        FishImage = fishTextures[81]
    },
    ["king_fish"] = {
        Baits = {"sadworm_bait"},
        Name = "King Fish",
        Biomes = {"Any"},
        Rarity = "Uncommon",
        Worth = 15,
        Quest_ID = "Q5020",
        Description = "This fish just has the blues.",
        SizeRange = {min = 15, max = 30},
        Special_Attribute = "Rare spawn, gives special rewards.",
        fishDifficulty = 1,
        FishMod = 3,
        FishImage = fishTextures[82]
    },
    ["walley_fish"] = {
        Baits = {"corn_bait"},
        Name = "Walleye",
        Biomes = {"River", "Lake", "Ice"},
        Rarity = "Uncommon",
        Worth = 15,
        Quest_ID = "Q3015",
        Description = "The oceans stealthy stalker, blending in and making every hunt a success!",
        SizeRange = {min = 15, max = 30},
        Special_Attribute = "Strong and difficult to catch.",
        fishDifficulty = 1,
        FishMod = 1.5,
        FishImage = fishTextures[83]
    },
    ["albino_catfish"] = {
        Baits = {"bacon_bait"},
        Name = "Albino Catfish",
        Biomes = {"River", "Lake"},
        Rarity = "Rare",
        Worth = 30,
        Quest_ID = "Q4018",
        Description = "The ocean’s elusive gem, standing out with a pristine, otherworldly shine!",
        SizeRange = {min = 10, max = 30},
        Special_Attribute = "Hard to catch.",
        fishDifficulty = 1,
        FishMod = 1.5,
        FishImage = fishTextures[84]
    },
    ["yellow_watchman"] = {
        Baits = {"donut_bait"},
        Name = "Yellow Watchman",
        Biomes = {"Ocean"},
        Rarity = "Mythical",
        Worth = 500,
        Quest_ID = "Q6017",
        Description = "A rare and elusive deep sea fish known for kepping an eye out.",
        SizeRange = {min = 20, max = 40},
        Special_Attribute = "Hard to find, gives luck bonus.",
        fishDifficulty = 1,
        FishMod = 2.5,
        FishImage = fishTextures[85]
    }
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

-- Function to roll for rarity based on weights
local function rollForRarity(rarityWeights, bait)
    if itemMetaData.bait_metadata[bait] == nil or bait == nil then
        print("Bait is nil so defaulting to Common")
        return "Common"  -- Default to common
    end
    -- Get the bait's rarity from the metadata
    local baitRarity = itemMetaData.bait_metadata[bait].ItemRarity
    print("Bait Rarity: " .. baitRarity)
    
    -- Define an ordered list of rarities
    local rarityOrder = {"Common", "Uncommon", "Rare", "Legendary", "Mythical"}
    
    -- Filter the rarityWeights to include only rarities up to the bait's rarity
    local filteredRarityWeights = {}
    for _, rarity in ipairs(rarityOrder) do
        if rarity == baitRarity then
            filteredRarityWeights[rarity] = rarityWeights[rarity]
            print("Adding rarity (final): " .. rarity .. " with weight: " .. tostring(rarityWeights[rarity]))  -- Print the final rarity added
            break
        elseif rarityWeights[rarity] then
            filteredRarityWeights[rarity] = rarityWeights[rarity]
            print("Adding rarity: " .. rarity .. " with weight: " .. tostring(rarityWeights[rarity]))  -- Print each rarity as it is added
        end
    end


    -- Calculate the total weight of the filtered rarities
    local totalWeight = 0
    for _, weight in pairs(filteredRarityWeights) do
        totalWeight = totalWeight + weight
    end
    print("Total Weight: " .. tostring(totalWeight))
    
    -- Generate the roll
    local roll = math.random(0, totalWeight-1) + math.random()  -- Add a random decimal to the roll for unpredictability
    local cumulativeWeight = 0
    print("Roll: " .. tostring(roll))
    
    -- Determine the rarity based on the roll using the correct order
    for _, rarity in ipairs(rarityOrder) do
        if filteredRarityWeights[rarity] then
            cumulativeWeight = cumulativeWeight + filteredRarityWeights[rarity]
            if roll <= cumulativeWeight then
                print("Selected Rarity: " .. rarity)
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
    print("Chosen Rarity: " .. chosenRarity)
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
        print("FishList[" .. i .. "]: " .. fish)
    end
    
    -- If no fish match the chosen rarity, Biome, and Bait, then pick any common fish that matches the chosen biome and bait
    if #fishList == 0 then

        print("[ERROR] No fish found for: " .. chosenRarity .. " in " .. Biome .. ".Defaulting to Common fish that doesnt need bait.")

        for fishName, fishData in fish_metadata do
            if CheckBiome(fishName, Biome) and (fishData.Rarity == "Common") then
                table.insert(fishList, fishName)
            end
        end
        if #fishList == 0 then
            print("[ERROR] No Common fish found for: " .. Biome)
            table.insert(fishList, "blue_gill") -- Default to boot fish if no common fish are found
        end
    end

    -- Select a random fish from the filtered list
    local randomFish = fishList[math.random(1, #fishList)]
    print("Selected a fish: " .. randomFish .. "with rarity: " .. fish_metadata[randomFish].Rarity .. " and Biome: " .. Biome .. " and Bait: " .. Bait)
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