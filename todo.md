

# To-Do (for Sunday)

INSIDE SPROUT:
* Probably want a little bit faster conversions? (Or does that ruin the idea of the game?) => Shouldn't they be displayed much higher on the player?
* Ugh, seems like the web build will not properly show characters not in the font.



ADVANCE FINSIDE OUT:
* Water current fix => With that, we can make swimming much slower, to stop it from being too big of an advantage
* The absolutely necessary graphics
  * For the menus and game over
  * For stuff in the game
* Create Health+ powerup (remove the _mass one)
* Create tutorial to explain how the game even works.
* I should write a list of SFX/Particles/Juice, but not actually do it.

At the end of the day, I want _both_ entries submittable.

# To-Do (for Monday)

* Merely create the page and simple marketing, decide which one to send in.
* Most of the day should be free.



## Collision Layers

1 = Everything, but player doesn't check against that (so it doesn't bump into anything)
2 = Hedges
3 = Map Bounds (checked by player to prevent them going out of bounds)


# Future To-Do

## Crucial for proper release

**Major: Implement multiplayer** => spawn multiple players, scale map size, input select screen.

**Major: Animate** => we probably want flowers to actually grow, enemies to actually walk/fly, etcetera.

**Major: Save Game & More Customization** => such as choosing what you want to include, actually modifying the map in some way as you go, more machines, etcetera

## Leftover Rules & Ideas

@IDEA: Certain monsters _drop_ stuff too, that you can then use (or must avoid) => It feels like the "medicine" for the heart should be _changing_, otherwise one specific element will always be way more important.

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

* The inside player _purchases new seeds_. They have stations for buying certain elements / making them spawn in certain locations. That's how you must manually make stuff appear, and hopefully in a tactical way.
* There's a moat _between_ the two players, so they literally can't visit each other's spaces. (And that moat can reuse my organic river generation code.) They can pass stuff between them, though, which is a transition that should _matter somehow_.
  * Maybe you can visit/swap places, but you need to both be at the harbor and it takes time.
  * Maybe giving stuff back to the inside is the _only_ way the inner player can get defenses/weapons in case the monsters break through there.
  * Maybe there are bridges to the inside. Destroying/changing those bridges are a crucial part of strategy, but it takes resources/timing/being at the correct station to do so obviously.

## Leftover polishing

Sound: Walking? Flower noticed?

# Library

## Rulesets / Progression

The specific percentages/values are just random guesses and will surely have changed on the fly.

* [x] "All entities move with 10% less speed."
* [x] "All entities move with 10% more speed."
* [x] "All enemies have 10% less speed."
* [x] "All flowers have 10% more health."
* [x] "Seeds convert 10% slower."
* [x] "Seeds convert 10% faster."
* [x] "Waves take 10% more time (to spread out their units)."
* [x] "Waves have 10% fewer units."
* [x] "Enemies have a 15% smaller sight range."
* [x] "Enemies have a 10% larger sight range."
* [x] "Enemies attack 10% slower."
* [x] "Enemies do 10% less damage."
* [x] "New seeds spawn 10% faster." (this really raises the bounds too?)
* [x] "Dropping Inside also heals the heart a tiny bit."
* [x] "The Treeheart fires bullets 15% faster."
* [x] "Bullets do 20% more damage before disappearing."
* [x] "Dropping Inside regrows one hedge."
* [x] "Monsters randomly drop seeds when they die."
* [x] "Monsters don't spawn anymore at the top edge."
* [x] "Monsters don't spawn anymore at the bottom edge."
* [x] "Players have 10% more speed."
* [x] "When entering Inside, all areas change colors."
* [x] "Flowers do 15% more damage."


## Enemies


Strength 1 Enemies: Bee, Butterfly, Sunbird (mostly flying ones)
Strength 2 Enemies: Bat, Mole, Pig, Giraffe
Strength 3 Enemies: Rabbit, Caterpillar, Moth
Strength 4 Enemies: Deer, Vole

### Bee (0)

* STRENGTH: 1
* DESC: "A very average animal for an easy time, hopefully."
* DISTRACT: Rose, Grass => DISTRACT ALL just isn't a fun way to start the game

### Mole (1)

* STRENGTH: 2
* DESC: "Slow and sees little, but hard to kill."
* DISTRACT: Dandelion, Sunflower
* MINUS: Speed, SightRange, KillRange
* PLUS: Health, Shield

### Pig (2)

* STRENGTH: 2
* DESC: "Powerful and hard to kill, but many ways to distract."
* DISTRACT: Sunflower, Tulip, Grass, Ginger
* PLUS: Damage, Shield, SightRange(?)
* MINUS: AttackDelay(?)

### Rabbit (3)

* STRENGTH: 3
* DESC: "Moves in sudden jumps."
* DISTRACT: Grass, Dandelion
* SPECIALTY: JumpMover => @TODO: assign


### Deer (4)

* STRENGTH: 3
* DESC: "High health and damage, but slow and attacks take a long time."
* DISTRACT: Dandelion, Tulip
* PLUS: Health, Damage
* MINUS: Delay, Speed

### Vole (5)

* STRENGTH: 4
* DESC: "Completely ignores flowers, but otherwise weak."
* DISTRACT: None
* PLUS: Speed, Delay
* MINUS: Health, Damage


### Caterpillar (6)

* STRENGTH: 3
* DESC: "Distracted by all flowers, damaged by none."
* DISTRACT: All
* WEAK: None


### Butterfly (7)

* STRENGTH: 1
* DESC: "A slow animal that takes its sweet time attacking."
* DISTRACT: Rose, Dandelion, Tulip
* MIN: Speed
* PLUS: Delay

### Sunbird (8)

* STRENGTH: 1
* DESC: "Has a very wide range, but low health and damage."
* DISTRACT: Sunflower, Grass, Ginger
* PLUS: SightRange, KillRange
* MIN: Damage, Health

### Moth (9)

* STRENGTH: 4
* DESC: "Fast, ruthless, hard to distract, but fortunately low health."
* DISTRACT: Sunflower
* PLUS: Speed, Damage, SightRange
* MINUS: Health

### Bat (10)

* STRENGTH: 2
* DESC: "A fast animal with very strict requirements."
* DISTRACT: Rose
* PLUS: Speed
* MIN: Delay

### Giraffe (11)

* STRENGTH: 2
* DESC: "Huge sight and kill range."
* DISTRACT: Rose, Ginger
* PLUS: SightRange, KillRange


# Plants

I could've given special properties to each plant, but ran out of time. (And saw no good way to _explain/communicate_ these.)

* Rose
* Dandelion
* Sunflower
* Tulip
* Grass
* Ginger


