
# To-Do (for Thursday)

* Write that article about "for every rule/system you invent, think about what it does or doesn't say to the player. Make sure it says the right things (don't be passive), but also that there's variety (no one strategy to rule them all)"
* PLAYER
  * Show what holding + time until drop
* ELEMENTS:
  * Draw some simple images for that so I can see what the hell I'm even doing.
* INSIDE/OUTSIDE
  * Allow marking as such. (Draw lines in _draw() for now to mark it) => 
    * MapAreaGroup, with shared functionality either being a tool or extending the base class
    * Yes, and this group only knows its _areas_ (and the areas know the groups they're in), so we can easily find connected stuff both ways
  * Track in which state you are on the MapTracker.
  * Create simple "recolor" function for all areas (separate it from the generation where it's now)
  * Implement the simple rules of "timers don't extend here", or "you drop everything immediately", or "you move much faster", or "things dropped here heal the heart", or "things dropped here change into type X" (which would be "bullets" for some machine later)
    * I should probably just have an "InsideRuleSet" and "OutsideRuleSet" with the modifications built-in => these are part of a general RuleSet resource that _could_ be reused for global roguelite unlocks

* TRY ALL SORTS OF RULES TWEAKS TO MAKE IT FUN.


TUTORIAL STEPS FOR NOW: 
* Defend the Treeheart!
* If you pick up seeds, they drop a few seconds later. Where you're standing at that moment determines the flower they become.
* Enemies are distracted and/or damaged by certain flowers (displayed on their body).
* If you drop seeds _inside_ the Heart chamber, they become bullets for the Treegun---a different path to defending nature ;)
  * @TODO: Perhaps the Heart is simply one version/subclass of "Machines", so I can easily implement the ideas for different machines that are only placed and operated when _inside_.
  * @TODO: Re-use the outline algorithm to determine the edges for "inside", then place hedges or whatever there to create a building naturally.
  * @ALTERNATIVE: If dropped inside the Treeheart chamber, they heal the Heart a little bit.
  * YES YES YES: because close to the heart ("inside"), your elements don't work, you _have_ to go further away and plant them there to defeat monsters.
  * 


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
* Progression: Track which rules are unlocked (roguelite things) + obviously give players the options to choose stuff between waves or something.
* A debug method for the sight/kill area of enemies; reuse that dotted line shader. (Should probably fade these in/out for players to see.)

BEE => Change to "Jack of all flowers, damaged by none." => That's a great simple first enemy, while reinforcing the need for some secondary mechanic to destroy monsters


RULE: Poisonous is probably always a SUBSET of distractions => we show the distractions, then highlight those that are poisonous

@IDEA: If we want to easily support multiplayer, we should just start half inside and half outside. But allow easy ways (or a common powerup/curse/whatever, maybe every wave) to _switch places_.

@IDEA: We _can_ go the route of giving a health module to players, creating a "I need to risk getting close to distract them, but that risks me getting hurt" => but if we remove the Heart, well, there is no reason to distract/kill monsters in the first place :p

@IDEA: When you go inside, you _eat/consume_ your current elements? (Or you eat all plants that are there? Inside INVERTS the process => you pick up plants and spit out seeds?) => So you must choose whether you want to use a certain element to distract/kill monsters, or to give yourself a benefit now.

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