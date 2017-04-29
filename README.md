STGL (ShooTing Game Language)
======================
= language to define the action of the ACTORs in the 2D shooting game.

[Try in the browser](http://abagames.sakura.ne.jp/stgl/ "STGL demo")

# Language reference

## ACTOR and FUNCTION

### ACTOR
= object such as the bullet, turret, enemy or stage-pattern controlled by the FUNCTION.

### FUNCTION
= composed of the FUNCTION_NAME, FUNCTION_ARGUMENTs and the SCRIPT described in the indentation block.

##### [format]
```
FUNCTION_NAME FUNCTION_ARGUMENT, FUNCTION_ARGUMENT, ...
        SCRIPT
```

##### [example]
```
straightBullet a, s
        @angle = a
        @speed = s
```

### SCRIPT
= sequcence of COMMANDs (e.g. fire the bullet, vanish in certain timing, change the position, angle or speed) to control the ACTOR.

### COMMAND
= composed of the COMMAND_NAME and COMMAND_ARGUMENTs.

##### [format]
```
COMMAND_NAME COMMAND_ARGUMENT, COMMAND_ARGUMENT, ...
```

##### [example]
```
straightBullet 90, 0.02
vanish
@y += 0.01
```

### COMMAND_NAME
= one of below-listed strings.

##### [command name list]
* VARIABLE =	(set)
* VARIABLE +=	(incrementBy)
* VARIABLE -=	(decrementBy)
* VARIABLE <=	(set the steady-state value)
* VARIABLE <+=	(set the steady-state increment value)
* VARIABLE <-=	(set the steady-state decrement value)
* VARIABLE =>	(set the target value)
* vanish		(vanish the ACTOR)
* wait		(wait executing the SCRIPT)
* waitUntil	(wait executing the SCRIPT conditionally)
* notify		(suspend the waiting state of other ACTORs)
* repeat		(repeat the CHILD_SCRIPT)
* while		(repeat the CHILD_SCRIPT conditionally)
* FUNCTION_NAME	(add another ACTOR)

#### VARIABLE = VALUE
= set the VALUE to the VARIABLE (e.g. position, angle or speed of this ACTOR).

##### [example]

```
@x = 0.2
```

#### VARIABLE += VALUE
= increment the VARIABLE by the VALUE.

##### [example]

```
@speed += 0.1
```

#### VARIABLE -= VALUE
= decrement the VARIABLE by the VALUE.

#### VARIABLE <= VALUE
= set the VALUE to VARIABLE every frame.

##### [example]

```
@x <= cos(@y * 0.001) * 0.4 + 0.5
```

(means the value of VARIABLE @x is set to the calculation result of the expression 'cos(@y * 0.001) * 0.4 + 0.5' every frame)

#### VARIABLE <+= VALUE
= increment the VARIABLE by the VALUE every frame.

##### [example]

```
@x <+= 0.01
```

(increments the value of the VARIABLE @x by 0.01 every frame)

#### VARIABLE <-= VALUE
= decrement the VARIABLE by the VALUE every frame.

#### VARIABLE => VALUE, VALUE(2)
= set the VALUE to the VARIABLE in a time span of VALUE(2) frames (1 frame = 1/60 sec.).

##### [example]

```
@y => 0.5, 120
```

(means the value of the VARIABLE @y changes from the current value to 0.5 linearly in a time span of 120 frames)

#### vanish
= vanish this actor.

#### vanish FUNCTION_NAME
= vanish CHILD_ACTORs having the FUNCTION_NAME.

(CHILD_ACTOR = ACTORs added by this ACTOR.)

#### wait {VALUE = $inf}
= wait executing the SCRIPT for VALUE frames.

{COMMAND_ARGUMENT = default value} = optional argument having the default value.

#### waitUntil {VALUE = 0}
= wait until VALUE becomes 1 (true).

#### notify
= suspend the waiting state of the PARENT_ACTOR.

#### notify FUNCTION_NAME
= suspend the waiting state of the CHILD_ACTOR having the FUNCTION_NAME.

(PARENT_ACTOR = ACTOR added this ACTOR.)

#### repeat {VALUE = $inf}
= repeat the CHILD_SCRIPT VALUE times.

(CHILD_SCRIPT= indentation blocks after the COMMAND.)

##### [example]

```
repeat 10
        fire a, s
        a += av / 10
        s += sv / 10
```

(SCRIPT from 'fire a, s' to 's += sv / 10' is the CHILD_SCRIPT)

#### while {VALUE = 1}
= repeat the CHILD_SCRIPT until VALUE becomes 0 (false).

#### FUNCTION_NAME FUNCTION_ARGUMENT_VALUE, FUNCTION_ARGUMENT_VALUE, ...
= add another ACTOR controlled by the FUNCTION corresponding the FUNCTION_NAME with FUNCTION_ARGUMENT_VALUEs.

##### [example]

```
waveEnemy
        @x <= cos(@y * 800) * 0.4 + 0.5
        @y <+= 0.003
        repeat
                downwardBullet 0.02
                wait 30
downwardBullet s
        @angle = 0
        @speed = s
```

(means the 'waveEnemy' fires the 'downwardBullet' every 30 frames)


## VARIABLE and VALUE

### VARIABLE
= below-listed actor variable or string represents the user defined variable.

##### [actor variable]
* @x	        (x-coordinate of the position of this ACTOR) (=0 means the left edge of the screen, =1 means the right edge)
* @y	        (y-coordinate of the position of this ACTOR) (=0 means top, =1 means bottom)
* @angle	(direction of movement of this ACTOR) (=0 means downward, =90 means rightward, =180 means upward, =270 means leftward)
* @speed	(speed of movement of this ACTOR)

##### [example]

```
@speed
a
appFlag1
```

### VALUE
= float value, VARIABLE, below-listed read-only variable or expression consists of OPERATORS and VALUEs.

##### [read-only variable]
* $playerX, $px			(x-coordinate of the position of the PLAYER)
* $playerY, $py			(y-coordinate of the position of the PLAYER)
* $enemyCount, $ec		(total numbers of enemies on the screen)
* $angleToPlayer, $atp		(angle from this ACTOR to the PLAYER)
* $distanceToPlayer, $dtp	(distance from this ACTOR to the PLAYER)
* $ticks, $t			(frame ticks from this ACTOR is generated)
* $parentX, $prx		(x-coordinate of the position of the PARENT_ACTOR)
* $parentY, $pry		(y-coordinate of the position of the PARENT_ACTOR)
* $infinity, $inf		(infinite value)

##### [example]

```
-4.2
@angle + 180
$playerY < 0.5 ? -1 : 1
```

(PLAYER = object controlled by the player (e.g. my ship, tank or fighter))

### OPERATORS
= operators to calc the float value. 

##### [operators]
* +, -, *, /, %		(Arithmetic operations)
* V1..V2		(Get a random integer value from V1 to V2)
* V1__V2		(Get a random float value from V1 to V2)
* V1|V2			(Get V1 or V2 fifty-fifty)
* ==, !=, >, >=, <, <=	(Comparison operations) (1 means true, 0 means false)
* !, &&, ||		(Logical operations)
* ? :			(Conditional operator)
* ()			(Bracket)
* sin(), cos()		(Trigonometric function)

## ACTOR_TYPE, COMMENT and MAIN_FUNCTION

### ACTOR_TYPE
= described in front of FUNCTIONs of stage, enemy, turret or bullet ACTORs.

##### [actor type]
* :stage	(sets up enemies in the stage)
* :enemy	(moves on the game screen and fires bullets)
* :turret	(moves together with the enemy and fires bullets)
* :bullet	(is fired toward the PLAYER)

### COMMENT
= characters after '#'.

##### [example]

```
wait 2 # this is a comment.
```

### MAIN_FUNCTION
= bootstrap FUNCTION.

##### [example]

```
main
        addWaves 10
```

License
----------
Copyright &copy; 2013 ABA Games

Distributed under the [MIT License][MIT].

[MIT]: http://www.opensource.org/licenses/mit-license.php
