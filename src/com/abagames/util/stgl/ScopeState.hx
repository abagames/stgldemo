package com.abagames.util.stgl;
class ScopeState {
	var actor:StglActor;
	var rootCommand:Command;
	var programCount = 0;
	var repeatCount = 1;
	var whileCond:Expression;
	public function new
	(actor:StglActor, rootCommand:Command, repeatCount:Int = 1, whileCond:Expression = null) {
		this.actor = actor;
		this.rootCommand = rootCommand;
		this.repeatCount = repeatCount;
		this.whileCond = whileCond;
	}
	public function update():Void {
		if (programCount >= rootCommand.children.length) {
			repeatCount--;
			if (repeatCount > 0 || (whileCond != null && whileCond.calc(actor) == 1)) {
				programCount = 0;
			} else {
				actor.popScopeState();
				return;
			}
		}
		var command = rootCommand.children[programCount];
		programCount++;
		try {
			doCommand(command);
		} catch (msg:String) {
			var tMsg = msg;
			if (msg.indexOf("l.") != 0) tMsg = "l." + command.lineCount + 
				" " + msg + " (" + command.toString() + ")";
			throw tMsg;
		}
	}
	function doCommand(command:Command):Void {
		switch (command.type) {
		case Repeat:
			var count = 9999999;
			if (command.args.length > 0) count = Std.int(command.args[0].calc(actor));
			actor.pushScopeState(new ScopeState(actor, command, count));
		case While:
			var cond:Expression;
			if (command.args.length > 0) cond = command.args[0];
			else cond = Expression.TRUE;
			actor.pushScopeState(new ScopeState(actor, command, 1, cond));
		case Wait:
			var count = 9999999;
			if (command.args.length > 0) count = Std.int(command.args[0].calc(actor));
			actor.setWaitTicks(count);
		case WaitUntil:
			var cond:Expression;
			if (command.args.length > 0) cond = command.args[0];
			else cond = Expression.FALSE;
			actor.setWaitCond(cond);
		case Vanish:
			var name:String = null;
			if (command.args.length > 0) name = command.args[0].getAsName();
			actor.vanish(name);
		case Notify:
			var name:String = null;
			if (command.args.length > 0) name = command.args[0].getAsName();
			actor.notify(name);
		case Function(name):
			var args = new Array<Float>();
			for (a in command.args) args.push(a.calc(actor));
			StglActor.add(name, args, actor);
		case Var(name, type):
			var v = actor.vars.get(name);
			if (v == null) v = actor.addVar(name);
			v.targetTicks = 0;
			v.consistentlyValue = null;
			v.consistentlyAdd = null;
			v.consistentlySub = null;
			var a = command.args[0];
			if (a == null) throw "lack of the assignment value";
			switch (type) {
			case Assignment:
				v.value = a.calc(actor);
			case Add:
				v.value += a.calc(actor);
			case Sub:
				v.value -= a.calc(actor);
			case Target:
				v.target = a.calc(actor);
			case ConsistentlyAssignment:
				v.consistentlyValue = a;
			case ConsistentlyAdd:
				v.consistentlyAdd = a;
			case ConsistentlySub:
				v.consistentlySub = a;
			}
			if (type == VarCommandType.Target) {
				if (command.args.length < 2) throw "lack of the target ticks argument";
				v.targetTicks = Std.int(command.args[1].calc(actor));
			}
		}
	}
}