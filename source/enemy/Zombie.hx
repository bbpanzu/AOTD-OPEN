package enemy;
import flixel.*;
import states.*;
import flixel.effects.FlxFlicker;
/**
 * ...
 * @author bbpanzu
 */
class Zombie extends Enemy
{
	public function new(X=0,Y=0,Z=0,radius=18,state:String = "spawn",waitToSpawn:Bool=false) 
	{
		super(X, Y, Z, radius, state, null, waitToSpawn);
		_speed = 0.7;
		_weight = 0.2;
		
		
		if(FlxG.random.bool()){
			sprite.loadGraphic("assets/sprites/enemies/zombie0.png", true, 64, 72);
		
		}else{
			
			sprite.loadGraphic("assets/sprites/enemies/zombie2.png", true, 64, 72);
		
		
		}
		sprite.animation.add("idle", [0, 1, 2, 3], 10, true,true);
		sprite.animation.add("walk", [8,9,10,11,12,13,14,15], 8, true,true);
		sprite.animation.add("notice", [16,17,18,19,19], 10, false,true);
		sprite.animation.add("hurt", [24,25,26,27,27], 10, false,true);
		sprite.animation.add("stun", [32,33,34,35], 10, false,true);
		sprite.animation.add("fall", [40,41,42,43], 10, false,true);
		sprite.animation.add("attack", [48,49,50,51,51], 10,false,true);
		sprite.animation.add("spawn", [56, 57, 58, 59, 60, 61], 10, false, true);
		sprite.x -= 32;
		sprite.y -= 68;
		
		
		_stickmargin = 1;
		setDamageData(4, 0, 3, 6, 4);
		setPos(X, Y, Z);
	}
	
	public override function spawn() 
	{
		
		super.spawn();
		
		//trace(getPos()._x,getPos()._y,getPos()._z);
		sprite.animation.play("spawn");
		if (sprite.animation.curAnim.curFrame == 5 ){
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
			//trace("on da ground ouch");
			justHit =  false;
			stuntime = 60;
			STATE = "fall";
			
			sprite.animation.play("fall");
			
		}
	}
	
	
	public override  function attack() 
	{
		
		
		sprite.animation.play("attack");
		onAttackFrame = sprite.animation.curAnim.curFrame == 2 && !justHit;
		if(sprite.animation.curAnim.curFrame == 1)justHit = false;
		if (sprite.animation.curAnim.curFrame == 4  && _onfloor){
			justHit =  false;
			STATE = "goto";
		}
		
	}
	
	public override  function damaged() 
	{
		sprite.animation.play("hurt");
		
		if (sprite.animation.curAnim.curFrame == 4 && _onfloor){
			justHit =  false;
			STATE = "goto";
		}
	}
	
	public override  function backup() 
	{
		backuptime --;
		sprite.animation.play("walk");
		var angle:Float = 0;
		
		
		
		angle = Math.atan2(_target._y - _y, _target._x - _x) * 180 / Math.PI;
		
		if (angle < 0) angle = 360 + angle;
		//trace(Math.floor(angle));
		
		_velx = angles[Math.floor(angle)].x * -_speed;
		_vely = angles[Math.floor(angle)].y * -_speed;
			
		
		
		if (_target._x > _x+FlxG.random.int(-2,2)){
			dir = 1;
		}
		if (_target._x < _x+FlxG.random.int(-2,2)){
			dir = -1;
		}
		
		if (backuptime == 0){
			STATE = "goto";
		}
		
		
	}
	
	public override  function goto() 
	{
		sprite.animation.play("walk");
		justHit = false;
		
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
		
		if (_x > _target._x - 16+FlxG.random.int(-4,2) && _x < _target._x + 16+FlxG.random.int(-4,2) && _y > _target._y - 8+FlxG.random.int(-2,2) && _y < _target._y + 8+FlxG.random.int(-2,2)){
			STATE = "attack";
		}
		
		
		if (_target.onAttackFrame){
			backuptime = 30;
			STATE = "backup";
		}
		
		super.goto();
	}
	
	public override  function wait() 
	{
		justHit = false;
		
		sprite.animation.play("idle");
		super.wait();
	}
	
	public override  function idle() 
	{
		justHit = false;
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
	
	
	override public function reactToHit(ent:Entity) 
	{
		
		
		if (!ent.isEnemy && ent.isOrganism || ent.isProp){//so zombies don't attack eachother
			
		if (STATE == "damaged"){
			_bounce = 0.5;
			sprite.animation.play("stun");
			STATE = "stun";
		}else if(STATE == "fall"){
			sprite.animation.play("fall");
			
		}else{
			_bounce = 0;
			if (Math.abs(_velx) > 4 || Math.abs(_vely) > 4){
				STATE = "stun";
			}else{
				STATE = "damaged";
			}
			
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