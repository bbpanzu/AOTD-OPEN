package gameobjects;
import flixel.*;
import level.*;
import states.*;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxRect;
import flixel.util.FlxTimer;
/**
 * ...
 * @author bbpanzu
 */
class Door extends FlxSpriteGroup
{
	var toFunction:Void->Void;
	var toState:FlxState;
	var toScript:String;
	var players:Array<Player> = [];
	public var _x:Float;
	public var _y:Float;
	public var _z:Float;
	var hitboxdata:FlxRect = new FlxRect( -32, -64, 64, 64);
	var hitbox:FlxRect = new FlxRect( -32, -64, 64, 64);
	var disabledtime = 0;
	public function new(X,Y,Z,toState:FlxState=null,toFunction:Void->Void=null,toScript:String="") 
	{
		this.toState = toState;
		this.toFunction = toFunction;
		this.toScript = toScript;
		_x = X;
		_y = Y;
		_z = Z;
		super(_x, _y-_z);
		
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		hitbox.x = _x + hitboxdata.x;
		hitbox.y = (_y + hitboxdata.y) - _z;
		
		players = [];
		
		if (disabledtime > 0 && !AOTD.inShopRN){
			disabledtime--;
		}
		
		
		for (pl in LevelState.players){
			if (pl._x > _x - hitbox.width/2 && pl._x < _x + hitbox.width/2   &&  pl._y > _y - hitbox.width/2 && pl._y < _y + hitbox.width/2 && !LevelState.inCombat && !AOTD.inShopRN && disabledtime == 0){
				players.push(pl);
				pl.visible = false;
				if (players.length == LevelState.players.length){
					AOTD.parseCommand("/player all state idle");
					AOTD.parseCommand("/player all enabled false");
					pl.visible = false;
					if (toScript != "") AOTD.parseCommand(toScript);
					if (toState == null){
						disabledtime = 80;
						if(toFunction != null)toFunction();
					}else{
						FlxG.switchState(toState);
					}
				}
			}
		}
		
	}
}