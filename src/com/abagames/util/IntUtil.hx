package com.abagames.util;
class IntUtil {
	public static inline function clampi(v:Int, min:Int, max:Int):Int {
		if (v > max) v = max;
		else if (v < min) v = min;
		return v;
	}
	public static inline function circlei(v:Int, max:Int, min:Int = 0):Int {
		var w = max - min;
		v -= min;
		var r:Int;
		if (v >= 0) r = v % w + min;
		else r = w + v % w + min;
		return r;
	}
}