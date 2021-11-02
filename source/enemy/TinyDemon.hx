package enemy;
import flixel.*;
import states.*;
import flixel.effects.FlxFlicker;
/**
 * ...
 * @author bbpanzu
 */
class TinyDemon extends Enemy
{
	public function new(X=0,Y=0,Z=0,radius=18,state:String = "spawn",waitToSpawn:Bool=false) 
	{
		super(X, Y, Z, radius, state,null,waitToSpawn);
		_speed = 3;
		_weight = 0.5;
		sprite.loadGraphic("assets/sprites/enemies/tinydemon.png", true, 32, 32);
		
		sprite.animation.add("idle", [16,17,18,19], 10, true,true);
		sprite.animation.add("walk", [0,1,2,3], 8, true,true);
		sprite.animation.add("notice", [4,4,4,4], 10, false,true);
		sprite.animation.add("hurt", [24,25,26,27,28,29,30,31], 10, false,true);
		sprite.animation.add("stun", [32,33,34,35], 10, false,true);
		sprite.animation.add("attack", [40,41,41,41,41,41,41,41,41,41,41], 5,false,true);
		sprite.animation.add("fallback", [42], 10,false,true);
		sprite.animation.add("spawn", [8,9,10,11,12,13,14,15], 10, false, true);
		sprite.x -= 16;
		sprite.y -= 32;
		
		
		_stickmargin = 1;
		setDamageData(7,0,1,6,4);
	}
	
	public override function spawn() 
	{
		super.spawn();
		sprite.animation.play("spawn");
		if (sprite.animation.curAnim.curFrame == 7 ){
			STATE = "goto";
		}
	}
	
	public override function death() 
	{
		super.death();
	}
	
	public override  function stun() 
	{
		
		idletime = 30;
		if (_onfloor){
			justHit =  false;
			stuntime = 60;
			STATE = "fall";
			sprite.animation.play("fall");
			
		}
	}
	
	
	public override  function attack() 
	{
		idletime = 30;
		
		sprite.animation.play("attack");
		onAttackFrame = sprite.animation.curAnim.curFrame >= 1 && !justHit;
		
		if (sprite.animation.curAnim.curFrame == 1){
			_grav = -5;
			_velx = 5 * dir;
		}
		
		if (sprite.animation.curAnim.curFrame >= 1  && _onfloor){
			justHit =  false;
			STATE = "goto";
		}
		
	}
	public override  function damaged() 
	{
		sprite.animation.play("hurt");
		_grav = 0;
		_velx = 0;
		_vely = 0;
		if (sprite.animation.curAnim.curFrame == 7){
			justHit =  false;
			STATE = "death";
			removeSelf();
		}
	}
	
	public override  function backup() 
	{
		sprite.animation.play("fallback");
		if (_onfloor){
			STATE = "idle";
		}
		
	}
	
	public override  function goto() 
	{
		idletime = 30;
		justHit =  false;
		sprite.animation.play("walk");
		
		if (_target._x > _x+FlxG.random.int(-2,2)){
			_velx = _speed;
			dir = 1;
		}
		if (_target._x < _x+FlxG.random.int(-2,2)){
			_velx = -_speed;
			dir = -1;
		}
		if (_target._y > _y+FlxG.random.int(-2,2)){
			_vely = _speed/2;
		}
		if (_target._y < _y+FlxG.random.int(-2,2)){
			_vely = -_speed/2;
		}
		
		if (_x > _target._x - 32+FlxG.random.int(-4,2) && _x < _target._x + 32+FlxG.random.int(-4,2) && _y > _target._y - 8+FlxG.random.int(-2,2) && _y < _target._y + 8+FlxG.random.int(-2,2)){
			STATE = "attack";
		}
		
		
		
	}
	
	public override  function wait() 
	{
		
		sprite.animation.play("idle");
		super.wait();
	}
	
	public override  function idle() 
	{
		idletime--;
		
		if (idletime == 0){
			STATE = "goto";
		}
		sprite.animation.play("idle");
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (STATE != "attack") onAttackFrame = false;//can't attack when not attacking
		scale.x = dir;
		super.update(elapsed);
		
	}
	override public function reactwhenHit(ent:Entity) 
	{
		super.reactwhenHit(ent);
		_velx = -_velx;
		STATE = "backup";
	}
	
	override public function reactToHit(ent:Entity) 
	{
		
		
		if (!ent.isEnemy && ent.isOrganism || ent.isProp){//so zombies don't attack eachother
			
		
			_bounce = 0;
			if (Math.abs(_velx) > 4 || Math.abs(_vely) > 4){
				STATE = "stun";
			}else{
				STATE = "damaged";
			}
			
		super.reactToHit(ent);
			if (ent.isProp){//so it doesn't parget props, only prop targets
				//trace("got hit by prop");
				_target = ent._target;
			}else{
				//trace("got hit by someone");
				_target = ent;
			}
		}
		
	}
	
	
}