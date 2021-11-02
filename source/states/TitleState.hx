package states;

import flixel.*;
import enums.GameMode;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.system.FlxAssets;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import level.Basement;
import level.LVL7;
import level.LVL_Test;
import openfl.system.System;
/**
 * ...
 * @author ...
 */
class TitleState extends AOTDState
{
	public var titleImg:FlxSprite = new FlxSprite(0, 0);
	public var bgGroup:FlxSpriteGroup = new FlxSpriteGroup();
	public var menu:FlxSpriteGroup = new FlxSpriteGroup();
	
	public var choice:Int = 0;
	public var choicetxt:Array<String> = ["START GAME","HOW TO PLAY","SETTINGS","CREDITS","QUIT"];
	public var texts:FlxText = new FlxText(0, 0,FlxG.width);
	public var vers:FlxText = new FlxText(0, 0,FlxG.width);
	public var mbg_select:FlxSprite =  new FlxSprite(0, 0).makeGraphic(FlxG.width, 14, 0x33FFFFFF);
	public var optbg:FlxSprite =  new FlxSprite(0, 0).makeGraphic(FlxG.width, 14, 0x33FFFFFF);
	public var onOptions:Bool = false;
	public function new() 
	{
		super();
		AOTD.resetGame();
		menu.y = (FlxG.height / 2);
		texts.setFormat("assets/fonts/AOTDdefault.ttf", 16, FlxColor.WHITE, "center",FlxTextBorderStyle.OUTLINE,0xFF000000);
		add(bgGroup);
		for (i in 1...10){
			bgGroup.add(new FlxSprite(0, 0)).loadGraphic("assets/sprites/titlescreen/ts" + (10 - i) + ".png");
			bgGroup.members[i-1].scrollFactor.set((i-1)*0.9,(i-1)*0.9);
			bgGroup.members[0].scrollFactor.set();
		} 
		
		
		
		titleImg.screenCenter();
		titleImg.offset.set(96, 32);
		titleImg.loadGraphic("assets/sprites/logo3.png", false, 192, 64);
		titleImg.y -= 64;
		add(titleImg);
		
		FlxG.sound.playMusic("assets/mus/mainmenu.ogg");
		
		add(menu);
		
		
		for(u in choicetxt){
		texts.text += u + "\n";
		}
		texts.borderSize = 1;
		var mbg:FlxSprite =  new FlxSprite(0, 0).makeGraphic(FlxG.width, 80, 0x66000000);
		var line:FlxSprite =  new FlxSprite(0, 0).makeGraphic(FlxG.width, 1, 0xFFFFFFFF);
		var line2:FlxSprite =  new FlxSprite(0, 0).makeGraphic(FlxG.width, 1, 0xFFFFFFFF);
		line2.y = 80;
		texts.y = 3;
		menu.add(mbg);
		menu.add(mbg_select);
		menu.add(line);
		menu.add(line2);
		menu.add(texts);
		menu.scrollFactor.set(1.3, 1.3);
		
		mbg_select.y = menu.y + (choice * 14) + 5;
		
		var verstxt:FlxText = new FlxText(0, 254, 0, "AOTD v0.1.0 alpha", 8);
		verstxt.scrollFactor.set();
		add(verstxt);
	}
	
	override public function create():Void 
	{
		super.create();
		
		FlxG.camera.flash();
		FlxTween.tween(FlxG.camera.scroll, {y: -8}, 1, {ease:FlxEase.quadOut, type:BACKWARD}).start();
	}
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		if(!onOptions){
			if (FlxG.keys.anyJustPressed(AOTD.keyset.DOWN)){
				choice++;
				if (choice == choicetxt.length) choice = 0;
				FlxTween.tween(mbg_select, {y:  menu.y + (choice * 14) + 5}, 0.125, {ease:FlxEase.circOut}).start();
			}
			if (FlxG.keys.anyJustPressed(AOTD.keyset.UP)){
				if (choice == 0) choice = choicetxt.length;
				choice--;
				FlxTween.tween(mbg_select, {y:  menu.y + (choice * 14) + 5}, 0.125, {ease:FlxEase.circOut}).start();
			}
			if (FlxG.keys.anyJustPressed(AOTD.keyset.PUNCH)){
				checkChoice();
			}
		}else{
			
		}
		//mbg_select.y = menu.y + (choice * 14) + 5;
		
		
	}
	
	private function checkChoice(){
		switch(choicetxt[choice]){
			case "START GAME":
				trace("going to play");
				FlxG.switchState(new GameModeState());
			case "HOW TO PLAY":
				trace("going to play");
				openSubState(new OptionsSubstate(["WASD SPACE/ARROW KEYS + NUMPAD0 ----- MOVE/NAVIGATE", "P/NUMPAD 1 ----- PUNCH/SELECT", "O/NUMPAD 2 ----- KICK/CANCEL", "I/NUMPAD 3 ----- INTERACT", "BACKSPACE ---- PAUSE", "EXIT"],"HOW TO PLAY"));
			case "SETTINGS":
				trace("going to play");
				openSubState(new OptionsSubstate(["VIDEO", "AUDIO", "EXIT"],"SETTINGS"));
			case "QUIT":
				System.exit(0);
			case "CREDITS":
				trace("going to play");
				openSubState(new OptionsSubstate(["Programmer- bbpanzu","Artists- bbpanzu","Animator- bbpanzu","Musician- bbpanzu","EXIT"]));
		}
	}
}