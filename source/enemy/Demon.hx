package enemy;
import flixel.*;
import states.*;
import flixel.effects.FlxFlicker;
import flixel.math.FlxPoint;
/**
 * ...
 * @author bbpanzu
 */
class Demon extends Enemy
{
	private var va:UInt = FlxG.random.int(1, 2);
	private var blocktime:UInt = 0;
	private var orbiting:UInt = 0;// FlxG.random.int(120, 180) ;
	private var thr:FlxPoint = new FlxPoint(FlxG.random.int(0,8),FlxG.random.int(-12, 12));
	public function new(X=0,Y=0,Z=0,radius=18,state:String = "spawn",waitToSpawn:Bool=false) 
	{
		super(X, Y, Z, radius, state,null,waitToSpawn);
		_speed = 3;
		_weight = 0.04;
		
		//if(FlxG.random.bool()){
			sprite.loadGraphic("assets/sprites/enemies/normalDemon.png", true, 64, 72);
		
		//}else{
			
		//	sprite.loadGraphic("assets/sprites/enemies/zombie2.png", true, 64, 72);
		
		
		//}
		sprite.animation.add("idle", [0, 1, 2, 3], 10, true,false);
		sprite.animation.add("walk", [8,9,10,11], 10, true,false);
		sprite.animation.add("spawn", [16,17,18,19,20,21,22,23,23], 8, false,false);
		sprite.animation.add("attack1", [24,25,26,27,28,28], 12, false,false);
		sprite.animation.add("attack2", [32,33,34,35,36,36], 14, false,false);
		sprite.animation.add("hurt", [40,41,41,41], 10, false,false);
		sprite.animation.add("fall", [40,41,48,49,50,51], 10,false,false);
		sprite.animation.add("death", [56, 57, 58, 59, 60, 61, 62, 63], 10, false, false);
		sprite.animation.add("block", [64], 0, false, false);
		sprite.x -= 32;
		sprite.y -= 68;
		
		
		_stickmargin = 1;
		setDamageData(8,2,5,8,6);
	}
	
	public override function spawn() 
	{
			backuptime = 30;
		super.spawn();
		sprite.animation.play("spawn");
		_showshadow = false;
			justHit =  false;
		if (sprite.animation.curAnim.curFrame == 8 ){
		_showshadow = true;
			STATE = "goto";
		}
	}
	
	public override function death() 
	{
		super.death();
	}
	
	override public function block() 
	{
			justHit =  false;
		super.block();
			sprite.animation.play("block");
			blocktime--;
		if (blocktime <= 0) STATE = "idle";
	}
	
	public override  function stun() 
	{
		
		idletime = 120;
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
		orbiting = 0;//FlxG.random.int(120, 180);
		_velx = 0;
		_vely = 0;
		sprite.animation.play("attack"+va);
		onAttackFrame = sprite.animation.curAnim.curFrame == 2 && !justHit;
		if (sprite.animation.curAnim.curFrame == 1) justHit = false;
		if (sprite.animation.curAnim.curFrame == 4  && _onfloor){
			justHit =  false;
			STATE = "backup";
		}
		
	}
	
	public override  function damaged() 
	{
		sprite.animation.play("hurt");
			justHit =  false;
		
		if (sprite.animation.curAnim.curFrame == 3){
			justHit =  false;
			STATE = "backup";
		}
	}
	
	public override  function backup() 
	{
		backuptime --;
			justHit =  false;
		sprite.animation.play("walk");
		
		
		
		
		var angle = Math.atan2(_target._y - _y, _target._x - _x) * 180 / Math.PI;
		
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
		
		va = FlxG.random.int(1, 2);
		
	}
	
	public override  function goto() 
	{
		justHit = false;
		backuptime = 30;
		sprite.animation.play("walk");
		
		/*nope
		if (orbiting > 0) orbiting--;
		
		
		if (orbiting < 60 && orbiting > 0){
			angle ++;
			if (angle < 0) angle = 360 + angle;
			if (angle >= 360) angle = angle - 360;
			
			
			var raidus = (_target._y-_y) / (_target._x-_x);
			if (angle < 0) angle = 360 + angle;
			
			_x = _target._x + raidus * angles[Math.floor(angle)].x;
			_y = _target._y + raidus * angles[Math.floor(angle)].y;
		}else{
		*/
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
		
		//}
		if (_x > _target._x - 16+thr.x+FlxG.random.int(-4,2) && _x < _target._x + 16+thr.x+FlxG.random.int(-4,2) && _y > _target._y - 8+thr.y+FlxG.random.int(-2,2) && _y < _target._y+thr.y + 8+FlxG.random.int(-2,2)){
			justHit =  false;
			STATE = "attack";
		}
		
		
		if (_target.onAttackFrame && _target.dir == -dir){
			justHit =  false;
			STATE = "backup";
		}
		
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
		if (STATE != "goto"){
			//angle = Math.atan2(_target._y - _y, _target._x - _x) * 180 / Math.PI;
		}
		super.update(elapsed);
		FlxG.watch.addQuick("Zombie State", STATE);
		
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
			
		}else if (STATE == "idle"){
			blocktime = 60;
			STATE = "block";
			
		}else{
			_bounce = 0;
			if (Math.abs(_velx) > 4 || Math.abs(_grav) > -4){
				STATE = "stun";
			}else{
				STATE = "damaged";
			}
			
		}
		if (STATE != "idle" && STATE != "block"){
			super.reactToHit(ent);
		}
			if (ent.isProp){//so it doesn't parget props, only prop targets
				//trace("got hit by prop");
				_target = ent._target;
			}else{
				//trace("got hit by someone");
				_target = ent;
			}
		}
		
	}
	
	override public function reactToDeath() 
	{
		super.reactToDeath();
		Coin.spawnMass(4, 2, _x, _y, _z, ["silver","silver","silver","gold"]);
	}
	
	
}