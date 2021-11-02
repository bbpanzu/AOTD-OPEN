package;
import flixel.*;
import states.*;
import effects.StatNumber;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.util.FlxColor;
import hscript.Interp;
import hscript.Parser;
import openfl.geom.Point;
import openfl.media.Sound;

/**
 * ...
 * @author ...
 */

class Entity extends FlxSpriteGroup 
{
	public var _x:Float = 0;//3d x (left right)
	public var _y:Float = 0;//3d y (far and close)
	public var _z:Float = 0;//3d z (up and down)
	
	public var _initx:Float = 0;//initial x
	public var _inity:Float = 0;//initial y
	public var _initz:Float = 0;// initial z
	
	public var _px:Float = 0;//previous x
	public var _py:Float = 0;//previous y
	public var _pz:Float = 0;// previous z
	
	public var _weight:Float = 0.4;
	public var _floorz:Float = 0;//z of groundlevel
	public var _elevation:Float = 0;//how far from ground
	public var _height:Float = 0;
	
	public var _forcex:Float = 0;//probs shouldn't use this
	public var _forcey:Float = 0;//probs shouldn't use this
	public var _grav:Float = 0;//probs shouldn't use this
	
	public var _velx:Float = 0;//x velocity
	public var _vely:Float = 0;//y velocity
	
	public var _vibrationx:Int = 0;//vibration x
	public var _vibrationy:Int = 0;// vibration y
	public var _rumble:Float = 0;
	
	public var angles:Array<FlxPoint> = [];
	
	
	public var _onfloor:Bool = false;
	
	public var _float:Bool = false;
	
	public var _hitstun:Int = 0;
	
	public var _material:String = "";
	
	public var _noclip:Bool = false;
	public var onAttackFrame:Bool = false;
	
	public var _carryOffset:Point3D = new Point3D();
	public var _canBeCaried:Bool = false;
	public var _beingCarried:Bool = false;
	public var _carrying:Bool = false;
	public var _objweight:String="";
	public var _carryObject:Entity;
	public var _carryweight:String = "heavy";
	
	public var _target:Entity;
	public var _lasthitted:Entity;
	
	public var _friction:Float = 1;
	
	public var _shadow:FlxSprite;
	public var _showshadow:Bool = true;
	
	public var _slip:Bool = true;
	public var _dead:Bool = false;
	
	public var _boundByCam:Bool = false;
	
	public var _hmpt:Float = 0;
	
	public var _landed:Bool = false;
	
	public var _update:Bool = true;
	public var _solid:Bool = true;
	public var _permaupdate:Bool = true;
	
	public var _bounce:Float = 0;
	
	public var _length:UInt = 16;
	public var _hp:Float = 20;
	public var _maxhp:Float = 20;
	public var dir:Int = 1;
	
	public var _affectByCollision:Bool = false;
	private var hf:FlxSprite;
	
	public var sprite:FlxSprite = new FlxSprite();
	
	public var campoint:FlxPoint = new FlxPoint(0, 0);
	
	public var isPlayer:Bool = false;
	public var isProp:Bool = false;
	public var isOrganism:Bool = false;
	public var isEnemy:Bool = false;
	
	public var soundPro_x:Float;
	public var soundPro_y:Float;
	public var soundPro_rad:Float = 480;
	
	public var hud:HUD;
	public var world:FlxSpriteGroup;
	public var effects:FlxSpriteGroup;
	public var shadow:FlxSpriteGroup;
	public var bg:FlxSpriteGroup;
	public var _stickmargin:UInt = 2;
	public static var UNIVERSAL_GRAVITY:Float = 0.4;
	
	public var hitbox:FlxRect = new FlxRect(0,0,32,64);
	public var hurtbox:FlxRect = new FlxRect(0,0,32,64);
	public var hurtboxOffset:FlxPoint = new FlxPoint(0,64);
	public var hitboxOffset:FlxPoint = new FlxPoint(16,-64);
	
	public var debug_hib:FlxSprite = new FlxSprite();
	public var debug_hub:FlxSprite = new FlxSprite();
	public var justHit:Bool = false;//if the entity just attacked something
	
	public var orbitSpeed:Float = 0;
	public var orbitDistance:Float = 0;
	public var instance:Entity;
	private var pl:Entity;
	private var data:Dynamic;
	var vibdx = 1;
	var vibdy = 1;
	public var defaultDamageData:HitboxData = new HitboxData(4, 5, 5, 4, 8);
	private var inited:Bool = false;
	private var runningfor:Int = 0;
	
