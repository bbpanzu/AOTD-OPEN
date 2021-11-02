package;
import flixel.*;

/**
 * ...
 * @author ...
 */
class DustStep extends FlxSprite 
{

	public function new(X,Y,flip:Bool=false) 
	{
		super(X, Y);
		
		loadGraphic("assets/sprites/misc/dust_step.png",true,16,16);
		animation.add("dust", [0, 1, 2, 3, 4, 5, 6, 7, 8], 10, false,flip);
		animation.play("dust");
		if (!flip) offset.x = 16;
		offset.y = 16;
	}
	public override function update(elapsed:Float) 
	{
		if (animation.curAnim.finished) this.kill();
		super.update(elapsed);
	}
	
}