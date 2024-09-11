--!Type(Module)

--!SerializeField
local poleIcons : {Texture} = nil
--!SerializeField
local poleOutfits : {CharacterOutfit} = nil
--!SerializeField
local baitIcons : {Texture} = nil
--!SerializeField
local dealsIcons : {Texture} = nil

--!SerializeField
local coinIcons : {Texture} = nil

function AssignCoinIcon(amount: number)
  if amount <= 49 then
    return coinIcons[1]
  elseif amount <= 99 then
    return coinIcons[2]
  else
    return coinIcons[3]
  end
end

pole_metadata = 
{
    ["fishing_pole_1"] = {
        Name = "Beginner's Pole",
        Description = "The basic fishing pole allows you to fish in small lakes and rivers.",
        Outfit = poleOutfits[1],
        ItemImage = poleIcons[1],
        ItemWorth = 0,
        ItemRarity = "Uncommon",
        ItemBiomes = {"Lake", "River"}, 
        ItemLevel = 1
    },
    ["fishing_pole_2"] = {
        Name = "Journeyman's Pole",
        Description = "The Journeyman's fishing pole allows you to fish in small lakes, rivers, and even icy waters!",
        Outfit = poleOutfits[2],
        ItemImage = poleIcons[2],
        ItemWorth = 100,
        ItemRarity = "Uncommon",
        ItemBiomes = {"Lake", "River", "Ice"},
        ItemLevel = 2
    },
    ["fishing_pole_3"] = {
        Name = "Deep Sea Pole",
        Description = "The Deep Sea fishing pole allows you to explore the salty ocean waters! but isnt effective in the fresh water rivers and lakes.",
        Outfit = poleOutfits[3],
        ItemImage = poleIcons[3],
        ItemWorth = 500,
        ItemRarity = "Rare",
        ItemBiomes = {"Ocean", "Ice"},
        ItemLevel = 3
    },
    ["fishing_pole_5"] = {
        Name = "Golden Pole",
        Description = "The Golden fishing pole allows you to fish in any body of water!",
        Outfit = poleOutfits[5],
        ItemImage = poleIcons[5],
        ItemWorth = 3000,
        ItemRarity = "Mythical",
        ItemBiomes = {"Any"},
        ItemLevel = 5
    }
}

pole_keys = 
{
    "fishing_pole_1", -- Level 1
    "fishing_pole_2", -- Level 2
    "fishing_pole_3", -- Level 3
    "fishing_pole_5", -- Level 5
}

-- Reordered by bait_keys order

-- Table for bait names
local bait_names = {
    ["sadworm_bait"] = "Worms",
    ["corn_bait"] = "Corn",
    ["plastic_bait"] = "Lure",
    ["maggot_bait"] = "Maggot",
    ["grub_bait"] = "Grub",
    ["toast_bait"] = "Toast",
    ["bacon_bait"] = "Bacon",
    ["broccoli_bait"] = "Broccoli",
    ["chicken_bait"] = "Chicken",
    ["egg_bait"] = "Egg",
    ["hotdog_bait"] = "Hotdog",
    ["pizza_bait"] = "Pizza",
    ["shrimp_bait"] = "Shrimp",
    ["squid_bait"] = "Squid",
    ["steak_bait"] = "Steak",
    ["donut_bait"] = "Donut"
}

-- Table for bait descriptions with luck boost
local bait_descriptions = {
    ["sadworm_bait"] = "The trusty Worm. Provides a 1.25x luck boost! Poor guy is a bit sad, but still gets the job done.",
    ["corn_bait"] = "A piece of corn. Provides a 1.5x luck boost! Fish can't resist the kernels, who knew?",
    ["plastic_bait"] = "A piece of plastic. Provides a 1.75x luck boost! Recycling at its finest... for fishing!",
    ["maggot_bait"] = "A maggot. Provides a 2x luck boost! Gross to you, but gourmet to the fish.",
    ["grub_bait"] = "A grub. Provides a 2.3x luck boost! The wriggliest bait you'll ever use.",
    ["toast_bait"] = "A piece of toast. Provides a 2.6x luck boost! Fish appreciate a good breakfast, too.",
    ["bacon_bait"] = "A strip of bacon. Provides a 3x luck boost! Even fish can’t say no to bacon.",
    ["broccoli_bait"] = "A piece of broccoli. Provides a 3.5x luck boost! Even fish need their greens sometimes.",
    ["chicken_bait"] = "A piece of chicken. Provides a 4x luck boost! A true feast for the fanciest of fish.",
    ["egg_bait"] = "An egg. Provides a 4.5x luck boost! Fish go wild for this eggcellent bait.",
    ["hotdog_bait"] = "A hotdog. Provides a 5x luck boost! For fish that enjoy a classic snack by the lake.",
    ["pizza_bait"] = "A slice of pizza. Provides a 6x luck boost! Fish can't resist the cheesy goodness.",
    ["shrimp_bait"] = "A shrimp. Provides a 7x luck boost! It's like fine dining underwater.",
    ["squid_bait"] = "A squid. Provides an 8x luck boost! Fancy bait for the pickiest of fish.",
    ["steak_bait"] = "A steak. Provides a 9x luck boost! The ultimate bait for fish with a taste for luxury.",
    ["donut_bait"] = "A donut. Provides a 10x luck boost! Because who doesn't love a good donut, even fish?"
}

