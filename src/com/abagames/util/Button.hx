package com.abagames.util;
using Math;
class Button {
	public var isOver = false;
	public var isPressing = false;
	public var isClicked = false;
	public function new(text:String, x:Float, y:Float, width:Float, height:Float) {
		this.text = text;
		pos = new Xy(x + width / 2, y + height / 2);
		size = new Xy(width, height);
		var sw = Std.int(width / DotShape.BASE_SCALE);
		var sh = Std.int(height / DotShape.BASE_SCALE);
		shape = new DotShape().c(Color.white.dz).lr(sw, sh);
		pressingShape = new DotShape().c(Color.white).lr(sw, sh);
		notOverShape = new DotShape().c(Color.white.bz.dz).fr(sw - 2, sh - 2);
		overShape = new DotShape().c(Color.white.rz.dz).fr(sw - 2, sh - 2);
	}
	public function update():Void {
		isClicked = false;
		isOver = (pos.x - Mouse.pos.x).abs() < size.x / 2 &&
			(pos.y - Mouse.pos.y).abs() < size.y / 2;
		if (isOver) {
			if (Mouse.isPressing) {
				if (!wasPressed) isPressing = true;
			} else {
				if (isPressing) isClicked = true;
				isPressing = false;
			}
		} else {
			isPressing = false;
		}
		if (isPressing) pressingShape.draw(pos);
		else shape.draw(pos);
		if (isOver) overShape.draw(pos);
		else notOverShape.draw(pos);
		Letter.draw(text, pos.x, pos.y - 5);
		wasPressed = Mouse.isPressing;
	}

	var text:String;
	var pos:Xy;
	var size:Xy;
	var shape:DotShape;
	var pressingShape:DotShape;
	var notOverShape:DotShape;
	var overShape:DotShape;
	var wasPressed = false;
}