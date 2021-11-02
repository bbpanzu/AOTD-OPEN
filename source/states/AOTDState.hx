package states;
import flixel.FlxState;

/**
 * ...
 * @author bbpanzu
 */
class AOTDState extends FlxState
{

	public function new() 
	{
		super();
	}
	
	
	override public function create():Void 
	{
		super.create();
		AOTD.crt(AOTD.crtFilter);
	}
	
	
}