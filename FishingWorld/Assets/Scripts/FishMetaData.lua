--!Type(Module)

--!SerializeField
local fishTextures : {Texture} = nil

local Utils = require("Utils")
local itemMetaData = require("ItemMetaData")

FishDifficulties = {
    ["Common"] = 1,
    ["Uncommon"] = 1.5,
    ["Rare"] = 2,
    ["Epic"] = 2.25,
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
    ["black_crappie"] = {"Any"},
    ["yellow_perch"] = {"Any"},
    ["blue_gill"] = {"Any"},
    ["pumpkinseed"] = {"Any"},
    ["boot_fish"] = {"Any"},
    ["can_fish"] = {"Any"},
    ["long_mouth_bass"] = {"Any"},
    ["salmon"] = {"Any"},
    ["crystal_fairy_fish"] = {"Any"},
    ["dragon_fish"] = {"Any"},
    ["unicorn_fish"] = {"Any"},
    ["anchovi_fish"] = {"Any"},
    ["angler_fish"] = {"Any"},
    ["arowana_fish"] = {"Any"},
    ["barred_knife_fish"] = {"Any"},
    ["beach_shark_fish"] = {"Any"},
    ["begginers_luck_fish"] = {"Any"},
    ["betta_fish"] = {"Any"},
    ["black_ghostshark"] = {"Any"},
    ["black_drum_fish"] = {"Any"},
    ["blue_whale"] = {"Any"},
    ["blue_tang"] = {"Any"},
    ["alley_cat_fish"] = {"Any"},
    ["catfish"] = {"Any"},
    ["chum_salmon_fish"] = {"Any"},
    ["clown_fish"] = {"Any"},
    ["coho_salmon_fish"] = {"Any"},
    ["common_carp_fish"] = {"Any"},
    ["crab"] = {"Any"},
    ["dolphin"] = {"Any"},
    ["rasta_drum_fish"] = {"Any"},
    ["dumbo_octopus"] = {"Any"},
    ["electric_eel"] = {"Any"},
    ["flounder_fish"] = {"Any"},
    ["tourist_fish"] = {"Any"},
    ["gold_fish"] = {"Any"},
    ["goliath_tiger_fish"] = {"Any"},
    ["jelly_fish"] = {"Any"},
    ["jogger_fish"] = {"Any"},
    ["killer_whale"] = {"Any"},
    ["king_catfish"] = {"Any"},
    ["king_mackerel"] = {"Any"},
    ["king_salmon"] = {"Any"},
    ["king_seahorse"] = {"Any"},
    ["koi_fish_samurai"] = {"Any"},
    ["koi_fish_large"] = {"Any"},
    ["large_stripped_bass"] = {"Any"},
    ["lion_fish"] = {"Any"},
    ["freindly_local_fish"] = {"Any"},
    ["mouse_fish"] = {"Any"},
    ["newborn_salmon"] = {"Any"},
    ["nomadic_trout"] = {"Any"},
    ["northern_pike"] = {"Any"},
    ["octopus"] = {"Any"},
    ["oil_eater_fish"] = {"Any"},
    ["omnipotent_squid"] = {"Any"},
    ["pearl_perch_fish"] = {"Any"},
    ["peasant_fish"] = {"Any"},
    ["pink_salmon"] = {"Any"},
    ["piranha"] = {"Any"},
    ["red_snapper_fish"] = {"Any"},
    ["rock_bass_fish"] = {"Any"},
    ["royal_lake_fish"] = {"Any"},
    ["salt_trader_fish"] = {"Any"},
    ["saw_fish"] = {"Any"},
    ["seahorse"] = {"Any"},
    ["servant_fish"] = {"Any"},
    ["small_common_trout"] = {"Any"},
    ["rainbow_trout"] = {"Any"},
    ["spotted_bass_fish"] = {"Any"},
    ["squid"] = {"Any"},
    ["squirrel_fish"] = {"Any"},
    ["star_fish"] = {"Any"},
    ["sting_ray"] = {"Any"},
    ["sun_fish"] = {"Any"},
    ["surffer_fish"] = {"Any"},
    ["sword_fish"] = {"Any"},
    ["tiger_pistol_shrimp"] = {"Any"},
    ["transparent_head_fish"] = {"Any"},
    ["buisness_fish"] = {"Any"},
    ["derp_fish"] = {"Any"},
    ["king_fish"] = {"Any"},
    ["walley_fish"] = {"Any"},
    ["albino_catfish"] = {"Any"},
    ["yellow_watchman"] = {"Any"},
    ["bubble_fish"] = {"Any"},
    ["rainbow_fish"] = {"crystal"},
    ["garnetfish"] = {"crystal"},
    ["amethyststream"] = {"crystal"},
    ["aquaripple"] = {"crystal"},
    ["diamondblink"] = {"crystal"},
    ["emeraldfin"] = {"crystal"},
    ["pearlglow"] = {"crystal"},
    ["rubyflame"] = {"crystal"},
    ["peridotglimmer"] = {"crystal"},
    ["sapphirine"] = {"crystal"},
    ["opalflare"] = {"crystal"},
    ["topazflare"] = {"crystal"},
    ["turquoisewave"] = {"crystal"},
    ["LouYu"] = {"crystal"},
    ["Obsidianfin"] = {"crystal"},
    ["solidGoldFish"] = {"crystal"},
    ["solidSilverFish"] = {"crystal"},
    ["tounniFish"] = {"crystal"},
    ["bubbleGumFish"] = {"crystal"},
    ["DreamweaverBeta"] = {"crystal"},
    ["crystalJellyFish"] = {"crystal"},
    --coral
    ["amberlure"] = {"coral"},
    ["ashflare"] = {"coral"},
    ["azuregill"] = {"coral"},
    ["blazefin"] = {"coral"},
    ["charavine"] = {"coral"},
    ["crownscale"] = {"coral"},
    ["duskmire"] = {"coral"},
    ["embercreel"] = {"coral"},
    ["flutterfin"] = {"coral"},
    ["gloomgill"] = {"coral"},
    ["jellyspawn"] = {"coral"},
    ["mandaglimmer"] = {"coral"},
    ["moltenfin"] = {"coral"},
    ["nightdarter"] = {"coral"},
    ["oarpike"] = {"coral"},
    ["puffreef"] = {"coral"},
    ["reefwarden"] = {"coral"},
    ["regalfin"] = {"coral"},
    ["skypiercer"] = {"coral"},
    ["spinebloom"] = {"coral"},
    ["stellafin"] = {"coral"},
    ["bettraquon"] = {"coral"},
    --winter
    ["brineleaf"] = {"winter"},
    ["crescentide"] = {"winter"},
    ["crystalfade"] = {"winter"},
    ["deepgloom"] = {"winter"},
    ["dusktide"] = {"winter"},
    ["frothling"] = {"winter"},
    ["frostchar"] = {"winter"},
    ["frostqueen"] = {"winter"},
    ["frostscale"] = {"winter"},
    ["glimmerscale"] = {"winter"},
    ["glacierrun"] = {"winter"},
    ["lunawing"] = {"winter"},
    ["moonspine"] = {"winter"},
    ["mythicrest"] = {"winter"},
    ["rimefang"] = {"winter"},
    ["shiverfin"] = {"winter"},
    ["silvertang"] = {"winter"},
    ["snowidol"] = {"winter"},
    ["tundrawave"] = {"winter"},
    ["whispergill"] = {"winter"},
    -- jungle
    ["tigerrush"] = {"jungle"},
    ["leafshade"] = {"jungle"},
    ["piranthrax"] = {"jungle"},
    ["goldripple"] = {"jungle"},
    ["shadowdrake"] = {"jungle"},
    ["drakefly"] = {"jungle"},
    ["voltcat"] = {"jungle"},
    ["gleameel"] = {"jungle"},
    ["gratch"] = {"jungle"},
    ["jadeflare"] = {"jungle"},
    ["glowbelly"] = {"jungle"},
    ["mystiglow"] = {"jungle"},
    ["nightmoth"] = {"jungle"},
    ["runecarp"] = {"jungle"},
    ["duneskimmer"] = {"jungle"},
    ["shovelclaw"] = {"jungle"},
    ["silkspinner"] = {"jungle"},
    ["stormpulse"] = {"jungle"},
    ["stripeflash"] = {"jungle"},
    ["zebris"] = {"jungle"},
    --cliffs
    ["glacierglow"] = {"cliffs"},
    ["axolume"] = {"cliffs"},
    ["blueflare"] = {"cliffs"},
    ["cratefin"] = {"cliffs"},
    ["mistwhirl"] = {"cliffs"},
    ["dragonscale"] = {"cliffs"},
    ["somnifin"] = {"cliffs"},
    ["faeglimmer"] = {"cliffs"},
    ["windsprite"] = {"cliffs"},
    ["ballfin"] = {"cliffs"},
    ["goldwyrm"] = {"cliffs"},
    ["skyrider"] = {"cliffs"},
    ["plumecrest"] = {"cliffs"},
    ["beakcoil"] = {"cliffs"},
    ["flareborn"] = {"cliffs"},
    ["glowcrest"] = {"cliffs"},
    ["spectralfin"] = {"cliffs"},
    ["speckledray"] = {"cliffs"},
    ["stellaroi"] = {"cliffs"},
    ["striatus"] = {"cliffs"},
    --tropical
    ["sunburstfish"] = {"tropical"},
    ["mudfin"] = {"tropical"},
    ["clearcap"] = {"tropical"},
    ["gulpfin"] = {"tropical"},
    ["tangaclaw"] = {"tropical"},
    ["neonflare"] = {"tropical"},
    ["shadefin"] = {"tropical"},
    ["rainbowbeak"] = {"tropical"},
    ["peaflare"] = {"tropical"},
    ["streamglow"] = {"tropical"},
    ["reefshadow"] = {"tropical"},
    ["stoneblenny"] = {"tropical"},
    ["rustbarb"] = {"tropical"},
    ["koisamurai"] = {"tropical"},
    ["shellback"] = {"tropical"},
    ["stardustfin"] = {"tropical"},
    ["dawnsnapper"] = {"tropical"},
    ["dusksnapper"] = {"tropical"},
    ["venomfang"] = {"tropical"},
    ["voidwing"] = {"tropical"},

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
    ["bubble_fish"] = "Bubble Fish",
    ["rainbow_fish"] = "Rainbow Fish",
    ["garnetfish"] = "Garnetfish",
    ["amethyststream"] = "Amethyststream",
    ["aquaripple"] = "Aquaripple",
    ["diamondblink"] = "Diamondblink",
    ["emeraldfin"] = "Emeraldfin",
    ["pearlglow"] = "Pearlglow",
    ["rubyflame"] = "Rubyflame",
    ["peridotglimmer"] = "Peridotglimmer",
    ["sapphirine"] = "Sapphirine",
    ["opalflare"] = "Opalflare",
    ["topazflare"] = "Topazflare",
    ["turquoisewave"] = "Turquoisewave",
    ["LouYu"] = "Lou Yu",
    ["Obsidianfin"] = "Obsidianfin",
    ["solidGoldFish"] = "Midas Fin",
    ["solidSilverFish"] = "Sterling Fish",
    ["tounniFish"] = "Glimmergill",
    ["bubbleGumFish"] = "Bubblegum Fish",
    ["DreamweaverBeta"] = "Dreamweaver Beta",
    ["crystalJellyFish"] = "Iridesceus",
    --coral
    ["amberlure"] = "Amber Lure",
    ["ashflare"] = "Ash Flare",
    ["azuregill"] = "Azure Gill",
    ["blazefin"] = "Blaze Fin",
    ["charavine"] = "Charavine",
    ["crownscale"] = "Crown Scale",
    ["duskmire"] = "Duskmire",
    ["embercreel"] = "Ember Creel",
    ["flutterfin"] = "Flutter Fin",
    ["gloomgill"] = "Gloom Gill",
    ["jellyspawn"] = "Jellyspawn",
    ["mandaglimmer"] = "Mandaglimmer",
    ["moltenfin"] = "Molten Fin",
    ["nightdarter"] = "Night Darter",
    ["oarpike"] = "Oarpike",
    ["puffreef"] = "Puff Reef",
    ["reefwarden"] = "Reef Warden",
    ["regalfin"] = "Regal Fin",
    ["skypiercer"] = "Sky Piercer",
    ["spinebloom"] = "Spine Bloom",
    ["stellafin"] = "Stella Fin",
    ["bettraquon"] = "Bettraquon",
    --winter
    ["brineleaf"] = "Brineleaf",
    ["crescentide"] = "Crescentide",
    ["crystalfade"] = "Crystalfade",
    ["deepgloom"] = "Deepgloom",
    ["dusktide"] = "Dusktide",
    ["frothling"] = "Frothling",
    ["frostchar"] = "Frostchar",
    ["frostqueen"] = "Frostqueen",
    ["frostscale"] = "Frostscale",
    ["glimmerscale"] = "Glimmerscale",
    ["glacierrun"] = "Glacierrun",
    ["lunawing"] = "Lunawing",
    ["moonspine"] = "Moonspine",
    ["mythicrest"] = "Mythicrest",
    ["rimefang"] = "Rimefang",
    ["shiverfin"] = "Shiverfin",
    ["silvertang"] = "Silvertang",
    ["snowidol"] = "Snowidol",
    ["tundrawave"] = "Tundrawave",
    ["whispergill"] = "Whispergill",
    -- jungle
    ["tigerrush"] = "Tigerrush",
    ["leafshade"] = "Leafshade",
    ["piranthrax"] = "Piranthrax",
    ["goldripple"] = "Goldripple",
    ["shadowdrake"] = "Shadowdrake",
    ["drakefly"] = "Drakefly",
    ["voltcat"] = "Voltcat",
    ["gleameel"] = "Gleameel",
    ["gratch"] = "Gratch",
    ["jadeflare"] = "Jadeflare",
    ["glowbelly"] = "Glowbelly",
    ["mystiglow"] = "Mystiglow",
    ["nightmoth"] = "Nightmoth",
    ["runecarp"] = "Runecarp",
    ["duneskimmer"] = "Duneskimmer",
    ["shovelclaw"] = "Shovelclaw",
    ["silkspinner"] = "Silkspinner",
    ["stormpulse"] = "Stormpulse",
    ["stripeflash"] = "Stripeflash",
    ["zebris"] = "Zebris",
    --cliffs
    ["axolume"] = "Axolume",
    ["ballfin"] = "Ballfin",
    ["beakcoil"] = "Beakcoil",
    ["blueflare"] = "Blueflare",
    ["cratefin"] = "Cratefin",
    ["dragonscale"] = "Dragonscale",
    ["faeglimmer"] = "Faeglimmer",
    ["flareborn"] = "Flareborn",
    ["glacierglow"] = "Glacierglow",
    ["glowcrest"] = "Glowcrest",
    ["goldwyrm"] = "Goldwyrm",
    ["mistwhirl"] = "Mistwhirl",
    ["plumecrest"] = "Plumecrest",
    ["skyrider"] = "Skyrider",
    ["somnifin"] = "Somnifin",
    ["spectralfin"] = "Spectralfin",
    ["speckledray"] = "Speckledray",
    ["stellaroi"] = "Stellaroi",
    ["striatus"] = "Striatus",
    ["windsprite"] = "Windsprite",
    --tropical
    ["sunburstfish"] = "Sunburstfish",
    ["mudfin"] = "mudfin",
    ["clearcap"] = "Clearcap",
    ["gulpfin"] = "Gulpfin",
    ["tangaclaw"] = "Tangaclaw",
    ["neonflare"] = "Neonflare",
    ["shadefin"] = "Shadefin",
    ["rainbowbeak"] = "Rainbowbeak",
    ["peaflare"] = "Peaflare",
    ["streamglow"] = "Streamglow",
    ["reefshadow"] = "Reefshadow",
    ["stoneblenny"] = "Stoneblenny",
    ["rustbarb"] = "Rustbarb",
    ["koisamurai"] = "Koisamurai",
    ["shellback"] = "Shellback",
    ["stardustfin"] = "Stardustfin",
    ["dawnsnapper"] = "Dawnsnapper",
    ["dusksnapper"] = "Dusksnapper",
    ["venomfang"] = "Venomfang",
    ["voidwing"] = "Voidwing",

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
    ["angler_fish"] = "Epic",
    ["arowana_fish"] = "Uncommon",
    ["barred_knife_fish"] = "Rare",
    ["beach_shark_fish"] = "Epic",
    ["begginers_luck_fish"] = "Epic",
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
    ["dolphin"] = "Epic",
    ["rasta_drum_fish"] = "Mythical",
    ["dumbo_octopus"] = "Rare",
    ["electric_eel"] = "Uncommon",
    ["flounder_fish"] = "Common",
    ["tourist_fish"] = "Legendary",
    ["gold_fish"] = "Rare",
    ["goliath_tiger_fish"] = "Uncommon",
    ["jelly_fish"] = "Mythical",
    ["jogger_fish"] = "Common",
    ["killer_whale"] = "Epic",
    ["king_catfish"] = "Legendary",
    ["king_mackerel"] = "Epic",
    ["king_salmon"] = "Epic",
    ["king_seahorse"] = "Legendary",
    ["koi_fish_samurai"] = "Mythical",
    ["koi_fish_large"] = "Rare",
    ["large_stripped_bass"] = "Uncommon",
    ["lion_fish"] = "Mythical",
    ["freindly_local_fish"] = "Legendary",
    ["mouse_fish"] = "Rare",
    ["newborn_salmon"] = "Rare",
    ["nomadic_trout"] = "Epic",
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
    ["king_fish"] = "Epic",
    ["walley_fish"] = "Uncommon",
    ["albino_catfish"] = "Rare",
    ["yellow_watchman"] = "Mythical",
    ["bubble_fish"] = "Legendary",
    ["rainbow_fish"] = "Mythical",
    ["garnetfish"] = "Epic",
    ["amethyststream"] = "Epic",
    ["aquaripple"] = "Epic",
    ["diamondblink"] = "Epic",
    ["emeraldfin"] = "Epic",
    ["pearlglow"] = "Epic",
    ["rubyflame"] = "Epic",
    ["peridotglimmer"] = "Epic",
    ["sapphirine"] = "Epic",
    ["opalflare"] = "Epic",
    ["topazflare"] = "Epic",
    ["turquoisewave"] = "Epic",
    ["LouYu"] = "Rare",
    ["Obsidianfin"] = "Rare",
    ["solidGoldFish"] = "Rare",
    ["solidSilverFish"] = "Rare",
    ["tounniFish"] = "Rare",
    ["bubbleGumFish"] = "Legendary",
    ["DreamweaverBeta"] = "Legendary",
    ["crystalJellyFish"] = "Mythical",
    --coral
    ["amberlure"] = "Rare",
    ["ashflare"] = "Epic",
    ["azuregill"] = "Epic",
    ["blazefin"] = "Legendary",
    ["charavine"] = "Epic",
    ["crownscale"] = "Epic",
    ["duskmire"] = "Rare",
    ["embercreel"] = "Rare",
    ["flutterfin"] = "Rare",
    ["gloomgill"] = "Rare",
    ["jellyspawn"] = "Legendary",
    ["mandaglimmer"] = "Legendary",
    ["moltenfin"] = "Mythical",
    ["nightdarter"] = "Legendary",
    ["oarpike"] = "Rare",
    ["puffreef"] = "Epic",
    ["reefwarden"] = "Rare",
    ["regalfin"] = "Mythical",
    ["skypiercer"] = "Rare",
    ["spinebloom"] = "Rare",
    ["stellafin"] = "Rare",
    ["bettraquon"] = "Epic",
    --winter
    ["brineleaf"] = "Mythical",
    ["crescentide"] = "Legendary",
    ["crystalfade"] = "Epic",
    ["deepgloom"] = "Rare",
    ["dusktide"] = "Epic",
    ["frothling"] = "Rare",
    ["frostchar"] = "Mythical",
    ["frostqueen"] = "Rare",
    ["frostscale"] = "Rare",
    ["glimmerscale"] = "Rare",
    ["glacierrun"] = "Rare",
    ["lunawing"] = "Rare",
    ["moonspine"] = "Epic",
    ["mythicrest"] = "Mythical",
    ["rimefang"] = "Rare",
    ["shiverfin"] = "Legendary",
    ["silvertang"] = "Epic",
    ["snowidol"] = "Epic",
    ["tundrawave"] = "Legendary",
    ["whispergill"] = "Rare",
    --jungle
    ["tigerrush"] = "Rare",
    ["leafshade"] = "Rare",
    ["piranthrax"] = "Rare",
    ["goldripple"] = "Rare",
    ["shadowdrake"] = "Legendary",
    ["drakefly"] = "Rare",
    ["voltcat"] = "Legendary",
    ["gleameel"] = "Rare",
    ["gratch"] = "Legendary",
    ["jadeflare"] = "Mythical",
    ["glowbelly"] = "Rare",
    ["mystiglow"] = "Mythical",
    ["nightmoth"] = "Rare",
    ["runecarp"] = "Epic",
    ["duneskimmer"] = "Rare",
    ["shovelclaw"] = "Epic",
    ["silkspinner"] = "Rare",
    ["stormpulse"] = "Epic",
    ["stripeflash"] = "Epic",
    ["zebris"] = "Rare",
    --cliffs
    ["glacierglow"] = "Epic",
    ["axolume"] = "Rare",
    ["blueflare"] = "Epic",
    ["cratefin"] = "Rare",
    ["mistwhirl"] = "Mythical",
    ["dragonscale"] = "Rare",
    ["somnifin"] = "Legendary",
    ["faeglimmer"] = "Epic",
    ["windsprite"] = "Legendary",
    ["ballfin"] = "Rare",
    ["goldwyrm"] = "Mythical",
    ["skyrider"] = "Rare",
    ["plumecrest"] = "Epic",
    ["beakcoil"] = "Rare",
    ["flareborn"] = "Legendary",
    ["glowcrest"] = "Legendary",
    ["spectralfin"] = "Rare",
    ["speckledray"] = "Rare",
    ["stellaroi"] = "Rare",
    ["striatus"] = "Rare",
    --tropical
    ["sunburstfish"] = "Legendary",
    ["mudfin"] = "Rare",
    ["clearcap"] = "Epic",
    ["gulpfin"] = "Epic",
    ["tangaclaw"] = "Epic",
    ["neonflare"] = "Rare",
    ["shadefin"] = "Epic",
    ["rainbowbeak"] = "Legendary",
    ["peaflare"] = "Rare",
    ["streamglow"] = "Mythical",
    ["reefshadow"] = "Epic",
    ["stoneblenny"] = "Rare",
    ["rustbarb"] = "Rare",
    ["koisamurai"] = "Mythical",
    ["shellback"] = "Rare",
    ["stardustfin"] = "Rare",
    ["dawnsnapper"] = "Rare",
    ["dusksnapper"] = "Rare",
    ["venomfang"] = "Legendary",
    ["voidwing"] = "Rare",

}

