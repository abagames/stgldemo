package com.abagames.stgldemo;
import com.abagames.util.Actor;
import com.abagames.util.Color;
import com.abagames.util.DotShape;
import com.abagames.util.Key;
import com.abagames.util.Particle;
import com.abagames.util.Screen;
import com.abagames.util.Se;
import com.abagames.util.SeType;
import com.abagames.util.Xy;
using com.abagames.util.FloatUtil;
class Player extends Actor {
	static var shape:DotShape = new DotShape()
	.c(Color.cyan.rz, Color.cyan.rz.rz).sa(3, 2, 1).fr(5, 3)
	.c(Color.cyan.gz.gz.gz, Color.green.bz).o(5, 0).fr(2, 5).o(-5, 0).fr(2, 5)
	.c(Color.green, Color.cyan.gz).o(0, -5).fr(3, 5);
	static var dstSe = new Se().b(SeType.NoiseScale).t(0.7, 3, 0.2).t(0.3, 3, 0.9).t(0.5, 5, 0).e();
	public var isAbleToMove = true;
	var sManager:SManager;
	var fireTicks = 0;
	var spPos:Xy;
	var invincibleTicks = 0;
	public function new(sManager) {
		super();
		this.sManager = sManager;
		spPos = new Xy();
		size.v = 1;
		initialize();
	}
	function initialize() {
		pos.x = Screen.center.x;
		pos.y = Screen.size.y * 0.8;
	}
	override public function update() {
		if (invincibleTicks < 120 && isAbleToMove) {
			var s = Key.stick;
			s.scaleBy(5);
			pos.incrementBy(s);
			fireTicks--;
			if (fireTicks <= 0 && Key.isButtonPressed) {
				spPos.xy = pos;
				spPos.x -= 14;
				Particle.add(spPos, Color.cyan.gz.rz, 10, 1, 10, 20, Math.PI, 0.5);
				spPos.x += 28;
				Particle.add(spPos, Color.cyan.gz.rz, 10, 1, 10, 20, Math.PI, 0.5);
				Shot.s.push(new Shot(pos));
				fireTicks = 3;
			}
		}
		pos.x = pos.x.clamp(0, Screen.size.x);
		pos.y = pos.y.clamp(0, Screen.size.y);
		if (invincibleTicks == 120) initialize();
		if (invincibleTicks <= 0) Actor.checkHitRect(this, SActor.s, true);
		if (invincibleTicks <= 0 || (invincibleTicks < 120 && invincibleTicks % 30 > 15)) {
			shape.draw(pos);
		}
		sManager.playerX = pos.x;
		sManager.playerY = pos.y;
		invincibleTicks--;
		return true;
	}
	public function destroy(isParseError:Bool = false) {
		if (!isParseError && invincibleTicks > 0) return;
		Particle.add(pos, Color.green.rz.rz.rz, 50, 50, 10);
		invincibleTicks = 180;
		dstSe.play();
	}
}