package minigames.ddr;
import flixel.FlxState;
import flixel.input.keyboard.FlxKey;

/**
 * ...
 * @author bbpanzu
 */
class DDRMinigame extends FlxState
{
	public var songPosition:Float = 0;
	public var keys:Array<Int> = [0,0,0,0];
	public function new() 
	{
		super();
	}
	
}