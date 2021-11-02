package;
import states.*;
import flixel.*;
import effects.StatNumber;
import flixel.effects.FlxFlicker;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
/**
 * ...
 * @author ...
 */
class Coin extends Entity
{
	public var canTouch:Bool = true;
	public var _type:String = "";
	public var value:Float;
	public function new(TYPE:String="bronze",X:Float=0,Y:Float=0,Z:Float=0,BOUNCE:Float=4,FORCEX:Float=0,FORCEY:Float=0) 
	{
		super();
		_type = TYPE;
		setPos(X,Y,Z);
		_affectByCollision = false;
		_stickmargin = 1;
		_solid = false;
		_weight = 0.23;
		_bounce = 0.8;
		_grav = -BOUNCE;
		_velx = FORCEX;
		_vely = FORCEY;
		sprite.loadGraphic("assets/sprites/misc/coins.png", true, 32, 32);
		sprite.animation.add("bronze", [0, 1, 2, 3, 4, 5], 10, true,FlxG.random.bool(50));
		sprite.animation.add("silver", [6, 7, 8, 9, 10, 11], 10, true, FlxG.random.bool(50));
		sprite.animation.add("gold", [12, 13, 14, 15, 16, 17], 10, true, FlxG.random.bool(50));
		sprite.animation.add("ruby", [18, 19, 20, 21, 22, 23], 10, true, FlxG.random.bool(50));
		sprite.animation.add("get", [24,25,26,27,28,29], 15, false, FlxG.random.bool(50));
		sprite.animation.play(_type);
		
		switch(_type){
			case "bronze":
				value = 0.10;
			case "silver":
				value = 0.20;
			case "gold":
				value = 0.50;
			case "ruby":
				value = 2.00;
		}
		
		
		fixOffset();
		sprite.offset.y -= 4;
		
		new FlxTimer().start(20, function(e:FlxTimer){
			
			FlxFlicker.flicker(sprite, 3, 0.04, true, false, function(e:FlxFlicker){
				this.removeSelf();
			});
			
		});
	}
	
	override public function update(elapsed:Float):Void 
	{
		if(canTouch){
			for (pl in LevelState.players){
				if (isInY(pl) && hitbox.overlaps(pl.hitbox) ){
					pl.coins += value;
					pl._hp += Math.round(value*10);
					canTouch = false;
					effects.add(new StatNumber(pl.x, pl.y-pl.height, "$"+FlxStringUtil.formatMoney(value), 0xFFFF9900));
					collect();
				}
			}
		}
		super.update(elapsed);
		
	}
	public function collect(){
		switch(_type){
			case "bronze":
				playSound("sfx_coin_bronze");
				
			case "silver"|"gold":
				playSound("sfx_coin");
			case "ruby":
				playSound("sfx_coin_ruby");
		}
		_update = false;
		sprite.animation.play("get", true);
		sprite.animation.finishCallback = this.removeSelf;
	}
	
	override public function reactToDeath() 
	{
	}
	public static function spawnMass(AMOUNT:UInt = 8,RADIUS:Float=10, X:Float = 0, Y:Float = 0, Z:Float = 0, TYPES:Array<String>){
		
		for (i in 0...AMOUNT){
			LevelState.world.add(new Coin(TYPES[FlxG.random.int(0, TYPES.length - 1)], X, Y, Z, FlxG.random.int( -4, -8), FlxG.random.float( -RADIUS, RADIUS), FlxG.random.float( -RADIUS, RADIUS)));
		}
	}
	
}