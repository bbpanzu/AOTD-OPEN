package;
import flixel.*;
import effects.StatNumber;
import flixel.effects.FlxFlicker;
import flixel.input.keyboard.*;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import haxe.Json;
import json2object.*;
import haxe.Utf8;
import hscript.Interp;
import hscript.Parser;
import hud.PlayerHud;
import level.LVL_Test;
import openfl.Assets;
import states.DeathScreen;
import states.LevelState;
#if desktop
import sys.FileSystem;
#end
using StringTools;
/**
 * ...
 * @author bbpanzu
 */
class Player extends Entity 
{
	public var STATE:String = "idle";
	public var character:String = "player";
	
	public var _attacking:Bool = false;
	public var _jumping:Bool = false;
	
	public var _walkspeed:Float = 2;
	public var _runspeed:Float = 4;
	public var _jumpforce:Float = 6;
	public var playerhud:PlayerHud;
	
	public var goingtoHold:Entity;
	
	public var _hitlag:Float = 8;
	public var _hurt:Bool = false;
	public var _landlag:Float = 8;
	public var _jumplag:Float = 8;
	
	public var _canMove:Bool = true;
	public var timebeenlanded:Int = 0;
	
	public var _landlagtime:Float = 0;
	public var _jumplagtime:Float = 0;
	
	public var mp:Float = 40;
	public var coins:Float = 0;
	public var stuntime:Float = 0;
	
	public var _stepped:Bool = false;
	
	public var canInterupt:Bool = false;
	public var combo:UInt = 0;
	public var highestCombo:UInt = 0;
	public var combodecay:UInt = 60;
	public var combodecaytime:UInt = 0;
	public var inAir:Bool = false;
	public var inDoor:Bool = false;
	
	public var _mode:UInt = 0;
	public var _enabled:Bool = true;
	public var curAnim:String = "idle";
	
	
	public var player:UInt=1;
	
	
	private	var vx:Float=0;
	private var vy:Float = 0;
	
	public var swingL:UInt = 1;
	public var didAThingOnce:Bool = false;
	private var rs:String = "walk";
	var waittofall = false;
	
	public var dddd:Dynamic = {
		"walk1":new FlxSound().loadEmbedded("assets/sfx/step1.ogg"),
		"walk2":new FlxSound().loadEmbedded("assets/sfx/step2.ogg"),
		"walk3":new FlxSound().loadEmbedded("assets/sfx/step3.ogg"),
		"walk4":new FlxSound().loadEmbedded("assets/sfx/step4.ogg"),
		"land1":new FlxSound().loadEmbedded("assets/sfx/land1.ogg"),
		"land2":new FlxSound().loadEmbedded("assets/sfx/land2.ogg")
		
	}
	
