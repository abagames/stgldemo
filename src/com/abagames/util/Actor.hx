package com.abagames.util;
using Math;
class Actor {
	public var pos:Xy;
	public var vel:Xy;
	public var angle = 0.0;
	public var speed = 0.0;
	public var size:Xy;
	public var radius = -1.0;
	public function new() {
		pos = new Xy();
		vel = new Xy();
		size = new Xy();
	}
	public function update():Bool {
		return true;
	}
	public static function updateAll(s:Array<Dynamic>):Void {
		var i = 0;
		while (i < s.length) {
			if (s[i].update()) i++;
			else s.splice(i, 1);
		}
	}
	public static function checkHitCircle(ca:Dynamic, s:Array<Dynamic>,
	callHit:Bool = false):Bool {
		return checkHit(ca, s, callHit, function(ca:Dynamic, a:Dynamic):Bool {
			return (ca.pos.distance(a.pos) <= ca.radius + a.radius);
		});
	}
	public static function checkHitRect(ca:Dynamic, s:Array<Dynamic>,
	callHit:Bool = false):Bool {
		return checkHit(ca, s, callHit, function(ca:Dynamic, a:Dynamic):Bool {
			return ((ca.pos.x - a.pos.x).abs() <= (ca.size.x + a.size.x) / 2 &&
				(ca.pos.y - a.pos.y).abs() <= (ca.size.y + a.size.y) / 2);
		});
	}
	public static function checkHit(ca:Dynamic, s:Array<Dynamic>, callHit:Bool,
	hitTest:Dynamic -> Dynamic -> Bool):Bool {
		var hf:Bool = false;
		for (a in s) {
			if (ca == a) continue;
			if (hitTest(ca, a)) {
				if (callHit) a.hit(ca);
				hf = true;
			}
		}
		return hf;
	}	
}