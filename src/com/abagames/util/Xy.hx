package com.abagames.util;
import flash.geom.Vector3D;
class Xy extends Vector3D {
	public static inline var ZERO = new Xy();
	public function new(x:Float = 0, y:Float = 0) {
		super(x, y);
	}
	public function distanceTo(p:Vector3D):Float {
		var ox = p.x - x;
		var oy = p.y - y;
		return Math.sqrt(ox * ox + oy * oy);
	}
	public function wayTo(p:Vector3D):Float {
		return Math.atan2(p.x - x, p.y - y);
	}
	public function addAngle(a:Float, s:Float):Void {
		x += Math.sin(a) * s;
		y += Math.cos(a) * s;
	}
	public function rotate(a:Float):Void {
		var px = x;
		x = -x * Math.cos(a) + y * Math.sin(a);
		y = px * Math.sin(a) + y * Math.cos(a);
	}
	public var v(null, setV):Float;
	public var xy(null, setXy):Vector3D;
	public var angle(getAngle, null):Float;
	public var xi(getXi, null):Int;
	public var yi(getYi, null):Int;

	function setV(v:Float):Float {
		return x = y = v;
	}
	function setXy(v:Vector3D):Vector3D {
		x = v.x;
		y = v.y;
		return this;
	}
	function getAngle():Float {
		return Math.atan2(x, y);
	}
	function getXi():Int {
		return Std.int(x);
	}
	function getYi():Int {
		return Std.int(y);
	}
}