	public static var _anim = {//remind me to make this a static property
		/*
		"jeremy":{
			"offsetleft":43,
			"offsetright":20,
			"jumpforce":9,
			"weight":1.3,
			"walkspeed":2,
			"runspeed":5,
			"idle":{
				sf:0,
				ef:7,
				fps:10,
				loop:true
			},
			"idle_heavy":{
				sf:104,
				ef:111,
				fps:10,
				loop:true
			},
			"walk":{
				sf:176,
				ef:183,
				fps:10,
				loop:true
			},
			"walk_heavy":{
				sf:112,
				ef:119,
				fps:10,
				loop:true
			},
			"run_heavy":{
				sf:112,
				ef:119,
				fps:10,
				loop:true
			},
			"throw_heavy":{
				sf:120,
				ef:124,
				fps:10,
				loop:true,
				attack:{
					frame:[99],
					dmg:3,
					kbx:2,
					kby:2,
					hitstun:4,
					hitlag:2
				}
			},
			"run":{
				sf:8,
				ef:15,
				fps:15,
				loop:true
			},
			"jump":{
				sf:71,
				ef:74,
				fps:5,
				loop:false
			},
			"land":{
				sf:28,
				ef:31,
				fps:15,
				loop:false
			},
			"hurt":{
				sf:33,
				ef:33,
				fps:8,
				loop:false
			},
			"stun":{
				sf:32,
				ef:33,
				fps:8,
				loop:false
			},
			"fall":{
				sf:36,
				ef:38,
				fps:8,
				loop:false
			},
			"death":{
				sf:33,
				ef:33,
				fps:8,
				loop:false
			},
			"an_heavy":{
				sf:120,
				ef:124,
				fps:10,
				loop:false,
				attack:{
					frame:[2],
					dmg:5,
					kbx:5,
					kby:5,
					hitstun:10,
					hitlag:12
				}
			},
			"an1":{
				sf:15,
				ef:19,
				fps:20,
				loop:false,
				attack:{
					frame:[2],
					dmg:1,
					kbx:1,
					kby:1,
					hitstun:5,
					hitlag:2
				}
			},
			"an2":{
				sf:19,
				ef:23,
				fps:20,
				loop:false,
				attack:{
					frame:[2],
					dmg:1,
					kbx:-1,
					kby:1,
					hitstun:5,
					hitlag:2
				}
			},
			"bn":{
				sf:152,
				ef:155,
				fps:15,
				loop:false,
				attack:{
					frame:[2],
					dmg:2,
					kbx:4,
					kby:2,
					hitstun:8,
					hitlag:5
				}
			},
			"aa":{
				sf:96,
				ef:98,
				fps:20,
				loop:false,
				attack:{
					frame:[1,2],
					dmg:4,
					kbx:5,
					kby:4,
					hitstun:10,
					hitlag:8
				}
			},
			"ba":{
				sf:80,
				ef:83,
				fps:20,
				loop:false,
				attack:{
					frame:[1,2,3],
					dmg:4,
					kbx:5,
					kby:4,
					hitstun:10,
					hitlag:8
				}
			},
			"aad":{
				sf:88,
				ef:90,
				fps:15,
				loop:false,
				attack:{
					frame:[2],
					dmg:8,
					
					kbx:2,
					kby:6,
					hitstun:15,
					hitlag:20,
				}
			},
			"an3":{
				sf:192,
				ef:197,
				fps:20,
				loop:false,
				attack:{
					frame:[3],
					dmg:4,
					kbx:1,
					kby:8,
					hitstun:17,
					hitlag:20
				}
			},
			"dn":{
				sf:200,
				ef:203,
				fps:20,
				loop:false,
				attack:{
					frame:[1],
					dmg:7,
					kbx:1,
					kby:7,
					hitstun:12,
					hitlag:15,
				}
			}
		},
		"michael":{
			"offsetleft":41,
			"offsetright":22,
			"jumpforce":10,
			"weight":0.4,
			"walkspeed":2.5,
			"runspeed":4,
			"idle":{
				sf:0,
				ef:7,
				fps:10,
				loop:true
			},
			"walk":{
				sf:8,
				ef:15,
				fps:10,
				loop:true
			},
			"run":{
				sf:40,
				ef:47,
				fps:15,
				loop:true
			},
			"hurt":{
				sf:33,
				ef:33,
				fps:8,
				loop:false
			},
			"stun":{
				sf:33,
				ef:33,
				fps:8,
				loop:false
			},
			"death":{
				sf:33,
				ef:33,
				fps:8,
				loop:false
			},
			"jump":{
				sf:88,
				ef:91,
				fps:5,
				loop:false
			},
			"land":{
				sf:88,
				ef:88,
				fps:15,
				loop:false
			},
			"an1":{
				sf:16,
				ef:18,
				fps:10,
				loop:false,
				attack:{
					frame:[2],
					dmg:3,
					kbx:2,
					kby:2,
					hitstun:4,
					hitlag:5
				}
			},
			"an2":{
				sf:20,
				ef:22,
				fps:10,
				loop:false,
				attack:{
					frame:[2],
					dmg:3,
					kbx:-2,
					kby:2,
					hitstun:4,
					hitlag:5
				}
			},
			"aa":{
				sf:96,
				ef:100,
				fps:15,
				loop:false,
				attack:{
					frame:[3],
					dmg:6,
					kbx:1,
					kby:-8,
					hitstun:20,
					hitlag:17
				}
			},
			"ba":{
				sf:104,
				ef:106,
				fps:10,
				loop:false,
				attack:{
					frame:[1,2],
					dmg:5,
					kbx:5,
					kby:4,
					hitstun:7,
					hitlag:5
				}
			},
			"bn":{
				sf:24,
				ef:31,
				fps:20,
				loop:false,
				attack:{
					frame:[5],
					dmg:8,
					kbx:2,
					kby:6,
					hitstun:15,
					hitlag:20,
				}
			},
			"aad":{
				sf:128,
				ef:128,
				fps:1,
				loop:false,
				attack:{
					frame:[1],
					dmg:8,
					kbx:2,
					kby:6,
					hitstun:15,
					hitlag:20,
				}
			},
			"an3":{
				sf:80,
				ef:83,
				fps:10,
				loop:false,
				attack:{
					frame:[1],
					dmg:6,
					kbx:2,
					kby:7,
					hitstun:18,
					hitlag:20
				}
			},
			"dn":{
				sf:120,
				ef:122,
				fps:10,
				loop:false,
				attack:{
					frame:[1],
					dmg:5,
					kbx:0,
					kby:2,
					hitstun:13,
					hitlag:15
				}
			}
		},
		"christine":{
			"offsetleft":43,
			"offsetright":18,
			"jumpforce":10,
			"weight":0.18,
			"walkspeed":2.3,
			"runspeed":3.8,
			"idle":{
				sf:0,
				ef:7,
				fps:10,
				loop:true
			},
			"idle_heavy":{
				sf:120,
				ef:123,
				fps:10,
				loop:true
			},
			"hurt":{
				sf:112,
				ef:112,
				fps:5,
				loop:false
			},
			"stun":{
				sf:113,
				ef:115,
				fps:10,
				loop:false
			},
			"fall":{
				sf:113,
				ef:115,
				fps:10,
				loop:false
			},
			"walk":{
				sf:8,
				ef:15,
				fps:10,
				loop:true
			},
			"run":{
				sf:16,
				ef:21,
				fps:15,
				loop:true
			},
			"walk_heavy":{
				sf:128,
				ef:135,
				fps:10,
				loop:true
			},
			"run_heavy":{
				sf:128,
				ef:135,
				fps:15,
				loop:true
			},
			"jump":{
				sf:48,
				ef:51,
				fps:15,
				loop:false
			},
			"land":{
				sf:48,
				ef:48,
				fps:15,
				loop:false
			},
			"an_heavy":{
				sf:136,
				ef:140,
				fps:10,
				loop:false,
				attack:{
					frame:[3],
					dmg:2,
					kbx:4,
					kby:4,
					hitstun:4,
					hitlag:5
				}
			},
			"throw_heavy":{
				sf:136,
				ef:140,
				fps:10,
				loop:false,
				attack:{
					frame:[99],
					dmg:3,
					kbx:2,
					kby:2,
					hitstun:4,
					hitlag:2
				}
				
			},
			"an1":{
				sf:24,
				ef:31,
				fps:20,
				loop:false,
				attack:{
					frame:[4],
					dmg:2,
					kbx:0,
					kby:4,
					hitstun:4,
					hitlag:5
				}
			},
			"an2":{
				sf:32,
				ef:39,
				fps:20,
				loop:false,
				attack:{
					frame:[4],
					dmg:3,
					kbx:0,
					kby:4,
					hitstun:4,
					hitlag:2
				}
			},
			"an3":{
				sf:40,
				ef:43,
				fps:10,
				loop:false,
				attack:{
					frame:[1],
					dmg:4,
					kbx:1,
					kby:9,
					hitstun:15,
					hitlag:8
				}
			},
			"aa":{
				sf:72,
				ef:76,
				fps:15,
				loop:false,
				attack:{
					frame:[2],
					dmg:6,
					kbx:1,
					kby:8,
					hitstun:2,
					hitlag:1
				}
			},
			"ba":{
				sf:64,
				ef:66,
				fps:10,
				loop:false,
				attack:{
					frame:[1,2,3],
					dmg:5,
					kbx:4,
					kby:5,
					hitstun:7,
					hitlag:5
				}
			},
			"aad":{
				sf:56,
				ef:58,
				fps:15,
				loop:true,
				attack:{
					frame:[0,1,2],
					dmg:1,
					kbx:0,
					kby:2,
					hitstun:8,
					hitlag:2,
				}
			},
			"bn":{
				sf:104,
				ef:106,
				fps:8,
				loop:false,
				attack:{
					frame:[1],
					dmg:3,
					kbx:2,
					kby:2,
					hitstun:4,
					hitlag:2
				}
			},
			"dn":{
				sf:96,
				ef:98,
				fps:4,
				loop:false,
				attack:{
					frame:[1],
					dmg:5,
					kbx:2,
					kby:0,
					hitstun:13,
					hitlag:15
				}
			}
		}*/
	}
	public function new(x:Int, y:Int, z:Int, char:String) 
	{
		
		super(x, y, z);





//_anim = Json.parse(s);




		AOTD.camFollow.push(this);
		setChar(char);
		//_walkspeed = data.walkspeed;
		_weight = 0.3;
		sprite.y = -64+_y;
		//centerOrigin();
		//origin.y -= 46;
		campoint.y = -80;
		_maxhp = 150;
		_hp = _maxhp;
		_canBeCaried = false;
		isOrganism = true;
		//origin.x -= 8;
		allowScripts = true;
		
	}

