
# To-Do (for Saturday)

* Put all graphics in the game! ( + properly flip_h enemies based on where they're looking + rotate bullet sideways to match flight angle)
* Tutorial: Code and display
* Create resource for all enemies + elements => assign correct frame and properties => make wave spawner use these properly
  * Only select a subset per round. Don't spawn any enemies that can only be killed by elements that are not in the level. Also don't _display_ weaknesses/distractions that aren't in the current run.

CRUCIAL FIXES:
* Enable the "recolor all" (if inside entered) thing again, check if fun
* @TODO: clear indication/progress on the heart loading up for shooting
* @TODO: protection against going out of bounds
* @TODO: Don't make the tree gun too overpowered now; the flowers themselves should be far stronger and lead to _longer_ distractions or _instakills_
* RadiusViewer => update whenever radius of col_shape changes
  * Need to set this properly from EnemyType first => then call signal

PROGRESSION:
* Actually create menu + game over screen + spawner progression
  * Spawner should display a simple graphic with new enemies unlocked + their description?
* Track which rules are unlocked (roguelite things) + obviously give players the options to choose stuff between waves or something. IDEAS:
  * "Things dropped here change into type X"
  * "Kill/Sight radius changes by Y"
  * "Damage/Health changes by Z"
  * The ProgData should return a _modified_ version of rules that mediates between int/ext and progression => It multiplies all factors, and makes booleans true if at least one is true

**Check all the ideas below.** If they can be simple _progression tweaks_, I can add them as an option. Otherwise, they must be put on the "future to-do" and completely ignored.

POLISHING:
* Finetune all the data (speed, monsters, health, wave progression, etcetera)
* Sound effects everywhere
* Some animations and particles, if possible.
* ENSURE YOU'RE GROWING STRONGER TOO (as the waves grow stronger)

# To-Do (for Sunday)

* Go back to polishing the rowing game _enough_ to perhaps submit that.
* Let this game be finished and tested.

# To-Do (for Monday)

* Merely create the page and simple marketing, decide which one to send in.
* Most of the day should be free.






@IDEA (UNRELATED, BUT REALLY GOOD): That idea of local multiplayer Olympic games, with all of them "simplified" and "partified". For example: any solo/take-turns sports now just _happen together_.
* Spear throwing? You're all throwing at the same time.
* There's a time limit. If you want to have the most tries, you need to walk into the field and collect your spear, and hope nobody spears you (which is death = long timeout) in the mean time.
* And the mechanics for throwing are always just the same few buttons.
* ("Olympigs?" "The Olyfantic Flames!" => tie into that Saga of Life idea, or that general story idea I had.)

* Hockey? You're just a blob with a huge stick and huge feet. The only rule we're really copying is that you get penalized for getting hit on your foot.

* Rowing? It's about sharing a boat, pressing buttons at the right time to go forward (with most speed). Mis-timing means you go sideways, as expected, which can be bad (penalty for going out of bounds etcetera) or good (you're able to grab some powerups or avoid some collision before you)
  * The most powerful feature here would be that you are "locked" in your direction for X time, because paddling needs a recharge. This makes movement unique and strategic. 




## Next



Articles

* Write that article about "for every rule/system you invent, think about what it does or doesn't say to the player. Make sure it says the right things (don't be passive), but also that there's variety (no one strategy to rule them all)"
* Write that article about why Bombgoggles ... bombed in that jam, what I learned from that and how I improved it.
* Write about "the problem of dreamshrink" => halfway any project, you have to realize that most of the possibilities/opportunities/ideas will not be done, and pick the one fixed/final path the project will head into. Always the hardest part, as if getting nostalgic for a game you never made.


BEE => Change to "Jack of all flowers, damaged by none." => That's a great simple first enemy, while reinforcing the need for some secondary mechanic to destroy monsters

* @IDEA: Certain monsters _drop_ stuff too, that you can then use (or must avoid)
  * It feels like the "medicine" for the heart should be _changing_, otherwise one specific element will always be way more important.

RULE: Poisonous is probably always a SUBSET of distractions => we show the distractions, then highlight those that are poisonous

@IDEA: Some areas are "highlighted" or "boosted" / "weakened" at random? (Can just draw a border around them or make them more transparent.) This changes the health/damage of all your flowers there.

@IDEA: If we want to easily support multiplayer, we should just start half inside and half outside. But allow easy ways (or a common powerup/curse/whatever, maybe every wave) to _switch places_.

@IDEA: We _can_ go the route of giving a health module to players, creating a "I need to risk getting close to distract them, but that risks me getting hurt" => but if we remove the Heart, well, there is no reason to distract/kill monsters in the first place :p => Nah, if we do this, it should really be a special monster/mechanic that comes _later_. (Maybe at wave 10, you can pick some option like "All monsters are 10% slower and weaker, but your player character has health and can die too.")

@IDEA: When you go inside, you _eat/consume_ your current elements? (Or you eat all plants that are there? Inside INVERTS the process => you pick up plants and spit out seeds?) => So you must choose whether you want to use a certain element to distract/kill monsters, or to give yourself a benefit now.

@IDEA: You have to break entities/things _out_ of these ice blocks? (Or jails because they're surrounded by stones/hedges/ice blocks?) So maybe there are helpers standing nearby, but you must take time out of fighting the waves to keep breaking them out?
=> That feels like the SECONDARY MECHANIC: You can make actions happen if you visit something _while_ elements are still converting => you'll just pay whatever element has least to go and make it happen.
=> Maybe INSIDE your timers stop, and that's when you can activate stations to shoot stuff or change the medicine type or whatever.

@IDEA: Some area effect (like a bomb) => I can now easily track which monsters are inside that specific area, and just kill them all at once

@IDEA: Some monsters will also avoid / walk much slower certain areas? And you can _repaint_ / _change_ as you go?
* Maybe EATING a certain plant might poison them/slow them down/or actually speed them up

@IDEA: This might even allow completely FLIPPING the idea, such that the heart is DYING AUTOMATICALLY, and you merely use the monsters to get the MEDICINE for it :p (The monsters don't necessarily attack the Heart, but _you_?)
* **@MONSTER IDEA: Drops Seeds/whatever element upon death.**

* The inside player _purchases new seeds_. They have stations for buying certain elements / making them spawn in certain locations. That's how you must manually make stuff appear, and hopefully in a tactical way.
* There's a moat _between_ the two players, so they literally can't visit each other's spaces. (And that moat can reuse my organic river generation code.) They can pass stuff between them, though, which is a transition that should _matter somehow_.
  * Maybe you can visit/swap places, but you need to both be at the harbor and it takes time.
  * Maybe giving stuff back to the inside is the _only_ way the inner player can get defenses/weapons in case the monsters break through there.
  * Maybe there are bridges to the inside. Destroying/changing those bridges are a crucial part of strategy, but it takes resources/timing/being at the correct station to do so obviously.