local FishWorth = {
    ["black_crappie"] = 20,
    ["yellow_perch"] = 15,
    ["blue_gill"] = 20,
    ["pumpkinseed"] = 15,
    ["boot_fish"] = 0,
    ["can_fish"] = 0,
    ["long_mouth_bass"] = 15,
    ["salmon"] = 15,
    ["crystal_fairy_fish"] = 200,
    ["dragon_fish"] = 2500,
    ["unicorn_fish"] = 2000,
    ["anchovi_fish"] = 15,
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
    ["catfish"] = 25,
    ["chum_salmon_fish"] = 30,
    ["clown_fish"] = 20,
    ["coho_salmon_fish"] = 15,
    ["common_carp_fish"] = 20,
    ["crab"] = 10,
    ["dolphin"] = 100,
    ["rasta_drum_fish"] = 100,
    ["dumbo_octopus"] = 30,
    ["electric_eel"] = 20,
    ["flounder_fish"] = 15,
    ["tourist_fish"] = 150,
    ["gold_fish"] = 50,
    ["goliath_tiger_fish"] = 15,
    ["jelly_fish"] = 100,
    ["jogger_fish"] = 15,
    ["killer_whale"] = 100,
    ["king_catfish"] = 150,
    ["king_mackerel"] = 100,
    ["king_salmon"] = 100,
    ["king_seahorse"] = 100,
    ["koi_fish_samurai"] = 1500,
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
    ["pearl_perch_fish"] = 15,
    ["peasant_fish"] = 1100,
    ["pink_salmon"] = 20,
    ["piranha"] = 150,
    ["red_snapper_fish"] = 30,
    ["rock_bass_fish"] = 15,
    ["royal_lake_fish"] = 100,
    ["salt_trader_fish"] = 500,
    ["saw_fish"] = 30,
    ["seahorse"] = 30,
    ["servant_fish"] = 15,
    ["small_common_trout"] = 15,
    ["rainbow_trout"] = 30,
    ["spotted_bass_fish"] = 15,
    ["squid"] = 100,
    ["squirrel_fish"] = 30,
    ["star_fish"] = 500,
    ["sting_ray"] = 30,
    ["sun_fish"] = 20,
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
    ["bubble_fish"] = 250,
    ["rainbow_fish"] = 800,

    -- Crystal biome fish
    ["garnetfish"] = 150,
    ["amethyststream"] = 150,
    ["aquaripple"] = 150,
    ["diamondblink"] = 150,
    ["emeraldfin"] = 150,
    ["pearlglow"] = 150,
    ["rubyflame"] = 150,
    ["peridotglimmer"] = 150,
    ["sapphirine"] = 150,
    ["opalflare"] = 150,
    ["topazflare"] = 150,
    ["turquoisewave"] = 150,

    ["LouYu"] = 50,
    ["Obsidianfin"] = 50,
    ["solidGoldFish"] = 50,
    ["solidSilverFish"] = 50,
    ["tounniFish"] = 50,
    ["bubbleGumFish"] = 125,
    ["DreamweaverBeta"] = 150,
    ["crystalJellyFish"] = 1000,

    --coral
    ["amberlure"] = 30,
    ["ashflare"] = 80,
    ["azuregill"] = 80,
    ["blazefin"] = 150,
    ["charavine"] = 80,
    ["crownscale"] = 80,
    ["duskmire"] = 30,
    ["embercreel"] = 30,
    ["flutterfin"] = 30,
    ["gloomgill"] = 30,
    ["jellyspawn"] = 150,
    ["mandaglimmer"] = 150,
    ["moltenfin"] = 500,
    ["nightdarter"] = 150,
    ["oarpike"] = 30,
    ["puffreef"] = 80,
    ["reefwarden"] = 30,
    ["regalfin"] = 500,
    ["skypiercer"] = 30,
    ["spinebloom"] = 30,
    ["stellafin"] = 30,
    ["bettraquon"] = 80,

    --winter
    ["brineleaf"] = 510,      -- Mythical
    ["crescentide"] = 150,    -- Legendary
    ["crystalfade"] = 80,     -- Epic
    ["deepgloom"] = 30,       -- Rare
    ["dusktide"] = 90,        -- Epic
    ["frothling"] = 40,       -- Rare
    ["frostchar"] = 500,      -- Mythical
    ["frostqueen"] = 20,      -- Rare
    ["frostscale"] = 30,      -- Rare
    ["glimmerscale"] = 40,    -- Rare
    ["glacierrun"] = 20,      -- Rare
    ["lunawing"] = 30,        -- Rare
    ["moonspine"] = 70,       -- Epic
    ["mythicrest"] = 490,     -- Mythical
    ["rimefang"] = 30,        -- Rare
    ["shiverfin"] = 160,      -- Legendary
    ["silvertang"] = 80,      -- Epic
    ["snowidol"] = 90,        -- Epic
    ["tundrawave"] = 140,     -- Legendary
    ["whispergill"] = 30,     -- Rare

    --jungle
    ["tigerrush"] = 30,      -- Rare
    ["leafshade"] = 30,      -- Rare
    ["piranthrax"] = 30,     -- Rare
    ["goldripple"] = 30,     -- Rare
    ["shadowdrake"] = 150,   -- Legendary
    ["drakefly"] = 30,       -- Rare
    ["voltcat"] = 150,       -- Legendary
    ["gleameel"] = 30,       -- Rare
    ["gratch"] = 150,        -- Legendary
    ["jadeflare"] = 500,     -- Mythical
    ["glowbelly"] = 30,      -- Rare
    ["mystiglow"] = 500,     -- Mythical
    ["nightmoth"] = 30,      -- Rare
    ["runecarp"] = 80,       -- Epic
    ["duneskimmer"] = 30,    -- Rare
    ["shovelclaw"] = 80,     -- Epic
    ["silkspinner"] = 30,    -- Rare
    ["stormpulse"] = 80,     -- Epic
    ["stripeflash"] = 80,    -- Epic
    ["zebris"] = 30,         -- Rare

    --cliff
    ["axolume"] = 30,          -- Rare
    ["ballfin"] = 30,          -- Rare
    ["beakcoil"] = 30,         -- Rare
    ["blueflare"] = 80,        -- Epic
    ["cratefin"] = 30,         -- Rare
    ["dragonscale"] = 30,      -- Rare
    ["faeglimmer"] = 80,       -- Epic
    ["flareborn"] = 150,       -- Legendary
    ["glacierglow"] = 80,      -- Epic
    ["glowcrest"] = 150,       -- Legendary
    ["goldwyrm"] = 500,        -- Mythical
    ["mistwhirl"] = 500,       -- Mythical
    ["plumecrest"] = 80,       -- Epic
    ["skyrider"] = 30,         -- Rare
    ["somnifin"] = 150,        -- Legendary
    ["spectralfin"] = 30,      -- Rare
    ["speckledray"] = 30,      -- Rare
    ["stellaroi"] = 30,        -- Rare
    ["striatus"] = 30,         -- Rare
    ["windsprite"] = 150,      -- Legendary

    --tropical
    ["sunburstfish"] = 150,      -- Legendary
    ["mudfin"] = 30,          -- Rare
    ["clearcap"] = 80,        -- Epic
    ["gulpfin"] = 80,         -- Epic
    ["tangaclaw"] = 80,       -- Epic
    ["neonflare"] = 30,       -- Rare
    ["shadefin"] = 80,        -- Epic
    ["rainbowbeak"] = 150,    -- Legendary
    ["peaflare"] = 30,        -- Rare
    ["streamglow"] = 500,     -- Mythical
    ["reefshadow"] = 80,      -- Epic
    ["stoneblenny"] = 30,     -- Rare
    ["rustbarb"] = 30,        -- Rare
    ["koisamurai"] = 500,     -- Mythical
    ["shellback"] = 30,       -- Rare
    ["stardustfin"] = 30,     -- Rare
    ["dawnsnapper"] = 30,     -- Rare
    ["dusksnapper"] = 30,     -- Rare
    ["venomfang"] = 150,      -- Legendary
    ["voidwing"] = 30,        -- Rare

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
    ["bubble_fish"] = "A whimsical fish that blows bubbles and spreads joy wherever it swims!",
    ["rainbow_fish"] = "A vibrant and colorful fish that brings a splash of joy to the ocean!",
    ["garnetfish"] = "Garnetfish",
    ["amethyststream"] = "Amethyststream",
    ["aquaripple"] = "Aquaripple",
    ["diamondblink"] = "Diamondblink",
    ["emeraldfin"] = "Emeraldfin",
    ["pearlglow"] = "Pearlglow",
    ["rubyflame"] = "Rubyflame",
    ["peridotglimmer"] = "Peridotglimmer",
    ["sapphirine"] = "Sapphirine",
    ["opalflare"] = "Opalflare",
    ["topazflare"] = "Topazflare",
    ["turquoisewave"] = "Turquoisewave",
    ["garnetfish"] = "Radiating a fiery red glow, the Garnetfish blazes through crystal waters like a living ember!",
    ["amethyststream"] = "A mystical swimmer with sparkling purple scales, the Amethyststream glides like a dream!",
    ["aquaripple"] = "Dancing through the currents, the Aquaripple leaves behind waves of serene shimmer!",
    ["diamondblink"] = "With dazzling flashes like lightning in the depths, the Diamondblink is the deep’s precious flicker!",
    ["emeraldfin"] = "This vibrant green beauty swims with elegant sways, painting the water with nature’s glow!",
    ["pearlglow"] = "Soft and radiant, the Pearlglow illuminates the dark with its moonlight shimmer!",
    ["rubyflame"] = "Bold and brilliant, the Rubyflame streaks through the crystal caverns like a comet of passion!",
    ["peridotglimmer"] = "The Peridotglimmer sparkles with earthy charm, a rare gem among aquatic royalty!",
    ["sapphirine"] = "Cool as the twilight sky, the Sapphirine brings calm and beauty to every crystalline ripple!",
    ["opalflare"] = "Flashing every color in the spectrum, the Opalflare is a living firework beneath the waves!",
    ["topazflare"] = "Golden and proud, the Topazflare swims like the sun itself dipped beneath the surface!",
    ["turquoisewave"] = "A tranquil tide in fish form, the Turquoisewave flows like a gemstone caught in motion!",
    ["LouYu"] = "A mysterious fish with ancient scales etched in forgotten symbols.",
    ["Obsidianfin"] = "This sleek fish glimmers with volcanic glass armor.",
    ["solidGoldFish"] = "A majestic creature made entirely of gleaming gold.",
    ["solidSilverFish"] = "Shimmering like moonlight, it glides silently through the water.",
    ["tounniFish"] = "Wrapped in vibrant silks, this fish is elegance in motion.",
    ["bubbleGumFish"] = "Bright, stretchy, and sweet-smelling—like a sugary puff underwater!",
    ["DreamweaverBeta"] = "Glides like a dream, leaving traces of iridescent mist.",
    ["crystalJellyFish"] = "A radiant jellyfish made of refracting crystal light.",
    -- coral
    ["amberlure"] = "A glowing fish known to attract others with its radiant amber shimmer.",
    ["ashflare"] = "A fiery swimmer that thrives near volcanic vents and glows like embers.",
    ["azuregill"] = "This sleek fish darts through tropical currents with vibrant blue fins.",
    ["blazefin"] = "Its blazing trail leaves scorch marks in the water — a rare sight to behold.",
    ["charavine"] = "Delicate and elegant, this fish weaves through coral like a vine.",
    ["crownscale"] = "A noble creature with regal scales that shimmer like a jeweled crown.",
    ["duskmire"] = "Dark and elusive, it drifts in the shadows of deep trenches.",
    ["embercreel"] = "A warm-toned fish often seen in glowing reefs during twilight.",
    ["flutterfin"] = "Its fins move like wings, gently pulsing through still waters.",
    ["gloomgill"] = "A melancholy dweller of underwater caves, nearly invisible in the dark.",
    ["jellyspawn"] = "A bizarre hybrid of jellyfish and fish, glowing with bioluminescence.",
    ["mandaglimmer"] = "A radiant, tranquil fish with colors that shift like silk in moonlight.",
    ["moltenfin"] = "Forged by magma flows, this legendary fish swims through molten tides.",
    ["nightdarter"] = "Fast and silent, it moves like a shadow, seen only by starlight.",
    ["oarpike"] = "An ancient species with paddle-like fins and a piercing gaze.",
    ["puffreef"] = "A buoyant, reef-dwelling fish that inflates when threatened.",
    ["reefwarden"] = "Guardian of the coral forests, rarely straying from its territory.",
    ["regalfin"] = "Graceful and powerful, said to bring fortune to those who catch a glimpse.",
    ["skypiercer"] = "A fast swimmer known to leap above waves, slicing through air and sea.",
    ["spinebloom"] = "Beautiful but dangerous, its barbed fins can sting like a thorn.",
    ["stellafin"] = "Dotted like the stars, it glows faintly in deep ocean midnight.",
    ["bettraquon"] = "An exotic and spirited fighter fish, shimmering with layered hues.",
    --winter
    ["brineleaf"] = "A rare seadragon adorned with icy fronds that drift like kelp in Arctic currents.",
    ["crescentide"] = "Glows faintly beneath the moon, its shape cutting soft arcs through snowy waters.",
    ["crystalfade"] = "Shimmers like frost on glass, vanishing in flashes as it darts through icy reefs.",
    ["deepgloom"] = "Lurks in frozen depths where no light reaches — a true shadow of the abyss.",
    ["dusktide"] = "Its violet glow pulses like twilight beneath frost-covered waves.",
    ["frothling"] = "A bubbly, playful fish that rides the crests of stormy northern seas.",
    ["frostchar"] = "A hardened survivor of glacial lakes, marked by silver stripes and cold resolve.",
    ["frostqueen"] = "Elegant and commanding, with fins that fan like a royal winter cloak.",
    ["frostscale"] = "Covered in tiny frost-like scales, it thrives where ice meets open water.",
    ["glimmerscale"] = "Its pearly body glints like snow under a full moon.",
    ["glacierrun"] = "Swift and strong, this fish cuts upstream through frigid meltwater streams.",
    ["lunawing"] = "Graceful and haunting, it circles beneath moonlit ice sheets.",
    ["moonspine"] = "Lined with glowing fins, it appears only on the coldest, clearest nights.",
    ["mythicrest"] = "Said to be a guardian spirit of frozen seas, rarely seen, never caught.",
    ["rimefang"] = "A fierce predator with jagged, ice-crusted teeth and unmatched speed.",
    ["shiverfin"] = "Trembles as it moves, disturbing water like ripples in a snowdrift.",
    ["silvertang"] = "Its polished scales reflect starlight like polished frost.",
    ["snowidol"] = "Regal and revered, this fish is thought to bring good fortune in deep winter.",
    ["tundrawave"] = "Surges with icy power, crashing like winter surf through frozen coves.",
    ["whispergill"] = "Its presence is known only by a shimmer — silent and spectral beneath the ice.",
    --jungle
    ["tigerrush"] = "A fierce predator with bold stripes that rule the jungle rivers.",
    ["leafshade"] = "A stealthy fish camouflaged perfectly among drifting jungle leaves.",
    ["piranthrax"] = "A small but vicious carnivore known for its razor-sharp teeth.",
    ["goldripple"] = "A shimmering beauty with golden scales that catch the sunlight.",
    ["shadowdrake"] = "A mysterious dragon-like fish that lurks in the jungle’s darkest pools.",
    ["drakefly"] = "A nimble swimmer, flitting like a dragonfly over jungle streams.",
    ["voltcat"] = "Electrifying predator, it shocks prey with a powerful jolt.",
    ["gleameel"] = "A translucent eel that glimmers softly in shadowed waters.",
    ["gratch"] = "A hardy native with a tough exterior and quick reflexes.",
    ["jadeflare"] = "Radiates a magical jade glow, illuminating murky jungle waters.",
    ["glowbelly"] = "Its belly glows faintly, guiding its way through dense aquatic foliage.",
    ["mystiglow"] = "Enigmatic fish said to harness ancient jungle magic in its glow.",
    ["nightmoth"] = "Flutters silently beneath the water’s surface like a nocturnal moth.",
    ["runecarp"] = "Ancient markings cover its scales, believed to bring fortune.",
    ["duneskimmer"] = "Skims swiftly over sandy jungle riverbeds with unmatched grace.",
    ["shovelclaw"] = "Powerful catfish with broad claws for digging and defense.",
    ["silkspinner"] = "Spins delicate webs of silk-like threads to catch prey.",
    ["stormpulse"] = "Pulses with energy, stirring the jungle waters during storms.",
    ["stripeflash"] = "Quick and colorful, flashing stripes confuse its foes.",
    ["zebris"] = "Small but vibrant, it zigzags through underwater jungle grasses.",
    --cliff
    ["axolume"] = "A glowing amphibian with mysterious powers.",
    ["ballfin"] = "Compact and sturdy, built for rocky streams.",
    ["beakcoil"] = "Eel with a sharp, pelican-like beak.",
    ["blueflare"] = "Bright blue scales that shimmer in sunlight.",
    ["cratefin"] = "Box-shaped fish with a tough exterior.",
    ["dragonscale"] = "Dragon-like scales protect this fierce fish.",
    ["faeglimmer"] = "Delicate fish that sparkles with magic.",
    ["flareborn"] = "Born from fire, it lights up dark waters.",
    ["glacierglow"] = "Radiates a cold, icy blue glow.",
    ["glowcrest"] = "Shines bright atop rocky cliffs.",
    ["goldwyrm"] = "Legendary fish with golden scales.",
    ["mistwhirl"] = "Swims through fog with ghostly grace.",
    ["plumecrest"] = "Vibrant fins like a peacock's plume.",
    ["skyrider"] = "Soars through water like a hawk in air.",
    ["somnifin"] = "Dreamy fish that lulls prey to sleep.",
    ["spectralfin"] = "Elusive fish with a ghostly glow.",
    ["speckledray"] = "Spotted pattern helps it hide in rocks.",
    ["stellaroi"] = "Koi with star-like patterns on its scales.",
    ["striatus"] = "Striped bass that darts swiftly.",
    ["windsprite"] = "Swift and light, it dances on currents.",
    --tropical
    ["sunburstfish"] = "A bright fish that shines like a tropical sunrise.",
    ["mudfin"] = "A sturdy bottom dweller with a muddy hue.",
    ["clearcap"] = "A translucent fish with a crystal-clear head.",
    ["gulpfin"] = "Deep-water eel with a huge mouth for swallowing prey.",
    ["tangaclaw"] = "A fierce cichlid with sharp claws from Lake Tanganyika.",
    ["neonflare"] = "Small and vibrant, glowing with neon colors.",
    ["shadefin"] = "A dark, elusive fish that lurks in shadowy reefs.",
    ["rainbowbeak"] = "Colorful parrotfish with a sharp, curved beak.",
    ["peaflare"] = "A flashy anthias with vibrant, peacock-like fins.",
    ["streamglow"] = "A mystical fish that glows softly in fast streams.",
    ["reefshadow"] = "An octopus-like fish blending into coral shadows.",
    ["stoneblenny"] = "A tiny fish camouflaged among rocky pools.",
    ["rustbarb"] = "A rusty-colored barb fish with a fierce attitude.",
    ["koisamurai"] = "A noble koi known for its fierce spirit.",
    ["shellback"] = "A snailfish with a sturdy shell-like back.",
    ["stardustfin"] = "A carp glittering with specks of stardust.",
    ["dawnsnapper"] = "A snapper that appears at sunrise, vibrant and bright.",
    ["dusksnapper"] = "A snapper that prowls the reefs at dusk.",
    ["venomfang"] = "A venomous fish with sharp fangs and swift strikes.",
    ["voidwing"] = "A manta that glides silently through deep, dark waters.",

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
    ["bubble_fish"] = {min = 5, max = 10},
    ["rainbow_fish"] = {min = 10, max = 30},
    ["garnetfish"] = {min = 10, max = 20},
    ["amethyststream"] = {min = 8, max = 18},
    ["aquaripple"] = {min = 7, max = 17},
    ["diamondblink"] = {min = 9, max = 19},
    ["emeraldfin"] = {min = 10, max = 20},
    ["pearlglow"] = {min = 6, max = 15},
    ["rubyflame"] = {min = 10, max = 20},
    ["peridotglimmer"] = {min = 8, max = 16},
    ["sapphirine"] = {min = 9, max = 18},
    ["opalflare"] = {min = 10, max = 20},
    ["topazflare"] = {min = 9, max = 19},
    ["turquoisewave"] = {min = 8, max = 17},
    ["LouYu"] = {min = 10, max = 20},
    ["Obsidianfin"] = {min = 10, max = 20},
    ["solidGoldFish"] = {min = 10, max = 20},
    ["solidSilverFish"] = {min = 10, max = 20},
    ["tounniFish"] = {min = 10, max = 20},
    ["bubbleGumFish"] = {min = 10, max = 20},
    ["DreamweaverBeta"] = {min = 10, max = 20},
    ["crystalJellyFish"] = {min = 10, max = 20},
    --coral
    ["amberlure"] = {min = 5, max = 15},
    ["ashflare"] = {min = 12, max = 22},
    ["azuregill"] = {min = 10, max = 18},
    ["blazefin"] = {min = 20, max = 35},
    ["charavine"] = {min = 8, max = 16},
    ["crownscale"] = {min = 14, max = 25},
    ["duskmire"] = {min = 6, max = 14},
    ["embercreel"] = {min = 7, max = 15},
    ["flutterfin"] = {min = 5, max = 13},
    ["gloomgill"] = {min = 6, max = 12},
    ["jellyspawn"] = {min = 15, max = 30},
    ["mandaglimmer"] = {min = 18, max = 28},
    ["moltenfin"] = {min = 25, max = 40},
    ["nightdarter"] = {min = 16, max = 30},
    ["oarpike"] = {min = 12, max = 20},
    ["puffreef"] = {min = 10, max = 18},
    ["reefwarden"] = {min = 9, max = 17},
    ["regalfin"] = {min = 22, max = 35},
    ["skypiercer"] = {min = 11, max = 21},
    ["spinebloom"] = {min = 8, max = 14},
    ["stellafin"] = {min = 9, max = 16},
    ["bettraquon"] = {min = 10, max = 18},
    --winter
    ["brineleaf"] = {min = 25, max = 40},       -- Mythical
    ["crescentide"] = {min = 18, max = 30},     -- Legendary
    ["crystalfade"] = {min = 12, max = 20},     -- Epic
    ["deepgloom"] = {min = 10, max = 18},       -- Rare
    ["dusktide"] = {min = 14, max = 22},        -- Epic
    ["frothling"] = {min = 6, max = 12},        -- Rare
    ["frostchar"] = {min = 28, max = 42},       -- Mythical
    ["frostqueen"] = {min = 10, max = 18},      -- Rare
    ["frostscale"] = {min = 8, max = 16},       -- Rare
    ["glimmerscale"] = {min = 9, max = 17},     -- Rare
    ["glacierrun"] = {min = 14, max = 22},      -- Rare
    ["lunawing"] = {min = 12, max = 20},        -- Rare
    ["moonspine"] = {min = 15, max = 25},       -- Epic
    ["mythicrest"] = {min = 30, max = 45},      -- Mythical
    ["rimefang"] = {min = 16, max = 28},        -- Rare
    ["shiverfin"] = {min = 20, max = 32},       -- Legendary
    ["silvertang"] = {min = 14, max = 24},      -- Epic
    ["snowidol"] = {min = 13, max = 22},        -- Epic
    ["tundrawave"] = {min = 22, max = 34},      -- Legendary
    ["whispergill"] = {min = 10, max = 18},     -- Rare
    --jungle
    ["tigerrush"] = {min = 20, max = 35},      -- Legendary
    ["leafshade"] = {min = 10, max = 18},      -- Rare
    ["piranthrax"] = {min = 8, max = 14},      -- Rare
    ["goldripple"] = {min = 12, max = 20},     -- Rare
    ["shadowdrake"] = {min = 25, max = 40},    -- Legendary
    ["drakefly"] = {min = 14, max = 22},       -- Rare
    ["voltcat"] = {min = 22, max = 35},        -- Legendary
    ["gleameel"] = {min = 15, max = 28},       -- Rare
    ["gratch"] = {min = 18, max = 30},          -- Legendary
    ["jadeflare"] = {min = 25, max = 38},      -- Mythical
    ["glowbelly"] = {min = 12, max = 20},      -- Rare
    ["mystiglow"] = {min = 28, max = 42},      -- Mythical
    ["nightmoth"] = {min = 10, max = 18},      -- Rare
    ["runecarp"] = {min = 16, max = 28},       -- Epic
    ["duneskimmer"] = {min = 10, max = 18},    -- Rare
    ["shovelclaw"] = {min = 20, max = 32},     -- Epic
    ["silkspinner"] = {min = 9, max = 16},     -- Rare
    ["stormpulse"] = {min = 18, max = 30},     -- Epic
    ["stripeflash"] = {min = 12, max = 22},    -- Epic
    ["zebris"] = {min = 8, max = 14},           -- Rare
    --cliff
    ["axolume"] = {min = 10, max = 18},
    ["ballfin"] = {min = 12, max = 20},
    ["beakcoil"] = {min = 15, max = 25},
    ["blueflare"] = {min = 14, max = 24},
    ["cratefin"] = {min = 10, max = 18},
    ["dragonscale"] = {min = 20, max = 35},
    ["faeglimmer"] = {min = 12, max = 22},
    ["flareborn"] = {min = 25, max = 40},
    ["glacierglow"] = {min = 18, max = 30},
    ["glowcrest"] = {min = 22, max = 34},
    ["goldwyrm"] = {min = 28, max = 45},
    ["mistwhirl"] = {min = 30, max = 48},
    ["plumecrest"] = {min = 14, max = 26},
    ["skyrider"] = {min = 16, max = 28},
    ["somnifin"] = {min = 20, max = 34},
    ["spectralfin"] = {min = 10, max = 18},
    ["speckledray"] = {min = 12, max = 22},
    ["stellaroi"] = {min = 14, max = 24},
    ["striatus"] = {min = 18, max = 30},
    ["windsprite"] = {min = 22, max = 36},
    --tropical
    ["sunburstfish"] = {min = 20, max = 35},
    ["mudfin"] = {min = 15, max = 25},
    ["clearcap"] = {min = 10, max = 18},
    ["gulpfin"] = {min = 18, max = 30},
    ["tangaclaw"] = {min = 12, max = 22},
    ["neonflare"] = {min = 6, max = 12},
    ["shadefin"] = {min = 14, max = 24},
    ["rainbowbeak"] = {min = 15, max = 28},
    ["peaflare"] = {min = 8, max = 15},
    ["streamglow"] = {min = 22, max = 36},
    ["reefshadow"] = {min = 16, max = 26},
    ["stoneblenny"] = {min = 7, max = 13},
    ["rustbarb"] = {min = 12, max = 20},
    ["koisamurai"] = {min = 25, max = 40},
    ["shellback"] = {min = 10, max = 18},
    ["stardustfin"] = {min = 15, max = 25},
    ["dawnsnapper"] = {min = 16, max = 26},
    ["dusksnapper"] = {min = 16, max = 26},
    ["venomfang"] = {min = 18, max = 30},
    ["voidwing"] = {min = 25, max = 40},

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
    ["bubble_fish"] = "Blows bubbles that can distract other fish.",
    ["rainbow_fish"] = "A vibrant fish that brings a splash of joy to the ocean.",
    ["garnetfish"] = "Hard to catch, glows faintly in deep waters.",
    ["amethyststream"] = "Rare spawn, boosts lure attraction for a short time.",
    ["aquaripple"] = "Quick and agile, leaves a shimmer trail.",
    ["diamondblink"] = "Hard to find, gives luck bonus.",
    ["emeraldfin"] = "Quick and agile, blends with crystal kelp.",
    ["pearlglow"] = "Rare spawn, glows softly to light up nearby fish.",
    ["rubyflame"] = "Emits short bursts of light, hard to catch.",
    ["peridotglimmer"] = "Hard to catch, attracts nearby small fish.",
    ["sapphirine"] = "Rare spawn, increases nearby fish spawn chance temporarily.",
    ["opalflare"] = "Hard to find, gives luck bonus.",
    ["topazflare"] = "Rare spawn, glows brighter during daytime.",
    ["turquoisewave"] = "Quick and agile, sometimes stuns small prey fish.",
    ["LouYu"] = "A mysterious fish with ancient scales etched in forgotten symbols.",
    ["Obsidianfin"] = "Tough scales make it difficult to catch.",
    ["solidGoldFish"] = "Rare spawn, shines bright when hooked.",
    ["solidSilverFish"] = "Slippery and fast, but worth the chase.",
    ["tounniFish"] = "Quick and agile, dances near bait.",
    ["bubbleGumFish"] = "Can inflate and bounce off hooks.",
    ["DreamweaverBeta"] = "Leaves a glowing trail.",
    ["crystalJellyFish"] = "Rarest jelly fish in the sea!",
    --coral
    ["amberlure"] = "A glowing fish known to attract others with its radiant amber shimmer.",
    ["ashflare"] = "A fiery swimmer that thrives near volcanic vents and glows like embers.",
    ["azuregill"] = "This sleek fish darts through tropical currents with vibrant blue fins.",
    ["blazefin"] = "Its blazing trail leaves scorch marks in the water — a rare sight to behold.",
    ["charavine"] = "Delicate and elegant, this fish weaves through coral like a vine.",
    ["crownscale"] = "A noble creature with regal scales that shimmer like a jeweled crown.",
    ["duskmire"] = "Dark and elusive, it drifts in the shadows of deep trenches.",
    ["embercreel"] = "A warm-toned fish often seen in glowing reefs during twilight.",
    ["flutterfin"] = "Its fins move like wings, gently pulsing through still waters.",
    ["gloomgill"] = "A melancholy dweller of underwater caves, nearly invisible in the dark.",
    ["jellyspawn"] = "A bizarre hybrid of jellyfish and fish, glowing with bioluminescence.",
    ["mandaglimmer"] = "A radiant, tranquil fish with colors that shift like silk in moonlight.",
    ["moltenfin"] = "Forged by magma flows, this legendary fish swims through molten tides.",
    ["nightdarter"] = "Fast and silent, it moves like a shadow, seen only by starlight.",
    ["oarpike"] = "An ancient species with paddle-like fins and a piercing gaze.",
    ["puffreef"] = "A buoyant, reef-dwelling fish that inflates when threatened.",
    ["reefwarden"] = "Guardian of the coral forests, rarely straying from its territory.",
    ["regalfin"] = "Graceful and powerful, said to bring fortune to those who catch a glimpse.",
    ["skypiercer"] = "A fast swimmer known to leap above waves, slicing through air and sea.",
    ["spinebloom"] = "Beautiful but dangerous, its barbed fins can sting like a thorn.",
    ["stellafin"] = "Dotted like the stars, it glows faintly in deep ocean midnight.",
    ["bettraquon"] = "An exotic and spirited fighter fish, shimmering with layered hues.",
    --winter
    ["brineleaf"] = "A rare seadragon adorned with icy fronds that drift like kelp in Arctic currents.",
    ["crescentide"] = "Glows faintly beneath the moon, its shape cutting soft arcs through snowy waters.",
    ["crystalfade"] = "Shimmers like frost on glass, vanishing in flashes as it darts through icy reefs.",
    ["deepgloom"] = "Lurks in frozen depths where no light reaches — a true shadow of the abyss.",
    ["dusktide"] = "Its violet glow pulses like twilight beneath frost-covered waves.",
    ["frothling"] = "A bubbly, playful fish that rides the crests of stormy northern seas.",
    ["frostchar"] = "A hardened survivor of glacial lakes, marked by silver stripes and cold resolve.",
    ["frostqueen"] = "Elegant and commanding, with fins that fan like a royal winter cloak.",
    ["frostscale"] = "Covered in tiny frost-like scales, it thrives where ice meets open water.",
    ["glimmerscale"] = "Its pearly body glints like snow under a full moon.",
    ["glacierrun"] = "Swift and strong, this fish cuts upstream through frigid meltwater streams.",
    ["lunawing"] = "Graceful and haunting, it circles beneath moonlit ice sheets.",
    ["moonspine"] = "Lined with glowing fins, it appears only on the coldest, clearest nights.",
    ["mythicrest"] = "Said to be a guardian spirit of frozen seas, rarely seen, never caught.",
    ["rimefang"] = "A fierce predator with jagged, ice-crusted teeth and unmatched speed.",
    ["shiverfin"] = "Trembles as it moves, disturbing water like ripples in a snowdrift.",
    ["silvertang"] = "Its polished scales reflect starlight like polished frost.",
    ["snowidol"] = "Regal and revered, this fish is thought to bring good fortune in deep winter.",
    ["tundrawave"] = "Surges with icy power, crashing like winter surf through frozen coves.",
    ["whispergill"] = "Its presence is known only by a shimmer — silent and spectral beneath the ice.",
    --jungle
    ["tigerrush"] = "A fierce predator with bold stripes that rule the jungle rivers.",
    ["leafshade"] = "A stealthy fish camouflaged perfectly among drifting jungle leaves.",
    ["piranthrax"] = "A small but vicious carnivore known for its razor-sharp teeth.",
    ["goldripple"] = "A shimmering beauty with golden scales that catch the sunlight.",
    ["shadowdrake"] = "A mysterious dragon-like fish that lurks in the jungle’s darkest pools.",
    ["drakefly"] = "A nimble swimmer, flitting like a dragonfly over jungle streams.",
    ["voltcat"] = "Electrifying predator, it shocks prey with a powerful jolt.",
    ["gleameel"] = "A translucent eel that glimmers softly in shadowed waters.",
    ["gratch"] = "A hardy native with a tough exterior and quick reflexes.",
    ["jadeflare"] = "Radiates a magical jade glow, illuminating murky jungle waters.",
    ["glowbelly"] = "Its belly glows faintly, guiding its way through dense aquatic foliage.",
    ["mystiglow"] = "Enigmatic fish said to harness ancient jungle magic in its glow.",
    ["nightmoth"] = "Flutters silently beneath the water’s surface like a nocturnal moth.",
    ["runecarp"] = "Ancient markings cover its scales, believed to bring fortune.",
    ["duneskimmer"] = "Skims swiftly over sandy jungle riverbeds with unmatched grace.",
    ["shovelclaw"] = "Powerful catfish with broad claws for digging and defense.",
    ["silkspinner"] = "Spins delicate webs of silk-like threads to catch prey.",
    ["stormpulse"] = "Pulses with energy, stirring the jungle waters during storms.",
    ["stripeflash"] = "Quick and colorful, flashing stripes confuse its foes.",
    ["zebris"] = "Small but vibrant, it zigzags through underwater jungle grasses.",
    --cliff
    ["axolume"] = "A glowing amphibian with mysterious powers.",
    ["ballfin"] = "Compact and sturdy, built for rocky streams.",
    ["beakcoil"] = "Eel with a sharp, pelican-like beak.",
    ["blueflare"] = "Bright blue scales that shimmer in sunlight.",
    ["cratefin"] = "Box-shaped fish with a tough exterior.",
    ["dragonscale"] = "Dragon-like scales protect this fierce fish.",
    ["faeglimmer"] = "Delicate fish that sparkles with magic.",
    ["flareborn"] = "Born from fire, it lights up dark waters.",
    ["glacierglow"] = "Radiates a cold, icy blue glow.",
    ["glowcrest"] = "Shines bright atop rocky cliffs.",
    ["goldwyrm"] = "Legendary fish with golden scales.",
    ["mistwhirl"] = "Swims through fog with ghostly grace.",
    ["plumecrest"] = "Vibrant fins like a peacock's plume.",
    ["skyrider"] = "Soars through water like a hawk in air.",
    ["somnifin"] = "Dreamy fish that lulls prey to sleep.",
    ["spectralfin"] = "Elusive fish with a ghostly glow.",
    ["speckledray"] = "Spotted pattern helps it hide in rocks.",
    ["stellaroi"] = "Koi with star-like patterns on its scales.",
    ["striatus"] = "Striped bass that darts swiftly.",
    ["windsprite"] = "Swift and light, it dances on currents.",
    --tropical
    ["sunburstfish"] = "A bright fish that shines like a tropical sunrise.",
    ["mudfin"] = "A sturdy bottom dweller with a muddy hue.",
    ["clearcap"] = "A translucent fish with a crystal-clear head.",
    ["gulpfin"] = "Deep-water eel with a huge mouth for swallowing prey.",
    ["tangaclaw"] = "A fierce cichlid with sharp claws from Lake Tanganyika.",
    ["neonflare"] = "Small and vibrant, glowing with neon colors.",
    ["shadefin"] = "A dark, elusive fish that lurks in shadowy reefs.",
    ["rainbowbeak"] = "Colorful parrotfish with a sharp, curved beak.",
    ["peaflare"] = "A flashy anthias with vibrant, peacock-like fins.",
    ["streamglow"] = "A mystical fish that glows softly in fast streams.",
    ["reefshadow"] = "An octopus-like fish blending into coral shadows.",
    ["stoneblenny"] = "A tiny fish camouflaged among rocky pools.",
    ["rustbarb"] = "A rusty-colored barb fish with a fierce attitude.",
    ["koisamurai"] = "A noble koi known for its fierce spirit.",
    ["shellback"] = "A snailfish with a sturdy shell-like back.",
    ["stardustfin"] = "A carp glittering with specks of stardust.",
    ["dawnsnapper"] = "A snapper that appears at sunrise, vibrant and bright.",
    ["dusksnapper"] = "A snapper that prowls the reefs at dusk.",
    ["venomfang"] = "A venomous fish with sharp fangs and swift strikes.",
    ["voidwing"] = "A manta that glides silently through deep, dark waters.",

}

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
    ["bubble_fish"] = 1.5,
    ["rainbow_fish"] = 1.2,
    ["garnetfish"] = 1.5,
    ["amethyststream"] = 1.5,
    ["aquaripple"] = 1,
    ["diamondblink"] = 1.5,
    ["emeraldfin"] = 1,
    ["pearlglow"] = 1.5,
    ["rubyflame"] = 1.5,
    ["peridotglimmer"] = 1,
    ["sapphirine"] = 1.5,
    ["opalflare"] = 1,
    ["topazflare"] = 1.5,
    ["turquoisewave"] = 1,
    ["LouYu"] = 1.2,
    ["Obsidianfin"] = 1.2,
    ["solidGoldFish"] = 1.2,
    ["solidSilverFish"] = 1.2,
    ["tounniFish"] = 1.2,
    ["bubbleGumFish"] = 1.5,
    ["DreamweaverBeta"] = 1.5,
    ["crystalJellyFish"] = 2,
    --coral
    ["amberlure"] = 1.1,
    ["ashflare"] = 1.4,
    ["azuregill"] = 1.3,
    ["blazefin"] = 1.5,
    ["charavine"] = 1.3,
    ["crownscale"] = 1.4,
    ["duskmire"] = 1.0,
    ["embercreel"] = 1.1,
    ["flutterfin"] = 1.0,
    ["gloomgill"] = 1.1,
    ["jellyspawn"] = 1.6,
    ["mandaglimmer"] = 1.5,
    ["moltenfin"] = 1.9,
    ["nightdarter"] = 1.6,
    ["oarpike"] = 1.0,
    ["puffreef"] = 1.3,
    ["reefwarden"] = 1.1,
    ["regalfin"] = 2.0,
    ["skypiercer"] = 1.2,
    ["spinebloom"] = 1.0,
    ["stellafin"] = 1.1,
    ["bettraquon"] = 1.3,
    --winter
    ["brineleaf"] = 1.9,       -- Mythical
    ["crescentide"] = 1.5,     -- Legendary
    ["crystalfade"] = 1.3,     -- Epic
    ["deepgloom"] = 1.0,       -- Rare
    ["dusktide"] = 1.4,        -- Epic
    ["frothling"] = 1.1,       -- Rare
    ["frostchar"] = 2.0,       -- Mythical
    ["frostqueen"] = 1.2,      -- Rare
    ["frostscale"] = 1.2,      -- Rare
    ["glimmerscale"] = 1.1,    -- Rare
    ["glacierrun"] = 1.2,      -- Rare
    ["lunawing"] = 1.2,        -- Rare
    ["moonspine"] = 1.3,       -- Epic
    ["mythicrest"] = 1.8,      -- Mythical
    ["rimefang"] = 1.3,        -- Rare
    ["shiverfin"] = 1.5,       -- Legendary
    ["silvertang"] = 1.4,      -- Epic
    ["snowidol"] = 1.3,        -- Epic
    ["tundrawave"] = 1.6,      -- Legendary
    ["whispergill"] = 1.1,     -- Rare
    --jungle
    ["tigerrush"] = 1.5,      -- Legendary  
    ["leafshade"] = 1.1,      -- Rare  
    ["piranthrax"] = 1.0,     -- Rare  
    ["goldripple"] = 1.1,     -- Rare  
    ["shadowdrake"] = 1.6,    -- Legendary  
    ["drakefly"] = 1.2,       -- Rare  
    ["voltcat"] = 1.5,        -- Legendary  
    ["gleameel"] = 1.2,       -- Rare  
    ["gratch"] = 1.5,         -- Legendary  
    ["jadeflare"] = 1.8,      -- Mythical  
    ["glowbelly"] = 1.1,      -- Rare  
    ["mystiglow"] = 1.9,      -- Mythical  
    ["nightmoth"] = 1.0,      -- Rare  
    ["runecarp"] = 1.3,       -- Epic  
    ["duneskimmer"] = 1.0,    -- Rare  
    ["shovelclaw"] = 1.4,     -- Epic  
    ["silkspinner"] = 1.1,    -- Rare  
    ["stormpulse"] = 1.3,     -- Epic  
    ["stripeflash"] = 1.3,    -- Epic  
    ["zebris"] = 1.0,         -- Rare
    --cliff
    ["axolume"] = 1.1,      -- Rare
    ["ballfin"] = 1.1,      -- Rare
    ["beakcoil"] = 1.2,     -- Rare
    ["blueflare"] = 1.3,    -- Epic
    ["cratefin"] = 1.1,     -- Rare
    ["dragonscale"] = 1.4,  -- Rare (tougher fish)
    ["faeglimmer"] = 1.3,   -- Epic
    ["flareborn"] = 1.5,    -- Legendary
    ["glacierglow"] = 1.3,  -- Epic
    ["glowcrest"] = 1.5,    -- Legendary
    ["goldwyrm"] = 1.9,     -- Mythical
    ["mistwhirl"] = 1.9,    -- Mythical
    ["plumecrest"] = 1.3,   -- Epic
    ["skyrider"] = 1.2,     -- Rare
    ["somnifin"] = 1.5,     -- Legendary
    ["spectralfin"] = 1.1,  -- Rare
    ["speckledray"] = 1.1,  -- Rare
    ["stellaroi"] = 1.1,    -- Rare
    ["striatus"] = 1.2,     -- Rare
    ["windsprite"] = 1.5,   -- Legendary
    --tropical
    ["mudfin"] = 1.0,          -- Rare
    ["clearcap"] = 1.3,        -- Epic
    ["dawnsnapper"] = 1.1,     -- Rare
    ["dusksnapper"] = 1.1,     -- Rare
    ["gulpfin"] = 1.4,         -- Epic
    ["tangaclaw"] = 1.2,       -- Rare
    ["koisamurai"] = 1.8,      -- Mythical
    ["neonflare"] = 1.0,       -- Rare
    ["peaflare"] = 1.2,        -- Rare
    ["rainbowbeak"] = 1.5,     -- Legendary
    ["reefshadow"] = 1.5,      -- Epic
    ["rustbarb"] = 1.2,        -- Rare
    ["shadefin"] = 1.3,        -- Epic
    ["shellback"] = 1.1,       -- Rare
    ["stoneblenny"] = 1.0,     -- Rare
    ["stardustfin"] = 1.1,     -- Rare
    ["sunburstfish"] = 1.5,    -- Legendary
    ["streamglow"] = 1.9,      -- Mythical
    ["venomfang"] = 1.5,       -- Legendary
    ["voidwing"] = 1.2,        -- Rare

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
    ["bubble_fish"] = fishTextures[86],
    ["rainbow_fish"] = fishTextures[87],
    ["garnetfish"] = fishTextures[88],
    ["amethyststream"] = fishTextures[89],
    ["aquaripple"] = fishTextures[90],
    ["diamondblink"] = fishTextures[91],
    ["emeraldfin"] = fishTextures[92],
    ["pearlglow"] = fishTextures[93],
    ["rubyflame"] = fishTextures[94],
    ["peridotglimmer"] = fishTextures[95],
    ["sapphirine"] = fishTextures[96],
    ["opalflare"] = fishTextures[97],
    ["topazflare"] = fishTextures[98],
    ["turquoisewave"] = fishTextures[99],
    ["LouYu"] = fishTextures[100],
    ["Obsidianfin"] = fishTextures[101],
    ["solidGoldFish"] = fishTextures[102],
    ["solidSilverFish"] = fishTextures[103],
    ["tounniFish"] = fishTextures[104],
    ["bubbleGumFish"] = fishTextures[105],
    ["DreamweaverBeta"] = fishTextures[106],
    ["crystalJellyFish"] = fishTextures[107],
    --coral
    ["amberlure"] = fishTextures[108],
    ["ashflare"] = fishTextures[109],
    ["azuregill"] = fishTextures[110],
    ["bettraquon"] = fishTextures[111],
    ["blazefin"] = fishTextures[112],
    ["charavine"] = fishTextures[113],
    ["crownscale"] = fishTextures[114],
    ["duskmire"] = fishTextures[115],
    ["embercreel"] = fishTextures[116],
    ["flutterfin"] = fishTextures[117],
    ["gloomgill"] = fishTextures[118],
    ["jellyspawn"] = fishTextures[119],
    ["mandaglimmer"] = fishTextures[120],
    ["moltenfin"] = fishTextures[121],
    ["nightdarter"] = fishTextures[122],
    ["oarpike"] = fishTextures[123],
    ["puffreef"] = fishTextures[124],
    ["reefwarden"] = fishTextures[125],
    ["regalfin"] = fishTextures[126],
    ["skypiercer"] = fishTextures[127],
    ["spinebloom"] = fishTextures[128],
    ["stellafin"] = fishTextures[129],
    --winter
    ["brineleaf"] = fishTextures[130],
    ["crescentide"] = fishTextures[131],
    ["crystalfade"] = fishTextures[132],
    ["deepgloom"] = fishTextures[133],
    ["dusktide"] = fishTextures[134],
    ["frothling"] = fishTextures[135],
    ["frostchar"] = fishTextures[136],
    ["frostqueen"] = fishTextures[137],
    ["frostscale"] = fishTextures[138],
    ["glacierrun"] = fishTextures[139],
    ["glimmerscale"] = fishTextures[140],
    ["lunawing"] = fishTextures[141],
    ["moonspine"] = fishTextures[142],
    ["mythicrest"] = fishTextures[143],
    ["rimefang"] = fishTextures[144],
    ["shiverfin"] = fishTextures[145],
    ["silvertang"] = fishTextures[146],
    ["snowidol"] = fishTextures[147],
    ["tundrawave"] = fishTextures[148],
    ["whispergill"] = fishTextures[149],
    --jungle
    ["drakefly"] = fishTextures[150],
    ["duneskimmer"] = fishTextures[151],
    ["gleameel"] = fishTextures[152],
    ["glowbelly"] = fishTextures[153],
    ["goldripple"] = fishTextures[154],
    ["gratch"] = fishTextures[155],
    ["jadeflare"] = fishTextures[156],
    ["leafshade"] = fishTextures[157],
    ["mystiglow"] = fishTextures[158],
    ["nightmoth"] = fishTextures[159],
    ["piranthrax"] = fishTextures[160],
    ["runecarp"] = fishTextures[161],
    ["shovelclaw"] = fishTextures[162],
    ["silkspinner"] = fishTextures[163],
    ["shadowdrake"] = fishTextures[164],
    ["stormpulse"] = fishTextures[165],
    ["stripeflash"] = fishTextures[166],
    ["tigerrush"] = fishTextures[167],
    ["voltcat"] = fishTextures[168],
    ["zebris"] = fishTextures[169],
    --cliff
    ["axolume"] = fishTextures[170],
    ["ballfin"] = fishTextures[171],
    ["beakcoil"] = fishTextures[172],
    ["blueflare"] = fishTextures[173],
    ["cratefin"] = fishTextures[174],
    ["dragonscale"] = fishTextures[175],
    ["faeglimmer"] = fishTextures[176],
    ["flareborn"] = fishTextures[177],
    ["glacierglow"] = fishTextures[178],
    ["glowcrest"] = fishTextures[179],
    ["goldwyrm"] = fishTextures[180],
    ["mistwhirl"] = fishTextures[181],
    ["plumecrest"] = fishTextures[182],
    ["skyrider"] = fishTextures[183],
    ["somnifin"] = fishTextures[184],
    ["spectralfin"] = fishTextures[185],
    ["speckledray"] = fishTextures[186],
    ["stellaroi"] = fishTextures[187],
    ["striatus"] = fishTextures[188],
    ["windsprite"] = fishTextures[189],
    --tropical
    ["clearcap"] = fishTextures[190],
    ["dawnsnapper"] = fishTextures[191],
    ["dusksnapper"] = fishTextures[192],
    ["gulpfin"] = fishTextures[193],
    ["koisamurai"] = fishTextures[194],
    ["mudfin"] = fishTextures[195],
    ["neonflare"] = fishTextures[196],
    ["peaflare"] = fishTextures[197],
    ["rainbowbeak"] = fishTextures[198],
    ["reefshadow"] = fishTextures[199],
    ["rustbarb"] = fishTextures[200],
    ["shadefin"] = fishTextures[201],
    ["shellback"] = fishTextures[202],
    ["stardustfin"] = fishTextures[203],
    ["stoneblenny"] = fishTextures[204],
    ["streamglow"] = fishTextures[205],
    ["sunburstfish"] = fishTextures[206],
    ["tangaclaw"] = fishTextures[207],
    ["venomfang"] = fishTextures[208],
    ["voidwing"] = fishTextures[209],
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
    ["bubble_fish"] = {"hotdog_bait"},
    ["rainbow_fish"] = {"donut_bait"},
    ["garnetfish"] = {"shrimp_bait"},
    ["amethyststream"] = {"donut_bait"},
    ["aquaripple"] = {"toast_bait"},
    ["diamondblink"] = {"steak_bait"},
    ["emeraldfin"] = {"broccoli_bait"},
    ["pearlglow"] = {"egg_bait"},
    ["rubyflame"] = {"hotdog_bait"},
    ["peridotglimmer"] = {"plastic_bait"},
    ["sapphirine"] = {"maggot_bait"},
    ["opalflare"] = {"pizza_bait"},
    ["topazflare"] = {"corn_bait"},
    ["turquoisewave"] = {"bacon_bait"},
    ["LouYu"] = {"shrimp_bait"},
    ["Obsidianfin"] = {"steak_bait"},
    ["solidGoldFish"] = {"donut_bait"},
    ["solidSilverFish"] = {"toast_bait"},
    ["tounniFish"] = {"broccoli_bait"},
    ["bubbleGumFish"] = {"pizza_bait"},
    ["DreamweaverBeta"] = {"egg_bait"},
    ["crystalJellyFish"] = {"hotdog_bait"},
    --coral
    ["amberlure"] = {"egg_bait"},
    ["ashflare"] = {"hotdog_bait"},
    ["azuregill"] = {"broccoli_bait"},
    ["bettraquon"] = {"bacon_bait"},
    ["blazefin"] = {"hotdog_bait"},
    ["charavine"] = {"corn_bait"},
    ["crownscale"] = {"shrimp_bait"},
    ["duskmire"] = {"maggot_bait"},
    ["embercreel"] = {"toast_bait"},
    ["flutterfin"] = {"Any"},
    ["gloomgill"] = {"maggot_bait"},
    ["jellyspawn"] = {"squid_bait"},
    ["mandaglimmer"] = {"donut_bait"},
    ["moltenfin"] = {"steak_bait"},
    ["nightdarter"] = {"shrimp_bait"},
    ["oarpike"] = {"corn_bait"},
    ["puffreef"] = {"broccoli_bait"},
    ["reefwarden"] = {"shrimp_bait"},
    ["regalfin"] = {"steak_bait"},
    ["skypiercer"] = {"pizza_bait"},
    ["spinebloom"] = {"corn_bait"},
    ["stellafin"] = {"egg_bait"},
    --winter
    ["brineleaf"] = {"shrimp_bait"},
    ["crescentide"] = {"donut_bait"},
    ["crystalfade"] = {"hotdog_bait"},
    ["deepgloom"] = {"maggot_bait"},
    ["dusktide"] = {"bacon_bait"},
    ["frothling"] = {"broccoli_bait"},
    ["frostchar"] = {"steak_bait"},
    ["frostqueen"] = {"corn_bait"},
    ["frostscale"] = {"toast_bait"},
    ["glacierrun"] = {"plastic_bait"},
    ["glimmerscale"] = {"egg_bait"},
    ["lunawing"] = {"pizza_bait"},
    ["moonspine"] = {"maggot_bait"},
    ["mythicrest"] = {"steak_bait"},
    ["rimefang"] = {"hotdog_bait"},
    ["shiverfin"] = {"squid_bait"},
    ["silvertang"] = {"broccoli_bait"},
    ["snowidol"] = {"pizza_bait"},
    ["tundrawave"] = {"donut_bait"},
    ["whispergill"] = {"chicken_bait"},
    --jungle
    ["tigerrush"] = {"bacon_bait"},
    ["leafshade"] = {"broccoli_bait"},
    ["piranthrax"] = {"hotdog_bait"},
    ["goldripple"] = {"egg_bait"},
    ["shadowdrake"] = {"steak_bait"},
    ["drakefly"] = {"pizza_bait"},
    ["voltcat"] = {"steak_bait"},
    ["gleameel"] = {"toast_bait"},
    ["gratch"] = {"shrimp_bait"},
    ["jadeflare"] = {"donut_bait"},
    ["glowbelly"] = {"pizza_bait"},
    ["mystiglow"] = {"donut_bait"},
    ["nightmoth"] = {"maggot_bait"},
    ["runecarp"] = {"plastic_bait"},
    ["duneskimmer"] = {"corn_bait"},
    ["shovelclaw"] = {"bacon_bait"},
    ["silkspinner"] = {"maggot_bait"},
    ["stormpulse"] = {"squid_bait"},
    ["stripeflash"] = {"bacon_bait"},
    ["zebris"] = {"chicken_bait"},
    --cliff
    ["axolume"] = {"maggot_bait"},
    ["ballfin"] = {"hotdog_bait"},
    ["beakcoil"] = {"toast_bait"},
    ["blueflare"] = {"bacon_bait"},
    ["cratefin"] = {"corn_bait"},
    ["dragonscale"] = {"steak_bait"},
    ["faeglimmer"] = {"donut_bait"},
    ["flareborn"] = {"steak_bait"},
    ["glacierglow"] = {"egg_bait"},
    ["glowcrest"] = {"steak_bait"},
    ["goldwyrm"] = {"donut_bait"},
    ["mistwhirl"] = {"donut_bait"},
    ["plumecrest"] = {"bacon_bait"},
    ["skyrider"] = {"chicken_bait"},
    ["somnifin"] = {"pizza_bait"},
    ["spectralfin"] = {"maggot_bait"},
    ["speckledray"] = {"corn_bait"},
    ["stellaroi"] = {"egg_bait"},
    ["striatus"] = {"plastic_bait"},
    ["windsprite"] = {"pizza_bait"},
    --tropical
    ["mudfin"] = {"Any"},
    ["clearcap"] = {"hotdog_bait"},
    ["dawnsnapper"] = {"corn_bait"},
    ["dusksnapper"] = {"corn_bait"},
    ["gulpfin"] = {"pizza_bait"},
    ["koisamurai"] = {"donut_bait"},
    ["neonflare"] = {"maggot_bait"},
    ["peaflare"] = {"shrimp_bait"},
    ["rainbowbeak"] = {"bacon_bait"},
    ["reefshadow"] = {"steak_bait"},
    ["rustbarb"] = {"broccoli_bait"},
    ["shadefin"] = {"hotdog_bait"},
    ["shellback"] = {"toast_bait"},
    ["stoneblenny"] = {"Any"},
    ["stardustfin"] = {"egg_bait"},
    ["sunburstfish"] = {"bacon_bait"},
    ["streamglow"] = {"donut_bait"},
    ["venomfang"] = {"hotdog_bait"},
    ["voidwing"] = {"toast_bait"},
    ["tangaclaw"] = {"shrimp_bait"},
}