-- Table for bait images
local bait_images = {
    ["sadworm_bait"] = baitIcons[20],
    ["corn_bait"] = baitIcons[8],
    ["plastic_bait"] = baitIcons[15],
    ["maggot_bait"] = baitIcons[13],
    ["grub_bait"] = baitIcons[11],
    ["toast_bait"] = baitIcons[19],
    ["bacon_bait"] = baitIcons[5],
    ["broccoli_bait"] = baitIcons[6],
    ["chicken_bait"] = baitIcons[7],
    ["egg_bait"] = baitIcons[10],
    ["hotdog_bait"] = baitIcons[12],
    ["pizza_bait"] = baitIcons[14],
    ["shrimp_bait"] = baitIcons[16],
    ["squid_bait"] = baitIcons[17],
    ["steak_bait"] = baitIcons[18],
    ["donut_bait"] = baitIcons[9]
}

-- Table for bait worth (value)
local bait_worth = {
    ["sadworm_bait"] = 100,
    ["corn_bait"] = 200,
    ["plastic_bait"] = 300,
    ["maggot_bait"] = 400,
    ["grub_bait"] = 500,
    ["toast_bait"] = 600,
    ["bacon_bait"] = 700,
    ["broccoli_bait"] = 800,
    ["chicken_bait"] = 900,
    ["egg_bait"] = 1000,
    ["hotdog_bait"] = 1200,
    ["pizza_bait"] = 1400,
    ["shrimp_bait"] = 1600,
    ["squid_bait"] = 1800,
    ["steak_bait"] = 2000,
    ["donut_bait"] = 2200
}

-- Table for bait rarity
local bait_rarity = {
    ["sadworm_bait"] = "Uncommon",
    ["corn_bait"] = "Uncommon",
    ["plastic_bait"] = "Uncommon",
    ["maggot_bait"] = "Uncommon",
    ["grub_bait"] = "Uncommon",
    ["toast_bait"] = "Rare",
    ["bacon_bait"] = "Rare",
    ["broccoli_bait"] = "Rare",
    ["chicken_bait"] = "Rare",
    ["egg_bait"] = "Rare",
    ["hotdog_bait"] = "Legendary",
    ["pizza_bait"] = "Legendary",
    ["shrimp_bait"] = "Mythical",
    ["squid_bait"] = "Mythical",
    ["steak_bait"] = "Mythical",
    ["donut_bait"] = "Mythical"
}

-- Table for bait biomes
local bait_biomes = {
    ["sadworm_bait"] = {"Any"},
    ["corn_bait"] = {"Any"},
    ["plastic_bait"] = {"Any"},
    ["maggot_bait"] = {"Any"},
    ["grub_bait"] = {"Any"},
    ["toast_bait"] = {"Any"},
    ["bacon_bait"] = {"Any"},
    ["broccoli_bait"] = {"Any"},
    ["chicken_bait"] = {"Any"},
    ["egg_bait"] = {"Any"},
    ["hotdog_bait"] = {"Any"},
    ["pizza_bait"] = {"Any"},
    ["shrimp_bait"] = {"Any"},
    ["squid_bait"] = {"Any"},
    ["steak_bait"] = {"Any"},
    ["donut_bait"] = {"Any"}
}

-- Table for bait level
local bait_luck = {
    ["sadworm_bait"] = 1.25,
    ["corn_bait"] = 1.5,
    ["plastic_bait"] = 1.75,
    ["maggot_bait"] = 2,
    ["grub_bait"] = 2.3,
    ["toast_bait"] = 2.6,
    ["bacon_bait"] = 3,
    ["broccoli_bait"] = 3.5,
    ["chicken_bait"] = 4,
    ["egg_bait"] = 4.5,
    ["hotdog_bait"] = 5,
    ["pizza_bait"] = 6,
    ["shrimp_bait"] = 7,
    ["squid_bait"] = 8,
    ["steak_bait"] = 9,
    ["donut_bait"] = 10
}

bait_keys = 
{
    "sadworm_bait",
    "corn_bait",
    "plastic_bait",
    "maggot_bait", 
    "grub_bait",
    "toast_bait",
    "bacon_bait",
    "broccoli_bait",
    "chicken_bait",
    "egg_bait",
    "hotdog_bait", 
    "pizza_bait",
    "shrimp_bait", 
    "squid_bait",
    "steak_bait",
    "donut_bait"
}

-- Create an entry for each fish pulling data from the tables above
bait_metadata = {}
for _, bait in ipairs(bait_keys) do
    bait_metadata[bait] = {
        Name = bait_names[bait],
        Description = bait_descriptions[bait],
        ItemImage = bait_images[bait],
        ItemWorth = bait_worth[bait],
        ItemRarity = bait_rarity[bait],
        ItemBiomes = bait_biomes[bait],
        ItemLuck = bait_luck[bait]
    }
end


deals_metadata = 
{
    ["fishing_token_1"] = {
        Name = "100 Fish Coins",
        Amount = 100,
        Description = "Get a quick boost with 100 Gold for 100 Coins – perfect for a small upgrade or some extra bait!",
        ItemImage = dealsIcons[1],
        ItemWorth = 100
    },
    ["fishing_token_2"] = {
        Name = "200 Fish Coins",
        Amount = 200,
        Description = "Grab 190 Gold for just 200 Coins – a great deal to keep you fishing longer with better gear.",
        ItemImage = dealsIcons[2],
        ItemWorth = 190
    },
    ["fishing_token_3"] = {
        Name = "500 Fish Coins",
        Description = "Maximize your value with 450 Gold for 500 Coins – the best choice for serious anglers looking to level up fast!",
        Amount = 500,
        ItemImage = dealsIcons[3],
        ItemWorth = 450
    }
}

deals_keys = 
{
    "fishing_token_1",
    "fishing_token_2",
    "fishing_token_3"
}


function GetItemData(itemID)
    if pole_metadata[itemID] then
        return pole_metadata[itemID]
    elseif bait_metadata[itemID] then
        return bait_metadata[itemID]
    end
end