	public var parser:Parser = new Parser();
	public var interp:Interp = new Interp();
	public var allowScripts:Bool = false;
	
	//HEIGHT MAP STUFF
		
		
		
	public function new(X:Float=0,Y:Float=0,Z:Float=0) 
	{
		super(X, Y);
		instance = this;
		hud = LevelState.hud;
		world = LevelState.world;
		shadow = LevelState.shadow;
		effects = LevelState.effects;
		bg = LevelState.bg;
		
		_initx = _x = X;
		_inity = _y = Y;
		_initz = _z = Z;
		x = Math.round(_x);
		y = Math.round(_y - _z);
		_shadow = new FlxSprite(0,0);
		_shadow.loadGraphic("assets/sprites/misc/shadow.png", false);
		add(_shadow);
		alignShadow();
		add(sprite);
		
		updateAttackBoxes();
			
		LevelState.debug.add(debug_hub);
		LevelState.debug.add(debug_hib);
		
		//sin and cos are intensive processes. so we'll cache these angles
		for (ang in 0...360){
			angles.push(new FlxPoint(Math.cos(ang), Math.sin(ang)));
		}
		
		
		interp.variables.set("Math",Math); // share the Math class
		interp.variables.set("setP",setP); // set the angles list
		interp.variables.set("setG",setP); // set the angles list
		interp.variables.set("self",instance); // set the angles list
		interp.variables.set("AOTD",AOTD); // set the angles list
	}
	
	public function updateAttackBoxes() 
	{
		
			hurtbox.x = (x - hurtbox.width / 2) ;
			hurtbox.y = (y - hurtbox.height);
			hitbox.x = x + (-hitbox.width/2) +(hitboxOffset.x * dir);
			hitbox.y = (hitboxOffset.y) + y;
			
			
		//hitbox.setSize(width, height);
		//hurtbox.setSize(width, height);
		
			debug_hib.setPosition(hitbox.x, hitbox.y);
			debug_hib.makeGraphic(Std.int(hitbox.width), Std.int(hitbox.height), 0x7fff0000);
			
			if (onAttackFrame){
				
				debug_hib.color = 0x80ffffff;
			}
			
			debug_hub.setPosition(hurtbox.x, hurtbox.y);
			debug_hub.makeGraphic(Std.int(hurtbox.width), Std.int(hurtbox.height), 0x7f0000ff);
			
			
	}
	