local RarityReelResistances = {
    ["Common"] = 1,
    ["Uncommon"] = 1.1,
    ["Rare"] = 1.2,
    ["Epic"] = 1.3,
    ["Legendary"] = 1.4,
    ["Mythical"] = 1.45,
}

local RarityStrengthResistances = {
    ["Common"] = 1,
    ["Uncommon"] = 1.05,
    ["Rare"] = 1.1,
    ["Epic"] = 1.15,
    ["Legendary"] = 1.2,
    ["Mythical"] = 1.225,
}

local RarityExperianceValue = {
    ["Common"] = 10,
    ["Uncommon"] = 50,
    ["Rare"] = 100,
    ["Epic"] = 250,
    ["Legendary"] = 500,
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
    "LouYu",            -- Rare
    "Obsidianfin",      -- Rare
    "solidGoldFish",    -- Rare
    "solidSilverFish",  -- Rare
    "tounniFish",       -- Rare

    -- Coral Rare
    "amberlure",     -- Rare
    "duskmire",      -- Rare
    "embercreel",    -- Rare
    "flutterfin",    -- Rare
    "gloomgill",     -- Rare
    "oarpike",       -- Rare
    "reefwarden",    -- Rare
    "skypiercer",    -- Rare
    "spinebloom",    -- Rare
    "stellafin",     -- Rare
    -- Winter Rare
    "deepgloom",
    "frothling",
    "frostqueen",
    "frostscale",
    "glimmerscale",
    "glacierrun",
    "lunawing",
    "rimefang",
    "whispergill",
    -- Jungel Rare
    "drakefly",
    "duneskimmer",
    "gleameel",
    "glowbelly",
    "leafshade",
    "nightmoth",
    "piranthrax",
    "silkspinner",
    "zebris",
    "goldripple",
    -- Cliffs Rare
    "axolume",
    "ballfin",
    "beakcoil",
    "cratefin",
    "dragonscale",
    "skyrider",
    "spectralfin",
    "speckledray",
    "stellaroi",
    "striatus",
    --tropical Rare
    "mudfin",
    "dawnsnapper",
    "dusksnapper",
    "neonflare",
    "peaflare",
    "rustbarb",
    "shellback",
    "stoneblenny",
    "stardustfin",
    "voidwing",

    -- Epic
    "dolphin",            -- Epic
    "king_mackerel",      -- Epic
    "killer_whale",       -- Epic
    "king_fish",          -- Epic
    "begginers_luck_fish",-- Epic
    "king_salmon",        -- Epic
    "beach_shark_fish",   -- Epic
    "angler_fish",        -- Epic
    "nomadic_trout",      -- Epic
    
    -- Crystal Epic
    "garnetfish",
    "amethyststream",
    "aquaripple",
    "diamondblink",
    "emeraldfin",
    "pearlglow",
    "rubyflame",
    "peridotglimmer",
    "sapphirine",
    "opalflare",
    "topazflare",
    "turquoisewave",
    -- Coral Epic
    "ashflare",      -- Epic
    "azuregill",     -- Epic
    "bettraquon",    -- Epic
    "charavine",     -- Epic
    "crownscale",    -- Epic
    "puffreef",      -- Epic
    -- Winter Epic
    "crystalfade",
    "dusktide",
    "moonspine",
    "silvertang",
    "snowidol",
    -- Jungle Epic
    "runecarp",
    "shovelclaw",
    "stormpulse",
    "stripeflash",
    -- Cliffs Epic
    "blueflare",
    "faeglimmer",
    "glacierglow",
    "glowcrest",
    "plumecrest",
    -- Tropical Epic
    "clearcap",
    "gulpfin",
    "shadefin",
    "reefshadow",
    "tangaclaw",

    -- Legendary
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
    "bubble_fish",       -- Legendary

    -- Crystal Legendary
    "bubbleGumFish",    -- leg
    "DreamweaverBeta",  -- leg
    -- Coral Legendary
    "blazefin",      -- Legendary
    "jellyspawn",    -- Legendary
    "mandaglimmer",  -- Legendary
    "nightdarter",   -- Legendary
    -- Winter Legendary
    "crescentide",
    "shiverfin",
    "tundrawave",
    -- jungle Legendary
    "shadowdrake",
    "tigerrush",
    "voltcat",
    "gratch",
    -- Cliffs Legendary
    "flareborn",
    "somnifin",
    "windsprite",
    -- Tropical Legendary
    "rainbowbeak",
    "sunburstfish",
    "venomfang",

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
    "salt_trader_fish",   -- Mythical
    "rainbow_fish",       -- Mythical

    -- Crystal Mythical
    "crystalJellyFish",   -- Mythical
    -- Coral Mythical
    "moltenfin",     -- Mythical
    "regalfin",      -- Mythical
    -- Winter Mythical
    "brineleaf",
    "frostchar",
    "mythicrest",
    -- Jungle Mythical
    "jadeflare",
    "mystiglow",
    -- Cliffs Mythical
    "goldwyrm",
    "mistwhirl",
    -- Tropical Mythical
    "koisamurai",
    "streamglow",
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
        Quest_ID = "nil",
        SizeRange = FishSizeRange[fishKey],
        Special_Attribute = FishSpecialAttributes[fishKey]
    }
