--- STEAMODDED HEADER
--- MOD_NAME: BlackboardAPI
--- MOD_ID: BlackboardAPI
--- MOD_AUTHOR: [Emihead]
--- MOD_DESCRIPTION: Lets modded suits be considered "light" or "dark"
--- PRIORITY: -10000

----------------------------------------------
------------MOD CODE -------------------------

function format_localization()
    local key = ""
    local suits = ""
    for k, v in ipairs(G.suitcolors.colorlist) do
        key = G.suitcolors.colorlist[k].."suits"
        G.localization.descriptions.Other[key] = {}
        G.localization.descriptions.Other[key].name = firstToUpper(G.suitcolors.colorlist[k]).." suits"
        G.localization.descriptions.Other[key].text = {}

        for i, w in ipairs(G.suitcolors.colors[v]) do
            if ((i-1) % 2 +1) == 1 then
                suits = w
            else
                suits = suits..", "..w
                table.insert(G.localization.descriptions.Other[key].text, suits)
            end
        end
    end
end

function SMODS.INIT.BlackboardAPI()

    G.suitcolors = {}
    G.suitcolors.colors = {}
    G.suitcolors.colors.light = {"Hearts", "Diamonds"}
    G.suitcolors.colors.dark = {"Spades", "Clubs"}
    G.suitcolors.blackboard_liked = {"dark"}
    G.suitcolors.colorlist = {"light", "dark"}

    G.localization.descriptions.Joker.j_blackboard.text = {
        "{X:red,C:white} X#1# {} Mult if all",
        "cards held in hand",
        "have #2# suits"
    }

    G.localization.descriptions.Other["lightsuits"] = {
        name = "Light suits",
        text = {
            "Hearts",
            "Diamonds"
        }
    }

    G.localization.descriptions.Other["darksuits"] = {
        name = "Dark suits",
        text = {
            "Spades",
            "Clubs"
        }
    }

    if SMODS.findModByID('SixSuits') then
        table.insert(G.suitcolors.colors.light, "Stars")
        table.insert(G.suitcolors.colors.dark, "Moons")
        table.insert(G.localization.descriptions.Other["lightsuits"].text, "Stars")
        table.insert(G.localization.descriptions.Other["darksuits"].text, "Moons")
    end

    if SMODS.findModByID('Bunco') then
        table.insert(G.suitcolors.colors.light, "Fleurons")
        table.insert(G.suitcolors.colors.dark, "Halberds")
        table.insert(G.localization.descriptions.Other["lightsuits"].text, "Fleurons")
        table.insert(G.localization.descriptions.Other["darksuits"].text, "Halberds")
    end

    SMODS.Joker:take_ownership('blackboard'):register()

    format_localization()

    function SMODS.Jokers.j_blackboard.loc_def(card)
        local goodsuits = ""
        local i = 0
            for k,v in ipairs(G.suitcolors.blackboard_liked) do
                if i == 0 then
                    goodsuits = v
                elseif i == 1 then
                    goodsuits = goodsuits.." or "..v
                else
                    goodsuits = v..", "..goodsuits
            end
                i = i + 1
            end
        return {card.ability.extra, goodsuits}
    end

    function SMODS.Jokers.j_blackboard.tooltip(card, info_queue)
        local key = ""
        for k,v in ipairs(G.suitcolors.blackboard_liked) do
            key = v..'suits'
            info_queue[#info_queue+1]= {key = key, set = 'Other'}
        end
    end
    
    SMODS.Jokers.j_blackboard.calculate = function(self, context)
        if context.cardarea == G.jokers and not context.after and not context.before then
            local black_suits, all_cards = 0, 0
            local goodsuits = {}
            for k,v in ipairs(G.suitcolors.blackboard_liked) do
                for l,w in ipairs(G.suitcolors.colors[v]) do
                    table.insert(goodsuits, w)
                end
            end
            for k, v in ipairs(G.hand.cards) do
                all_cards = all_cards + 1
                local done = false
                for i,w in ipairs(goodsuits) do
                    if v:is_suit(w, nil, true) and not done then
                    done = true
                    black_suits = black_suits + 1
                    end
                end
            end
            if black_suits == all_cards then 
                return {
                    message = localize{type='variable',key='a_xmult',vars={self.ability.extra}},
                    Xmult_mod = self.ability.extra
                }
            end
        end
    end
end

function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

function new_suit_color(color, blackboard_liked)
    G.suitcolors.colors[color] = {}
    if blackboard_liked then table.insert(G.suitcolors.blackboard_liked, color) end
    table.insert(G.suitcolors.colorlist, color)
    local key = color.."suits"
    G.localization.descriptions.Other[key] = {
        name = firstToUpper(color).." suits",
        text = {}
    }
end

function define_suit_color(suitname, color)
    table.insert(G.suitcolors.colors[color], suitname)
    local key = color.."suits"
    table.insert(G.localization.descriptions.Other[key].text, suitname)
    format_localization()
end
----------------------------------------------
------------MOD CODE END----------------------
