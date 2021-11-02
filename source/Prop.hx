package;
import level.*;
import states.*;
import flixel.*;
import flixel.graphics.frames.FlxFilterFrames;
import openfl.filters.BitmapFilter;
import openfl.filters.GlowFilter;
/**
 * ...
 * @author bbpanzu
 */
class Prop extends Entity
{
	//var instance:Prop;
	var goinBright:Bool = true;
	var _id:String = "";
	public function new(X,Y,Z,id:String) 
	{
		super(X, Y, Z);
		_id = id;
		isProp = true;
		instance = this;
		_affectByCollision = true;
		switch(id){
			case "ball":
				_carryweight = "_heavy";
				_weight = 0.2;
				_bounce = 0.8;
				sprite.loadGraphic("assets/sprites/misc/ball.png", false, 32, 32);
				fixOffset();
				_height = 0;
			case "box":
				_carryweight = "_heavy";
				_weight = FlxG.random.float(0.2, 0.6);
				_bounce = 0.2;
				sprite.loadGraphic("assets/sprites/props/props27.png", false, 32, 32);
				sprite.offset.x = 20;
				sprite.offset.y = 29;
				_height = 32;
			case "trashcan":
				_carryweight = "_heavy";
				_weight = 0.4;
				_bounce = 0.5;
				sprite.loadGraphic("assets/sprites/props/props24.png", false, 32, 32);
				sprite.offset.x = 14;
				sprite.offset.y = 29;
				_height = 32;
			case "trashbag":
				_carryweight = "_heavy";
				_weight = 0.4;
				_bounce = 0;
				sprite.loadGraphic("assets/sprites/props/props25.png", false, 32, 32);
				sprite.offset.x = 42;
				sprite.offset.y = 83;
				_height = 0;
				
		}
		
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		switch(_id){
			case "ball":
				sprite.angle += _velx*2;
		}
		for (pl in LevelState.players){
			if (pl._x > _x - 16 && pl._x < _x + 16 && pl._y > _y - 8 && pl._y < _y + 8 && pl._z > _z - 8 && pl._z < _z + _height+8 && (pl.goingtoHold == null || pl.goingtoHold == this)){
				pl.goingtoHold = this;
				if (FlxG.keys.anyJustPressed(AOTD.keysets[pl.player - 1].INTERACT)){
					if(!_beingCarried){
						defaultDamageData.enabled = true;
						pl._objweight = _carryweight;
						pl._carrying = true;
						_target = pl;
						pl._carryObject = instance;
						trace(_target._carryObject);
						_beingCarried = true;
						_showshadow = false;
					}else{
						_showshadow = true;
						pl.goingtoHold = null;
						defaultDamageData.enabled = true;
						pl._objweight = "";
						pl._carrying = false;
						_target = pl;
						pl._carryObject = null;
						_beingCarried = false;
					}
				}
			}
		}
		
		
	}
	override public function reactwhenHit(ent:Entity) 
	{
		super.reactwhenHit(ent);
		
		_velx = -_velx*0.5;
	}
	
}