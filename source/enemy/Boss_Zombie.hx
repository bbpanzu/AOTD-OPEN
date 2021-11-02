package enemy;
import flixel.*;
import states.*;
import flixel.effects.FlxFlicker;
import flixel.util.FlxTimer;
/**
 * ...
 * @author bbpanzu
 */
class Boss_Zombie extends Enemy
{
	var blocktime:Float = 0;
	public var tiredtime:Float = 0;
	public var phase:Int = 1;
	public var boss:Bool = false;
	public function new(X=0,Y=0,Z=0,radius=18,state:String = "spawn",waitToSpawn:Bool=false,boss:Bool = true) 
	{
		super(X, Y, Z, radius, state, null, waitToSpawn);
		this.boss = boss;
		_speed = 0.8;
		_weight = 1;
		
		_maxhp = 100;
		_hp = _maxhp;
		
			sprite.loadGraphic("assets/sprites/enemies/boss_zombie.png", true, 100, 100);
		sprite.animation.add("idle", [0, 1, 2, 3, 4, 5,6,7], 10, true,true);
		sprite.animation.add("walk", [8,9,10,11,12,13,14,15], 8, true,true);
		sprite.animation.add("spawn", [16,17,18,19,18,19,18,19,18,19,18,19,19,19,18,18,18], 10, false,true);
		sprite.animation.add("attack", [24,25,26,27,28,28,28,28], 8, false,true);
		sprite.animation.add("attack3", [26,27,28,28,28,28], 20, false,true);
		sprite.animation.add("tired", [32,33,34,35], 10, true,true);
		sprite.animation.add("attack2", [40,41,42,43,43,43], 10, false,true);
		sprite.animation.add("death", [48,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,50,51,50,51,50,51,51], 24,false,true);
		sprite.animation.add("block", [56, 57], 8, false, true);
		sprite.x -= 50;
		sprite.y -= 96;
		
		
		_stickmargin = 8;
		hitboxOffset.x -= 16;
		hitbox.width = 64;
		setDamageData(15, 15, 4, 12, 12);
		setPos(X, Y, Z);
	}
	
	public override function spawn() 
	{
		idletime = 60;
		super.spawn();
		//trace(getPos()._x,getPos()._y,getPos()._z);
		sprite.animation.play("spawn");
		if (sprite.animation.curAnim.curFrame == 16 ){
			STATE = "idle";
		}
	}
	
	public override function death() 
	{
		super.death();
		
		sprite.animation.play("death");
		_velx = 0;
		_vely = 0;
		if (boss){
			FlxG.sound.music.fadeOut(1, 0);
		}
		if (sprite.animation.curAnim.curFrame > 8){
			_vibrationx = -4;
		}
		if (sprite.animation.curAnim.curFrame > sprite.animation.curAnim.numFrames - 2){
			AOTD.shakeCamera(10);
			Coin.spawnMass(20, 10, _x, _y, _z, ["bronze", "silver", "silver", "silver", "gold", "gold"]);
			LevelState.instance.addToWorld(new Coin("ruby", _x, _y, _z, 7, 0, 0));
			removeSelf();
			if (boss){
				new FlxTimer().start(10, function(e:FlxTimer){
					AOTD.parseCommand("/el");
				});
			}
		}
	}
	
	
	
	public override  function attack() 
	{
		tiredtime = 300/phase;
		idletime = Std.int(60/phase);
		
		_velx = 0;
		_vely = 0;
		sprite.animation.play("attack");
		onAttackFrame = sprite.animation.curAnim.curFrame == 4 && !justHit;
		if(sprite.animation.curAnim.curFrame == 3)justHit = false;
		if (sprite.animation.curAnim.curFrame >=4  && _onfloor){
			justHit =  false;
			STATE = "tired";
		}
		
	}
	public override  function attack3() 
	{
		_velx = 0;
		_vely = 0;
		idletime =  Std.int(30/phase);
		sprite.animation.play("attack");
		onAttackFrame = sprite.animation.curAnim.curFrame == 4 && !justHit;
		if(sprite.animation.curAnim.curFrame == 1)justHit = false;
		if (sprite.animation.curAnim.curFrame == 5  && _onfloor){
			justHit =  false;
			STATE = "idle";
		}
		
		
	}
	public override  function attack2() 
	{
		
		_velx = 0;
		_vely = 0;
		
		idletime =  Std.int(60/phase);
		sprite.animation.play("attack2");
		onAttackFrame = sprite.animation.curAnim.curFrame == 2 && !justHit;
		if (sprite.animation.curAnim.curFrame == 3  && _onfloor){
			justHit =  false;
			STATE = "tired";
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
	public override function block(){
		_velx = 0;
		_vely = 0;
		idletime = 30;
		sprite.animation.play("block");
		blocktime --;
		if (blocktime <= 0) STATE = "idle";
	}
	public function tired(){
		tiredtime--;
		sprite.animation.play("tired");
		
		if (tiredtime == 0) STATE = "idle";
	}
	public override  function goto() 
	{
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
		justHit = false;
		super.update(elapsed);
		FlxG.watch.addQuick("Zombie State", STATE);
		
		if (STATE == "tired") tired();
		
	}
	
	
	override public function reactwhenHit(ent:Entity) 
	{
		super.reactwhenHit(ent);
		
		AOTD.shakeCamera(8);
	}
	override public function reactToHit(ent:Entity) 
	{
		
		
		if (!ent.isEnemy && ent.isOrganism || ent.isProp){//so zombies don't attack eachother
			
			if (STATE == "tired"){
				super.reactToHit(ent);
				
				if (_hp <= 0){
					STATE = "death";
				}
				
				
			}else if (STATE == "block"){
				new FlxTimer().start(0.2, function(e:FlxTimer){
				STATE = "attack3";
				});
			}else if(STATE != "attack3" && STATE != "death"){
				blocktime = 60;
				STATE = "block";
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
	
	
}