	override public function update(elapsed:Float):Void
	{
		goingtoHold = null;
		super.update(elapsed);
		sprite.y = -64+y;
		_stickmargin = 16;
		
		_carryweight = "_heavy";
		switch(character){
			case "jeremy":
				_carryOffset.set(0, 1, 62);
			case "christine":
				_carryOffset.set(0, 1, 60);
				
		}
		//if(FlxG.keys.anyJustPressed(AOTD.keysets[player-1].INTERACT)){
		//	_carryOffset.set(64, 0, 32);
		//}
		
		if (combodecaytime > 0){
			combodecaytime --;
		}else{
			combo = 0;
		}
		
		_boundByCam = LevelState.inCombat;
		if (character == "jeremy"){
			//trace(_z +","+ LevelState.getValue(LevelState.heightmap.getPixel(Math.round(_x), Math.round(_y)), "red"));
		}
		//FlxG.camera.x = -_x;
		//FlxG.camera.y = -_y - 80;
		
		//FlxG.camera.x += 32;
		_affectByCollision = true;
		if (LevelState.instance.command.text == ""){
			/*
		if (FlxG.keys.anyPressed([ONE])){
			setChar("jeremy");
		}else if (FlxG.keys.anyPressed([TWO])){
			setChar("michael");
		}else if (FlxG.keys.anyPressed([THREE])){
			setChar("christine");
		}else if (FlxG.keys.anyPressed([FOUR])){
			setChar("rich");
		}else if (FlxG.keys.anyPressed([FIVE])){
			setChar("chloe");
		}*/
		
		if (!_onfloor){
			_landlagtime = _landlag;
		}
		if (STATE != "jump"){
			_jumplagtime = _jumplag;
		}
			
		if(_enabled){
		if (FlxG.keys.anyPressed(AOTD.keysets[player-1].RUN) && (!_carrying))
			rs = "run";
		else
			rs = "walk";
			
			if (!_attacking){
				
				if (_onfloor && _jumping && !STATE.startsWith("hurt")){
					timebeenlanded = 0;
					_canMove = true;
					inAir = false;
					//Reflect.getProperty(soundList,"land" + FlxG.random.int(1, 2)).play();
					playSound("land" + FlxG.random.int(1, 2));
					var d1:DustStep = new DustStep(_x+8, y, dir == -1);
					var d2:DustStep = new DustStep(_x-8, y, dir == 1);
					LevelState.effects.add(d1);
					LevelState.effects.add(d2);
					
				//var i = FlxG.random.int(0, AudioStore.land.length - 1);
					
					//AudioStore.land[0].play();
					
					state("land");
				}else if (StringTools.startsWith(STATE, rs) && !_onfloor && _elevation > _stickmargin && _canMove && _hurt == false){
					if (rs == "run"){
						vx = _velx;
						vy = _vely;
					}
					state("fall");
				}else if (FlxG.keys.anyPressed(AOTD.keysets[player-1].LEFT) && FlxG.keys.anyPressed(AOTD.keysets[player-1].UP)  && _onfloor && _canMove && STATE != "jump" && _hurt == false){
					state(rs+"_upleft");
				}else if (FlxG.keys.anyPressed(AOTD.keysets[player-1].RIGHT) && FlxG.keys.anyPressed(AOTD.keysets[player-1].UP)  && _onfloor && _canMove && STATE != "jump" && _hurt == false){
					state(rs+"_upright");
				}else if (FlxG.keys.anyPressed(AOTD.keysets[player-1].LEFT) && FlxG.keys.anyPressed(AOTD.keysets[player-1].DOWN)  && _onfloor && _canMove && STATE != "jump" && _hurt == false){
					state(rs+"_downleft");
				}else if (FlxG.keys.anyPressed(AOTD.keysets[player-1].RIGHT) && FlxG.keys.anyPressed(AOTD.keysets[player-1].DOWN) && _onfloor && _canMove && STATE != "jump" && _hurt == false){
					state(rs+"_downright");
				}else if (FlxG.keys.anyPressed(AOTD.keysets[player-1].LEFT) && _onfloor && _canMove && STATE != "jump" && _hurt == false){
					state(rs+"_left");
				}else if (FlxG.keys.anyPressed(AOTD.keysets[player-1].RIGHT) && _onfloor && _canMove && STATE != "jump" && _hurt == false){
					state(rs+"_right");
				}else if (FlxG.keys.anyPressed(AOTD.keysets[player-1].DOWN) && _onfloor && _canMove && STATE != "jump" && _hurt == false){
					state("walk_down");
				}else if (FlxG.keys.anyPressed(AOTD.keysets[player-1].UP) && _onfloor && _canMove && STATE != "jump" && _hurt == false){
					state("walk_up");
				}else if (FlxG.keys.anyPressed(AOTD.keysets[player-1].LEFT) && _onfloor && _canMove && _hurt == false){
					state("jump");
				}else if (FlxG.keys.anyPressed(AOTD.keysets[player-1].RIGHT) && _onfloor && _canMove && _hurt == false){
					state("jump");
				}else if (FlxG.keys.anyPressed(AOTD.keysets[player-1].DOWN) && _onfloor && _canMove && _hurt == false){
					state("jump");
				}else if(_onfloor && _canMove && !_jumping && STATE != "jump" && !STATE.startsWith("hurt")){
					state("idle");
				}
				
				if (FlxG.keys.anyPressed(AOTD.keysets[player-1].JUMP) && _onfloor && _canMove && !_jumping){
					if (FlxG.keys.anyPressed(AOTD.keysets[player-1].LEFT) && FlxG.keys.anyPressed(AOTD.keysets[player-1].UP) ){
						state("jump");
					}else if (FlxG.keys.anyPressed(AOTD.keysets[player-1].RIGHT) && FlxG.keys.anyPressed(AOTD.keysets[player-1].UP) ){
						state("jump");
					}else if (FlxG.keys.anyPressed(AOTD.keysets[player-1].LEFT) && FlxG.keys.anyPressed(AOTD.keysets[player-1].DOWN) ){
						state("jump");
					}else if (FlxG.keys.anyPressed(AOTD.keysets[player-1].RIGHT) && FlxG.keys.anyPressed(AOTD.keysets[player-1].DOWN) ){
						state("jump");
					}else if (FlxG.keys.anyPressed(AOTD.keysets[player-1].LEFT)){
						state("jump");
					}else if (FlxG.keys.anyPressed(AOTD.keysets[player-1].RIGHT)){
						state("jump");
					}else if (FlxG.keys.anyPressed(AOTD.keysets[player-1].DOWN)){
						state("jump");
					}else if (FlxG.keys.anyPressed(AOTD.keysets[player-1].UP)){
						state("jump");
					}else{
						state("jump");
					}
					
				} 
				
			}else{
				if (_onfloor && (_jumping || inAir)&& !STATE.startsWith("hurt")){
					timebeenlanded = 0;
					//Reflect.getProperty(soundList,"land"+FlxG.random.int(1,2)).play();
					//FlxG.sound.play("assets/sfx/+".ogg").proximity(soundPro_x,soundPro_y,LevelState.camfollow,soundPro_rad);
					playSound("land" + FlxG.random.int(1, 2));
					_attacking = false;
					inAir = false;
					var d1:DustStep = new DustStep(_x+8, y, dir == -1);
					var d2:DustStep = new DustStep(_x-8, y, dir == 1);
					LevelState.effects.add(d1);
					LevelState.effects.add(d2);
				//var i = FlxG.random.int(0, AudioStore.land.length - 1);
					
					//AudioStore.land[0].play();
					
					state("land");
				}
			}
				
		if ((FlxG.keys.anyJustPressed(AOTD.keysets[player-1].PUNCH) || FlxG.keys.anyJustPressed(AOTD.keysets[player-1].KICK)) && FlxG.keys.anyPressed(AOTD.keysets[player-1].DOWN) && !_onfloor && _canMove&& !_carrying && _hurt == false){
			_attacking = true;
			state("aad");
		}else if ((FlxG.keys.anyJustPressed(AOTD.keysets[player-1].PUNCH)) && !_onfloor && _canMove&& !_carrying && _hurt == false){
			_attacking = true;
			state("aa");
		}else if ((FlxG.keys.anyJustPressed(AOTD.keysets[player-1].KICK)) && !_onfloor && _canMove&& !_carrying && _hurt == false){
			_attacking = true;
			state("ba");
		}else if (FlxG.keys.anyJustPressed(AOTD.keysets[player-1].KICK) && _onfloor && _canMove && _carrying&& !_attacking && _hurt == false){
			_attacking = true;
			playAnim("throw"+_carryObject._carryweight);
			state("throw");
		}else if (FlxG.keys.anyJustPressed(AOTD.keysets[player-1].KICK) && _onfloor && _canMove && !_carrying&& !_attacking && _hurt == false){
			_attacking = true;
			state("bn");
		}else if ((FlxG.keys.anyJustPressed(AOTD.keysets[player-1].PUNCH) || FlxG.keys.anyJustPressed(AOTD.keysets[player-1].KICK)) && FlxG.keys.anyPressed(AOTD.keysets[player-1].UP) && _onfloor && _canMove && !_carrying&& !_attacking && _hurt == false){
			_attacking = true;
			state("an3");
		}else if ((FlxG.keys.anyJustPressed(AOTD.keysets[player-1].PUNCH) || FlxG.keys.anyJustPressed(AOTD.keysets[player-1].KICK)) && FlxG.keys.anyPressed(AOTD.keysets[player-1].DOWN) && _onfloor && _canMove && !_carrying&& !_attacking && _hurt == false){
			_attacking = true;
			state("dn");
		}else if (FlxG.keys.anyJustPressed(AOTD.keysets[player-1].PUNCH) && !FlxG.keys.anyPressed(AOTD.keysets[player-1].UP) && _onfloor && _canMove&& _carrying&& !_attacking && _hurt == false){
			_attacking = true;
			state("an"+_carryObject._carryweight);
		}else if (FlxG.keys.anyJustPressed(AOTD.keysets[player-1].PUNCH) && !FlxG.keys.anyPressed(AOTD.keysets[player-1].UP) && _onfloor && _canMove&& !_carrying && !_attacking && _hurt == false){
			_attacking = true;
			state("an"+swingL);
		}else if (FlxG.keys.anyJustPressed(AOTD.keysets[player-1].FORCE) && _canMove&& !_carrying && !_attacking && mp >= 100){
			_attacking = true;
			state("force");
		}
			
		
		}
		didAThingOnce = false;
		if (FlxG.keys.anyJustPressed(AOTD.keysets[player-1].PUNCH) ||FlxG.keys.anyJustPressed(AOTD.keysets[player-1].KICK)){
			didAThingOnce = true;
		}
		
		
		
		//if()FlxG.watch.addQuick("holding: ", _carryObject);
		
		switch(STATE){
			case "idle":
				resetHitbox();
				vx = _velx;
				vy = _vely;
				playAnim("idle" + _objweight);
				
				FlxG.watch.addQuick("carry object: ",_carryObject);
				
			case "throw":
				vx = _velx;
				vy = _vely;
				if (sprite.animation.curAnim.curFrame == 2){
					_carryObject._velx = (5+(mp/10)) * dir;
					_carryOffset.set(32, 1, 32);
					_objweight = "";
					
				}
				if (sprite.animation.curAnim.curFrame == 3){
					_carryObject._beingCarried = false;
					_carrying = false;
					_carryObject._showshadow = true;
				}
				if (animFinished()){
					_carryObject = null;
					_canMove = true;
					justHit =  false;
					state("idle");
				}
				
				if (animFinished()){
					endAttack();
				}
				
			case "hurt":
				_hurt = true;
				_attacking = false;
				resetHitbox();
				_stickmargin = 2;
				_canMove = false;
				justHit =  false;
				playAnim("hurt");
				if(sprite.animation.curAnim.curFrame == sprite.animation.curAnim.numFrames-1){
					_hurt = false;
					_canMove = true;
					state("idle");
				}
				
				
			case "hurt_stun":
				_attacking = false;
				justHit =  false;
				_hurt = true;
				resetHitbox();
				_stickmargin = 2;
				_canMove = false;
				playAnim("hurt");
					stuntime = 60;
					if (waittofall){
						if (_onfloor){
							waittofall = false;
							playSound("land" + FlxG.random.int(1, 2));
							AOTD.freezeFrame(this, this, 5);
							playAnim("fall");
							STATE = "hurt_fall";
						}
					}
					waittofall = true;
			case "hurt_fall":
				_attacking = false;
				resetHitbox();
				_stickmargin = 2;
				_canMove = false;
				if(!_beingCarried)stuntime--;
				
				for (pl in LevelState.players){
					if(pl != this){
						if (pl._x > _x - 16 && pl._x < _x + 16 && pl._y > _y - 8 && pl._y < _y + 8){
							if (FlxG.keys.anyJustPressed(AOTD.keysets[pl.player - 1].INTERACT) && !_beingCarried && pl._canMove ){
								defaultDamageData.enabled = true;
								pl._objweight = _carryweight;
								pl._carrying = true;
								_target = pl;
								pl._carryObject = this;
								_beingCarried = true;
							}
						}
					}
				}
				
				if (stuntime == 0){
					//trace("on da ground ouch");
					stuntime = 60;
					
					if (_hp <= 0){
					STATE = "hurt_death";
						_attacking = false;
						trace("player died : (");
						FlxFlicker.flicker(sprite, 1, FlxG.elapsed, true, false, function(e:FlxFlicker){
							playerhud.bg.color.brightness = 0.5;
							playerhud.y += 4;
							removeSelf();
						});
						AOTD.playerData[player - 1].dead = true;
						_dead = true;
						LevelState.numPlayers--;
						LevelState.players.remove(this);
						AOTD.camFollow.remove(this);
						if (LevelState.players.length == 0) FlxG.switchState(new DeathScreen());
						
					}else{
					_hurt = false;
					STATE = "idle";
					_canMove = true;
					justHit =  false;
					}
					
				}
			case "land":
				timebeenlanded++;
				resetHitbox();
				if (_landlagtime == _landlag){
					FlxG.camera.shake(_grav*0.01, 0.066);
				}
				_landlagtime -= 1;
				_jumping = false;
				_canMove = false;
				playAnim("land");
				_velx = 0;
				_vely = 0;
				if (_landlagtime == 0 || animFinished() || timebeenlanded > 12-(6*mp/100)){
					_canMove = true;
					state("idle");
				}
				
				
				
				
			case "walk_left":
				vx = _velx;
				vy = _vely;
				_slip = false;
				_vely = 0;
				dir = -1;
				playAnim("walk"+_objweight);
				moveH( -_walkspeed-(_walkspeed*mp/250));
				
				
			case "walk_right":
				vx = _velx;
				vy = _vely;
				_slip = false;
				_vely = 0;
				dir = 1;
				playAnim("walk"+_objweight);
				moveH(_walkspeed+(_walkspeed*mp/250));
			case "walk_up":
				vx = _velx;
				vy = _vely;
				_slip = false;
				_velx = 0;
				playAnim("walk"+_objweight);
				moveV( -_walkspeed);
			case "walk_down":
				vx = _velx;
				vy = _vely;
				_slip = false;
				_velx = 0;
				playAnim("walk"+_objweight);
				moveV(_walkspeed);
				
				
			case "walk_downleft":
				_slip = false;
				vx = _velx;
				vy = _vely;
				_vely = 0;
				_velx = 0;
				dir = -1;
				playAnim("walk"+_objweight);
				moveH(-_walkspeed-(_walkspeed*mp/250));
				moveV(_walkspeed);
			case "walk_downright":
				_slip = false;
				vx = _velx;
				vy = _vely;
				_vely = 0;
				_velx = 0;
				dir = 1;
				playAnim("walk"+_objweight);
				moveH(_walkspeed+(_walkspeed*mp/250));
				moveV(_walkspeed);
			case "walk_upleft":
				_slip = false;
				vx = _velx;
				vy = _vely;
				_vely = 0;
				_velx = 0;
				playAnim("walk"+_objweight);
				moveH(-_walkspeed-(_walkspeed*mp/250));
				moveV(-_walkspeed);
			case "walk_upright":
				_slip = false;
				vx = _velx;
				vy = _vely;
				_vely = 0;
				_velx = 0;
				playAnim("walk"+_objweight);
				moveH(_walkspeed+(_walkspeed*mp/250));
				moveV(-_walkspeed);
				
				
				//RUN 
				
				
			case "run_left":
				_slip = true;
				vx = _velx;
				vy = _vely;
				_vely = 0;
				dir = -1;
				playAnim("run"+_objweight);
				moveH(-_runspeed-(_runspeed*mp/250));
			case "run_right":
				_slip = true;
				vx = _velx;
				vy = _vely;
				_vely = 0;
				dir = 1;
				playAnim("run"+_objweight);
				moveH(_runspeed+(_runspeed*mp/250));
				
			case "run_downleft":
				_slip = true;
				vx = _velx;
				vy = _vely;
				_vely = 0;
				_velx = 0;
				dir = -1;
				playAnim("run"+_objweight);
				moveH(-_runspeed-(_runspeed*mp/250));
				moveV(1);
			case "run_downright":
				_slip = true;
				vx = _velx;
				vy = _vely;
				_vely = 0;
				_velx = 0;
				dir = 1;
				playAnim("run"+_objweight);
				moveH(_runspeed+(_runspeed*mp/250));
				moveV(1);
			case "run_upleft":
				_slip = true;
				vx = _velx;
				vy = _vely;
				_vely = 0;
				_velx = 0;
				playAnim("run"+_objweight);
				moveH(-_runspeed-(_runspeed*mp/250));
				moveV(-1);
			case "run_upright":
				_slip = true;
				vx = _velx;
				vy = _vely;
				_vely = 0;
				_velx = 0;
				playAnim("run"+_objweight);
				moveH(_runspeed+(_runspeed*mp/250));
				moveV(-1);
				
				
				
				
				//JUMP
				
				
				
			case "jump":
				inAir = true;
				_jumplagtime --;
				_slip = true;
				playAnim("jump");
				if (_jumplagtime == 0){
					//trace("before velocity", _velx, _vely);
				_jumping = true;
				moveH(vx);
				moveV(vy);
					//trace("stored velocity", vx, vy);
					//trace("velocity", _velx, _vely);
				_grav = -_jumpforce*0.75;//SHORT HOP
				_z += _jumpforce;
					playSound("sfx_jump");
				if(FlxG.keys.anyPressed(AOTD.keysets[player-1].JUMP))_grav = -_jumpforce;//FOR HIGH JUMP
				}
				pauseAnimAtEnd();
			case "fall":
				inAir = true;
				_jumping = true;
				_slip = true;
				playAnim("jump");
				sprite.animation.curAnim.curFrame = 2;
				if (animFinished()) sprite.animation.curAnim.curFrame = sprite.animation.curAnim.numFrames;
				
			case "an_heavy":
						hitbox.setSize(32, 64);
						hitboxOffset.set(32, -64);
				
				initAttack("an_heavy", true);
				switch(character){
					case "jeremy":
						switch(sprite.animation.curAnim.curFrame){
							case 0:
							_carryOffset.set(-10, 1, 64);
								
							case 1:
							_carryOffset.set(-8, 1, 63);
							case 2:
							_carryOffset.set(32, 1, -2);
							case 3:
							_carryOffset.set(32, 1, 0);
							case 4:
							_carryOffset.set(32, 1, 1);
								
						}
						
					case "christine":
						switch(sprite.animation.curAnim.curFrame){
							case 0:
							_carryOffset.set(-10, 1, 64);
								
							case 1:
							_carryOffset.set(-8, 1, 63);
							case 2:
							_carryOffset.set(32, 1, 32);
							case 3:
							_carryOffset.set(32, 1, 2);
							case 4:
							_carryOffset.set(32, 1, 0);
								
						}
						
				}
			case "an1":
				swingL = 2;//set attack variation to 2
				if (combo == 2) swingL = 3;//if on 3rd hit set attack variation to 3
				initAttack("an1", true);
				
			case "force":
				
				swingL = 2;//set attack variation to 2
				if (combo == 2) swingL = 3;//if on 3rd hit set attack variation to 3
				initAttack("an1", true);
				
			case "an2":
				swingL = 1;//set attack variation to 1
				if (combo == 2) swingL = 3;//if on 3rd hit set attack variation to 3
				initAttack("an2",true);
			case "an3":
				swingL = 1;
				initAttack("an3", true);
				
				switch(character){
					case "michael":
						if (sprite.animation.curAnim.curFrame == 2){
							_grav = -3;
						}
					
					
				}
				
			case "bn":
				initAttack("bn",true);
			case "dn":
				hitbox.setSize(32, 32);
				hitboxOffset.set(16, -16);
				initAttack("dn",true);
			case "aa":
				initAttack("aa", false, false);
				if (animFinished()) sprite.animation.curAnim.curFrame = sprite.animation.curAnim.numFrames - 2 ;
				if (_onfloor) state("idle");
				
			case "ba":
				initAttack("ba", false, false);
				if (animFinished()) sprite.animation.curAnim.curFrame = sprite.animation.curAnim.numFrames - 2 ;
				if (_onfloor) state("idle");
				
			case "aad":
				initAttack("aad", false, false);
				
				
				/*
				switch(character){
					case "jeremy":
						if (sprite.animation.curAnim.curFrame == 1)_grav = 6;
						hitbox.setSize(32, 32);
						hitboxOffset.set(0, -16);
					case "christine":
						hitbox.setSize(48, 32);
						hitboxOffset.set(0, -16);
						if (sprite.animation.curAnim.curFrame == 1){
							justHit = false;
							defaultDamageData.enabled = true;
							_grav = 4;
						}
					
					
					case "michael":
						if (sprite.animation.curAnim.curFrame == 1){
							_forcex = 8 * dir;
							_grav = 8;
						}
					
					
				}*/
				if (_onfloor) state("idle");
				pauseAnimAtEnd();
				
		}
				var atd = Reflect.getProperty(Reflect.getProperty(Reflect.getProperty(_anim, character), sprite.animation.curAnim.name), "attack");
				
					defaultDamageData.hitlag = Reflect.getProperty(atd, "hitlag");
					defaultDamageData.hitstun = Reflect.getProperty(atd, "hitstun");
					defaultDamageData.kbx = Reflect.getProperty(atd, "kbx");
					defaultDamageData.kby = Reflect.getProperty(atd, "kby");
					defaultDamageData.dmg = Reflect.getProperty(atd, "dmg");
				
		// FOR EACH FOOTSTEP //
		
		if (sprite.animation.name == rs){//IF IT'S WALKING OR RUNNNIG
			var i = FlxG.random.int(1, 4);//GET RANDOM NUMBER
			if ((sprite.animation.curAnim.curFrame == 2 || sprite.animation.curAnim.curFrame == 6)){//IF IT'S A STEP sprite.animation
				if(!_stepped){//AND IT HASN'T TOOKEN A STEP
					_stepped = true;//THEN IT HAS
					//Reflect.getProperty(soundList,"step"+FlxG.random.int(1,4)).play();
					FlxG.sound.play("assets/sfx/step"+FlxG.random.int(1,4)+".ogg").proximity(soundPro_x,soundPro_y,LevelState.camfollow,soundPro_rad);//PLAY STEP SOUND
				} ///COMPILE THE GAME RIGHT NOW
			}
			if ((sprite.animation.curAnim.curFrame == 3 || sprite.animation.curAnim.curFrame == 7))_stepped = false;//IF NOT STEP FRAME, THEN IT'S NOT STEPPING
		}
		scale.x = dir;
		sprite.x = -Reflect.getProperty(Reflect.getProperty(_anim, character), "offsetright") + _x;//SET RIGHT FACING OFFSET
		if(dir == -1)sprite.x = -Reflect.getProperty(Reflect.getProperty(_anim, character), "offsetleft") + _x;//SET LEFT FACING OFFSET
		
		
		
		
		
		
					if(!STATE.startsWith("hurt"))onAttackFrame = false;//NOT ATTACK FRAME unless if hurt and thrown
		if (Reflect.getProperty(Reflect.getProperty(Reflect.getProperty(_anim, character), sprite.animation.curAnim.name), "attack") != null){//CHECK IF IT'S sprite.animation DATA HAS AN ATTACK PROPERTY
			var data = Reflect.getProperty(Reflect.getProperty(Reflect.getProperty(_anim, character), sprite.animation.curAnim.name), "attack");//DATA IS sprite.animation DATA ATTACK PROPERTY
			var f = (Reflect.getProperty(data, "frame"));//F IS FRAME ARRAY
			var fr = (Reflect.getProperty(f, "length"));//FR IS HOW LONG THE FRAME ARRAY IS
			
				if (sprite.animation.curAnim.curFrame == f[0] && !justHit){//IF CUR FRAME IS THE FIRST FRAME IN THE FRAME ARRAY
					onAttackFrame = true;
				}
			for (r in 0...fr-1){//CHECK FOR ALL FRAMES IN THE FRAME ARRAY
				if (sprite.animation.curAnim.curFrame == f[r] && !justHit){//IF sprite.animation CURRENT FRAME IS THE CURRENT FRAME ARRAY INDEX
					onAttackFrame = true;
				}
				
			}
		}
		curAnim = sprite.animation.curAnim.name;//FOR SWAG SHIT
			if (mp > 100)mp = 100;
			if (mp <0)mp = 0;
		//Main.debugtext.text = "jumping = "+_jumping;
		}
		
		interp.variables.set("state", STATE);
		
		
		
		//FlxG.log.add(
	}
	
	
	public function setChar(char:String){
		/*
		 * Makes character and 
		 * sets up their sprite.animations.
		*/
		
		/*
		
		trace("loaded " + char);
		var json:String = Utf8.encode(sys.io.File.getContent("assets/characters/chr_" + char + ".json"));
		trace("loaded char json");
		
		while (!json.endsWith("}"))
		{
			json = json.substr(0, json.length - 1);
			// LOL GOING THROUGH THE BULLSHIT TO CLEAN IDK WHATS STRANGE
		}
		
		
		var data:Dynamic = Json.parse(json);
		trace("parsed char json");
		_weight = data.weight;
		_walkspeed = data.walkspeed;
		*/
		
		character = char;
		_forcex = 0;
		_forcey = 0;
		_velx = 0;
		_vely = 0;
		_walkspeed = Reflect.getProperty(Reflect.getProperty(_anim, character), "walkspeed");
		_runspeed = Reflect.getProperty(Reflect.getProperty(_anim, character), "runspeed");
		_weight = Reflect.getProperty(Reflect.getProperty(_anim, character), "weight");
		_jumpforce = Reflect.getProperty(Reflect.getProperty(_anim, character), "jumpforce");
		sprite.loadGraphic(AOTD.getBitmapFile("assets/sprites/players/spr_" + character + ".png"), true, 64, 72);
		addAnimByData("idle");
		addAnimByData("idle_heavy");
		addAnimByData("walk");
		//addAnimByData("walk_light");
		addAnimByData("walk_heavy");
		addAnimByData("run");
		//addAnimByData("run_light");
		addAnimByData("run_heavy");
		addAnimByData("throw_heavy");
		addAnimByData("an_heavy");
		addAnimByData("jump");
		addAnimByData("an1");
		addAnimByData("an2");
		addAnimByData("an3");
		addAnimByData("bn");
		addAnimByData("aa");
		addAnimByData("ba");
		addAnimByData("dn");
		addAnimByData("aad");
		addAnimByData("land");
		addAnimByData("hurt");
		addAnimByData("stun");
		addAnimByData("fall");
		playAnim("idle");
		sprite.animation.callback = onAnimFrame;
	}
	public function endAttack(toIdle:Bool = true){
		_canMove = false;
		_hitlag = Reflect.getProperty(Reflect.getProperty(Reflect.getProperty(_anim, character), sprite.animation.curAnim.name),"attack").hitlag;
		new FlxTimer().start(_hitlag/FlxG.updateFramerate,function(e:FlxTimer){
		_canMove = true;
				});
		_attacking = false;
		if(toIdle)state("idle");
	}
	public function moveH(sp:Float){
		this._velx = sp;// / 4;
	}
	public function moveV(sp:Float){
		this._vely = sp; /// 4;
		
	}
	public function state(name:String,force:Bool=false){
		STATE = name;
	}
	public function animFinished():Bool{
		var fin = sprite.animation.curAnim.curFrame == sprite.animation.curAnim.numFrames-2;//because numFrames is a 1 based number and end of frame is too late
		return fin;
	}
	public function playAnim(name:String, force:Bool = false, reverse:Bool = false, frame:UInt = 1){
		if (curAnim != name) justHit = false;//only executes when sprite.animation changes
		sprite.animation.play(name, force, reverse, frame);
		
	}
	public function addAnimByData(_name:String){
		var b = Reflect.getProperty(Reflect.getProperty(_anim, character), _name);
		if(b != null)addAnim(_name, b.sf, b.ef, b.fps, b.loop,false,false);
	}
	public function addAnim(name:String, startframe:UInt, endframe:UInt, fps:Float, loop:Bool, flipx:Bool, flipy:Bool){
		var _frames:Array<Int> = new Array<Int>();
		var fm = (endframe-startframe+1);
		for (i in 0...fm){
			_frames[i] = i + startframe;
		}
		if (!loop)_frames.push(endframe);
		sprite.animation.add(name, _frames, fps, loop, flipx, flipy);
	}
	
