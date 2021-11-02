package states;
import flixel.FlxSprite;
import flixel.*;
import flixel.addons.plugin.control.FlxControl;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxBitmapFont;
import flixel.math.FlxPoint;
import flixel.text.FlxBitmapText;
import flixel.util.FlxColor;

/**
 * ...
 * @author bbpanzu
 */
class EndingDemo extends AOTDState
{
	public var intro:String = "thanks for playing the demo (again)";
	public var end:String = "join the discord to follow the further development!!";
	public var text:FlxBitmapText;
	public var THEEND:FlxBitmapText;
	public var sourcetext:FlxTypeText;
	public var sourcetext2:FlxTypeText;
	public var t:UInt = 0;
	var bg:FlxSprite;
	public function new() 
	{
		super();
	}
	
	override public function create():Void 
	{
		
		sourcetext = new FlxTypeText( 0, -999, 0, intro);
		sourcetext2 = new FlxTypeText( 0, -999, 0, end);
		text = new FlxBitmapText(Font.THICK);
		THEEND = new FlxBitmapText(Font.THICK);
		FlxG.camera.flash(FlxColor.BLACK, 1);
		super.create();
		FlxG.sound.playMusic("assets/mus/ending_demo.ogg", 1, false);
		bg = new FlxSprite(0, 0).loadGraphic("assets/sprites/endings/ending_demo.png");
		bg.screenCenter();
		bg.y -= 32;
		THEEND.text = "the end";
		add(THEEND);
		THEEND.screenCenter();
		add(bg);
		text.alignment = "center";
		text.fieldWidth = 360;
		text.wordWrap = true;
		text.wrapByWord = true;
		text.y = bg.height + bg.y + 20;
		add(text);
		add(sourcetext);
		add(sourcetext2);
		
		sourcetext.start(0.02);
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		t++;
		text.screenCenter(X);
		
		
		if (t == 280){
			sourcetext.erase(elapsed);
		}
		if (t < 300){
		text.text = sourcetext.text;
		}
		if (t > 300){
		text.text = sourcetext2.text;
		}
		if (t == 300){
			sourcetext2.start(0.04);
		}
		
		if (t == 720){
			text.visible = false;
			bg.visible = false;
		}
		if (t == 720+120){
			FlxG.switchState(new TitleState());
		}
	}
	
}