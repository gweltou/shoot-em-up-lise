Prototip Shoot 'Em Up savet el lise

## Shooting bullets


## Building bullet patterns
There is 3 kind of bullet patterns pre-built :

### StarPattern
Shoot `number` bullets at the same time, evenly spaced around the thrower.

### FanPattern
Shoot `number` bullets at same time within a sector of `angle_spread` angle.

### SequencePattern
Shoot `number` bullets, one after the other with a interval time of `rate` and with an angle of `angle_step` between each bullet.

```gdscript
# Default values
var rate = 0.2					# Rate of fire (in seconds)
var angle_step = 0.2				# Angle between each bullet
```

## Da ober :
 * Diabarzhañ tresadennoù Loula
 * Gortoz ur pennadig amzer random etre pep fiñv ar c'helenner
 * Krouiñ patternoù diwar menozioù disheñvel
 * Tennañ an taolioù eus al live (tresadenn SVG ha collision shape)
 * Krouiñ ur scene "taol"
 * Gallout diviz frekañs an tagadennoù hag hini lizhiri bonus dre variennoù
 * Krouiñ al lodenn visual novel
