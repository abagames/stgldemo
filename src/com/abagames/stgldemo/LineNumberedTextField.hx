package com.abagames.stgldemo;
import flash.display.Sprite;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
class LineNumberedTextField extends Sprite {
	public var hasFocus = false;
	public function new(width:Float = 320, height:Float = 480) {
		super();
		createTextFields(width, height);
	}
	public var text(getText, setText):String;
	function getText():String {
		return textField.text;
	}
	function setText(s:String):String {
		textField.text = s;
		refreshLines();
		return s;
	}

	var textField:TextField;
	var lineNumberField:TextField;
	var lineHeight:Int;
	function createTextFields(width:Float, height:Float) {
		textField = new TextField();
		textField.borderColor = 0xffffff;
		textField.border = true;
		textField.backgroundColor = 0;
		textField.textColor = 0x88ff88;
		textField.width = width - 36;
		textField.height = height - 8;
		textField.multiline = true;
		textField.type = TextFieldType.INPUT;
		textField.x = 32;
		textField.y = 3;
		textField.addEventListener(FocusEvent.KEY_FOCUS_CHANGE, onKeyFocusChange);
		textField.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		textField.addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
		textField.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
		var textFormat = new TextFormat();
		var tabStops = new Array<Int>();
		for (i in 0...20) tabStops.push((i + 1) * 20);
		textFormat.tabStops = tabStops;
		textFormat.font = "_typewriter";
		textField.defaultTextFormat = textFormat;
		addChild(textField);
		lineNumberField = new TextField();
		lineNumberField.y = textField.y;
		lineNumberField.width = 32;
		lineNumberField.height = textField.height;
		lineNumberField.multiline = true;
		lineNumberField.backgroundColor = 0;
		lineNumberField.textColor = 0xffff88;
		var lnTextFormat = new TextFormat();
		lnTextFormat.align = TextFormatAlign.RIGHT;
		lnTextFormat.underline = true;
		lnTextFormat.font = "_typewriter";
		lineNumberField.defaultTextFormat = lnTextFormat;
		addChild(lineNumberField);
		lineHeight = Std.int(textField.height / textField.getLineMetrics(0).height);
		refreshLines();
	}
	function onKeyFocusChange(e:FocusEvent):Void {
		e.preventDefault();
		var tf = cast(e.currentTarget, TextField);
		tf.replaceText(tf.caretIndex, tf.caretIndex, "\t");
		tf.setSelection(tf.caretIndex + 1, tf.caretIndex + 1);
	}
	function onKeyUp(e:KeyboardEvent):Void {
		refreshLines();
		if (e.keyCode != 13) return;
		var prevLineIndex = textField.getLineIndexOfChar(textField.caretIndex - 1);
		if (prevLineIndex < 0) return;
		var lineText = textField.getLineText(prevLineIndex);
		var indexStr = "";
		for (i in 0...lineText.length) {
			var c = lineText.charAt(i);
			if (c == " " || c == "\t") indexStr += c;
			else break;
		}
		var ci = textField.caretIndex;
		textField.replaceText(ci, ci, indexStr);
		ci += indexStr.length;
		textField.setSelection(ci, ci);
	}
	var prevScrollV = -1;
	var prevNumLines = -1;
	function refreshLines() {
		if (prevScrollV == textField.scrollV && prevNumLines == textField.numLines) return;
		var text = "";
		var el = Std.int(Math.min(textField.scrollV + lineHeight - 1, textField.numLines));
		for (i in textField.scrollV...el + 1) {
			text += i + "\n";
		}
		lineNumberField.text = text;
		prevScrollV = textField.scrollV;
		prevNumLines = textField.numLines;
	}
	function onFocusIn(e:FocusEvent) {
		hasFocus = true;
	}
	function onFocusOut(e:FocusEvent) {
		hasFocus = false;
	}
}