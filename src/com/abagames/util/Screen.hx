package com.abagames.util;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.filters.BlurFilter;
import flash.filters.ColorMatrixFilter;
import flash.Lib;
class Screen {
	public static var size:Xy;
	public static var center:Xy;
	public static var backgroundColor:Int = 0;
	public static function isIn(p:Xy, spacing:Float = 0):Bool {
		return p.x >= -spacing && p.x <= size.x + spacing &&
			p.y >= -spacing && p.y <= size.y + spacing;
	}
	public static function fillRect(
	x:Float, y:Float, width:Float, height:Float, color:Int):Void {
		fRect.x = Std.int(x) - Std.int(width / 2);
		fRect.y = Std.int(y) - Std.int(height / 2);
		fRect.width = width;
		fRect.height = height;
		bd.fillRect(fRect, color);
	}

	public static var bd:BitmapData;
	public static var pos:Xy;
	static var blurBd:BitmapData;
	static var fRect:Rectangle;
	public static function initialize
	(x:Int = -1, y:Int = -1, width:Int = -1, height:Int = -1):Void {
		if (x < 0) {
			size = new Xy(Lib.current.stage.stageWidth, Lib.current.stage.stageHeight);
		} else {
			size = new Xy(width, height);
		}
		center = new Xy(size.x / 2, size.y / 2);
		bd = new BitmapData(size.xi, size.yi, true, 0);
		blurBd = new BitmapData(size.xi, size.yi, false, 0);
		var bm = new Bitmap(blurBd);
		pos = new Xy();
		if (x >= 0) {
			bm.x = pos.x = x;
			bm.y = pos.y = y;
		}
		Lib.current.addChild(bm);
		fRect = new Rectangle();
	}
	public static function begin():Void {
		bd.lock();
		bd.fillRect(bd.rect, backgroundColor);
	}
	public static function end():Void {
		bd.unlock();
		drawBlur();
	}
	static var fadeFilter:ColorMatrixFilter = new ColorMatrixFilter([
		1, 0, 0, 0, 0,  0, 1, 0, 0, 0,  0, 0, 1, 0, 0,  0, 0, 0, 0.8, 0]);
	static var blurFilter10:BlurFilter = new BlurFilter(10, 10);
	static var blurFilter20:BlurFilter = new BlurFilter(20, 20);
	static var zeroPoint:Point = new Point();	
	static function drawBlur():Void {
		blurBd.lock();
		blurBd.applyFilter(blurBd, blurBd.rect, zeroPoint, fadeFilter);
		blurBd.copyPixels(bd, bd.rect, zeroPoint, null, null, true);
		blurBd.applyFilter(blurBd, blurBd.rect, zeroPoint, blurFilter20);
		blurBd.copyPixels(bd, bd.rect, zeroPoint, null, null, true);
		blurBd.applyFilter(blurBd, blurBd.rect, zeroPoint, blurFilter10);
		blurBd.copyPixels(bd, bd.rect, zeroPoint, null, null, true);
		blurBd.unlock();
	}
}