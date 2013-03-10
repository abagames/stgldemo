package com.abagames.util;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;
class Bgm {
	public function new(sound:Sound) {
		this.sound = sound;
		soundTransform = new SoundTransform();
	}
	public function play():Void {
		if (currentBgm != null) currentBgm.stop();
		soundTransform.volume = 0.9;
		isFadingOut = false;
		soundChannel = sound.play(0, 999999, soundTransform); 
		currentBgm = this;
	}
	public function fadeOut():Void {
		if (soundChannel == null) return;
		isFadingOut = true;
	}
	public function stop():Void {
		if (soundChannel == null) return;
		soundChannel.stop();
		soundChannel = null;
		currentBgm = null;
	}

	var sound:Sound;
	var soundChannel:SoundChannel;
	var soundTransform:SoundTransform;
	var isFadingOut = false;
	public function handleFadeOut():Void {
		if (soundChannel == null || !isFadingOut) return;
		soundTransform.volume -= 0.015;
		soundChannel.soundTransform = soundTransform;
		if (soundTransform.volume <= 0.05) stop();
	}
	static var currentBgm:Bgm;
	public static function update():Void {
		if (currentBgm == null) return;
		currentBgm.handleFadeOut();
	}
}