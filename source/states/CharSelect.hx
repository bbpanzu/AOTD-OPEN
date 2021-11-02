package states;

import flixel.*;
import flixel.text.FlxBitmapText;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import level.Basement;
/**
 * ...
 * @author bbpanzu
 */
class CharSelect extends AOTDState
{
	var charlist = [];
	var charsel = [0];
	var character:Array<FlxSprite> = [];
	var ticks:Array<FlxSprite> = [];
	var current = ["jeremy"];
	var label:FlxText;
	var ready = 0;
	var readys = [0];
	var confirm:FlxBitmapText;
	public function new() 
	{
		super();
	}
	
	
	override public function create():Void 
	{
		super.create();
		AOTD.playerData = [AOTD.playerData[0]];
		label = new FlxText();
		add(label);
		var bg:FlxSprite = new FlxSprite().loadGraphic("assets/sprites/bg/menu/bg.png");
		add(bg);
		charlist = AOTD.characterList;
		
		
		character.push(new FlxSprite().loadGraphic("assets/sprites/players/spr_jeremy.png", true, 64, 72));
		add(character[0]);
		character[0].screenCenter(Y);
		
		ticks.push(new FlxSprite().loadGraphic("assets/sprites/misc/charselthing.png", true, 80, 80));
		add(ticks[0]);
		ticks[0].animation.add("i", [0, 1, 2], 0);
		ticks[0].screenCenter(Y);
		
		
		var text:FlxBitmapText = new FlxBitmapText(Font.THICK);
		text.text = "SELECT A CHARACTER";
		add(text);
		text.screenCenter();
		text.y -= 80;
		
		var addshit:FlxBitmapText = new FlxBitmapText(Font.SMALL);
		addshit.text = "W/S  or UP/DOWN to select characters.       I to add another player";
		add(addshit);
		addshit.setPosition(0, 254);
		
		confirm = new FlxBitmapText(Font.THICK);
		confirm.text = "CONFIRM CHARACTER(S)?";
		confirm.visible = false;
		add(confirm);
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		label.screenCenter();
		
		for (p in 0...current.length ){
			ready = 0;
			for (i in readys){
				ready += i;
			}
					ticks[p].animation.play("i", true, false, 0);
			if(ready != current.length){
				if (FlxG.keys.anyPressed(AOTD.keysets[p].UP)){
					ticks[p].animation.play("i", true, false, 2);
					
				}
				if (FlxG.keys.anyPressed(AOTD.keysets[p].DOWN)){
					
					ticks[p].animation.play("i", true, false, 1);
				}
				if (FlxG.keys.anyJustPressed(AOTD.keysets[p].UP)){
					
					FlxG.sound.play(AOTD.getSFX("sfx_hud_hover"));
					changeChars( -1,p);
				}
				
				if (FlxG.keys.anyJustPressed(AOTD.keysets[p].DOWN)){
					
					FlxG.sound.play(AOTD.getSFX("sfx_hud_hover"));
					changeChars(1,p);
					
				}
			}
			if (FlxG.keys.anyJustPressed(AOTD.keysets[p].PUNCH)){
				
				AOTD.playerData[p].character = current[p];
				character[p].alpha = 0.8;
				readys[p] = 1;
				if (ready == current.length){
					FlxG.sound.play(AOTD.getSFX("sfx_hud_start"));
				FlxTween.tween(FlxG.camera.scroll, {y: 270}, 1, {onComplete:function(e:FlxTween){
					LevelState.numPlayers = current.length+1;
					
					FlxG.switchState(new StageSelectState());
					
					
				}});
					
					
					
				}else{
					FlxG.sound.play(AOTD.getSFX("sfx_hud_select"));
					
				}
				
				trace(ready);
			}
					if(ready == current.length)confirm.visible = true;
			if (FlxG.keys.anyJustPressed(AOTD.keysets[p].KICK)){
				
				
				character[p].color.brightness = 0.5;
				readys[p] = 0;
				
			}
			if (FlxG.keys.anyJustPressed(AOTD.keysets[p].INTERACT) && current.length < 2){//you can increase this btw lol <33
				
				AOTD.playerData.push(new PlayerData());
				readys.push(0);
				charsel.push(0);
				current.push("jeremy");
				
						if (AOTD.keysets[current.length] == null){//case a nigga wanna put more chars lol
							AOTD.keysets.push(new KeySet());
						}
				character.push(new FlxSprite().loadGraphic("assets/sprites/players/spr_jeremy.png", true, 64, 72));
				ticks.push(new FlxSprite(64*(current.length-1)).loadGraphic("assets/sprites/misc/charselthing.png", true, 80, 80));
				ticks[current.length - 1].animation.add("i", [0, 1, 2], 0);
				character[current.length-1].x = 64 * (current.length - 1);
				add(character[current.length-1]);
				add(ticks[current.length-1]);
				character[current.length-1].screenCenter(Y);
				ticks[current.length-1].screenCenter(Y);
				
				
			}
		}
	}
	
	
	public function changeChars(dir = 1,p){
		
		charsel[p] += dir;
		if (charsel[p] == -1) charsel[p] = charlist.length - 1;
		if (charsel[p] == charlist.length) charsel[p] = 0;
		current[p] = charlist[charsel[p]];
		character[p].loadGraphic("assets/sprites/players/spr_"+current[p]+".png", true, 64, 72);
		FlxTween.tween(character[p], {y:character[p].y + dir*4}, 0.1, {ease:FlxEase.linear, type:BACKWARD});
		trace(current[p]);
		label.screenCenter();
		label.text = current[0];
		
		
	}
	
}