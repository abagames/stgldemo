package com.abagames.util;
import org.si.sion.SiONDriver;
import org.si.sion.SiONData;
using Math;
using com.abagames.util.FloatUtil;
class Se {
	public function new() { }
	public function b(t:SeType, l:Int = 64, v:Int = 16):Se {
		type = t;
		if (mml == null) mml = "";
		else mml += ";";
		var voice:Int;
		switch (type) {
			case Major: voice = 1; toneIndex = 1;
			case Minor: voice = 1; toneIndex = 2;
			case Noise: voice = 9;
			case NoiseScale: voice = 10;
		}
		mml += "%1@" + voice + "l" + l + "v" + v;
		return this;
	}
	public function t(from:Float, time:Int = 1, to:Float = 0,
	waveWidth:Float = 0, waveAngle:Float = 0):Se {
		var tone = from;
		var step = (time > 1 ? (to - from) / (time - 1) : 0.0);
		var wa = 0.0;
		for (i in 0...time) {
			tone = tone.clamp(0, 1);
			var tv = (tone + wa.sin() * (waveWidth / 2)).clamp(0, 1);
			wa += waveAngle;
			switch (type) {
			case Major, Minor:
				var ti = Std.int(tv * 39);
				var o = Std.int(ti / 5 + 2);
				mml += "o" + o + tones[toneIndex][ti % 5];
			case Noise, NoiseScale:
				var ti = Std.int(tv * 14);
				if (ti < 4) mml += "o5" + tones[0][3 - ti];
				else mml += "o4" + tones[0][15 - ti];
			}
			tone += step;
		}
		return this;
	}
	public function r(v:Int = 1):Se {
		for (i in 0...v) mml += "r";
		return this;
	}
	public function l(v:Int = 64):Se {
		mml += "l" + l;
		return this;
	}
	public function v(v:Int = 16):Se {
		mml += "v" + v;
		return this;
	}
	public function e():Se {
		isStarting = false;
		data = driver.compile(mml);
		driver.volume = 0;
		driver.play();
		s.push(this);
		return this;
	}
	public function play():Void {
		if (!Frame.i.isInGame || lastPlayTicks > 0) return;
		isPlaying = true;
	}

	public static var s:Array<Se> = new Array<Se>();
	static var tones:Array<Array<String>> = [
		["c", "c+", "d", "d+", "e", "f", "f+", "g", "g+", "a", "a+", "b"],
		["c", "d", "e", "g", "a"],
		["c", "d-", "e-", "g-", "a-"]];
	static var driver:SiONDriver = new SiONDriver();
	static var isStarting = false;
	var data:SiONData;
	var isPlaying = false;
	var mml:String;
	var type:SeType;
	var toneIndex = 0;
	var lastPlayTicks = 0;
	public function update():Void {
		lastPlayTicks--;
		if (!isPlaying) return;
		if (!isStarting) {
			driver.volume = 0.9;
			isStarting = true;
		}
		driver.sequenceOn(data, null, 0, 0, 0);
		isPlaying = false;
		lastPlayTicks = 5;
	}
	public static function updateAll():Void {
		for (se in s) se.update();
	}
}