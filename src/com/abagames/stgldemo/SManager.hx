package com.abagames.stgldemo;
import com.abagames.util.stgl.StglActor;
import com.abagames.util.stgl.StglManager;
class SManager implements StglManager {
	public var baseSpeed = 0.01;
	public var screenWidth = 320.0;
	public var screenHeight = 480.0;
	public var playerX = 160.0;
	public var playerY = 240.0;
	public var enemyCount(getEnemyCount, null):Int;
	public function new() { }
	public function add(stglActor:StglActor):Void {
		var actor = new SActor(stglActor);
		SActor.s.push(actor);
	}
	function getEnemyCount():Int {
		return SActor.countEnemies();
	}
}