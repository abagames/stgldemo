package com.abagames.util;
import flash.display.BitmapData;
import flash.geom.Rectangle;
class Letter {
	static inline var BASE_SCALE = 2;
	public static function draw(text:String, x:Float, y:Float):Void {
		drawAligned(text, x, y, Center);
	}
	public static function drawAligned(text:String, x:Float, y:Float, align:LetterAlign,
	scale:Int = BASE_SCALE, color:Color = null):Void {
		var tx = Std.int(x), ty = Std.int(y);
		var ci = (color == null ? Color.white.i : color.i);
		var lw = scale * 5;
		switch (align) {
		case Left:
		case Center:
			tx -= Std.int(text.length * lw / 2);
		case Right:
			tx -= text.length * lw;
		}
		rect.width = rect.height = scale;
		for (i in 0...text.length) {
			var c = text.charCodeAt(i);
			var li = charToIndex[c];
			if (li >= 0) drawDots(li, tx, ty, ci);
			tx += lw;
		}
	}

	static inline var COUNT = 64;
	static var dotPatterns:Array<Array<Xy>>;
	static var charToIndex:Array<Int>;
	static var rect:Rectangle;
	static var bd:BitmapData;
	public static function initialize():Void {
		var patterns = [
		0x4644AAA4, 0x6F2496E4, 0xF5646949, 0x167871F4, 0x2489F697, 0xE9669696, 0x79F99668,
		0x91967979, 0x1F799976, 0x1171FF17, 0xF99ED196, 0xEE444E99, 0x53592544, 0xF9F11119,
		0x9DDB9999, 0x79769996, 0x7ED99611, 0x861E9979, 0x994444E7, 0x46699699, 0x6996FD99,
		0xF4469999, 0x2224F248, 0x26244424, 0x64446622, 0x84284248, 0x40F0F024, 0xF0044E4,
		0x480A4E40, 0x9A459124, 0xA5A16, 0x640444F0, 0x80004049, 0x40400004, 0x44444040,
		0xA00004, 0x64E4E400, 0x45E461D9, 0x4424F424, 0x42F244E5, 
		];
		dotPatterns = new Array<Array<Xy>>();
		var p = 0, d = 32;
		var pIndex = 0;
		var dots:Array<Xy>;
		for (i in 0...COUNT) {
			dots = new Array<Xy>();
			for (j in 0...5) {
				for (k in 0...4) {
					if (++d >= 32) {
						p = patterns[pIndex++];
						d = 0;
					}
					if (p & 1 > 0) dots.push(new Xy(k, j));
					p >>= 1;
				}
			}
			dotPatterns.push(dots);
		}
		var charCodes = [
		40, 41, 91, 93, 60, 62, 61, 43, 45, 42, 47, 37, 38, 95, 33, 63, 44, 46, 58, 124,
		39, 34, 36, 64, 117, 114, 100, 108];
		charToIndex = new Array<Int>();
		for (c in 0...128) {
			var li = -1;
			if (c >= 48 && c < 58) {
				li = c - 48;
			} else if (c >= 65 && c <= 90) {
				li = c - 65 + 10;
			} else {
				var lic = 36;
				for (cc in charCodes) {
					if (cc == c) {
						li = lic;
						break;
					}
					lic++;
				}
			}
			charToIndex.push(li);
		}
		rect = new Rectangle();
		bd = Screen.bd;
	}
	static function drawDots(i:Int, x:Int, y:Int, color:Int):Void {
		for (p in dotPatterns[i]) {
			rect.x = x + p.xi * 2;
			rect.y = y + p.yi * 2;
			bd.fillRect(rect, color);
		}
	}
}