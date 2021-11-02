package;
import flixel.*;
import flixel.text.FlxText;

/**
 * ...
 * @author ...
 */
class AnimDebug extends FlxState
{
	public var bg:FlxSprite = new FlxSprite();
	public var anim:FlxSprite = new FlxSprite();
	public var txt:FlxText = new FlxText(0, 0, 0, "");
	public var num1:UInt = 64;
	public var num2:UInt = 64;
	public var num3:Float = 0.25;
	public var num4:UInt = 8;
	public function new() 
	{
		super();
		bg.makeGraphic(FlxG.width, FlxG.height);
		this.add(bg);
		anim.loadGraphic("assets/sprites/players/spr_jeremy.png", true,64,72);
		anim.animation.add("anim", [1, 2, 3, 4, 5, 6, 7, 8], 10, true);
		add(anim);
		add(txt);
		txt.color = 0xFF0000;
		FlxG.camera.follow(anim, LOCKON, 1);
	}
	
	public override function update(elapsed:Float){
		anim.scale.x = 1;
		if (FlxG.keys.anyPressed([SPACE])) anim.scale.x = -1;
		if (FlxG.keys.anyJustPressed([LEFT])){
			if (FlxG.keys.anyJustPressed([ONE]))num1--;
			if (FlxG.keys.anyJustPressed([TWO]))num2--;
			if (FlxG.keys.anyJustPressed([THREE]))num3--;
			if (FlxG.keys.anyJustPressed([FOUR]))num4--;
		}
		if (FlxG.keys.anyPressed([RIGHT])){
			if (FlxG.keys.anyJustPressed([ONE]))num1++;
			if (FlxG.keys.anyJustPressed([TWO])) num2++;
			if (FlxG.keys.anyJustPressed([THREE]))num3++;
			if (FlxG.keys.anyJustPressed([FOUR]))num4++;
		}
		anim.offset.x = ((num1 - ((num2 * anim.scale.x)))*num3)+(num4*anim.scale.x);
		txt.text = "((" + num1 + " - ((" + num2 + " * dir)))*" + num3 + ")+(" + num4 + "*dir);";
		super.update(elapsed);
	}
	
}