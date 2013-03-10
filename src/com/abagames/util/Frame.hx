package com.abagames.util;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.geom.Rectangle;
import flash.Lib;
class Frame {
	public var title = "";
	public var isDebugging = false;
	public var platform:Platform;
	public function initializeFirst():Void { }
	public function initialize():Void { }
	public function update():Void { }
	public static var i:Frame;
	public var random:Random;
	public var score = 0;
	public var ticks = 0;
	public var isInGame = false;
	public var fps = 0.0;
	public function endGame():Bool {
		if (!isInGame) return false;
		platform.recordScore(score);
		isInGame = false;
		wasClicked = wasReleased = false;
		ticks = 0;
		titleTicks = 10;
		return true;
	}

	public function new(x:Int = -1, y:Int = -1, width:Int = -1, height:Int = -1) {
		Lib.current.stage.align = StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
		Frame.i = this;
		Screen.initialize(x, y, width, height);
		Key.initialize();
		Mouse.initialize();
		Letter.initialize();
		random = new Random();
		initializeFirst();
		initializeGame();
		if (isDebugging) beginGame();
		lastTimer = Lib.getTimer();
		Lib.current.addEventListener(Event.ACTIVATE, onActivated);
		Lib.current.addEventListener(Event.DEACTIVATE, onDeactivated);
		Lib.current.addEventListener(Event.ENTER_FRAME, updateFrame);
	}
	var isPaused = false;
	var wasClicked = false;
	var wasReleased = false;
	var titleTicks = 0;
	function beginGame():Void {
		isInGame = true;
		score = 0;
		ticks = 0;
		random.setSeed();
		initializeGame();
	}
	function initializeGame():Void {
		Particle.initialize();
		Message.initialize();
		initialize();
	}
	function updateFrame(e:Event):Void {
		Screen.begin();
		if (!isPaused) {
			update();
			if (isDebugging) {
				Letter.drawAligned("FPS: " + Std.string(Std.int(fps)), Screen.size.xi, 20, Right);
			}
			Se.updateAll();		
			ticks++;
		} else {
			Letter.draw("PAUSED", Screen.center.x, Screen.center.y - 8);
			Letter.draw(platform.clickStr + " TO RESUME",
				Screen.center.x, Screen.center.y + 8);
		}
		Bgm.update();
		Letter.drawAligned(Std.string(score), Screen.size.x, 2, Right);
		//if (!isInGame) handleTitleScreen();
		Screen.end();
		calcFps();
	}
	function handleTitleScreen():Void {
		Letter.draw(title, Screen.center.x, Screen.center.y - 20);
		Letter.draw(platform.clickStr, Screen.center.x, Screen.center.y + 8);
		Letter.draw("TO", Screen.center.x, Screen.center.y + 18);
		Letter.draw("START", Screen.center.x, Screen.center.y + 28);
		if (Mouse.isPressing) {
			if (wasReleased) wasClicked = true;
		} else {
			if (wasClicked) beginGame();
			if (--titleTicks <= 0) wasReleased = true;
		}
	}
	var fpsCount = 0;
	var lastTimer = 0;
	function calcFps():Void {
		fpsCount++;
		var currentTimer:Int = Lib.getTimer();
		var delta:Int = currentTimer - lastTimer;
		if (delta >= 1000) {
			fps = fpsCount * 1000 / delta;
			lastTimer = currentTimer;
			fpsCount = 0;
		}
	}
	function onActivated(e:Event):Void {
		isPaused = false;
	}
	function onDeactivated(e:Event):Void {
		Key.reset();
		if (isInGame) isPaused = true;
	}
}