package com.abagames.util;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.Lib;
class Mouse {
	public static var pos:Xy;
	public static var isPressing = false;

	public static function initialize():Void {
		pos = new Xy();
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMoved);
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_DOWN, onPressed);
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_UP, onReleased);
		Lib.current.stage.addEventListener(Event.MOUSE_LEAVE, onReleased);
	}
	static function onMoved(e:MouseEvent) {
		pos.x = e.stageX - Screen.pos.x;
		pos.y = e.stageY - Screen.pos.y;
	}
	static function onPressed(e:MouseEvent) {
		isPressing = true;
		onMoved(e);
	}
	static function onReleased(e:Event) {
		isPressing = false;
	}
}