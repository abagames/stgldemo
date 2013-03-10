package com.abagames.stgldemo;
import com.abagames.util.Actor;
import com.abagames.util.Color;
import com.abagames.util.Frame;
import com.abagames.util.Screen;
class Star extends Actor {
	public static var s:Array<Star>;
	var color:Int;
	public function new() {
		super();
		pos.x = Frame.i.random.sx();
		vel.y = Frame.i.random.n(5, 1);
		color = Color.white.blink.i;
	}
	override public function update():Bool {
		pos.incrementBy(vel);
		Screen.fillRect(pos.x, pos.y, 3, 3, color);
		return pos.y < Screen.size.y;
	}
}