end

--[[
 Function to roll for rarity based on a range of chances with a rarity cap
]]
-- @param luck - a float between 1 (min chance) and 10 (max chance)
-- @param cap - a string that represents the highest rarity allowed (e.g., "Epic")
function rollRarity(luck, cap)
    luck = luck or 1
    cap = cap or "Mythical"
    -- Clamp luck to be at least 1 (or you could define specific behavior for luck = 0)
    luck = math.max(luck, 1)
    print("Luck: " .. tostring(luck))
    -- Define the minimum and maximum chances for each rarity
    local rarities = {
        {name = "Common", minChance = 70, maxChance = 55.5},
        {name = "Uncommon", minChance = 20, maxChance = 25},
        {name = "Rare", minChance = 7, maxChance = 12},
        {name = "Epic", minChance = 2, maxChance = 5},
        {name = "Legendary", minChance = 0.9, maxChance = 2},
        {name = "Mythical", minChance = 0.1, maxChance = .5},
    }

    -- Map the cap to a maximum index
    local capIndex = #rarities  -- Default to Mythical (highest)
    for i, rarity in ipairs(rarities) do
        if rarity.name == cap then
            capIndex = i
            break
        end
    end

    -- Normalize luck to a range between 0 (for luck = 1) and 1 (for luck = 10)
    local luckFactor = (luck - 1) / 9  -- 9 because the range is from 1 to 10

    -- Calculate adjusted chances based on luckFactor (interpolating between min and max)
    local totalChance = 0
    for i, rarity in ipairs(rarities) do
        if i <= capIndex then
            rarity.adjustedChance = rarity.minChance + luckFactor * (rarity.maxChance - rarity.minChance)
            totalChance = totalChance + rarity.adjustedChance
        else
            rarity.adjustedChance = 0  -- Set chances to 0 for rarities above the cap
        end
        --print("Adjusted chance for " .. rarity.name .. ": " .. tostring(rarity.adjustedChance))
    end

    -- Normalize adjusted chances to ensure the total remains 100 for allowed rarities
    for i, rarity in ipairs(rarities) do
        if i <= capIndex then
            rarity.finalChance = (rarity.adjustedChance / totalChance) * 100
        else
            rarity.finalChance = 0  -- No chance for rarities above the cap
        end
    end

    -- Roll a random number between 0 and 100 to pick a rarity
    local roll = math.random() * 100
    --print("Roll: " .. tostring(roll))
    local cumulative = 0

    for i, rarity in ipairs(rarities) do
        cumulative = cumulative + rarity.finalChance
        if roll <= cumulative then
            -- If a rarity higher than the cap is selected, return the cap rarity
            if i > capIndex then
                print("Rarity rolled above cap: " .. rarities[capIndex].name)
                return rarities[capIndex].name
            else
                print("Rarity rolled: " .. rarity.name)
                return rarity.name
            end
        end
    end

    return rarities[1].name -- Fallback, should not reach here
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

function GetRandomFish(Biome, Bait, MaxRarity)

    math.randomseed(os.time())
    Biome = Biome or "Any"
    Bait = Bait or "none"

    local Luck = 1
    if Bait ~= "none" then Luck = itemMetaData.GetItemData(Bait).ItemLuck end
    -- Determine rarity based on weighted roll
    local chosenRarity = rollRarity(Luck, MaxRarity)
    --print("Chosen Rarity: " .. chosenRarity)
    local fishList = {}
    
    -- Gather fish matching the chosen Rartiy, Biome, and Bait
    for fishName, fishData in fish_metadata do
        if fishData.Rarity == chosenRarity and CheckBiome(fishName, Biome) then
            table.insert(fishList, fishName)
            --print("Found fish: " .. fishName .. " with rarity: " .. fishData.Rarity .. " in Biome: " .. Biome)
            -- if the fish matches the chosen bait add it in the table again to increase its odds
            if CheckBait(fishName, Bait) then
                table.insert(fishList, fishName)
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