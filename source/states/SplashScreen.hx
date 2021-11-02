package states;

import flixel.*;
import flixel.graphics.tile.FlxGraphicsShader;
import flixel.input.keyboard.FlxKey;
import flixel.text.FlxText;
import flixel.util.*;
import flixel.system.FlxSound;
import states.*;
import haxe.Json;
import level.Basement;
import level.LVL7;
import level.LVL_Test;
import openfl.Assets;
import openfl.filters.*;
#if desktop
import sys.FileSystem;
#end
/**
 * ...
 * @author ...
 */
class SplashScreen extends AOTDState
{
	public var text:FlxText = new FlxText(0, 0, 0, "bbpanzu \npresents", 8);
	public var f:UInt = 0;
	public var STRINGS:Array<String> = [
		"A Be More Chill Fan Game\nThat took 2 years to make.",
		"A Be More Chill Fan Game\nCOMPLETELY REDONE FROM SCRATCH ON HAXE (jesus)",
		"A Be More Chill Fan Game\nThat some how made it past the lawyers",
		"A Be More Chill Fan Game\nThat's broadway trash",
		"A Be More Chill Fan Game\nThat's River City Ransom with broadway musicals",
		"A Be More Chill Fan Game\nThat's based off one lyric of one song",
		"A Be More Chill Fan Game\nThat's been developed on 2 seperate computers",
		"A Be More Chill Fan Game\nThat almost lost it's fizz",
		"A Be More Chill Fan Game\n...thank God I used Haxe",
		"A Be More Chill Fan Game\nthis is taking forever : /",
		"A Be More Chill Fan Game\n...never use Actionscript to make games",
		"A Be More Chill Fan Game\nThanks, Kaitotaku",
		"A Be More Chill Fan Game\nThanks, Jojo",
		"A Be More Chill Fan Game\nThanks, William",
		"A Be More Chill Fan Game\nily Kaya <3",
		"A Be More Chill Fan Game\nMade entirely with pirated software",
		"A Be More Chill Fan Game\nthat took $0 to make",
		"A Be More Chill Fan Game\nwith a scrapped co-op multiplayer",
		"A Be More Chill Fan Game\nAlmost made on the Flash engine",
		"A Be More Chill Fan Game\nMight be based on another arcade beat 'em up"
		];
	public function new() 
	{
		
		super();
		
	}
	override public function create():Void 
	{
		super.create();
		
		AOTD.initGame();
		
		text.setFormat("assets/fonts/AOTDdefault.ttf", 16, FlxColor.WHITE, "center");
		add(text);
		text.screenCenter();
		
		trace("got all da sounds and shits");
		
		
		AOTD.sprite_duststep = new FlxSprite();
		AOTD.sprite_duststep.loadGraphic("assets/sprites/misc/dust_step.png", true, 16, 16);
		
		
		
		
	}
	public override function update(elapsed:Float){
		if(f == 60*3){
			text.text = "";
		}
		if(f == 60*4){
			text.text = FlxG.random.getObject(STRINGS);
		text.screenCenter();
		}
		if(f == 60*8){
			text.text = "";
		}
		if (f == 60 * 9){
			finish();
		}
		
		if (FlxG.keys.anyJustPressed(AOTD.keyset.JUMP)) finish();
		f++;
		super.update(elapsed);
	}
	
	
	public function finish(){
		//FlxG.save.data.playerData = AOTD.playerData;
		for(i in AOTD.playerData){
			i.dead = false;
		}
		//#if testroom
		//LevelState.spawnPoint.set(100, 225, 0);
		//#else
		LevelState.spawnPoint.setByPoint(Basement.spawn);
		//#end
			FlxG.switchState(new IntroState());
	}
	
	
	
}