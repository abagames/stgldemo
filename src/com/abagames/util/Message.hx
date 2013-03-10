package com.abagames.util;
class Message extends Actor {
	public static var s:Array<Message>;
	static var shownMessages:Array<String> = new Array<String>();
	public static function addOnce(
	text:String, pos:Xy, vx:Float = 0, vy:Float = 0, ticks:Int = 240):Message {
		for (m in shownMessages) if (m == text) return null;
		shownMessages.push(text);
		return add(text, pos, vx, vy, ticks);
	}
	public static function add(
	text:String, pos:Xy, vx:Float = 0, vy:Float = 0, ticks:Int = 60):Message {
		var m = new Message();
		m.text = text;
		m.pos.xy = pos;
		m.vel.x = vx / ticks;
		m.vel.y = vy / ticks;
		m.ticks = ticks;
		s.push(m);
		return m;
	}

	public static function initialize():Void {
		s = new Array<Message>();
	}
	public static function updateAll():Void {
		Actor.updateAll(s);
	}
	public var text:String;
	public var ticks:Int;
	public function new() {
		super();
	}
	override public function update():Bool {
		pos.incrementBy(vel);
		Letter.draw(text, pos.x, pos.y);
		return --ticks > 0;
	}
}