	override public function update(elapsed:Float):Void{
		
		if(allowScripts){
			interp.variables.set("_velx",_velx);
			interp.variables.set("_vely",_vely); 
			interp.variables.set("vx",_velx);
			interp.variables.set("vy",_vely); 
			interp.variables.set("_grav",_grav); 
			interp.variables.set("g",_grav); 
			interp.variables.set("_forcex",_forcex);
			interp.variables.set("_forcey",_forcey); 
			interp.variables.set("fx",_forcex);
			interp.variables.set("fy",_forcey); 
			interp.variables.set("_angle",sprite.angle); 
			interp.variables.set("_x",_x); 
			interp.variables.set("_y",_y); 
			interp.variables.set("_z",_z); 
			interp.variables.set("_px",_px); 
			interp.variables.set("_py",_py); 
			interp.variables.set("_pz",_pz); 
			interp.variables.set("_onfloor",_onfloor); 
			interp.variables.set("of",_onfloor); 
			interp.variables.set("dir", dir);
			interp.variables.set("direction", dir);
		}
		visible = getScreenPosition(null, FlxG.camera).x > -128 && getScreenPosition(null, FlxG.camera).x < 1400; 
		if(_update && !AOTD.inShopRN){
			updateAttackBoxes();
			
			
			if (_boundByCam && inited){//BOUND IN CAMERA WHEN NEEDED
				if (_px < FlxG.camera.scroll.x + FlxG.width && _px > FlxG.camera.scroll.x){
					
				
					if (_x > FlxG.camera.scroll.x + FlxG.width){
						_x = FlxG.camera.scroll.x + FlxG.width;
					}
				
					if (_x < FlxG.camera.scroll.x){
						_x = FlxG.camera.scroll.x;
					}
				}
				if (_py < FlxG.camera.scroll.y + FlxG.height && _py > FlxG.camera.scroll.y){
					if (_y > FlxG.camera.scroll.y + FlxG.height){
						_y = FlxG.camera.scroll.y + FlxG.height;
					}
					if (_y < FlxG.camera.scroll.y){
						_y = FlxG.camera.scroll.y-1;
					}
						
				
				
				}
			}
			
			_px = _x;
			_py = _y;
			_pz = _z;
			
			_landed = false;
			updatecoords();
			if(!_beingCarried){
			if (!_float){
				if(_grav >0){
					_grav += _weight;
				}else{
					_grav += Entity.UNIVERSAL_GRAVITY;
				}
			}
			
			if (!_noclip){
				
			collideToWall();//deals with heightmap walls and stuff
			_floorz = (LevelState.getValue(LevelState.heightmap.getPixel(Math.round(_x), Math.round(_y)), "value"));
			
			
			world.forEachAlive(function(i:FlxSprite){
				
				var pl:Entity = cast(i, Entity);
				if (this != pl && !pl.isOrganism && pl._height >8){//make sure it doesn't hit itself
					if (pl._x > _x - pl.sprite.width && pl._x < _x + pl.sprite.width && pl._y > _y - 8 && pl._y < _y + 8){
						if(_z > pl._z+pl._height-_grav)_floorz = pl._height + pl._z;
					}
				}
			
			
			});
			/*STANDING ON TOP OF ENTITIES*/
			
			//if on red pixel on heightmap, make it pit
			
			
			
			//FIXES BUG WHERE CHARACTER'S WILL FALL ON THE EDGE OF A MAP
			
			if (_x < 0 )_x = 1;
			if (_y < 0 )_y = 1;
			if (_x > LevelState.camBound.width )_x = LevelState.camBound.width-1;
			if (_y > LevelState.camBound.height )_y = LevelState.camBound.height-1;
			
			
			if (LevelState.getValue(LevelState.heightmap.getPixel(Math.round(_x), Math.round(_y)), "red") > 254 - LevelState.th && 
			LevelState.getValue(LevelState.heightmap.getPixel(Math.round(_x), Math.round(_y)), "blue") ==-LevelState.th && 
			LevelState.getValue(LevelState.heightmap.getPixel(Math.round(_x), Math.round(_y)), "green") == -LevelState.th){
				_floorz = -999;
			}
			
			}
			
			
			if (_bounce > 0){
				_onfloor = _z <= _floorz;
			}else{
				_onfloor = _z <= _floorz + _stickmargin;
			}
			if (!_noclip) if (_z <= _floorz+_stickmargin){
				_z = _floorz;
				_landed = true;
				//_grav = -_grav*_bounce;
			}
			
			if (_onfloor){
				_grav = -_grav*_bounce;
				if (_velx > 0){
					_velx -= _friction * _weight;
				}
				if (_velx < 0){
					_velx += _friction * _weight;
				}
				
				if (_vely > 0){
					_vely -= _friction * _weight;
				}
				if (_vely < 0){
					_vely += _friction * _weight;
				}
				if (_forcex > 0){
					_forcex -= _friction * _weight;
				}
				if (_forcex < 0){
					_forcex += _friction * _weight;
				}
				
				if (_forcey > 0){
					_forcey -= _friction * _weight;
				}
				if (_forcey < 0){
					_forcey += _friction * _weight;
				}
				
				if (_velx < 0.5 && _velx > -0.5)_velx = 0;
				if (_vely < 0.5 && _vely > -0.5)_vely = 0;
				
				if (_forcex < 0.5 && _forcex > -0.5)_forcex = 0;
				if (_forcey < 0.5 && _forcey > -0.5)_forcey = 0;
			}else{
				if (!_slip){
					_velx = 0;
					_vely = 0;
				}
			}
			
			}else{
				dir = _target.dir ;
				scale.x = dir;
				setPos(_target._x + _target._carryOffset._x*_target.scale.x, _target._y + _target._carryOffset._y, _target._z+ _target._carryOffset._z);
			}
			
			if (!isPlayer && !_beingCarried && _solid){
				onAttackFrame = Math.abs(_velx) > 8;
			}
			//collsion and floor shit
			
			
			_elevation = _z - _floorz;
			
			
			
			if (!_noclip && _affectByCollision){
				
				if(_hitstun == 0){
					testCollision();
				}else{
					_hitstun--;
				}
			}
			_shadow.visible = _showshadow;
			if (_vibrationx > 0)_vibrationx--;
			if (_vibrationy > 0)_vibrationy--;
			alignShadow();
			soundPro_x = getScreenPosition(null,FlxG.camera).x;
			soundPro_y = getScreenPosition(null, FlxG.camera).y;
			
			if (runningfor < 4) runningfor ++;
			if(runningfor == 3)inited = true;
			
		}
			
			x = Math.round(_x)+(FlxG.random.int(-_vibrationx,_vibrationx));
			y = Math.round(_y - _z)+(FlxG.random.int(-_vibrationy,_vibrationy));
			if (_hp > _maxhp)_hp = _maxhp;
			if (_hp <0)_hp = 0;
			if(_permaupdate )super.update(elapsed);
	}
	
