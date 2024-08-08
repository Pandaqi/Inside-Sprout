
# To-Do

* PLAYER
  * Way faster
  * Show what holding + time until drop
* MONSTERS:
  * Make monsters pause a little while removing an Element ( => again modifiable through their resource)
  * Display their distraction + poisonous types
* ELEMENTS:
  * Draw some simple images for that so I can see what the hell I'm even doing.
* SPAWNING:
  * Don't spawn the Heart anywhere near the edge
  * Create a variant that draws a random position from _cells_ as input
    * Allow giving a "forbidden_cells" data => so we can query a random position while ignoring, for example, all Heart areas/Inside cells
* TRY ALL SORTS OF RULES TWEAKS TO MAKE IT FUN.


## Next

Further work:

* The "Inside" area can just be a MapArea again, but this time we feed it all the cells of the smaller areas it contains. (OR BETTER: make built-in functionality to do this, after feeding it just the areas itself) => Once this is figured out, make the option to assign "inside"
  * Which would just be the area(s) around Hearts, right?
  * And maybe regrowing those ice blocks/healing the heart just means dropping the element in the same area as a Heart?
* I need to use this INSIDE/OUTSIDE or BUY SEEDS YOURSELF to grow your own strength over time, otherwise there's no way you're prepared for harder waves.
  * NO, WAIT, PLANTS OBVIOUSLY STAY. (You can't move them again.) So the better you do in one wave, the better you'll also be prepared the next one.
* Certain monsters _drop_ stuff too, that you can then use (or must avoid)
  * It feels like the "medicine" for the heart should be _changing_, otherwise one specific element will always be way more important.
  * And it feels like the player should have a _tiny_ bit of interaction possible with the enemies, otherwise it's all too "indirect"
* Health module for players?
* Progression: Track which rules are unlocked (roguelite things) + obviously give players the options to choose stuff between waves or something.



RULE: Poisonous is probably always a SUBSET of distractions => we show the distractions, then highlight those that are poisonous



@IDEA: When you go inside, you _eat_ your current elements? (Or you eat all plants that are there? Inside INVERTS the process => you pick up plants and spit out seeds?) => So you must choose whether you want to use a certain element to distract/kill monsters, or to give yourself a benefit now.

@IDEA: Elements have Health too? Some can take X monsters before they die.

@IDEA: You start with lots of "ice blocks" or something around your Heart. These are randomly distributed, so some paths to the Heart are shorter than others => whenever a monster bumps into one, it will chip the ice away until completely gone.

@IDEA: You have to break entities/things _out_ of these ice blocks? (Or jails because they're surrounded by stones/ice blocks?) So maybe there are helpers standing nearby, but you must take time out of fighting the waves to keep breaking them out?
=> That feels like the SECONDARY MECHANIC: You can make actions happen if you visit something _while_ elements are still converting => you'll just pay whatever element has least to go and make it happen.
=> Maybe INSIDE your timers stop, and that's when you can activate stations to shoot stuff or change the medicine type or whatever.


@IDEA: Some monsters will also avoid / walk much slower certain areas? And you can _repaint_ / _change_ as you go?

@IDEA: There _is_ an inner circle. (A random set of polygons from the center is combined into one group to form the center.) Going there, lots of stuff doesn't work (no conversions, no pick up, etcetera). But you walk really fast and can do other stuff you might sometimes need, such as fight or heal the heart (by dropping the right element in that inside area.)
* This might even allow completely FLIPPING the idea, such that the heart is DYING AUTOMATICALLY, and you merely use the monsters to get the MEDICINE for it :p (The monsters don't necessarily attack the Heart, but _you_?)

* The inside player _purchases new seeds_. They have stations for buying certain elements / making them spawn in certain locations. That's how you must manually make stuff appear, and hopefully in a tactical way.
* There's a moat _between_ the two players, so they literally can't visit each other's spaces. (And that moat can reuse my organic river generation code.) They can pass stuff between them, though, which is a transition that should _matter somehow_.
  * Maybe you can visit/swap places, but you need to both be at the harbor and it takes time.
  * Maybe giving stuff back to the inside is the _only_ way the inner player can get defenses/weapons in case the monsters break through there.
  * Maybe there are bridges to the inside. Destroying/changing those bridges are a crucial part of strategy, but it takes resources/timing/being at the correct station to do so obviously.