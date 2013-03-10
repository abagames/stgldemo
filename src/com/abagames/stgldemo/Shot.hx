package com.abagames.stgldemo;
import com.abagames.util.Actor;
import com.abagames.util.Color;
import com.abagames.util.DotShape;
import com.abagames.util.Screen;
import com.abagames.util.Xy;
class Shot extends Actor {
	public static var s:Array<Shot>;	
	static var shape:DotShape = new DotShape()
	.c(Color.green.rz.rz, Color.cyan.rz.rz).sa(0, 1, 1).o(4, 0).fr(2, 5).o(-4, 0).fr(2, 5);
	var isRemoving = false;
	public function new(p) {
		super();
		pos.xy = p;
		vel.y = -15;
		size.v = 30;
	}
	override public function update() {
		if (isRemoving) return false;
		pos.incrementBy(vel);
		Actor.checkHitRect(this, SActor.s, true);
		shape.draw(pos);
		return Screen.isIn(pos, 10);
	}
	public function remove() {
		isRemoving = true;
	}
}