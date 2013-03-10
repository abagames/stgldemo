package com.abagames.util.stgl;
interface StglManager {
	var baseSpeed:Float;
	var screenWidth:Float;
	var screenHeight:Float;
	var playerX:Float;
	var playerY:Float;
	var enemyCount(getEnemyCount, null):Int;
	function add(stglActor:StglActor):Void;
}