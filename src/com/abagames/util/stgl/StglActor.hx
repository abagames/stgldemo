package com.abagames.util.stgl;
import com.abagames.util.stgl.ActorType;
using Math;
class StglActor {
	public static function initialize(manager:StglManager) {
		stglManager = manager;
		baseSpeed = manager.baseSpeed;
	}
	public var name:String;
	public var type:ActorType;
	public var xVar:Variable;
	public var yVar:Variable;
	public var angleVar:Variable;
	public var speedVar:Variable;
	public var vars:Hash<Variable>;
	public var ticks:Int;
	public var parent:StglActor;
	public var childActors:Array<StglActor>;
	public function update():Bool {
		for (v in vars) v.update(this);
		var x = xVar.value;
		var y = yVar.value;
		var angle = angleVar.value * Math.PI / 180;
		var speed = speedVar.value;
		if (speed != 0) {
			x += angle.sin() * speed * baseSpeed;
			y += angle.cos() * speed * baseSpeed;
			xVar.value = x;
			yVar.value = y;
		}
		if (type == Enemy || type == Turret || type == Bullet) {
			if (x > -0.1 && x < 1.1 && y > -0.1 && y < 1.1) {
				wasInScreen = true;
			} else {
				if (wasInScreen) remove();
			}
		}
		var commandCount = 0;
		while (true) {
			if (waitCond != null) {
				if (waitCond.calc(this) == 0) break;
				else waitCond = null;
			}
			if (currentState == null ||	waitTicks > 0) break;
			currentState.update();
			if (++commandCount > 1000) throw "execute too many commands at a frame";
		}
		if (isRemoving) {
			if (type == Enemy) {
				removeChildTurret();
			}
			return false;
		}
		ticks++;
		waitTicks--;
		return true;
	}
	public function addVar(name:String):Variable {
		var v = new Variable(name);
		vars.set(name, v);
		return v;
	}
	public var exists(getExists, null):Bool;

	static var stglManager:StglManager;
	static var baseSpeed:Float;
	public static function add
	(name:String, args:Array<Float> = null, parent:StglActor = null):StglActor {
		var actor = new StglActor(name, args, parent);
		stglManager.add(actor);
		return actor;
	}
	var waitTicks = 0;
	var waitCond:Expression = null;
	var scopeStates:Array<ScopeState>;
	var currentState:ScopeState;
	var dynamicValues:Hash<Float>;
	var isRemoving = false;
	var wasInScreen = false;
	var sPos:Xy;
	function new(name:String, args:Array<Float> = null, parent:StglActor = null) {
		var command = Command.s.get(name);
		if (command == null) throw "FUNCTION " + name + " doesn't exist";
		this.name = name;
		vars = new Hash <Variable>();
		var ai = 0;
		for (a in command.args) {
			var v = addVar(a.getAsName());
			if (args != null && ai < args.length) v.value = args[ai];
			ai++;
		}
		type = command.actorType;
		xVar = addVar("@x");
		yVar = addVar("@y");
		angleVar = addVar("@angle");
		speedVar = addVar("@speed");
		scopeStates = new Array<ScopeState>();
		childActors = new Array<StglActor>();
		dynamicValues = new Hash<Float>();
		this.parent = parent;
		if (parent == null) {
			xVar.value = 0.5;
			yVar.value = 0.2;
		} else {
			xVar.value = parent.xVar.value;
			yVar.value = parent.yVar.value;
		}
		angleVar.value = 0;
		speedVar.value = 0;
		currentState = new ScopeState(this, command);
		if (parent != null) parent.childActors.push(this);
	}
	public function pushScopeState(state:ScopeState):Void {
		scopeStates.push(currentState);
		currentState = state;
	}
	public function popScopeState():Void {
		currentState = scopeStates.pop();
	}
	public function setWaitTicks(v:Int):Void {
		waitTicks = v;
	}
	public function setWaitCond(cond:Expression):Void {
		waitCond = cond;
	}
	public function vanish(actorName:String = null):Void {
		if (actorName == null) {
			remove();
		} else {
			for (ca in childActors) {
				if (ca.name == actorName) ca.remove();
			}
		}
	}
	public function remove():Void {
		isRemoving = true;
	}
	public function notify(actorName:String = null):Void {
		if (actorName == null) {
			if (parent != null) parent.notifyThis();
			return;
		}
		for (ca in childActors) {
			if (ca.name == actorName) ca.notifyThis();
		}
	}
	public function notifyThis():Void {
		waitTicks = 0;
		waitCond = null;
	}
	public function getReadOnlyVariableValue(name:String):Float {
		switch (name) {
		case "$playerX", "$px":
			return stglManager.playerX / stglManager.screenWidth;
		case "$playerY", "$py":
			return stglManager.playerY / stglManager.screenHeight;
		case "$enemyCount", "$ec":
			return stglManager.enemyCount;
		case "$angleToPlayer", "$atp":
			var px = stglManager.playerX / stglManager.screenWidth;
			var py = stglManager.playerY / stglManager.screenHeight;
			return Math.atan2(px - xVar.value, py - yVar.value) * 180 / Math.PI;
		case "$distanceToPlayer", "$dtp":
			var ox = stglManager.playerX - xVar.value * stglManager.screenWidth;
			var oy = stglManager.playerY - yVar.value * stglManager.screenHeight;
			return Math.sqrt(ox * ox + oy * oy) /
				Math.min(stglManager.screenWidth, stglManager.screenHeight);
		case "$ticks", "$t":
			return ticks;
		case "$parentX", "$prx":
			if (parent == null) throw "parent doesn't exist";
			return parent.xVar.value;
		case "$parentY", "$pry":
			if (parent == null) throw "parent doesn't exist";
			return parent.yVar.value;
		case "$infinity", "$inf":
			return 9999999;
		default:
			throw "invalid READ_ONLY_VARIABLE: " + name;
		}
	}
	function removeChildTurret():Void {
		for (c in childActors) {
			if (c.type == ActorType.Turret) c.remove();
		}
	}
	function getExists():Bool {
		return !isRemoving;
	}
}