	public function initPos(includeZ:Bool){
		_x = _initx;
		_y = _inity;
		if (includeZ)_z = _initz;
	}
	
	
	
	private function alignShadow(){
		if(shadow != null && _showshadow){
			if(_z < 256)_shadow.alpha = _shadow.scale.x = _shadow.scale.y = 1 - (_z - _floorz) / 200;
			_shadow.centerOffsets();
			_shadow.offset.x = 16;
			_shadow.offset.y = 8+_floorz+_grav;
		}
	}
	public function prevPos(includeZ:Bool){
		_x = _px;
		_y = _py;
		if (includeZ)_z = _pz;
	}
	public function fixOffset(){
		sprite.offset.set((sprite.width / 2), (sprite.height - 1));
	}
	public function updatecoords(){
		
			_x += _velx+_forcex;
			_y += _vely+_forcey;
			_z -= _grav;
			_shadow.x = _x;
			_shadow.y = _y;
	}
	public function getFlatCoords():FlxPoint{
		return new FlxPoint(_x, _y);
	}
	public function collideToWall(){
		
		if(_x < 0 || _x >= LevelState.heightmap.width ||_y < 0 || _y >= LevelState.heightmap.height-1){
				prevPos(false);
				if(_bounce>0){
				_velx = -_velx * _bounce;
				_vely = -_vely * _bounce;
				}
		}
		if(_x < 0 || _x >= LevelState.heightmap.width ||_y < 0 || _y >= LevelState.heightmap.height-1){
				prevPos(false);
				if(_bounce>0){
				_velx = -_velx * _bounce;
				_vely = -_vely * _bounce;
				}
		}
		
		
		_hmpt = LevelState.getValue(LevelState.heightmap.getPixel(Math.round(_x), Math.round(_y)), "red") - LevelState.th;
		
		
		
			if (LevelState.getValue(LevelState.heightmap.getPixel(Math.round(_x), Math.round(_y)), "blue") > 254 - LevelState.th && 
			LevelState.getValue(LevelState.heightmap.getPixel(Math.round(_x), Math.round(_y)), "red") ==-LevelState.th && 
			LevelState.getValue(LevelState.heightmap.getPixel(Math.round(_x), Math.round(_y)), "green") == -LevelState.th){
				prevPos(false);
				if(_bounce>0){
				_velx = -_velx * _bounce;
				_vely = -_vely * _bounce;
				}
			}
		
			
			
			if (_z < LevelState.getValue(LevelState.heightmap.getPixel(Math.round(_x), Math.round(_y)), "red") && LevelState.getValue(LevelState.heightmap.getPixel(Math.round(_x), Math.round(_y)), "red") - _z > 8){
				prevPos(false);
				if(_bounce>0){
				_velx = -_velx * _bounce;
				_vely = -_vely * _bounce;
				}
				
			}
	}
	public function setPos(X:Float=0,Y:Float=0,Z:Float=0){
		_x = X;
		_y = Y;
		_z = Z;
	}
	public function getPos():Point3D{
		return new Point3D(_x, _y, _z);
	}
	
	public function removeSelf(e = null):Void 
	{
		reactToDeath();
		forEachAlive(function(e:FlxSprite){
			remove(e);
		});
		_permaupdate = false;
		_update = false;
		_dead = false;
		hitbox.destroy();
		hurtbox.destroy();
		debug_hib.destroy();
		debug_hub.destroy();
		world.remove(this);
		
		
	}
	
	public function isInY(object:Entity):Bool 
	{
		var bo:Bool = _y > object._y - object._length && _y < object._y + object._length && overlaps(object);
		return bo;
	}
	
