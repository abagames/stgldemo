package com.abagames.util;
class Random {
	public function n(v:Float = 1, s:Float = 0):Float { return get() * v + s; }
	public function i(v:Int, s:Int = 0):Int { return Std.int(n(v, s)); }
	public function sx(v:Float = 1, s:Float = 0):Float { return n(v, s) * Screen.size.x; }
	public function sy(v:Float = 1, s:Float = 0):Float { return n(v, s) * Screen.size.y; }
	public function pm():Int { return i(2) * 2 - 1; }
	public function pmn(v:Float = 1):Float { return n(v) * pm(); }

	var x:Int;
	var y:Int;
	var z:Int;
	var w:Int;
	public function new(v:Int = -0x7fffffff) {
		setSeed(v);
	}
	public function setSeed(v:Int = -0x7fffffff):Void {
		var sv:Int;
		if (v == -0x7fffffff) sv = Std.int(Math.random() * 0x7fffffff);
		else sv = v;
		x = sv = 1812433253 * (sv ^ (sv >> 30));
		y = sv = 1812433253 * (sv ^ (sv >> 30)) + 1;
		z = sv = 1812433253 * (sv ^ (sv >> 30)) + 2;
		w = sv = 1812433253 * (sv ^ (sv >> 30)) + 3;
	}
	public function get():Float {
		var t:Int = x ^ (x << 11);
		x = y;
		y = z;
		z = w;
		w = (w ^ (w >> 19)) ^ (t ^ (t >> 8));
		return cast(w, Float) / 0x7fffffff;
	}
}