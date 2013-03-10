package com.abagames.util.stgl;
enum CommandType {
	Repeat;
	While;
	Wait;
	WaitUntil;
	Vanish;
	Notify;
	Function(name:String);
	Var(name:String, type:VarCommandType);
}