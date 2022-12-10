xaries = {}

xaries.config = {
    blockedKeys = { --Disable all LEFT/RIGHT MOUSE BUTTON KEYS
        24, 
        25, 
        106,
        122,
        135,
        142,
        257,
        329,
        346,
    },

    disableCollison = true, --Set true to enable | Disabling collision with vehicles and peds

    wait = false,
    waitSeconds = 100, --4 seconds / Set how much time must to wait to make can player attack from greenzone

    callback = function(a)
        --Notification setting. You can attach your notifications here.
        if a == "join" then
            print("joined to greenzone")
        elseif a == "leave" then
            print("leaved from greenzone")
        end
    end,

    greenzones = {
        ["groveStreet"] = {
            coords = vector3(102.63, -1939.21, 20.8), --Grove Street
            colors = { -- RGB Colors
                r = 2,
                g = 255,
                b = 255,
                a = 0.3 -- From 0.0 to 1.0
            },
            radius = 20.0, -- Radius for greenzone
            blip = true,
            blipType = "radius", --RADIUS/NORMAL
            blipRadius = 20.0, -- BLIP RADIUS | Set the same radius as above or different
            blipSprite = 438, --BLIP SPRITE | List of all blips https://docs.fivem.net/docs/game-references/blips/
            blipColor = 42, --BLIP COLOR | List of all colors https://docs.fivem.net/docs/game-references/blips/
            blipAlpha = 222, --BLIP ALPHA | Set blip transparent
            blipName = "Greenzone", -- BLIP NAME | Set blip name
            changeBucket = true, -- True/false  whether the player is to be hidden in the bucket | You can set bucket from 0 to 2147483647 | Set to 0 to not change the bucket
            routingBucket = 0 -- You can set "random" for random bucket or number of bucket example: routingBucket = 24 works only if changeBucket is set to true
        },
        ["masle1"] = {
            coords = vector3(33.63, -444.21, 20.8), --Grove Street
            colors = { -- RGB Colors
                r = 2,
                g = 255,
                b = 255,
                a = 0.3 -- From 0.0 to 1.0
            },
            radius = 60.0, -- Radius for greenzone
            blip = true,
            blipType = "radius", --RADIUS/NORMAL
            blipRadius = 60.0, -- BLIP RADIUS | Set the same radius as above or different
            blipSprite = 438, --BLIP SPRITE | List of all blips https://docs.fivem.net/docs/game-references/blips/
            blipColor = 42, --BLIP COLOR | List of all colors https://docs.fivem.net/docs/game-references/blips/
            blipAlpha = 222, --BLIP ALPHA | Set blip transparent
            blipName = "Greenzone", -- BLIP NAME | Set blip name
            changeBucket = true, -- True/false  whether the player is to be hidden in the bucket | You can set bucket from 0 to 2147483647 | Set to 0 to not change the bucket
            routingBucket = "random" -- You can set "random" for random bucket or number of bucket example: routingBucket = 24 works only if changeBucket is set to true
        }
    }
}