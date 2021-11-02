package states;
import flixel.*;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxBitmapText;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.ui.Window;
import openfl.Lib;
import openfl.system.System;

/**
 * ...
 * @author bbpanzu
 */
class OptionsSubstate extends FlxSubState
{

	//0 main menu
	//1 graphics
	//2 audio
	//3 controls
	
	/*for graphics
	
	-toggle res (960x540)
	-toggle fps (60fps) 15fps-60fps
	-post-proccessing effects
	-back
	
	/*for audio
	
	-sfx volume (100%)
	-music volume(100%)
	-sound test
	-back
	
	/*for controls
	
	-left [A]
	-up [W]
	-down[S]
	-right[D]
	-jump[SPACE]
	
	-punch/accept [P]
	-kick/back [O]
	-interact[I]
	-force[U]
	
	*/
	
	
	
	public var titleImg:FlxSprite = new FlxSprite(0, 0);
	public var bgGroup:FlxSpriteGroup = new FlxSpriteGroup();
	public var menu:FlxSpriteGroup = new FlxSpriteGroup();
	
	public var choice:Int = 0;
	public var choicetxt:Array<String> = ["RESUME","SETTINGS","EXIT TO MENU"];
	public var menuText:String = "PAUSE";
	public var texts:FlxText = new FlxText(0, 0,FlxG.width);
	public var vers:FlxText = new FlxText(0, 0,FlxG.width);
	public var mbg_select:FlxSprite =  new FlxSprite(0, 0).makeGraphic(FlxG.width, 14, 0x33FFFFFF);
	public var optbg:FlxSprite =  new FlxSprite(0, 0).makeGraphic(FlxG.width, 14, 0x33FFFFFF);
	public var onOptions:Bool = false;
	public var musvol:Float = 0;
	public var musvol2:Float = 0;
	public var onVolume:String = "";
	public var lastState:FlxState;
	public var topHeader:FlxBitmapText;
	public function new(choiceArr:Array<String>=null,name:String ="") 
	{
		//lastState = state;
		if (choiceArr != null) choicetxt = choiceArr;
		if (name != null) menuText = name;
		super();
	}
	override public function create():Void 
	{
		super.create();
		//FlxTween.tween(FlxG.camera.scroll, {y: -8}, 1, {ease:FlxEase.quadOut, type:BACKWARD}).start();
		
		var bg:FlxSprite = new FlxSprite(0, 0);
		bg.makeGraphic(480, 270, 0x66000000);
		add(bg);
		menu.y = (FlxG.height / 2);
		texts.setFormat("assets/fonts/AOTDdefault.ttf", 16, FlxColor.WHITE, "center",FlxTextBorderStyle.OUTLINE,0xFF000000);
		add(bgGroup);
		bgGroup.add(new FlxSprite().loadGraphic("assets/sprites/bg/menu/bg.png"));
		titleImg.offset.set(96, 32);
		titleImg.loadGraphic("assets/sprites/logo3.png", false, 192, 64);
		titleImg.y -= 64;
		topHeader = new FlxBitmapText(Font.THICK);
		topHeader.fieldWidth = 360;
		topHeader.screenCenter();
		topHeader.y -= 16;
		topHeader.scrollFactor.set();
		topHeader.alignment = "center";
		
		
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
		menu.scrollFactor.set(0, 0);
		mbg.scrollFactor.set();
		
		menu.scrollFactor.set();
		titleImg.scrollFactor.set();
		bgGroup.scrollFactor.set();
		texts.scrollFactor.set();
		bg.scrollFactor.set();
		titleImg.screenCenter();
		mbg_select.scrollFactor.set();
		mbg_select.y = menu.y + (choice * 14) + 5;
		add(topHeader);
		
	}
	
	
	public function changeChoices(choiceArr:Array<String>,header:String=""){
		choice = 0;
		onVolume = "";
				FlxTween.tween(mbg_select, {y:  menu.y + (choice * 14) + 5}, 0.125, {ease:FlxEase.circOut}).start();
		choicetxt = choiceArr;
		texts.text = "";
		menuText = header;
		for(u in choicetxt){
		texts.text += u + "\n";
		}
	}
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		topHeader.text = menuText;
		topHeader.screenCenter();
		if (!onOptions){
			
			if (FlxG.keys.anyJustPressed(AOTD.keyset.DOWN)){
			FlxG.sound.play(AOTD.getSFX("sfx_hud_hover"));
				choice++;
				if (choice == choicetxt.length) choice = 0;
				FlxTween.tween(mbg_select, {y:  menu.y + (choice * 14) + 5}, 0.125, {ease:FlxEase.circOut}).start();
			}
			if (FlxG.keys.anyJustPressed(AOTD.keyset.UP)){
			FlxG.sound.play(AOTD.getSFX("sfx_hud_hover"));
				if (choice == 0) choice = choicetxt.length;
				choice--;
				FlxTween.tween(mbg_select, {y:  menu.y + (choice * 14) + 5}, 0.125, {ease:FlxEase.circOut}).start();
			}
			if (FlxG.keys.anyJustPressed(AOTD.keyset.PUNCH)){
					FlxG.sound.play(AOTD.getSFX("sfx_hud_select"));
				checkChoice();
			}
		}else{
			
		}
		