	public function initAttack(anim:String, halt:Bool = true, revertToIdle:Bool = true){
		defaultDamageData.enabled = true;
		playAnim(anim);
		
		
		if (didAThingOnce){//do the attack script
				var Iscript = Reflect.getProperty(Reflect.getProperty(Reflect.getProperty(Reflect.getProperty(_anim, character), anim), "attack"), "iscript");
				if (Iscript != null){
					
					var Iprogram = parser.parseString(Iscript);
					interp.execute(Iprogram);
				}
		}
		
				
		if(halt){
		_velx = 0;
		_vely = 0;
		}
		//trace(animFinished());
		if (animFinished()){
			if (revertToIdle){
				endAttack();
			}else{
				pauseAnimAtEnd();
			}
		}
	}
	public function onAnimFrame(name = null, fn = null, fi = null){
		var Fscripts:Array<String> = Reflect.getProperty(Reflect.getProperty(Reflect.getProperty(Reflect.getProperty(_anim, character), curAnim), "attack"),"fscript");
				
				if (Fscripts != null){
					if(fn < Fscripts.length+1 ){
						var Fprogram = parser.parseString(Fscripts[fn-1]);
						interp.execute(Fprogram);
					}
				}
	}
	public function pauseAnimAtEnd(){
		if (animFinished()) sprite.animation.pause(); //sprite.animation.curAnim.curFrame = sprite.animation.curAnim.numFrames - 2;
		
	}
	