	public function testCollision(){
		world.forEachAlive(function(i){
			var p1:Entity = cast(i,Entity);
			if (this != p1){//make sure it doesn't hit itself
				if(isPlayer && AOTD.friendlyfire && p1.isPlayer|| !isPlayer && p1._carryObject != this){//tests if it's both players or not
					if (p1._y > _y - _length && p1._y < _y + _length ){
							//	trace("ray'd");
						if (p1.onAttackFrame){
								//trace("player attacking");
							if (p1.hitbox.overlaps(hurtbox) && p1.defaultDamageData.enabled){
								p1.justHit = true;
								p1.defaultDamageData.enabled = false;
								//trace("hurt");
								hf = new FlxSprite((p1.x + x) / 2, ((p1.y-p1.height/2) + (y-height/2)) / 2);
								//AOTD.shakeCamera(Reflect.getProperty(data, "hitstun"));
								hf.offset.set(16, 16);
								hf.loadGraphic("assets/sprites/misc/hitflash.png", true,32,32);
								hf.animation.add("flash1", [0, 1, 2, 3], 10, false);
								hf.animation.play("flash1");
								LevelState.effects.add(hf);
								
								//LevelState.effects.add(new StatNumber(x, y, Reflect.getProperty(data, "dmg"), 0xFFFF4444));
								this.pl = p1;
								this.data = p1.defaultDamageData;
								reactToHit(p1);
								pl.reactwhenHit(this);
								updatecoords();
								collideToWall();
								
								//RUN THE TEST!!!!
								
								AOTD.freezeFrameSeperate(p1, this, data.hitstun, data.hitlag);
								_hitstun = 8;
							}
							
						}
					}
				}
			}
		}
		);
	}
	public function setDamageData(dmg:Float, kbx:Float, kby:Float, hitlag:Int, hitstun:Int){
		defaultDamageData.dmg = dmg;
		defaultDamageData.kbx = kbx;
		defaultDamageData.kby = kby;
		defaultDamageData.hitlag = hitlag;
		defaultDamageData.hitstun = hitstun;
	}
	
	public function playSound(ID:String){
		FlxG.sound.play(AOTD.getSoundFile("assets/sfx/"+ ID + AOTD.soundext));
	}
	
	public function toFloor(andStayThere:Bool = false){
		_x = _floorz;
		if (andStayThere){
			active = false;
		}
		
	}
	
	
	public function reactToHit(ent:Entity){
	AOTD.shakeCamera(Std.int(data.hitstun/4));
		effects.add(new StatNumber(x, y-height, data.dmg, 0xFFFFFFFF));
		this._hp -= data.dmg;
		_vibrationx = Std.int(data.kbx / 2);
		_vibrationy = Std.int(data.kby / 2);
								playSound("sfx_hit_enemy_" + FlxG.random.int(1, 3));//.proximity(soundPro_x,soundPro_y,LevelState.camfollow,soundPro_rad);
								//trace(data.kbx * this.pl.dir + "," + data.kby);
								_z += -data.kby;
								_x += data.kbx * this.pl.dir;
								_grav = -data.kby;
								_velx = data.kbx * this.pl.dir;
								
	}
	public function reactwhenHit(ent:Entity){
		
								
	}
	public function reactToDeath(){
		Coin.spawnMass(1, 10, _x, _y, _z, ["bronze"]);
	}
	
	public function resetHitbox(){
		
	hitbox.set(0,0,32,64);
	hurtbox.set(0,0,32,64);
	hurtboxOffset.set(0,64);
	hitboxOffset.set(16,-64);
	}
	
	
	public function setP(instance,variable:String,value:Dynamic){//stollen from FNF Psych Engine.
		var killMe:Array<String> = variable.split('.');
			if(killMe.length > 1) {
				var coverMeInPiss:Dynamic = Reflect.getProperty(instance, killMe[0]);
				for (i in 1...killMe.length-1) {
					coverMeInPiss = Reflect.getProperty(coverMeInPiss, killMe[i]);
				}
				return Reflect.setProperty(coverMeInPiss, killMe[killMe.length-1], value);
			}
			return Reflect.setProperty(instance, variable, value);
	}
	public function getP(instance,variable:String){//stollen from FNF Psych Engine.
		var killMe:Array<String> = variable.split('.');
			if(killMe.length > 1) {
				var coverMeInPiss:Dynamic = Reflect.getProperty(instance, killMe[0]);
				for (i in 1...killMe.length-1) {
					coverMeInPiss = Reflect.getProperty(coverMeInPiss, killMe[i]);
				}
				return Reflect.getProperty(coverMeInPiss, killMe[killMe.length-1]);
			}
			return Reflect.getProperty(instance, variable);
	}
	
}