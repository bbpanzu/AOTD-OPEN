package enemy;
import flixel.*;
import enums.*;
import flixel.effects.FlxFlicker;
import states.LevelState;

/**
 * ...
 * @author bbpanzu
 */
class Enemy extends Entity
{
	public var _noticeRadius:Float = 60;
	public var STATE:String = "wait";
	public var _enemyname:String = "phred";
	public var _speed:Float = 1;
	public var _stopCamera:Bool = false;
	public var waitToSpawn:Bool = false;
	public var spawned:Bool = false;
	public var inCam:Bool = false;
	public var touchingWall:Bool = false;
	public var foundSpot:Bool = false;
	var idletime = 0;
	var stuntime = 0;
	var backuptime = 0;
	var guardtime = 0;
	//path shit
	var aroundTimer:Float = 0;
	var goDirection:Int = 1;
	public var id:Int = 0;
	public var iu:Int = 0;
	//
	public function new(X:Float = 0, Y:Float = 0, Z:Float = 0, noticeRadius:Float = 18, state:String = "spawn", target:Player =  null, waitToSpawn:Bool = false) 
	{
		
		super(X, Y, Z);
		this.waitToSpawn = waitToSpawn;
		_noticeRadius = noticeRadius;
		_affectByCollision = true;
		isEnemy = true;
		isOrganism = true;
		STATE = state;
		if (target == null){
			_target = LevelState.players[FlxG.random.int(0, LevelState.players.length - 1)];
		}else{
			_target = target;
		}
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
			
		if (_target != null && _target._dead && LevelState.players.length > 0) newTarget(); //if it has a target and the target is dead and there are players left, then switch to a new arget
			
			if (STATE == "spawn") spawn ();
			if (STATE == "idle") idle ();
			if (STATE == "wait") wait();
			if (STATE == "goto") goto();
			if (STATE == "backup") backup();
			if (STATE == "block") block();
			if (STATE == "attack") attack();
			if (STATE == "attack2") attack2();
			if (STATE == "attack3") attack3();
			if (STATE == "attack4") attack4();
			if (STATE == "attack5") attack5();
			if (STATE == "stun") stun ();
			if (STATE == "fall") fall ();
			if (STATE == "damaged") damaged ();
			if (STATE == "death") death ();
			if (STATE == "goaround") goAround ();
		if(!_dead && spawned)LevelState.inCombat = true;
			if (inCam){
				LevelState.enemiesOnScreen.push(this);
			}
	}
	
	public function death() 
	{
		_dead = true;
		LevelState.inCombat = false;
	}
	public function block() 
	{
		
	}
	
	public function stun() 
	{
		
	}
	public function spawn() 
	{
		justHit = false;
		_boundByCam = true;
		if (_target == null){
			newTarget();//_target = LevelState.players[FlxG.random.int(0, LevelState.players.length - 1)];
		}
		LevelState.inCombat = true;
		if (!spawned){
			inCam = true;
			AOTD.camFollow.push(this);
		}
		//_stopCamera = true;
		spawned = true;
	}
	
	public function newTarget(){
		
			_target = LevelState.players[FlxG.random.int(0, LevelState.players.length - 1)];
	}
	
	public function fall() 
	{
		justHit = false;/*CARRY FALLEN ENEMIES
		for (pl in LevelState.players){
			if(pl._x > _x-16 && pl._x < _x+16 && pl._y > _y-8 && pl._y < _y+8 && pl._z > _z-32 && pl._z < _x+32  ){
				if (FlxG.keys.anyJustPressed(AOTD.keysets[pl.player - 1].INTERACT)){
					_target = pl;
					_beingCarried = !_beingCarried;
				}
			}
		}*/
		
		
		
		if(!_beingCarried)stuntime--;
		if (stuntime == 0){
			if(_hp > 0){
				STATE = "idle";
			}else{
				_affectByCollision = false;
				FlxFlicker.flicker(sprite, 1, 0.04, true, false, function(e:FlxFlicker){
				this.removeSelf();
			});
				STATE = "death";
			}
		}
	}
	
	public function attack() 
	{
		
	}
	
	public function attack2() 
	{
		
	}
	
	public function attack3() 
	{
		
	}
	
	public function attack4() 
	{
		
	}
	
	public function attack5() 
	{
		
	}
	
	public function backup() 
	{
		
	}
	
	public function goto() 
	{
		justHit = false;
		defaultDamageData.enabled = true;
		
		touchingWall = (AOTD.getFloorZ(_x + 15 * dir, _y) >_floorz+12) || (AOTD.getFloorZ(_x + 15 * dir, _y-8) >_floorz+12) || (AOTD.getFloorZ(_x + 15 * dir, _y+8) >_floorz+12);
		
		if (touchingWall) checkForCorner();
	}
	public function checkForCorner(){
		_noticeRadius = 64;
		foundSpot = false;
		id = 0;
		while (id <10){//check 10 times for a corner
				id++;
			if(!foundSpot){//keep checking if it hasn't found a spot
				foundSpot = !AOTD.onWall(_x + 2 * dir, _y + id * 16)&&AOTD.getFloorZ(_x + 5 * dir, _y + id * 16)<_floorz+2;//finds spot
				aroundTimer = Math.round((id*16)/_speed)+8;
				goDirection = 1;
				if(foundSpot)trace("found spot below");
			}
			if(!foundSpot){//keep checking if it hasn't found a spot
				foundSpot = !AOTD.onWall(_x + 2 * dir, _y - id * 16)&&AOTD.getFloorZ(_x + 5 * dir, _y - id * 16)<_floorz+2;
				aroundTimer = ( id * 16) / _speed;
				goDirection = -1;
				if(foundSpot)trace("found spot above");
			}
		}
		
		if (foundSpot){
			//trace(AOTD.getFloorZ(_x + 15 * dir, _y + id * 16));
			trace(goDirection);
			STATE = "goaround";
		}else{
			STATE = "idle";
		}
	}
	
	public function goAround(){
		_velx = 0;
		_vely = _speed*goDirection;
		if (aroundTimer <= 0){
			STATE = "goto";
		}else{
			
		aroundTimer --;
		}
	}
	public function wait() 
	{
		justHit = false;
		defaultDamageData.enabled = true;
		if(waitToSpawn){
		_showshadow = false;
		sprite.alpha = 0;
		_affectByCollision = false;
		}
		_affectByCollision = true;
		for ( t in LevelState.players){
			if (_x > t._x - _noticeRadius && _x < t._x + _noticeRadius && _y > t._y - _noticeRadius && _y < t._y + _noticeRadius){
				_showshadow = true;
				sprite.alpha = 1;
				if (waitToSpawn){
					STATE = "spawn";
				}else{
					_target = t;
					STATE = "goto";
				}
			}
		}
	}
	
	public function idle() 
	{
		
	}

	public function damaged() 
	{
		
	}
	
	override public function reactToDeath() 
	{
		LevelState.inCombat = false;
		if(inCam)AOTD.camFollow.remove(this);
		Coin.spawnMass(4, 10, _x, _y, _z, ["bronze","bronze","silver"]);
	}
	override public function reactToHit(ent:Entity) 
	{
		super.reactToHit(ent);
		defaultDamageData.enabled = true;
	}
	
	
	
}