	public function updateHurtbox(){
		
	}
	override public function reactToDeath() 
	{
		LevelState.instance.addToWorld(new Coin("ruby", _x, _y, _z));
	}
	override public function reactToHit(ent:Entity) 
	{
		super.reactToHit(ent);
		stuntime += 6;
		_attacking = false;
		_slip = true;
		waittofall = false;
		if(STATE != "hurt_fall"){
		
			if(Math.abs(_velx) > 4 ||Math.abs(_grav) > 4){
			state("hurt_stun");
			trace("OUCH DAMNNN");
			}else{
			state("hurt");
				
			}
		}else{
			playAnim("fall", true);
		}
	}
	
	public function initForce(){
	}
	
	
	override public function reactwhenHit(ent:Entity) 
	{
		super.reactwhenHit(ent);
		
		/*
		switch(curAnim){
			
			case "aa":
				switch(character){
					case "christine":
						_grav = -4;
				}
		
		}*/
		
		
		
				var Hscript = Reflect.getProperty(Reflect.getProperty(Reflect.getProperty(Reflect.getProperty(_anim, character), curAnim), "attack"), "hscript");
				
				if (Hscript != null){
					
					var Hprogram = parser.parseString(Hscript);
					interp.execute(Hprogram);
				}
				
		
		var co:FlxColor;
		co = FlxColor.fromRGB(255, 255-Std.int((combo/12)*255), 255-Std.int((combo/12)*255), 255);
		if (_lasthitted == ent){
			
		
		combo += 1;
		combodecaytime = combodecay;
		//trace("combo " + combo);
		if (combo >= 3){
			if(ent.isOrganism)mp += defaultDamageData.dmg*3;
			playerhud.add(new StatNumber(0, 48, "combo " + combo, co));
		}
		
		}
		_x -= scale.x*2;
			_lasthitted = ent;
			
			
		if (STATE == "force" && ent.isEnemy){
			//mp = 0;
			//AOTD.parseCommand("/anim force_christine");
		}
	}
	
}