package com.abagames.util;
import flash.display.BitmapData;
import flash.geom.Rectangle;
using Math;
class DotShape {
	public static inline var BASE_SCALE = 3;
	public function new() {
		dots = new Array<OffsetColor>();
		color = Color.transparent;
		colorSpot = Color.transparent;
		offset = new Xy();
	}
	public function c(c:Color, cs:Color = null, cb:Color = null, cbs:Color = null):DotShape {
		if (c != null) color = c;
		if (cs != null) colorSpot = cs;
		colorBottom = cb;
		colorBottomSpot = cbs;
		return this;
	}
	public function sa(x:Float = 0, y:Float = 0, xy:Float = 0):DotShape {
		xAngleVel = x;
		yAngleVel = y;
		xyAngleVel = xy;
		return this;
	}
	public function st(v:Float):DotShape {
		spotThreshold = v;
		return this;
	}
	public function o(x:Float = 0, y:Float = 0):DotShape {
		offset.x = x; offset.y = y;
		return this;
	}
	public function fr(width:Int, height:Int):DotShape {
		return setRect(width, height, false);
	}
	public function lr(width:Int, height:Int):DotShape {
		return setRect(width, height, true);
	}
	public function fc(radius:Int):DotShape {
		return setCircle(radius, false);
	}
	public function lc(radius:Int):DotShape {
		return setCircle(radius, true);
	}
	public function fd(x:Int, y:Int, ry:Float = 0):DotShape {
		var ca = (x * xAngleVel).cos() * (y * yAngleVel).cos() * ((x + y) * xyAngleVel).cos();
		var c:Color;
		if (ca.abs() < spotThreshold) {
			if (colorBottomSpot != null) c = colorSpot.blend(colorBottomSpot, ry);
			else c = colorSpot;
		} else {
			if (colorBottom != null) c = color.blend(colorBottom, ry);
			else c = color;
		}
		if (c.r < 0) return this;
		var d = new OffsetColor();
		d.offset.x = x + offset.x;
		d.offset.y = y + offset.y;
		d.color = c.i;
		dots.push(d);
		return this;
	}
	public function draw(
	pos:Xy, angle:Float = 0,
	scaleX:Float = BASE_SCALE, scaleY:Float = 0, rectScale:Int = 0,
	color:Color = null):Void {
		var sx = scaleX;
		var sy = (scaleY > 0 ? scaleY : scaleX);
		if (rectScale > 0) {
			rect.width = rect.height = rectScale;
		} else {
			rect.width = sx.abs();
			rect.height = sy.abs();
		}
		var ox = Std.int(scaleX / 2), oy = Std.int(scaleY / 2);
		for (d in dots) {
			rPos.x = d.offset.x * sx;
			rPos.y = d.offset.y * sy;
			if (angle != 0) rPos.rotate(angle);
			rect.x = Std.int(pos.x + rPos.x) - ox;
			rect.y = Std.int(pos.y + rPos.y) - oy;
			if (color != null) Screen.bd.fillRect(rect, color.i);
			else Screen.bd.fillRect(rect, d.color);
		}
	}

	static var rect:Rectangle = new Rectangle();
	static var rPos:Xy = new Xy();
	var dots:Array<OffsetColor>;
	var color:Color;
	var colorSpot:Color;
	var colorBottom:Color;
	var colorBottomSpot:Color;
	var spotThreshold = 0.3;
	var xAngleVel = 0.0;
	var yAngleVel = 0.0;
	var xyAngleVel = 0.0;
	var offset:Xy;
	function setRect(width:Int, height:Int, isDrawingEdge:Bool = false):DotShape {
		var ox = Std.int( -width / 2), oy = -Std.int(height / 2);
		for (y in 0...height) {
			for (x in 0...width) {
				if (!isDrawingEdge ||
				x == 0 || x == width - 1 || y == 0 || y == height - 1) {
					fd(x + ox, y + oy, y / height);
				}
			}
		}
		return this;
	}
	function setCircle(radius:Int, isDrawingEdge:Bool = false):DotShape {
		var d = 3 - radius * 2;
		var y = radius;
		for (x in 0...y + 1) {
			if (isDrawingEdge) {
				setCircleDotsEdge(x, y, radius);
				setCircleDotsEdge(y, x, radius);
			} else {
				setCircleDots(x, y, radius);
				setCircleDots(y, x, radius);
			}
			if (d < 0) {
				d += 6 + x * 4;
			} else {
				d += 10 + x * 4 - y * 4;
				y--;
			}
		}
		return this;
	}
	function setCircleDots(x:Int, y:Int, r:Int):Void {
		setXLine(-x, x, y, r);
		setXLine(-x, x, -y, r);
	}
	function setXLine(xb:Int, xe:Int, y:Int, r:Int):Void {
		var ry = (y + r) / (r * 2);
		for (x in xb...xe + 1) fd(x, y, ry);
	}
	function setCircleDotsEdge(x:Int, y:Int, r:Int):Void {
		var ry = (y + r) / (r * 2);
		fd(-x, y, ry); fd(x, y, ry);
		ry = (-y + r) / (r * 2);
		fd(-x, -y, ry); fd(x, -y, ry);
	}
}
class OffsetColor {
	public var offset:Xy;
	public var color:UInt;
	public function new() {
		offset = new Xy();
	}
}