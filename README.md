# BlackboardAPI

This mod lets you define "color" attributes for modded suits. Like the name implies, this is so you can have Jokers with Blackboard-esque effects without having to handle every suit manually.
There are two default colors: light (Hearts and Diamonds) and dark (Spades and Clubs). However, there is functionality for creating new colors if you so wish.
This mod also takes ownership of Blackboard itself and changes it to check for all "dark" colored suits rather than specifically Spades and Clubs.

###Important notes

- This does not affect Smeared Joker. It was going to but an incompatibility with SixSuits arose in how it detects Spectrums. If you want to have your suits affected by Smeared Joker then try hooking into the `is_suit` function and defining pairs similar to how it's done in the base game.
- Any features in your mod that depend on this should check if the mod exists first, obviously.

## Compatibility for suits

By default, this mod is compatible with Stars and Moons from SixSuits as well as Fleurons and Halberds from Bunco.
Adding your own compatibility is not too hard, though.

### new_suit_color(color, blackboard_liked)
This function allows you to create a new type of color that suits can be assigned to.
- **color**: String. The name of your color. Must be lowercase.
- **blackboard_liked**: Boolean. Setting this to true will make Blackboard count this color.

### define_suit_color(suitname, color)
Use this function to assign a suit to a color.
- **suit**: String. The name of the suit. Must be in title case (first letter capitalized).
- **color**: String. The name of your color. Must be lowercase.

## Using color for effects

This mod has several tables for storing info about suits and colors. You can pull info from these tables for your Jokers and stuff.

- **G.suitcolors.colorlist** - Contains the names of all the colors as strings. The new_suit_color function will add your color to this table.
- **G.suitcolors.colors.\["colorname"\]** - These tables contain the names of all the suits of that color as strings. By default, there is **G.suitcolors.colors.light** and **G.suitcolors.colors.dark**. The new_suit_color function will create one of these tables for your color automatically. The define_suit_color function will add your suit to the chosen color.
- **G.suitcolors.blackboard_liked** - This contains the names of all the suits that are accepted by Blackboard. You probably won't need this but you might want it if you want your joker to respond to the exact same suits as Blackboard does. Your color will be added to this by the new_suit_color function if blackboard_liked is true.
- **G.localization.descriptions.Other\["colorsuits"\]** - These localization tables contain tooltip data for each color, which will allow you to add tooltips to your jokers showing exactly what suits they'll apply to if they interact with an entire color. A table will be automatically created and added to with use of the earlier functions. The key is the name of your color with `suits` added to the end; so if you make a color called `medium`, the table can be accessed at `G.localization.descriptions.Other["mediumsuits"]`.

### Examples

Creating 3 suits, creating a new color, and assigning 1 suit to light, 1 to dark, and 1 to the new color:
```
(register your suits here)

new_suit_color("medium",true)
define_suit_color("Suit1", "light")
define_suit_color("Suit2", "dark")
define_suit_color("Suit3", "medium")
```
On its own, this will make it so that Suit2 is accepted by Blackboard, and Suit3 is accepted as well due to the `medium` color having `blackboard_liked` set to true.
There are no vanilla effects that use the `light` color but it's good to assign your suits to it regardless in case a mod wants to.

Creating a Joker that gives chips when a certain color is scored:
```
(register your joker here)

SMODS.Jokers.j_example.calculate = function(self, context)
    if context.individual and context.cardarea == G.play then
        for k,v in ipairs(G.suitcolors.colors["medium"]) do
            if context.other_card:is_suit(v) then
                    return {
                        chips = 50,
                        card = self
                    }
            end
        end
    end
end
```
This joker will give 50 chips when a suit in the `medium` color is played. This should serve as an example of how to check if a card's suit matches a specific color.

Giving a Joker a tooltip showing what suits are included in a color:
```
function SMODS.Jokers.j_example.tooltip(card, info_queue)
    info_queue[#info_queue+1]= {key = "mediumsuits", set = 'Other'}
end
```
This is a very simple example that will only show 1 specific color.