		if (onVolume != ""){
			
			if (FlxG.keys.anyPressed(AOTD.keyset.LEFT)){
				if (onVolume == "snd") FlxG.sound.volume -= 0.01;
				if (onVolume == "mus") FlxG.sound.music.volume -= 0.01;
			}
			if (FlxG.keys.anyPressed(AOTD.keyset.RIGHT)){
				if (onVolume == "snd") FlxG.sound.volume += 0.01;
				if (onVolume == "mus") FlxG.sound.music.volume += 0.01;
			}
			if (FlxG.sound.volume < 0) FlxG.sound.volume = 0;
			if (FlxG.sound.music.volume < 0) FlxG.sound.music.volume = 0;
			if (FlxG.sound.volume > 1) FlxG.sound.volume = 1;
			if (FlxG.sound.music.volume > 1) FlxG.sound.music.volume = 1;
		}
		if (FlxG.keys.anyJustPressed(AOTD.keyset.PAUSE)){
		FlxG.sound.play("assets/sfx/sfx_pause.ogg");
			//lastState.persistentUpdate = false;
			this.close();
		}
		//mbg_select.y = menu.y + (choice * 14) + 5;
		
		
	}
	
	private function checkChoice(){
		
		switch(choicetxt[choice]){
			case "RESUME" | "EXIT":
				//lastState.persistentUpdate = false;
				close();
			case "EXIT TO MENU" | "YES":
				//lastState.persistentUpdate = false;
				close();
				AOTD.properlyExit();
				FlxG.switchState(new TitleState());
			case "SETTINGS" | "BACK TO SETTINGS":
				var b = "EXIT TO MENU";
				if (AOTD.midGame) b = "BACK";
				changeChoices(["VIDEO", "AUDIO",b],"SETTINGS");
			case "VIDEO" | "BACK TO VIDEO SETTINGS":
				changeChoices(["TOGGLE RESOLUTION", "TOGGLE FPS", "TOGGLE CRT FILTER", "BACK TO SETTINGS"],"VIDEO SETTINGS");
			case "AUDIO"| "BACK TO AUDIO SETTINGS":
				changeChoices(["MUSIC VOL", "SOUND VOL", "BACK TO SETTINGS"],"AUDIO SETTINGS");
			case "SOUND VOL":
				changeChoices(["MUSIC VOL","< SOUND VOL >","BACK TO AUDIO SETTINGS"],"SOUND SETTINGS");
				choice++;
				if (choice == choicetxt.length) choice = 0;
				FlxTween.tween(mbg_select, {y:  menu.y + (choice * 14) + 5}, 0.125, {ease:FlxEase.circOut}).start();
				onVolume = "snd";
			case "MUSIC VOL":
				changeChoices(["< MUSIC VOL >", "SOUND VOL","BACK TO AUDIO SETTINGS"],"MUSIC SETTINGS");
				onVolume = "mus";
			//VIDEO
			case "TOGGLE RESOLUTION":
				#if desktop
				if(!Lib.application.window.fullscreen){
					switch (Lib.application.window.height){
						case 270:
							Lib.application.window.width = 960;
							Lib.application.window.height = 540;
						case 540:
							Lib.application.window.width = 1440;
							Lib.application.window.height = 810;
						case 810:
							Lib.application.window.width = 1920;
							Lib.application.window.height = 1080;
						case 1080:
							Lib.application.window.fullscreen = true;
					}
				}else{
					Lib.application.window.fullscreen = false;
							Lib.application.window.width = 480;
							Lib.application.window.height = 270;
				}
				#end
			case "TOGGLE FPS":
				switch (FlxG.drawFramerate){
					case 60:
						FlxG.drawFramerate = 15;
					case 15:
						FlxG.drawFramerate = 30;
					case 30:
						FlxG.drawFramerate = 60;
				}
			case "TOGGLE CRT FILTER":
				AOTD.crt(!AOTD.crtFilter);
			case "BACK":
				trace("going back");
				changeChoices(["RESUME", "SETTINGS", "QUIT"],"PAUSE");
			case " ":
				trace("penis");
			case "QUIT":
				
				changeChoices(["NO", "YES"],"Data will not be saved. Continue?");
				
			case "NO":
				changeChoices(["RESUME", "SETTINGS", "QUIT"]);
		}
	}
	
}