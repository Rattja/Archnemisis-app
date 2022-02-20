# Archnemisis-app
PoE Archnemisis tracking tool for Archnemisis mods.

Features:

- When mousing over a mod, all other places that mod is used will light up yellow. There will also be a panel in the left bottom corner, showing description and rewards for that mod.

- When mousing over a Tier 1 mod that can drop, a tooltip will list all the maps it is likely to drop in based on information gathered from this post:

https://www.reddit.com/r/pathofexile/comments/srtuug/i_made_a_sheet_for_archnemesis_drop_locations

Do note that map modifiers may change the possible drops, so this is not guaranteed, it's more like a general guideline. The post above explains more in detail how this works.

- Left click to increase mod count by 1, right click to decrease by 1. It does not matter which one you click, the mods are linked and follow each other.

- Once a recipe is able to be crafted, the border will light up.

- You can search for mod names or reward types in the search field, and matches will light up green. Ctrl+F can be used to go directly to search.

- You can grab the mod name by mousing over a mod and pressing Ctrl+C, or the whole recipe string by clicking the grab button. This makes it easier to look them up ingame.

- With shift-click you can now quick craft a recipe. It will reduce the count of all parts used by 1.

- Clicking a mod with the middle mouse button will add it to targeted mods and give it a yellow outline.

- The Current amount for tracked mods are stored in a json file and should be located here on Windows: %appdata%\Godot\app_userdata\Archnemesis-git
  If using the old version, it will be under %appdata%\Godot\app_userdata\Archnemesis, simply copy the json file over to migrate.
