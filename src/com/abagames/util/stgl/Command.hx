package com.abagames.util.stgl;
class Command {
	public static var s:Hash<Command>;
	static inline var COMMAND_EREG = ~/^([@\$:]?\w+)(?:\s*)(<?[\+\-]?=>?)?(?:\s+)?(.*)$/;
	public static function read(string:String) {
		s = new Hash<Command>();
		var lineCount = 0;
		var indentSpaceCounts = new Array<Int>();
		var indentSpaceCount = 0;
		var parents = new Array<Command>();
		indentSpaceCounts.push(indentSpaceCount);
		var lines = string.split("\r\n").join("\n").split("\n");
		lines.push(":bullet");
		lines.push("fire angle, speed");
		lines.push("	@angle = angle");
		lines.push("	@speed = speed");
		var parent:Command = null;
		var current:Command = null;
		var currentActorType:ActorType = None;
		var errorMessages = "";
		var errorCount = 0;
		for (line in lines) {
			lineCount++;
			var ci = line.indexOf("#");
			if (ci >= 0) line = line.substr(0, ci);
			if (line.length <= 0) continue;
			var isc = 0;
			while (true) {
				var cc = line.charCodeAt(isc);
				if (cc != 9 && cc != 32) break;
				isc++;
			}
			if (line.length <= isc) continue;
			var l = line.substr(isc, line.length - isc);
			var ereg = COMMAND_EREG;
			if (!ereg.match(l)) {
				errorMessages += "l." + lineCount + " parse error (" + l + ")\n";
				errorCount++;
				continue;
			}
			var commandName = ereg.matched(1);
			if (commandName.charAt(0) == ':') {
				var actorTypeName = commandName.substr(1);
				switch (actorTypeName) {
				case "none": currentActorType = null;
				case "stage": currentActorType = Stage;
				case "enemy": currentActorType = Enemy;
				case "turret": currentActorType = Turret;
				case "bullet": currentActorType = Bullet;
				default:
					errorMessages +=  "l." + lineCount + " invalid ACTOR_TYPE: " +
					actorTypeName + " (" + l + ")\n";
					errorCount++;
				}
				continue;
			}
			var commandOperator =  ereg.matched(2);
			var argStr = ereg.matched(3);
			var args:Array<String> = null;
			if (argStr.length > 0) args = ereg.matched(3).split(",");
			if (parent == null) indentSpaceCount = isc;
			if (isc > indentSpaceCount) {
				indentSpaceCounts.push(indentSpaceCount);
				indentSpaceCount = isc;
				parents.push(parent);
				parent = current;
			} else if (isc < indentSpaceCount) {
				while (isc < indentSpaceCount) {
					indentSpaceCount = indentSpaceCounts.pop();
					parent = parents.pop();
				}
			}
			if (parents.length == 0 && parent != null) {
				addRootCommand(parent.name, parent);
				parent = null;
			}
			try {
				current = new Command
					(currentActorType, commandName, commandOperator, args, lineCount);
			} catch (msg:String) {
				errorMessages += "l." + lineCount + " " + msg + " (" + l + ")\n";
				errorCount++;
				continue;
			}
			if (parent == null) parent = current;
			else parent.children.push(current);
		}
		if (parents.length > 0) addRootCommand(parents[0].name, parents[0]);
		if (errorCount > 0) {
			throw errorCount + " error(s)\n" + errorMessages;
		}
	}
	static function addRootCommand(name:String, command:Command):Void {
		s.set(name, command);
		if (command.actorType == ActorType.Turret) {
			command.addChildToHead(new Command(command.actorType, 
				"@y", "<=", ["$parentY"], -1));
			command.addChildToHead(new Command(command.actorType, 
				"@x", "<=", ["$parentX"], -1));
		}
		if (command.actorType == ActorType.Stage || command.actorType == ActorType.Turret) {
			command.addChildToTail(new Command(command.actorType, 
				"vanish", null, null, -1));
		}
	}
	public var name:String;
	public var actorType:ActorType;
	public var type:CommandType;
	public var args:Array<Expression>;
	public var children:Array<Command>;
	public var lineCount:Int;
	public function new
	(actorType:ActorType,
	commandName:String, commandOperator:String, argStrs:Array<String>,
	lineCount:Int) {
		this.actorType = actorType;
		this.lineCount = lineCount;
		name = commandName;
		if (commandOperator != null && commandOperator.length > 0) {
			var ereg = ~/^@?\w+$/;
			if (!ereg.match(commandName)) throw "invalid VARIABLE: " + commandName;
			switch (commandOperator) {
			case "=": type = Var(commandName, Assignment);
			case "+=": type = Var(commandName, Add);
			case "-=": type = Var(commandName, Sub);
			case "<=": type = Var(commandName, ConsistentlyAssignment);
			case "<+=": type = Var(commandName, ConsistentlyAdd);
			case "<-=": type = Var(commandName, ConsistentlySub);
			case "=>": type = Var(commandName, Target);
			default: throw "invalid COMMAND_NAME: " + commandName + " " + commandOperator;
			}
			name += " " + commandOperator;
		} else {
			var ereg = ~/^\w+$/;
			if (!ereg.match(commandName)) throw "invalid COMMAND_NAME: " + commandName;
			switch (commandName) {
			case "repeat": type = Repeat;
			case "while": type = While;
			case "wait": type = Wait;
			case "waitUntil": type = WaitUntil;
			case "vanish": type = Vanish;
			case "notify": type = Notify;
			default: type = Function(commandName);
			}
		}
		args = new Array<Expression>();
		if (argStrs != null) for (a in argStrs) args.push(new Expression(a));
		children = new Array<Command>();
	}
	public function addChildToHead(command:Command):Void {
		children.unshift(command);
	}
	public function addChildToTail(command:Command):Void {
		children.push(command);
	}
	public function toString(indent:Int = 0):String {
		var s:String = "";
		for (i in 0...indent) s += " ";
		s += name + " ";
		for (a in args) s += a.string + ",";
		s = s.substr(0, s.length - 1);
		/*if (children != null && children.length > 0) {
			s += "\n";
			for (c in children) s += c.toString(indent + 1) + "\n";
		}*/
		return s;
	}
}