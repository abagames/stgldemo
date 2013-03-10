package com.abagames.util.stgl;
class Variable {
	public var name:String;
	public var value = 0.0;
	public var target = 0.0;
	public var targetTicks = 0;
	public var consistentlyValue:Expression = null;
	public var consistentlyAdd:Expression = null;
	public var consistentlySub:Expression = null;
	public function new(name:String) {
		this.name = name;
	}
	public function update(actor:StglActor):Void {
		if (targetTicks > 0) {
			value += (target - value) / targetTicks;
			targetTicks--;
		}
		if (consistentlyValue != null) value = consistentlyValue.calc(actor);
		if (consistentlyAdd != null) value += consistentlyAdd.calc(actor);
		if (consistentlySub != null) value -= consistentlySub.calc(actor);
	}
}