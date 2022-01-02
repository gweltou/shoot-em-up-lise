# Prototip Shoot 'Em Up savet el lise

![Game screenshot](/ressources/screenshot_21-12-6.png)

## Project structure
The game is divided in two main parts : a Visual Novel and a Shoot 'em Up. \
Assets, scripts and scenes of each part goes into the `vn` and `seu` folders, respectively.

```
 .
 ├─ vn
 │   ├─ assets
 │   │   └─ (images, sounds, fonts...)
 │   └─ (scripts and scenes)
 └─ seu
     ├─ assets
     │   └─ (images, sounds, fonts...)
     └─ (scripts and scenes)
```

## Shooting bullets

Intanciating a bullet and changing its parameters :
```gdscript
var bullet = Bullet.instance()
bullet.speed = 150
bullet.hitval = -1
```

Below is a list of parameters you can change to change the bullet's behaviour :

`speed` : Flying speed of the bullet (defaults to 100) \
`drag` : Air friction, will slow bullet down if positive (defaults to 0) \
`lifetime` : Bullet will disapear after the specified time (in seconds, defaults to 8s) \
`hitval` : score penalty (if negative) or bonus (if positive) when bullet hits the player \
`size` : scale the size of the bullet (defaults to 1, a size of 2 will double the default size) \
`homing` : bullet will follow player if true (true/false, defaults to false) \
`letter` : bullet will be the specified letter

## Building bullet patterns

To build a pattern, first create a bullet. This bullet will serve as template for the whole pattern. \
The pattern will be automatically added to the game tree when instanciated and will be automatically removed when used. \
For example :

```gdscript
func fivestar_attack():
	var bullet = Bullet.instance()
	bullet.speed = 100
	bullet.hitval = -0.5
	bullet.size = 1.2
	bullet.homing = true
	
	var pattern = StarPattern.new(self, bullet)
	pattern.number = 5
```

For every kind of bullet pattern you have access to those parameters:

`number` : number of bullets to be shot (integer) \
`delay` : delay before start of the pattern (in seconds) \
`aimed` : is the pattern aimed in the direction of the player ? (true/false)

There is 3 kind of pre-built bullet patterns :

### StarPattern
Shoot `number` bullets at the same time, evenly spaced around the thrower.

### FanPattern
Shoot `number` bullets at same time within a sector of `angle_cone` angle (in radian).

```gdscript
# Default values
var angle_cone = PI / 3
```

### SequencePattern
Shoot `number` bullets, one after the other with a interval time of `rate` and with an angle of `angle_step` between each bullet.

```gdscript
# Default values
var rate = 0.2				# Rate of fire (in seconds)
var angle_step = 0.2			# Angle between each bullet
```

## Da ober :
### Kodiñ :
 * Diabarzhañ tresadennoù Loula
 * Krouiñ diazez al lodenn visual novel
 * "Game over" ma ya ar score da 0
 * Krouiñ patternoù diwar menozioù disheñvel
 * Tennañ an taolioù eus al live (tresadenn SVG ha collision shape)
 * Krouiñ ur scene "taol", evit gallout krouiñ levelioù gant dasparzhioù taolioù disheñvel
 * Gallout diviz frekañs an tagadennoù hag hini lizhiri bonus dre variennoù

### Tresañ :
 * **Pa vez treset ur sprite : Arabat "upsamplañ" anezho (brasaat ar resolution). Chomm hep leskel spasoù goulo tro dro.**
 * Ur galon evit diskouez ar buhez(ioù) a chomm
 * Ur sprite simpl evit ar c'helenner (hep animasion, evit gwelet ar ment hag ar style evit kregiñ)

## Menozioù :
 * Ur bullet bonus evit tennañ lizherennoù er baner
 * Implij "buhezioù" ma vez marvet (pa vez ar score da 0), araok kaout un "game over"
 * Un talvoud disheñvel etre pep lizherenn hervez e frekañs

## Bugoù :
 * 
