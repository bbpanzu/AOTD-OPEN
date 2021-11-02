package states;
import animateatlas.AtlasFrameMaker;
import flixel.*;
import flixel.FlxSprite;
import flixel.graphics.tile.FlxDrawQuadsItem;

/**
 * ...
 * @author bbpanzu
 */
class IntroState extends FlxState
{
	public var u = 0;
	public var intro:AOTDAnimation;
	public function new() 
	{
		super();
	}
	override public function create():Void 
	{
		
		
		
		super.create();
		intro = new AOTDAnimation("aotdintro");
		add(intro);
		FlxG.sound.playMusic("assets/mus/introsequence.ogg",1,false);
		
		FlxG.sound.music.onComplete = fadeToEnd;
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		intro.sprite.animation.play("anim", true, false, Math.floor((FlxG.sound.music.time / 1000) * 30));
		if(u == 80){
		}
		u++;
		
		if (FlxG.keys.justPressed.P || FlxG.keys.justPressed.SPACE){
			fadeToEnd();
		}
		
		
	}
	public function fadeToEnd(){
		FlxG.camera.fade(0xFF000000, 0.5, false, function(){
			FlxG.switchState(new TitleState());
		});
	}
}