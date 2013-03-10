package com.abagames.stgldemo;
import com.abagames.util.Actor;
import com.abagames.util.Color;
import com.abagames.util.DotShape;
import com.abagames.util.Frame;
import com.abagames.util.Particle;
import com.abagames.util.Screen;
import com.abagames.util.Se;
import com.abagames.util.SeType;
import com.abagames.util.Xy;
import com.abagames.util.stgl.ActorType;
import com.abagames.util.stgl.StglActor;
using com.abagames.util.FloatUtil;
class SActor extends Actor {
	public static var s:Array<SActor>;
	static var enemyShape:DotShape = new DotShape()
	.c(Color.red.gz, Color.red.gz.gz).sa(1, 2, 3).fr(5, 4)
	.c(Color.yellow.rz.rz, Color.yellow.rz).sa(8, 0, 7).o(5, -1).fr(2, 4).o(-5, -1).fr(2, 4);
	static var midEnemyShape:DotShape = new DotShape()
	.c(Color.red.gz, Color.red.gz.gz).sa(9, 4, 0).o(0, -2).fr(5, 4).o(0, 2).fr(7, 4)
	.c(Color.yellow.rz.rz, Color.yellow.rz).sa(7, 5, 0)
	.o(7, -4).fr(3, 5).o(-7, -4).fr(3, 5).o(8, 4).fr(4, 6).o(-8, 4).fr(4, 6);
	static var bigEnemyShape:DotShape = new DotShape()
	.c(Color.red.gz, Color.red.gz.gz).sa(4, 5, 6).fr(5, 4).o(0, -5).fr(7, 4).o(0, 5).fr(9, 4)
	.c(Color.yellow.rz.rz, Color.yellow.rz).sa(6, 5, 4)
	.o(9, 0).fr(5, 4).o(-9, 0).fr(5, 4).o(9, 7).fr(6, 5).o(-9, 7).fr(6, 5)
	.o(9, -7).fr(7, 6).o(-9, -7).fr(7, 6);
	static var turretShape:DotShape = new DotShape()
	.c(Color.yellow.rz.rz, Color.red.gz).sa(3, 2, 1).lc(1);
	static var bulletShape:DotShape = new DotShape()
	.c(Color.red.bz.bz, Color.magenta.rz.rz).sa(2, 1).fr(1, 3).c(Color.red).lr(3, 5);
	static var fireSe = new Se().b(SeType.Noise, 64, 12).t(0, 2, 0.5).e();
	static var dstSe = new Se().b(SeType.Noise).t(0.7, 2, 0.3).t(0.5, 3, 0).e();
	static var midDstSe = new Se().b(SeType.Noise).t(0.6, 2, 0.3).t(0.9, 5, 0.1).e();
	static var bigDstSe = new Se().b(SeType.Noise).t(0.9, 5, 0).t(0, 10, 0.3).e();
	public static function countEnemies():Int {
		var c = 0;
		for (a in s) {
			if (a.stglActor.type == Enemy) c++;
		}
		return c;
	}
	var stglActor:StglActor;
	var pPos:Xy;
	var sVel:Xy;
	var shape:DotShape = null;
	var shield = 1;
	public function new(stglActor) {
		super();
		this.stglActor = stglActor;
		pPos = new Xy();
		sVel = new Xy();
		switch (stglActor.type) {
		case Enemy:
			if (stglActor.name.substr(0, 3) == "big") {
				shape = bigEnemyShape;
				shield = 50;
				size.x = 90;
				size.y = 60;
			} else if (stglActor.name.substr(0, 3) == "mid") {
				shape = midEnemyShape;
				shield = 10;
				size.x = 60;
				size.y = 45;
			} else {
				shape = enemyShape;
				size.v = 30;
			}
		case Turret:
			shape = turretShape;
		case Bullet:
			size.v = 15;
			shape = bulletShape;
		default:
		}
	}
	override public function update() {
		if (!stglActor.update()) return false;
		pos.x = stglActor.xVar.value * Screen.size.x;
		pos.y = stglActor.yVar.value * Screen.size.y;
		angle = stglActor.angleVar.value * Math.PI / 180;
		if (stglActor.type == Bullet) {
			if (!Screen.isIn(pos, 10)) return false;
			sVel.xy = pos;
			sVel.decrementBy(pPos);
			var s = sVel.length;
			var t = stglActor.ticks;
			if (t == 2) {
				if (stglActor.parent.type != Bullet) {
					Particle.add(pos, Color.red.gz.gz, 15, 5, s, 60, angle, 1);
					fireSe.play();
				}
			} else if (t > 2) {
				Particle.add(pos, Color.magenta.gz, 5, 1, s, 15, angle + Math.PI, 0);
			}
			bulletShape.draw(pos, angle);
		}
		if (shape != null) shape.draw(pos, angle);
		pPos.xy = pos;
		return true;
	}
	public function hit(s:Dynamic) {
		if (!stglActor.exists) return;
		if (Std.is(s, Shot)) {
			if (stglActor.type != Enemy) return;
			if (--shield <= 0) {
				destroy();
				Frame.i.score++;
			} else {
				Particle.add(pos, Color.red.gz.gz.gz, 10, 10, 10, 30, 0, 1);
			}
			s.remove();
		} else if (Std.is(s, Player)) {
			if (stglActor.type == Enemy || stglActor.type == Bullet) {
				destroy();
				s.destroy();
			}
		}
	}
	function destroy() {
		if (stglActor.type == Enemy) {
			Particle.add(pos, Color.red.gz.gz, 20, 20, 10);
			if (stglActor.name.substr(0, 3) == "big") bigDstSe.play();
			else if (stglActor.name.substr(0, 3) == "mid") midDstSe.play();
			else dstSe.play();
		} else if (stglActor.type == Bullet) {
			Particle.add(pos, Color.magenta.gz, 10, 10, 5);
		}
		stglActor.vanish();
	}
}