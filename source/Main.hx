package;


import flixel.FlxGame;
import flixel.FlxState;
import openfl.Assets;
import openfl.Lib;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.events.Event;
import states.*;
import openfl.text.TextField;
import openfl.text.TextFormat;
/**
 * ...
 * @author ...
 */
class Main extends Sprite
{
	public static var debugtext:TextField;
	public static var daGame:FlxGame;
	public static var debug:Bool = false;
	public function new() 
	{
		super();
		daGame = new FlxGame(480, 270, SplashScreen, 2, 60, 60, false, false);
		addChild(daGame);
		
		debugtext = new TextField();
		debugtext.setTextFormat(new TextFormat(null, 16, 0xFFFFFF));
		debugtext.y = 18;
		if (debug){
			addChild(new FPS(0, 0, 0xFFFFFF));
			addChild(debugtext);
			
		}
	}
	
}