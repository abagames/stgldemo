package com.abagames.stgldemo;
class Sample {
	public static var s:Array<Array<String>> = [
["fire bullet",
":stage
main
	fire 0, 1"],
["V nway bullet",
":stage
main
	vnway 15, 80
:turret
vnway count, angle
	atp = $angleToPlayer
	oa = 0
	s = 1
	fire atp, s
	rc = count / 2 - 1
	ia = angle / rc
	is = 2 / rc
	repeat rc
		wait 3
		oa += ia
		s += is
		fire atp + oa, s
		fire atp - oa, s"],
["wave bullet",
":stage
main
	repeat 5
		rfBullet -45, 5
		wait 30
		rfBullet 45, -5
		wait 30
:bullet
rfBullet angle, roll
	@angle = angle
	@speed = 1
	a = $angleToPlayer
	repeat 10
		wait 3
		fire a, 1
		a += roll
	vanish"],
["bounce bullet",
":stage
main
	repeat 10
		bnBullet $angleToPlayer
		bnBullet $angleToPlayer - 45
		bnBullet $angleToPlayer + 45
		wait 20
:bullet
bnBullet a
	@angle = a
	@speed = 1
	@angle <+= @x < 0 && @angle < 0 ? (-@angle * 2) : (@x > 1 && @angle > 0 ? (-@angle * 2) : 0)
	wait 480
	vanish"],
["descent bullet",
":stage
main
	repeat 10
		soBullet
		wait 30
:bullet
soBullet
	vx = -0.02__0.02
	@x <+= vx
	vy = 0
	@y <+= vy
	vy <+= 0.0005
	repeat
		fire $angleToPlayer, 1
		wait 10"],
["rusher enemy",
":stage
main
	s = 0.003
	repeat 30
		rusherEnemy s
		s += 0.0007
		wait 60 / (s / 0.003)
:enemy
rusherEnemy s
	@x = 0.1__0.9
	@y = -0.1
	@y <+= s
	repeat
		wait 30
		variableSpeedBullet
:bullet
variableSpeedBullet
	@angle = $angleToPlayer
	@speed = 0.5__1.5"],
["turn enemy",
":stage
main
	repeat 10
		turnEnemy
		wait 60
:enemy
turnEnemy
	@x = 0__1
	@y = 0
	@angle = $angleToPlayer + -10__10
	s = 1__1.5
	@speed = s
	waitUntil @y > $playerY - 0.2
	@speed = 0
	@angle => $angleToPlayer + 180|-180 + -30__30, 15
	wait 15
	fire $angleToPlayer, 1
	@speed = s * 2"],
["explode enemy",
":stage
main
	gzkt
:enemy
gzkt
	@x = 0.1__0.9
	@y = -0.1
	@y <+= 0.015
	wait 30
	a = 0
	repeat 16
		fire a, 2
		a += 360 / 16
	repeat 4
		homing a
		a += 360 / 4
	vanish
:bullet
homing a
	vx = sin(a) * 0.01
	vy = cos(a) * 0.01
	@x <+= vx
	@y <+= vy
	vx <+= ($px - @x) * 0.003
	vy <+= ($py - @y) * 0.003"],
["turn 90 enemy",
":stage
main
	repeat 20
		t90Enemy 0.015
		wait 30
:enemy
t90Enemy s
	@x = 0.1__0.9
	@y = -0.1
	@y <+= s
	waitUntil @y > $py
	@y = @y
	vx = @x < $px ? 1 : -1
	@x <+= vx * s
	repeat
		wait 15
		variableSpeedBullet
:bullet
variableSpeedBullet
	@angle = $angleToPlayer
	@speed = 0.5__1.5"],
["wave enemy",
":stage
main
	addWaves 10
addWaves count
	xs = $playerX > 0.5 ? -1 : 1
	@y = -0.1
	repeat count
		wave 800, 0.003, xs
		@y -= 0.02
		wait 2
:enemy
wave vx, vy, xs
	@x <= cos(@y * vx) * 0.4 * xs + 0.5
	@y <+= vy
	firePeriod 60
:turret
firePeriod interval
	repeat
		variableSpeedBullet
		wait interval
:bullet
variableSpeedBullet
	@angle = $angleToPlayer
	@speed = 0.5__1.5"],
["escaping enemy",
":stage
main
	repeat 5
		addEscapeEnemy 2..4
		notifyNoEnemy
		wait 200
notifyNoEnemy
	waitUntil $enemyCount == 0
	notify
addEscapeEnemy count
	px = $playerX < 0.5 ? 1 : -1
	repeat count
		@x = 0.5 + 0.3__0.6 * px
		@y = -0.3__-0.1
		escapeEnemy -px
:enemy
escapeEnemy xs
	vx = xs * 0.002
	@x <+= vx
	@y <+= 0.005
	waitUntil (@x - $playerX) * xs > -0.1
	vx <-= xs* 0.001
	fire $angleToPlayer, 1"],
["mid whip enemy",
":stage
main
	@y = -0.1
	repeat 10
		@x = 0.1__0.9
		midWhipEnemy
		wait 100..200
:enemy
midWhipEnemy
	whipTurret -0.1
	whipTurret 0.1
	@y => 0.2, 60
	wait 60
	@y => 0.5, 240
	wait 240
	@y => 1.2, 120
:turret
whipTurret ox
	@x <= $parentX + ox
	while $parentY < 0.4
		wait 60
		s = 1
		repeat 7
			fire $angleToPlayer, s
			s += 0.1
			wait 3"],
["mid rollig enemy",
":stage
main
	repeat 10
		midRbEnemy
		wait 120
:enemy
midRbEnemy
	sx = -1|1
	@x = 0.5 + 0.3__0.6 * sx
	@y = -0.1
	@x => 0.5 + 0.1__0.3 * sx, 60
	@y => 0.1__0.2, 60
	wait 60
	@y <+= 0.4 / 200
	rbTurret
	wait 200
	vanish rbTurret
	@x => 0.5 + 0.7 * sx, 120
:turret
rbTurret
	repeat
		a = 0
		repeat 16
			rBullet a
			a += 360 / 16
		wait 60
:bullet
rBullet a
	r = 0
	r <+= 0.01
	va = 5
	@angle = a
	@angle <+= va
	@x <= $prx + sin(@angle) * r
	@y <= $pry + cos(@angle) * r
	wait 20
	va => 0, 30"],
["stage1",
":stage
main
	addWaves 10
	wait 150
	repeat 10
		t90Enemy 0.01
		wait 20
	wait 60
	addWaves 10
	wait 150
	repeat 10
		t90Enemy 0.015
		wait 20
	wait 60
	s = 0.003
	repeat 20
		rusherEnemy s
		s += 0.001
		wait 60 / (s / 0.003)
	addBigEnemy1
	wait 600
	vanish addBigEnemy1
	repeat 5
		addEscapeEnemy 2..4
		notifyNoEnemy
		wait 120
	repeat 10
		turnEnemy
		wait 30
	wait 60
	gzkt
	wait 60
	bigEnemy2
addBigEnemy1
	bigEnemy1
	notifyNoEnemy
	wait
	repeat
		rusherEnemy 0.005
		wait 40
notifyNoEnemy
	waitUntil $enemyCount == 0
	notify
addWaves count
	xs = $playerX > 0.5 ? -1 : 1
	@y = -0.1
	repeat count
		wave 800, 0.003, xs
		@y -= 0.02
		wait 2
addEscapeEnemy count
	px = $playerX < 0.5 ? 1 : -1
	repeat count
		@x = 0.5 + 0.3__0.6 * px
		@y = -0.3__-0.1
		escapeEnemy -px
:enemy
wave vx, vy, xs
	@x <= cos(@y * vx) * 0.4 * xs + 0.5
	@y <+= vy
	firePeriod 60
t90Enemy s
	@x = 0.1__0.9
	@y = -0.1
	@y <+= s
	waitUntil @y > $py
	@y = @y
	vx = @x < $px ? 1 : -1
	@x <+= vx * s
	repeat
		wait 15
		variableSpeedBullet
rusherEnemy s
	@x = 0.1__0.9
	@y = -0.1
	@y <+= s
	repeat
		wait 30
		variableSpeedBullet
escapeEnemy xs
	vx = xs * 0.002
	@x <+= vx
	@y <+= 0.005
	waitUntil (@x - $playerX) * xs > -0.1
	vx <-= xs* 0.001
	fire $angleToPlayer, 1
turnEnemy
	@x = 0__1
	@y = 0
	@angle = $angleToPlayer + -10__10
	s = 1__1.5
	@speed = s
	waitUntil @y > $playerY - 0.2
	@speed = 0
	@angle => $angleToPlayer + 180|-180 + -30__30, 15
	wait 15
	fire $angleToPlayer, 1
	@speed = s * 2
gzkt
	@x = 0.1__0.9
	@y = -0.1
	@y <+= 0.015
	wait 30
	a = 0
	repeat 16
		fire a, 2
		a += 360 / 16
	repeat 4
		homing a
		a += 360 / 4
	vanish
bigEnemy1
	@y = -0.1
	@x <= sin($ticks) * 0.3 + 0.5
	@y <+= 0.005
	wait 60
	sy = @y
	@y <= sy + sin($ticks - 60) * 0.1
	repeat 26
		soBullet
		wait 20
	@y <-= 0.01
bigEnemy2
	@y = -0.1
	@x <= -sin($ticks) * 0.3 + 0.5
	@y <+= 0.005
	wait 60
	sy = @y
	@y <= sy + sin($ticks - 60) * 0.1
	repeat 3
		repeat 3
			rfBullet -45, 5
			wait 20
			rfBullet 45, -5
			wait 20
		wait 40
		repeat 6
			bnBullet $angleToPlayer
			bnBullet $angleToPlayer - 30
			bnBullet $angleToPlayer - 60
			bnBullet $angleToPlayer + 30
			bnBullet $angleToPlayer + 60
			wait 20
		wait 40
	@y <-= 0.01
:turret
firePeriod interval
	repeat
		variableSpeedBullet
		wait interval
:bullet
variableSpeedBullet
	@angle = $angleToPlayer
	@speed = 0.5__1.5
homing a
	vx = sin(a) * 0.01
	vy = cos(a) * 0.01
	@x <+= vx
	@y <+= vy
	vx <+= ($px - @x) * 0.003
	vy <+= ($py - @y) * 0.003
rfBullet angle, roll
	@angle = angle
	@speed = 1
	a = $angleToPlayer
	repeat 10
		wait 3
		fire a, 1
		a += roll
	vanish
bnBullet a
	@angle = a
	@speed = 1
	@angle <+= @x < 0 && @angle < 0 ? (-@angle * 2) : (@x > 1 && @angle > 0 ? (-@angle * 2) : 0)
	wait 480
	vanish
soBullet
	vx = -0.02__0.02
	@x <+= vx
	vy = 0
	@y <+= vy
	vy <+= 0.0005
	repeat
		fire $angleToPlayer, 1
		wait 10"],
	];
}