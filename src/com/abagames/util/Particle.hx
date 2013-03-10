package com.abagames.util;
class Particle extends Actor {
	public static function add(
	pos:Xy, color:Color, size:Float, count:Int, speed:Float, ticks:Float = 60,
	angle:Float = 0, angleWidth:Float = 6.28):Void {
		var random = Frame.i.random;
		for (i in 0...count) {
			var pt = new Particle();
			pt.color = color;
			pt.targetSize = size;
			pt.pos.xy = pos;
			pt.vel.addAngle(angle + random.pmn(angleWidth / 2), random.n(speed));
			pt.ticks = Std.int(ticks * random.n(1, 0.5));
			s.push(pt);
		}
	}

	public static var s:Array<Particle>;
	public static function initialize():Void {
		s = new Array<Particle>();
	}
	public static function updateAll():Void {
		Actor.updateAll(s);
	}
	var ticks:Int;
	var color:Color;
	var scale = 1.0;
	var targetSize:Float;
	var isExpand = true;
	override public function update():Bool {
		pos.incrementBy(vel);
		vel.scaleBy(0.98);
		if (isExpand) {
			scale *= 1.5;
			if (scale > targetSize) isExpand = false;
		} else {
			scale *= 0.95;
		}
		Screen.fillRect(pos.x, pos.y, scale, scale, color.blink.i);
		return --ticks > 0;
	}
}