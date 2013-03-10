package com.abagames.util;
class FloatUtil {
	public static inline function clamp(v:Float, min:Float, max:Float):Float {
		if (v > max) v = max;
		else if (v < min) v = min;
		return v;
	}
	public static inline function normalizeAngle(v:Float):Float {
		var r = v % (Math.PI * 2);
		if (r < -Math.PI) r += Math.PI * 2;
		else if (r > Math.PI) r -= Math.PI * 2;
		return r;
	}
	public static inline function aimAngle(v:Float, targetAngle:Float, angleVel:Float):Float {
		var oa = normalizeAngle(targetAngle - v);
		var r:Float;
		if (oa > angleVel) r = v + angleVel;
		else if (oa < -angleVel) r = v - angleVel;
		else r = targetAngle;
		return normalizeAngle(r);
	}
	public static inline function circle(v:Float, max:Float, min:Float = 0):Float {
		var w = max - min;
		v -= min;
		var r:Float;
		if (v >= 0) r = v % w + min;
		else r = w + v % w + min;
		return r;
	}
}