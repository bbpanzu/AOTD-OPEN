package states;

import flixel.*;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxAssets;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import level.Basement;
import level.LVL7;
import level.LVL_Test;
import states.CharSelect;
/**
 * ...
 * @author ...
 */
class GameModeState extends AOTDState
{
	public var titleImg:FlxSprite = new FlxSprite(0, 0);
	public var bgGroup:FlxSpriteGroup = new FlxSpriteGroup();
	public var menu:FlxSpriteGroup = new FlxSpriteGroup();
	
	public var choice:Int = 0;
	public var choicetxt:Array<String> = ["STORY MODE","ARCADE MODE","PRACTICE","BACK"];
	public var texts:FlxText = new FlxText(0, 0,FlxG.width);
	public var vers:FlxText = new FlxText(0, 0,FlxG.width);
	public var mbg_select:FlxSprite =  new FlxSprite(0, 0).makeGraphic(FlxG.width, 14, 0x33FFFFFF);
	public var optbg:FlxSprite =  new FlxSprite(0, 0).makeGraphic(FlxG.width, 14, 0x33FFFFFF);
	public var onOptions:Bool = false;
	public function new() 
	{
		super();
		menu.y = (FlxG.height / 2);
		texts.setFormat("assets/fonts/AOTDdefault.ttf", 16, FlxColor.WHITE, "center",FlxTextBorderStyle.OUTLINE,0xFF000000);
		add(bgGroup);
		bgGroup.add(new FlxSprite().loadGraphic("assets/sprites/bg/menu/bg.png"));
		
		
		
		titleImg.screenCenter();
		titleImg.offset.set(96, 32);
		titleImg.loadGraphic("assets/sprites/logo3.png", false, 192, 64);
		titleImg.y -= 64;
		
		
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
		
	}
	
	override public function create():Void 
	{
		super.create();
		
		FlxG.camera.flash(FlxColor.BLACK);
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
			case "STORY MODE":
				trace("going to play");
				AOTD.gameMode = 0;
				for (i in AOTD.playerData){
					i.initx = Basement.spawn._x;
					i.inity = Basement.spawn._y;
					i.initz = Basement.spawn._z;
					
					
					i.x = i.initx;
					i.y = i.inity;
					i.z = i.initz;
				}
				FlxG.switchState(new StageSelectState());
			case "ARCADE MODE":
				AOTD.gameMode = 1;
				trace("going to play");
				for (i in AOTD.playerData){
					i.initx = Basement.spawn._x;
					i.inity = Basement.spawn._y;
					i.initz = Basement.spawn._z;
					
					
					i.x = i.initx;
					i.y = i.inity;
					i.z = i.initz;
				}
				FlxG.switchState(new CharSelect());
			case "PRACTICE":
				AOTD.gameMode = 2;
				trace("going to play");
				for (i in AOTD.playerData){
					i.initx = LVL_Test.spawn._x;
					i.inity = LVL_Test.spawn._y;
					i.initz = LVL_Test.spawn._z;
					
					
					i.x = i.initx;
					i.y = i.inity;
					i.z = i.initz;
				}
				FlxG.switchState(new LVL_Test());
			case "BACK":
				trace("going back");
				FlxG.switchState(new TitleState());
		}
	}
}