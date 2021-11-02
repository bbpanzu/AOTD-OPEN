package effects;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxBitmapFont;
import flixel.math.FlxPoint;
import flixel.text.FlxBitmapText;
using StringTools;
/**
 * ...
 * @author ...
 */
class StatNumber extends FlxBitmapText
{
	var f:UInt = 0;
	public function new(X,Y,TEXT:String,color:UInt) 
	{
		var font = Font.THICK;
		super(font);
		
		x = X;
		y = Y;
		this.color = color;
		this.text = TEXT+"";
	}
	
	override public function update(elapsed:Float):Void 
	{
		
		super.update(elapsed);
		f++;
		if (f < 30){
			y -= 0.2;
		}
		if (f == 80){
			
			destroy();
		}
		
	}
	
}