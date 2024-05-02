--- STEAMODDED HEADER
--- MOD_NAME: Blackboard Test
--- MOD_ID: BlackboardTest
--- MOD_AUTHOR: [Emihead]
--- MOD_DESCRIPTION: Two new suits of a new color to test Blackboard API

----------------------------------------------
------------MOD CODE -------------------------
function SMODS.INIT.BlackboardTest()
    local BlackboardTestmod = SMODS.findModByID('BlackboardTest')
    local sprite_cards_1 = SMODS.Sprite:new('bbt_cards_1', BlackboardTestmod.path, '8BitDeck.png', 71, 95, 'asset_atli')
    local sprite_cards_2 = SMODS.Sprite:new('bbt_cards_2', BlackboardTestmod.path, '8BitDeck_opt2.png', 71, 95,
        'asset_atli')
    local sprite_ui_1 = SMODS.Sprite:new('bbt_ui_1', BlackboardTestmod.path, 'ui_assets.png', 18, 18, 'asset_atli')
    local sprite_ui_2 = SMODS.Sprite:new('bbt_ui_2', BlackboardTestmod.path, 'ui_assets_opt2.png', 18, 18, 'asset_atli')
    sprite_cards_1:register()
    sprite_cards_2:register()
    sprite_ui_1:register()
    sprite_ui_2:register()
    -- function SMODS.Card:new_suit(name, card_atlas_low_contrast, card_atlas_high_contrast, card_pos, ui_atlas_low_contrast, ui_atlas_high_contrast, ui_pos, colour_low_contrast, colour_high_contrast)
    SMODS.Card:new_suit('Leprechauns', 'bbt_cards_1', 'bbt_cards_2', { y = 1 }, 'bbt_ui_1', 'bbt_ui_2',
        { x = 1, y = 0 }, '68BC9A', '68BC9A')
    SMODS.Card:new_suit('Gays', 'bbt_cards_1', 'bbt_cards_2', { y = 0 }, 'bbt_ui_1', 'bbt_ui_2',
        { x = 0, y = 0 }, '8A71E1', '8A71E1')

    new_suit_color("rainbow",true)
    define_suit_color("Gays", "rainbow")
    define_suit_color("Leprechauns", "rainbow")

    SMODS.Sprite:new("j_colorful", BlackboardTestmod.path, "j_colorful.png", 71, 95, "asset_atli"):register();

    SMODS.Joker:new("Colorful Joker", "colorful", {extra = 50}, {x = 0, y = 0}, {
        name = 'Colorful Joker',
        text = {
            'When a card with a',
            '{C:attention}rainbow{} suit is scored',
            '{C:chips}+#1#{} Chips'
        }
    }, 1, 5):register()

    function SMODS.Jokers.j_colorful.loc_def(card)
        return {card.ability.extra}
    end

    SMODS.Jokers.j_colorful.calculate = function(self, context)
        if context.individual and context.cardarea == G.play then
            for k,v in ipairs(G.suitcolors.colors["rainbow"]) do
                if context.other_card:is_suit(v) then
                        return {
                            chips = self.ability.extra,
                            card = self
                        }
                end
            end
        end
    end

end

----------------------------------------------
------------MOD CODE END---------------------
