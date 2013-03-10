package com.abagames.util;
import flash.events.KeyboardEvent;
import flash.Lib;
class Key {
	public static var s:Array<Bool>;
	public static var isWPressed(getIsWPressed, null):Bool;
	public static var isAPressed(getIsAPressed, null):Bool;
	public static var isSPressed(getIsSPressed, null):Bool;
	public static var isDPressed(getIsDPressed, null):Bool;
	public static var isButtonPressed(getIsButtonPressed, null):Bool;
	public static var isButton1Pressed(getIsButton1Pressed, null):Bool;
	public static var isButton2Pressed(getIsButton2Pressed, null):Bool;
	public static var stick(getStick, null):Xy;

	static var stickXy:Xy;
	public static function initialize():Void {
		s = new Array<Bool>();
		for (i in 0...256) s.push(false);
		stickXy = new Xy();
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, onPressed);
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, onReleased);
	}
	public static function reset() {
		for (i in 0...256) s[i] = false;
	}
	static function onPressed(e:KeyboardEvent) {
		s[e.keyCode] = true;
	}
	static function onReleased(e:KeyboardEvent) {
		s[e.keyCode] = false;
	}
	static function getIsWPressed():Bool {
		return s[0x26] || s[0x57];
	}
	static function getIsAPressed():Bool {
		return s[0x25] || s[0x41];
	}
	static function getIsSPressed():Bool {
		return s[0x28] || s[0x53];
	}
	static function getIsDPressed():Bool {
		return s[0x27] || s[0x44];
	}
	static function getIsButtonPressed():Bool {
		return isButton1Pressed || isButton2Pressed;
	}
	static function getIsButton1Pressed():Bool {
		return s[0x5a] || s[0xbe] || s[0x20];
	}
	static function getIsButton2Pressed():Bool {
		return s[0x58] || s[0xbf];
	}	
	static function getStick():Xy {
		stickXy.v = 0;
		if (isWPressed) stickXy.y -= 1;
		if (isAPressed) stickXy.x -= 1;
		if (isSPressed) stickXy.y += 1;
		if (isDPressed) stickXy.x += 1;
		if (stickXy.x != 0 && stickXy.y != 0) stickXy.scaleBy(0.7);
		return stickXy;
	}
}