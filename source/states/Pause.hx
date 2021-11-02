package states;
import flixel.*;
import flixel.graphics.FlxGraphic;
import flixel.text.FlxText;
import openfl.geom.Point;

/**
 * ...
 * @author ...
 */
class Pause extends FlxSubState 
{
	public function new() 
	{
		super();
	}
	
	public override function create(){
		
		FlxG.sound.play("assets/sfx/sfx_pause.ogg");
		
		var bg:FlxSprite = new FlxSprite(0, 0);
		bg.makeGraphic(480, 270, 0x66000000);
		add(bg);
		var txt:FlxText = new FlxText(0, 0, 0, "PAUSED", 16);
		add(txt);
		txt.screenCenter();
		super.create();
		bg.scrollFactor.set();
		txt.scrollFactor.set();
	}
	
	public override function update(elapsed:Float){
		if (FlxG.keys.anyJustPressed(AOTD.keyset.PAUSE)){
		FlxG.sound.play("assets/sfx/sfx_pause.ogg");
			LevelState.instance.persistentUpdate = false;
			this.close();
		}
		super.update(elapsed);
	}
	
	public function exit(){
		this.close();
	}
}