--!Type(Module)

--!SerializeField
local poleIcons : {Texture} = nil
--!SerializeField
local poleOutfits : {CharacterOutfit} = nil
--!SerializeField
local baitIcons : {Texture} = nil
--!SerializeField
local dealsIcons : {Texture} = nil

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

bait_metadata = 
{
    ["bacon_bait"] = {
        Name = "Bacon",
        Description = "A strip of bacon, perfect for catching up to Rare fish.",
        ItemImage = baitIcons[5],
        ItemWorth = 10,
        ItemRarity = "Rare",
        ItemBiomes = {"Any"},
        ItemLevel = 1
    },
    ["broccoli_bait"] = {
        Name = "Broccoli",
        Description = "A piece of broccoli, perfect for catching up to Rare fish.",
        ItemImage = baitIcons[6],
        ItemWorth = 10,
        ItemRarity = "Rare",
        ItemBiomes = {"Any"},
        ItemLevel = 1
    },
    ["chicken_bait"] = {
        Name = "Chicken",
        Description = "A piece of chicken, perfect for catching up to Rare fish.",
        ItemImage = baitIcons[7],
        ItemWorth = 10,
        ItemRarity = "Rare",
        ItemBiomes = {"Any"},
        ItemLevel = 1
    },
    ["corn_bait"] = {
        Name = "Corn",
        Description = "A piece of corn, perfect for catching up to Uncommon fish.",
        ItemImage = baitIcons[8],
        ItemWorth = 5,
        ItemRarity = "Uncommon",
        ItemBiomes = {"Any"},
        ItemLevel = 1
    },
    ["donut_bait"] = {
        Name = "Donut",
        Description = "A donut, perfect for catching up to Mythical fish.",
        ItemImage = baitIcons[9],
        ItemWorth = 20,
        ItemRarity = "Mythical",
        ItemBiomes = {"Any"},
        ItemLevel = 1
    },
    ["egg_bait"] = {
        Name = "Egg",
        Description = "An egg, perfect for catching up to Rare fish.",
        ItemImage = baitIcons[10],
        ItemWorth = 10,
        ItemRarity = "Rare",
        ItemBiomes = {"Any"},
        ItemLevel = 1
    },
    ["grub_bait"] = {
        Name = "Grub",
        Description = "A grub, perfect for catching up to Uncommon fish.",
        ItemImage = baitIcons[11],
        ItemWorth = 5,
        ItemRarity = "Uncommon",
        ItemBiomes = {"Any"},
        ItemLevel = 1
    },
    ["hotdog_bait"] = {
        Name = "Hotdog",
        Description = "A hotdog, perfect for catching up to Legendary fish.",
        ItemImage = baitIcons[12],
        ItemWorth = 15,
        ItemRarity = "Legendary",
        ItemBiomes = {"Any"},
        ItemLevel = 1
    },
    ["maggot_bait"] = {
        Name = "Maggot",
        Description = "A maggot, perfect for catching up to Uncommon fish.",
        ItemImage = baitIcons[13],
        ItemWorth = 5,
        ItemRarity = "Uncommon",
        ItemBiomes = {"Any"},
        ItemLevel = 1
    },
    ["pizza_bait"] = {
        Name = "Pizza",
        Description = "A slice of pizza, perfect for catching up to Legendary fish.",
        ItemImage = baitIcons[14],
        ItemWorth = 15,
        ItemRarity = "Legendary",
        ItemBiomes = {"Any"},
        ItemLevel = 1
    },
    ["plastic_bait"] = {
        Name = "Lure",
        Description = "A piece of plastic, perfect for catching up to Uncommon fish.",
        ItemImage = baitIcons[15],
        ItemWorth = 5,
        ItemRarity = "Uncommon",
        ItemBiomes = {"Any"},
        ItemLevel = 1
    },
    ["shrimp_bait"] = {
        Name = "Shrimp",
        Description = "A shrimp, perfect for catching up to Mythical fish.",
        ItemImage = baitIcons[16],
        ItemWorth = 20,
        ItemRarity = "Mythical",
        ItemBiomes = {"Any"},
        ItemLevel = 1
    },
    ["squid_bait"] = {
        Name = "Squid",
        Description = "A squid, perfect for catching up to Mythical fish.",
        ItemImage = baitIcons[17],
        ItemWorth = 20,
        ItemRarity = "Mythical",
        ItemBiomes = {"Any"},
        ItemLevel = 1
    },
    ["steak_bait"] = {
        Name = "Steak",
        Description = "A steak, perfect for catching up to Mythical fish.",
        ItemImage = baitIcons[18],
        ItemWorth = 20,
        ItemRarity = "Mythical",
        ItemBiomes = {"Any"},
        ItemLevel = 1
    },
    ["toast_bait"] = {
        Name = "Toast",
        Description = "A piece of toast, perfect for catching up to Rare fish.",
        ItemImage = baitIcons[19],
        ItemWorth = 10,
        ItemRarity = "Rare",
        ItemBiomes = {"Any"},
        ItemLevel = 1
    },
    ["sadworm_bait"] = {
        Name = "Worms",
        Description = "The trusty Worm, perfect for catching Uncommon fish. It's a little sad, but it gets the job done and is easy to find.",
        ItemImage = baitIcons[20],
        ItemWorth = 5,
        ItemRarity = "Uncommon",
        ItemBiomes = {"Any"},
        ItemLevel = 1
    }
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