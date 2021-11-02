package;
import flixel.*;
import flixel.input.keyboard.FlxKey;
/**
 * ...
 * @author ...
 */
class KeySet 
{
	
	public var LEFT:Array<FlxKey> = [FlxKey.A,FlxKey.LEFT];
	public var RIGHT:Array<FlxKey> = [FlxKey.D,FlxKey.RIGHT];
	public var UP:Array<FlxKey> = [FlxKey.W,FlxKey.UP];
	public var DOWN:Array<FlxKey> = [FlxKey.S,FlxKey.DOWN];
	
	public var PUNCH:Array<FlxKey> = [FlxKey.P,FlxKey.NUMPADONE,FlxKey.SPACE];
	public var KICK:Array<FlxKey> = [FlxKey.O,FlxKey.NUMPADTWO];
	public var INTERACT:Array<FlxKey> = [FlxKey.I,FlxKey.NUMPADTHREE];
	public var FORCE:Array<FlxKey> = [FlxKey.U,FlxKey.NUMPADFOUR];
	
	public var JUMP:Array<FlxKey> = [FlxKey.SPACE,FlxKey.NUMPADZERO];
	public var BLOCK:Array<FlxKey> = [FlxKey.CONTROL];
	public var RUN:Array<FlxKey> = [FlxKey.SHIFT];
	
	public var PAUSE:Array<FlxKey> = [FlxKey.BACKSPACE];
	
	public var DEBUGTOGGLE:Array<FlxKey> = [FlxKey.GRAVEACCENT];
	public var DEBUG:Array<FlxKey> = [FlxKey.TAB];
	public function new() 
	{
		
	}
	
}