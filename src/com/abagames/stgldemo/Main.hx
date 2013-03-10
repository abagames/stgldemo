package com.abagames.stgldemo;
import com.abagames.util.Actor;
import com.abagames.util.Button;
import com.abagames.util.Color;
import com.abagames.util.DotShape;
import com.abagames.util.Frame;
import com.abagames.util.Key;
import com.abagames.util.Letter;
import com.abagames.util.Message;
import com.abagames.util.Mouse;
import com.abagames.util.Particle;
import com.abagames.util.Platform;
import com.abagames.util.Screen;
import com.abagames.util.Se;
import com.abagames.util.SeType;
import com.abagames.util.Xy;
import com.abagames.util.stgl.Command;
import com.abagames.util.stgl.Expression;
import com.abagames.util.stgl.StglActor;
import flash.Lib;
using Math;
using com.abagames.util.FloatUtil;
using com.abagames.util.IntUtil;
class Main extends Frame {
	static var parsedSe = new Se().b(SeType.Major).t(0.1, 3, 0.5).t(0.3, 3, 0.7).t(0.5, 3, 0.9).e();
	static var inGameSe = new Se().b(SeType.Minor).t(0.3, 2, 0.2).r().t(0.3, 2, 0.2).e();
	var sManager:SManager;
	var textField:LineNumberedTextField;
	var startButton:Button;
	var sampleOpenButton:Button;
	var sampleButtons:Array<Button>;
	var isSampleButtonsOpen = false;
	var player:Player;
	var consoleMessages:Array<String>;
	var hasError = false;
	var starAddTicks = 0;
	var isStarted = false;
	var isF5Pressed = false;
	public function new() {
		super(320, 0, 320, 480);
	}
	override public function initializeFirst():Void {
		title = "STGL DEMO";
		isDebugging = false;
		platform = new Platform();
		textField = new LineNumberedTextField();
		Lib.current.stage.addChild(textField);
		setSample(Sample.s.length - 1);
		startButton = new Button("START", 10, 10, 80, 25);
		sampleOpenButton = new Button("SAMPLES", 120, 10, 100, 25);
		sampleButtons = new Array<Button>();
		for (i in 0...Sample.s.length) {
			sampleButtons.push(new Button(Sample.s[i][0].toUpperCase(),
				120, 40 + i * 30, 180, 25));
		}
		sManager = new SManager();
		StglActor.initialize(sManager);
		player = new Player(sManager);
		Shot.s = new Array<Shot>();
		Star.s = new Array<Star>();
		consoleMessages = new Array<String>();
	}
	function setSample(i) {
		textField.text = Sample.s[i][1].split("\r\n").join("\r");
	}
	override public function initialize():Void {
		isStarted = false;
		SActor.s = new Array<SActor>();
		setConsoleMessage("");
	}
	override public function update():Void {
		if (ticks == 0) {
			Message.addOnce("u", new Xy(50, 40));
			Message.addOnce("PUSH 'START' TO PARSE STGL", new Xy(140, 60));
		} else if (ticks == 30) {
			Message.addOnce("u ", new Xy(180, 80));
			Message.addOnce("OR SELECT OTHER 'SAMPLES'", new Xy(170, 100));
		} else if (ticks == 60) {
			Message.addOnce("l", new Xy(10, 120));
			Message.addOnce("OR WRITE YOUR OWN STGL", new Xy(120, 140));
		} else if (ticks == 120) {
			Message.addOnce("[u][d][l][r]: MOVE YOUR SHIP", new Xy(150, 400));
			Message.addOnce("[Z]: FIRE", new Xy(150, 420));
			Message.addOnce("[F5]: START", new Xy(150, 450));
		}
		if (--starAddTicks <= 0) {
			Star.s.push(new Star());
			starAddTicks = 5;
		}
		Actor.updateAll(Star.s);
		Particle.updateAll();
		Actor.updateAll(Shot.s);
		player.isAbleToMove = !textField.hasFocus;
		player.update();
		if (!hasError && player.isAbleToMove) {
			try {
				Actor.updateAll(SActor.s);
			} catch (msg:String) {
				setError(msg);
			}
			if (ticks % 60 == 0) inGameSe.play();
		} else {
			if (isStarted) initialize();
		}
		drawConsoleMessage();
		Message.updateAll();
		startButton.update();
		if (startButton.isClicked || (!isF5Pressed && Key.s[116])) {
			Lib.current.stage.focus = null;
			isSampleButtonsOpen = false;
			readStgl();
		}
		isF5Pressed = Key.s[116];
		sampleOpenButton.update();
		if (sampleOpenButton.isClicked) {
			isSampleButtonsOpen = !isSampleButtonsOpen;
		} else if (isSampleButtonsOpen) {
			var i = 0;
			for (b in sampleButtons) {
				b.update();
				if (b.isClicked) setSample(i);
				i++;
			}
		}
	}
	function setError(msg:String) {
		player.destroy(true);
		initialize();
		setConsoleMessage(msg);
		hasError = true;
	}
	function readStgl() {
		try {
			score = 0;
			//initialize();
			Message.s = new Array<Message>();
			Command.read(textField.text.split("\r").join("\n"));
			beginGame();
			StglActor.add("main");
			setConsoleMessage("STGL SUCCESSFULLY PARSED.");
			hasError = false;
			isStarted = true;
			parsedSe.play();
		} catch (msg:String) {
			setError(msg);
		}
	}
	function setConsoleMessage(msg:String) {
		var maxChar = 30;
		consoleMessages = new Array<String>();
		for (l in msg.toUpperCase().split("\n")) {
			while (l.length > maxChar) {
				consoleMessages.push(l.substr(0, maxChar));
				l = l.substr(maxChar);
			}
			consoleMessages.push(l);
		}
	}
	function drawConsoleMessage() {
		var y = 50;
		for (l in consoleMessages) {
			Letter.drawAligned(l, 10, y, Left);
			y += 20;
		}
	}
	static function main() {
		new Main();
	}
}