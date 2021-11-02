package;
import flixel.*;
import animateatlas.AtlasFrameMaker;
import enemy.Boss_Zombie;
import enemy.Demon;
import enemy.TinyDemon;
import enemy.Zombie;
import flixel.math.*;
import flixel.graphics.*;
import flixel.graphics.frames.FlxBitmapFont;
import flixel.graphics.frames.FlxFramesCollection;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.system.FlxSound;
import flixel.text.FlxBitmapText;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import gameobjects.Door;
import haxe.Json;
import haxe.io.Error;
import states.*;
import hud.PlayerHud;
import level.StoryData;
import openfl.display.BitmapData;
import openfl.media.Sound;
import openfl.system.System;
import openfl.utils.Assets;
import shaders.*;
#if desktop
import sys.FileSystem;
import sys.io.File;
#end
using StringTools;
/**
 * ...
 * @author ...
 */
class  AOTD 
{
	/*
	public static var KEY_LEFT_HOLD:Bool
	public static var KEY_RIGHT_HOLD:Bool
	public static var KEY_UP_HOLD:Bool
	public static var KEY_DOWN_HOLD:Bool
	
	public static var KEY_LEFT_PRESS:Bool
	public static var KEY_RIGHT_PRESS:Bool
	public static var KEY_UP_PRESS:Bool
	public static var KEY_DOWN_PRESS:Bool
	
	public static var KEY_LEFT_RELEASE:Bool
	public static var KEY_RIGHT_RELEASE:Bool
	public static var KEY_UP_RELEASE:Bool
	public static var KEY_DOWN_RELEASE:Bool
	
	public static var KEY_A_HOLD:Bool
	public static var KEY_B_HOLD:Bool
	public static var KEY_X_HOLD:Bool
	public static var KEY_Y_HOLD:Bool
	
	public static var KEY_A_PRESS:Bool
	public static var KEY_B_PRESS:Bool
	public static var KEY_X_PRESS:Bool
	public static var KEY_Y_PRESS:Bool
	
	public static var KEY_A_RELEASE:Bool
	public static var KEY_B_RELEASE:Bool
	public static var KEY_X_RELEASE:Bool
	public static var KEY_Y_RELEASE:Bool*/
	public static var keyset:KeySet = new KeySet();
	public static var keysets:Array<KeySet> = [new KeySet(),new KeySet(),new KeySet()];
	public static var camshake:Float = 0;
	public static var playerData:Array<PlayerData> = [new PlayerData()];
	public static var sprite_duststep:FlxSprite;
	public static var camFollowType:Int = 0;
	public static var camFollowLerp:UInt = 8;
	public static var gameMode:UInt = 0;
	
	/*
	
	0 = storymode
	1 = arcade mode
	2 = training mode
	*/
	public static var inShopRN:Bool = false;
	public static var characterList:Array<String> = [];
	
	public static var CAM_Y_THRESHOLD:Int = 128;
	#if desktop
	public static var soundext:String = ".ogg";
	#else
	public static var soundext:String = ".mp3";
	#end
	#if desktop
	public static var vidext:String = ".webm";
	#else
	public static var vidext:String = ".mp4";
	#end
	
	public static var friendlyfire:Bool = true;
	
	public static var crtFilter:Bool = false;
	
	public static var storyLevels:Array<StoryData> = [
	new StoryData("jeremy", true, "Jeremy's street",-1,"basement",260,180),
	new StoryData("michael", false, "Hansenville Subdivision",-1,"lvl2",60,440),
	new StoryData("christine", false, "Middleborough City",-1,"lvl3"),
	new StoryData("rich", false, "Underground Sewers",-1,"lvl4"),
	new StoryData("chloe", false, "Halloween House Party",-1,"lvl5"),
	new StoryData("brooke", false, "Menlo Mall",-1,"lvl6"),
	new StoryData("michael", false, "The Mythical Forest",-1,"lvl7"),
	new StoryData("jeremy", false, "Middleborough Highschool",-1,"lvl8"),
	new StoryData("jeremy", false, "The Cafetorium",-1,"lvl9")
	];
	
	public static var currentLevelInt = 0;
	public static var midGame = false;
	
	public static var camFollow:Array<Entity> = [];
	public static var cachedAnims:Map<String,FlxGraphic> = new  Map<String,FlxGraphic>();
	public function new() 
	{
		
	}
	public static function resetGame(){
		
		AOTD.midGame = false;
		AOTD.currentLevelInt = 0;
		LevelState.instance = null;
		LevelState.music = "";
		LevelState.players = [];
	}
	
	public static function initGame(){
		Font.THICK = FlxBitmapFont.fromMonospace("assets/fonts/thickfont.png", "abcdefghijklmnopqrstuvwxyz0123456789$%.><-_*()[]@#ñ^ABCDEFGHIJKLMNOPQRSTUVWXYZ !?\n\t`Ñá▼É♥íœó²ú", new FlxPoint(8, 16));
		Font.SMALL = FlxBitmapFont.fromMonospace("assets/fonts/smallfont.png", "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_~ .,!?'[](){} /-=+*@#$%^&\n<", new FlxPoint(7, 9));
		
		LevelState.players = [];
		refreshCharacters();
		FlxG.debugger.toggleKeys = [F6];
		FlxG.save.bind("aotd");
		
		trace(FlxG.save.data.storyLevels);
		if (FlxG.save.data.storyLevels != null){
			AOTD.storyLevels = FlxG.save.data.storyLevels;
		}
		
		
		//cache animations
		#if desktop
		for (i in FileSystem.readDirectory(FileSystem.absolutePath('assets/animations')))//load anim
        {
			var sp:FlxSprite = new FlxSprite();
			sp.frames = AtlasFrameMaker.construct("assets/animations/" +i);
			//add(sp);
			var bmp:FlxGraphic = FlxGraphic.fromGraphic(sp.graphic);
			bmp.persist = true;
			AOTD.cachedAnims.set(i, bmp);
			trace("cached: " + i);
			trace(AOTD.cachedAnims.get(i));
        }
		#end
		AudioStore.step = [
			new FlxSound().loadEmbedded("assets/sfx/step1"+AOTD.soundext),
			new FlxSound().loadEmbedded("assets/sfx/step2"+AOTD.soundext),
			new FlxSound().loadEmbedded("assets/sfx/step3"+AOTD.soundext),
			new FlxSound().loadEmbedded("assets/sfx/step4"+AOTD.soundext)
		];
		AudioStore.land = [
			new FlxSound().loadEmbedded("assets/sfx/land1"+AOTD.soundext),
			new FlxSound().loadEmbedded("assets/sfx/land2"+AOTD.soundext)
		];
		AudioStore.enemy_hit = [
			new FlxSound().loadEmbedded("assets/sfx/sfx_hit_enemy_1"+AOTD.soundext),
			new FlxSound().loadEmbedded("assets/sfx/sfx_hit_enemy_2"+AOTD.soundext),
			new FlxSound().loadEmbedded("assets/sfx/sfx_hit_enemy_3"+AOTD.soundext)
		];
		AudioStore.woosh = [
			new FlxSound().loadEmbedded("assets/sfx/sfx_woosh1"+AOTD.soundext),
			new FlxSound().loadEmbedded("assets/sfx/sfx_woosh2"+AOTD.soundext),
			new FlxSound().loadEmbedded("assets/sfx/sfx_woosh3"+AOTD.soundext)
		];
		
		FlxG.sound.muteKeys = null;
		
		AOTD.playerData[0].character = "jeremy";
		//AOTD.playerData[2].character = "christine";
		
		AOTD.keysets[0].UP = [FlxKey.W];
		AOTD.keysets[0].LEFT = [FlxKey.A];
		AOTD.keysets[0].DOWN = [FlxKey.S];
		AOTD.keysets[0].RIGHT = [FlxKey.D];
		AOTD.keysets[0].PUNCH = [FlxKey.P];
		AOTD.keysets[0].KICK = [FlxKey.O];
		AOTD.keysets[0].JUMP = [FlxKey.SPACE];
		AOTD.keysets[0].INTERACT = [FlxKey.I];
		AOTD.keysets[0].FORCE = [FlxKey.U];
		
		AOTD.keysets[1].LEFT = [FlxKey.LEFT];
		AOTD.keysets[1].RIGHT = [FlxKey.RIGHT];
		AOTD.keysets[1].UP = [FlxKey.UP];
		AOTD.keysets[1].DOWN = [FlxKey.DOWN];
		AOTD.keysets[1].PUNCH = [FlxKey.NUMPADONE];
		AOTD.keysets[1].KICK = [FlxKey.NUMPADTWO];
		AOTD.keysets[1].JUMP = [FlxKey.NUMPADZERO];
		AOTD.keysets[1].RUN = [FlxKey.CONTROL];
		AOTD.keysets[1].INTERACT = [FlxKey.NUMPADTHREE];
		
		AOTD.keysets[2].LEFT = [FlxKey.F];
		AOTD.keysets[2].RIGHT = [FlxKey.H];
		AOTD.keysets[2].UP = [FlxKey.T];
		AOTD.keysets[2].DOWN = [FlxKey.G];
		AOTD.keysets[2].PUNCH = [FlxKey.J];
		AOTD.keysets[2].KICK = [FlxKey.K];
		AOTD.keysets[2].INTERACT = [FlxKey.C];
		AOTD.keysets[2].FORCE = [FlxKey.V];
		AOTD.keysets[2].JUMP = [FlxKey.B];
		AOTD.keysets[2].RUN = [FlxKey.N];
		
		
		
	}
	
	static public function refreshCharacters() 
	{
		AOTD.characterList = [];
		
		var list = ["jeremy.json", "michael.json"];
		#if desktop
		list = FileSystem.readDirectory(FileSystem.absolutePath('assets/characters'));
		#end
		for (i in list)//load characters
        {
			var ch = StringTools.replace(i, ".json", "");
			trace(ch);
			AOTD.characterList.push(ch);
		var s = (getTextFile("assets/characters/" + i));
		var raw = Json.parse(s);
        Reflect.setProperty(Player._anim, ch, raw);//create character slot
        }
	}
	
	
	
	public static function getSound(id:Array<FlxSound>):FlxSound{
		var sound:FlxSound = id[FlxG.random.int(0, id.length-1)];
		
		//var i = FlxG.random.int(0, AudioStore.land.length - 1);
				
			//	AudioStore.land[i].play();
		trace(id, sound);
		return sound;
	}
	public static function freezeFrame(obj1:Entity, obj2:Entity, time:Float){
		obj1.active = false;
		obj2.active = false;
		new FlxTimer().start(time/FlxG.updateFramerate,function(e:FlxTimer){
		obj1.active = true;
		obj2.active = true;
		});
	}
	public static function freezeFrameSeperate(obj1:Entity, obj2:Entity, time1:Float,time2:Float){
		obj1.active = false;
		obj2.active = false;
		new FlxTimer().start(time1/60,function(e:FlxTimer){
		obj1.active = true;
		});
		new FlxTimer().start(time2/60,function(e:FlxTimer){
		obj2.active = true;
		});
	}
	public static function shakeCamera(intentsity:Int){
		camshake = intentsity;
	}
	public static function getHeightFromCoord(X:Float=0,Y:Float=0){
		return LevelState.getValue(LevelState.heightmap.getPixel(Math.round(X), Math.round(Y)), "value");
	}
	public static function getHeightFromPoint(point:FlxPoint){
		return LevelState.getValue(LevelState.heightmap.getPixel(Math.round(point.x), Math.round(point.y)), "value");
	}
	
	public static function getFloorZ(_x,_y):Float{
		return LevelState.getValue(LevelState.heightmap.getPixel(Math.round(_x), Math.round(_y)), "value");
	}
	public static function onWall(_x:Float, _y:Float):Bool{
		var on = false;
		
		if(_x < 0 || _x >= LevelState.heightmap.width ||_y < 0 || _y >= LevelState.heightmap.height-1){
				on = true;
		}
		if(_x < 0 || _x >= LevelState.heightmap.width ||_y < 0 || _y >= LevelState.heightmap.height-1){
				on = true;
		}
		if (LevelState.getValue(LevelState.heightmap.getPixel(Math.round(_x), Math.round(_y)), "blue") > 254 - LevelState.th && 
			LevelState.getValue(LevelState.heightmap.getPixel(Math.round(_x), Math.round(_y)), "red") ==-LevelState.th && 
			LevelState.getValue(LevelState.heightmap.getPixel(Math.round(_x), Math.round(_y)), "green") == -LevelState.th){
				on = true;
			}
		
		if (LevelState.getValue(LevelState.heightmap.getPixel(Math.round(_x), Math.round(_y)), "red") > 254 - LevelState.th && 
			LevelState.getValue(LevelState.heightmap.getPixel(Math.round(_x), Math.round(_y)), "blue") ==-LevelState.th && 
			LevelState.getValue(LevelState.heightmap.getPixel(Math.round(_x), Math.round(_y)), "green") == -LevelState.th){
				on = true;
			}
		
		
		
		
		return on;
	}
	
	
	public static function parseCommand(command:String){
		var cmd:Array<String> = StringTools.replace(command,"\n","").replace("|"," ").split(" ");
		
		switch(cmd[0].toLowerCase()){
			case "/camera" | "/cam" | "/c"://setCamMode
				
				
				switch(cmd[1]){
					case "position" | "pos"://camera pos 14 800
						LevelState.camfollow.setPosition(Std.parseInt(cmd[2]), Std.parseInt(cmd[3]));
					
					case "type" | "t"://camera type 1
						AOTD.camFollowType = Std.parseInt(cmd[2]);
						
					case "lerp" | "l"://camera lerp 8
						AOTD.camFollowLerp = Std.parseInt(cmd[2]);
					case "shake" | "sh"://camera lerp 8
						AOTD.shakeCamera(Std.parseInt(cmd[2]));
					case "flash" | "f"://camera flash 0xFFFF0000 8
						FlxG.camera.flash(Std.parseInt(cmd[3]),Std.parseFloat(cmd[2]));
					case "ythreshold" | "th"://camera lerp 8
						AOTD.CAM_Y_THRESHOLD = (Std.parseInt(cmd[2]));
				}
				
				
				
				
				
			case "/player": 
				
				if(cmd[1] == "all"){
					switch(cmd[2]){
						case "tospawn":// /player all tospawn
							for (pl in LevelState.players){
								pl.setPos(LevelState.spawnPoint._x, LevelState.spawnPoint._y, LevelState.spawnPoint._z);
							}
						case "position" | "pos":
							for (pl in LevelState.players){
								pl.setPos(Std.parseInt(cmd[3]), Std.parseInt(cmd[4]), Std.parseInt(cmd[5]));
							}
						case "dead" | "d":
							for (pl in LevelState.players){
								pl._dead = cmd[3] == "true";
							}
							
						case "enabled" | "e":
							for (pl in LevelState.players){
								pl._enabled = cmd[3] == "true";
							}
						case "state" | "s":
							for (pl in LevelState.players){
								pl.state(cmd[3]);
							}
						case "refresh" | "r":
							AOTD.refreshCharacters();
							
					}
				}else{
					switch(cmd[2]){
						case "tospawn":// /player all tospawn
								LevelState.players[Std.parseInt(cmd[1])].setPos(LevelState.spawnPoint._x, LevelState.spawnPoint._y, LevelState.spawnPoint._z);
						case "position" | "pos"://player 0 position 13 15 16
							LevelState.players[Std.parseInt(cmd[1])].setPos(Std.parseInt(cmd[3]), Std.parseInt(cmd[4]), Std.parseInt(cmd[5]));
						
						case "hp":
							LevelState.players[Std.parseInt(cmd[1])]._hp = Std.parseInt(cmd[3]);
						case "mp":
							LevelState.players[Std.parseInt(cmd[1])].mp = Std.parseInt(cmd[3]);
						case "getpos" | "getposition":
							var p:Point3D = LevelState.players[Std.parseInt(cmd[1])].getPos();
							var pp = (p._x + ", " + p._y + ", " + p._z );
							System.setClipboard(pp);
							trace(pp);
						case "getfloorz":
							var pp = (LevelState.players[Std.parseInt(cmd[1])]._floorz);
							
							System.setClipboard(Std.string(pp));
							trace(pp);
						case "setChar" | "char"| "character":
							
							LevelState.players[Std.parseInt(cmd[1])].setChar(cmd[3]);
							trace("Player "+(Std.parseInt(cmd[1])+1) + " is now " + LevelState.players[Std.parseInt(cmd[1])].character);
						case "givemoney" | "money" |"coins":
							LevelState.players[Std.parseInt(cmd[1])].coins += Std.parseFloat(cmd[3]);
							trace(LevelState.players[Std.parseInt(cmd[1])].coins);
						
						case "dead" | "d":
							LevelState.players[Std.parseInt(cmd[1])]._dead = cmd[3] == "true";
						case "enabled" | "e":
								LevelState.players[Std.parseInt(cmd[1])]._enabled = cmd[3] == "true";
						case "state" | "s":
								LevelState.players[Std.parseInt(cmd[1])].state(cmd[3]);
						case "property" | "p":
							trace(Reflect.getProperty(LevelState.players[Std.parseInt(cmd[1])], cmd[3]));
					}
				}
			case "/toscene" | "/gotoscene" | "/ts":
				LevelState.transScene(cmd[1],new Point3D(Std.parseFloat(cmd[2]),Std.parseFloat(cmd[3]),Std.parseFloat(cmd[4])));
			case "/add" | "/addToWorld":
				
				switch(cmd[1]){
					case "entity":
						var ent:Entity = new Entity(Std.parseInt(cmd[2]), Std.parseInt(cmd[3]), Std.parseInt(cmd[4]));
						var bitmap:BitmapData = getBitmapFile("assets/sprites/"+cmd[5]+".png");
						ent.sprite.loadGraphic(bitmap);
						ent.sprite.offset.set(Std.parseInt(cmd[6]), Std.parseInt(cmd[7]));
						ent._affectByCollision = false;
						ent._showshadow = false;
						ent._shadow.visible = false;
						ent.toFloor(true);
						LevelState.instance.addToWorld(ent);
					case "npc":
						var npc:Npc = new Npc(Std.parseInt(cmd[2]), Std.parseInt(cmd[3]), Std.parseInt(cmd[4]), Std.parseInt(cmd[5]), Std.parseInt(cmd[6]));
						
						LevelState.instance.addToWorld(npc);
					case "prop":// /add prop x y z id
						var ent:Prop = new Prop(Std.parseInt(cmd[2]), Std.parseInt(cmd[3]), Std.parseInt(cmd[4]),cmd[5]);
						
						LevelState.instance.addToWorld(ent);
					case "door":
						
						var door:Door;
						
						switch(cmd[5]){
							case "shop":
								trace("going to make door to shop " + cmd[6]);
								door = new Door(Std.parseInt(cmd[2]), Std.parseInt(cmd[3]), Std.parseInt(cmd[4]), null, function(){
									LevelState.toShop(cmd[6],new Point3D(door._x, door._y+34, door._z));
								}, null);
								trace("made door to shop " + cmd[6]);
						LevelState.instance.add(door);
							
							case "command":
								door = new Door(Std.parseInt(cmd[2]), Std.parseInt(cmd[3]), Std.parseInt(cmd[4]), null, null, cmd[6]);
						
							case "script":
								door = new Door(Std.parseInt(cmd[2]), Std.parseInt(cmd[3]), Std.parseInt(cmd[4]), null, null, "/script "+cmd[6]);
						LevelState.instance.add(door);
							case "pos":
								door = new Door(Std.parseInt(cmd[2]), Std.parseInt(cmd[3]), Std.parseInt(cmd[4]), null, null, cmd[6]);
						LevelState.instance.add(door);
							
							case "level" | "room":
								var s:Array<String> = [];
								s = cmd[7].split(",");
								var point:Point3D = new Point3D(Std.parseFloat(s[0]), Std.parseFloat(s[1]), Std.parseFloat(s[2]));
								door = new Door(Std.parseInt(cmd[2]), Std.parseInt(cmd[3]), Std.parseInt(cmd[4]), null , function(){
									LevelState.transScene(cmd[6], point);
								}, null);
								LevelState.instance.add(door);
						}
					case "player":
						AOTD.playerData.push(new PlayerData());
						var i = AOTD.playerData.length - 1;
						trace(AOTD.playerData.length);
						
						if (AOTD.keysets[i] == null){
							AOTD.keysets.push(new KeySet());
						}
						
						
						var data:PlayerData;
							data = AOTD.playerData[i];
							var name = "jeremy";
							if (cmd[2] != null) name = cmd[2];
							var pl:Player = new Player(Std.int(LevelState.players[0]._x)-(i*4), Std.int(LevelState.players[0]._y)+(i*8), 360,name);
							pl.player = i + 1;
							LevelState.players.push(pl);
							//AOTD.applyPlayerData(i);
							LevelState.world.add(LevelState.players[i]);
							
							var phud = new PlayerHud(pl);
							LevelState.hud.add(phud);
					case "coin":
						var coin:Coin;
						coin = new Coin(cmd[2], Std.parseFloat(cmd[3]), Std.parseFloat(cmd[4]), Std.parseFloat(cmd[5]));
						LevelState.world.add(coin);
					case "zombie":
						var ent:Zombie = new Zombie(Std.parseInt(cmd[2]), Std.parseInt(cmd[3]), Std.parseInt(cmd[4]), Std.parseInt(cmd[5]));
						LevelState.instance.addToWorld(ent);
					case "enemy":
						switch(cmd[2]){
							case "0" | "zombie":
								var ent:Zombie = new Zombie(Std.parseInt(cmd[3]), Std.parseInt(cmd[4]), Std.parseInt(cmd[5]), Std.parseInt(cmd[6]),cmd[7], cmd[8].contains("true"));
								LevelState.instance.addToWorld(ent);
							case "1" | "demon":
								var ent:Demon = new Demon(Std.parseInt(cmd[3]), Std.parseInt(cmd[4]), Std.parseInt(cmd[5]), Std.parseInt(cmd[6]),cmd[7], cmd[8].contains("true"));
								LevelState.instance.addToWorld(ent);
							case "2" | "tinydemon":
								var ent:TinyDemon = new TinyDemon(Std.parseInt(cmd[3]), Std.parseInt(cmd[4]), Std.parseInt(cmd[5]), Std.parseInt(cmd[6]),cmd[7], cmd[8].contains("true"));
								LevelState.instance.addToWorld(ent);
							case "boss_zombie":
								var ent:Boss_Zombie = new Boss_Zombie(Std.parseInt(cmd[3]), Std.parseInt(cmd[4]), Std.parseInt(cmd[5]), Std.parseInt(cmd[6]),cmd[7], cmd[8].contains("true"));
								LevelState.instance.addToWorld(ent);
						}
				}
			case "/getcommand" | "/script" | "/runscript":
				var link:String =  "assets/scripts/" + cmd[1] + ".txt";
				if(fileExists(link)){
					var script:Array<String> = getTextFile(link).split("\n");
					for ( scr in script){
						trace("ran script: " + scr);
						parseCommand(scr);
					}
				}
			case "/music" | "/mus":
				switch(cmd[1]){
					case "volume":
						FlxG.sound.music.volume =  Std.parseFloat(cmd[2]);
					case "stop":
						FlxG.sound.music.stop();
					case "pause":
						FlxG.sound.music.pause();
					case "resume":
						FlxG.sound.music.resume();
					default:
						if(fileExists("assets/mus/" + cmd[1]+soundext) && LevelState.music != cmd[1])FlxG.sound.playMusic(getSoundFile("assets/mus/" + cmd[1]+soundext));
						LevelState.music = cmd[1];
				}
			case "hud":
				switch(cmd[1]){
					case "hide":
						LevelState.hud.forEachAlive(function(e:FlxSprite){
							e.visible = false;
						});
					case "show":
						LevelState.hud.forEachAlive(function(e:FlxSprite){
							e.visible = true;
						});
					case "alpha":
						
						LevelState.hud.forEachAlive(function(e:FlxSprite){
							e.alpha = Std.parseFloat(cmd[2]);
						});
						
					case "fade":
						
						LevelState.hud.forEachAlive(function(e:FlxSprite){
							e.alpha = Std.parseFloat(cmd[2]);
							FlxTween.tween(e, {alpha:Std.parseFloat(cmd[3])});
						});
				}
				
			case "/sound" | "/snd":
				if(fileExists("assets/sfx/" + cmd[1]+soundext))FlxG.sound.play(getSoundFile("assets/sfx/" + cmd[1]+soundext),1,(cmd[2] == "true"));
			case "/gravity" | "/grav" | "/gv":
				Entity.UNIVERSAL_GRAVITY = Std.parseFloat(cmd[1]);
			case "/basefloor" | "/bf":
				LevelState.th = Std.parseInt(cmd[1]);
			case "/dfps" | "/drawframerate":
				FlxG.drawFramerate = Std.parseInt(cmd[1]);
				trace("draw framerate: " + FlxG.drawFramerate);
			case "/ufps" | "/updateframerate":
				FlxG.updateFramerate = Std.parseInt(cmd[1]);
				trace("update framerate: " + FlxG.updateFramerate);
			case "/friendlyfire" | "/ff":
				AOTD.friendlyfire = cmd[1] == "1";
				trace("friendly fire: " + AOTD.friendlyfire);
			case "/combat" | "/cb":
				LevelState.inCombat = cmd[1] == "1";
				trace("combat: " + LevelState.inCombat);
			case "/chrabs" | "/ca":
				ShadersHandler.setChrome(Std.parseFloat(cmd[1]) / 1000);
				trace("chrabs: " + cmd[1]);
			case "/end" | "/endgame":
				FlxG.switchState(new EndingDemo());
				trace("Ending Game : D");
			case "/shop" | "/sh":
				LevelState.toShop(cmd[1], new Point3D(Std.parseInt(cmd[2]), Std.parseInt(cmd[3]), Std.parseInt(cmd[4])));
				trace("open shop");
			case "/delay":
				new FlxTimer().start(Std.parseFloat(cmd[1]),function(e:FlxTimer){
					AOTD.parseCommand("/script " + cmd[2]);
					trace("ran script "+cmd[2]);
				});
			case "/loop":
				var tm:FlxTimer = new FlxTimer();
				tm.start(Std.parseFloat(cmd[1]),function(e:FlxTimer){
					AOTD.parseCommand("/script " + cmd[3]);
					trace("ran script");
				},Std.parseInt(cmd[2]));
			case "/dl":
				new FlxTimer().start(Std.parseFloat(cmd[1]),function(e:FlxTimer){
					AOTD.parseCommand(StringTools.replace(cmd[2],":"," "));
					trace("ran script "+cmd[2]);
				});
			case "/lp":
				var tm:FlxTimer = new FlxTimer();
				tm.start(Std.parseFloat(cmd[1]),function(e:FlxTimer){
					AOTD.parseCommand(StringTools.replace(cmd[2],":"," "));
					trace("ran script");
				},Std.parseInt(cmd[2]));
			case "/effect" | "/ef":
						var bitmap:BitmapData =  getBitmapFile("assets/sprites/" + cmd[3] + ".png");
						var spr:FlxSprite = new FlxSprite(Std.parseInt(cmd[1]), Std.parseInt(cmd[2]));
						
						spr.loadGraphic(bitmap);
						LevelState.effects.add(spr);
			case "/huditem":
						trace(cmd[1]);
						trace("assets/sprites/" + cmd[3] + ".png");
						var bitmap:BitmapData = getBitmapFile("assets/sprites/" + cmd[3] + ".png");
						var spr:FlxSprite = new FlxSprite(Std.parseInt(cmd[1]), Std.parseInt(cmd[2]));
						
						spr.loadGraphic(bitmap);
						spr.scrollFactor.set();
						LevelState.hud.add(spr);
			case "/crt" | "/setCRT":
				var on:Bool = cmd[1] == "1";
				AOTD.crt(on);
				trace("crt filter "+on);
				trace("open shop");
			case "/test" | "/testroom":
				parseCommand("/ts testroom 100 230 0");
			case "/endlevel" | "/el":
				LevelState.instance.persistentUpdate = false;
				LevelState.instance.openSubState(new ResultsScreen(AOTD.currentLevelInt,AOTD.storyLevels[currentLevelInt].levelName));
			case "/unlocklevel" | "/ul":
				storyLevels[Std.parseInt(cmd[1])].unlocked = true;
			case "/locklevel" | "/ll":
				storyLevels[Std.parseInt(cmd[1])].unlocked = false;
			case "/setlvl" | "/lvl":
				currentLevelInt = Std.parseInt(cmd[1]);
			case "/anim":
				
				var name = "aotdintro";
				var fps = 30;
				var lp = 0;
				if (cmd[1] != null) name = cmd[1];
				if (cmd[2] != null) fps = Std.parseInt(cmd[2]);
				if (cmd[3] != null) lp = Std.parseInt(cmd[3]);
				
				LevelState.instance.openSubState(new CutsceneSubstate(name, fps, lp));
		}
		
	}
	
	public static function getTextFile(path:String):String{
		#if web
			return Assets.getText(path);
		#else
			return File.getContent(path);
		#end
	}
	public static function getBitmapFile(path:String):BitmapData{
		#if web
			return Assets.getBitmapData(path);
		#else
			return BitmapData.fromFile(path);
		#end
	}
	public static function getSoundFile(path:String):Sound{
		#if web
			return Assets.getSound(path);
		#else
			return Sound.fromFile(path);
		#end
	}
	public static function fileExists(path:String):Bool{
		#if web
			return Assets.exists(path);
		#else
			return FileSystem.exists(path);
		#end
	}
	
	public function parseString(string:String){
		
	}
	
	public static function getSFX(audio:String):String{
		return ("assets/sfx/"+audio+soundext);
	}
	public static function getMusic(audio:String):String{
		return ("assets/mus/"+audio+soundext);
	}
	public static function crt(on:Bool){
		crtFilter = on;
		if(on){
		FlxG.camera.setFilters([ShadersHandler.chromaticAberration, ShadersHandler.scanline]);
		ShadersHandler.setChrome(2 / 1000);
		}else{
		FlxG.camera.setFilters([]);
		}
	}
	
	
	public static function applyPlayerData(player:Int){
		var data:PlayerData = AOTD.playerData[player];
		if(data != null || LevelState.players[player] != null){
			LevelState.players[player]._x = data.x;
			LevelState.players[player]._y = data.y;
			LevelState.players[player]._z = data.z;
			LevelState.players[player]._hp = data.hp;
			LevelState.players[player].mp = data.mp;
			LevelState.players[player].coins = data.coins;
			LevelState.players[player].character = data.character;
		}
	}
	public static function applyPlayerDataToAll(data:String = "all", value){
		switch(data){
			case "all":
				for (i in 0...AOTD.playerData.length){
					applyPlayerData(i);
				}
				
			default:
				
				for (i in 0...AOTD.playerData.length){
					Reflect.setProperty(Reflect.getProperty(LevelState.players[i], data),Reflect.getProperty(AOTD.playerData[i], data),value);
				}
				
		}
		
	}
	public static function savePlayerDataToAll(data:String = "all", value){
		switch(data){
			case "all":
				for (i in 0...AOTD.playerData.length){
					savePlayerData(i);
				}
				
			default:
				
				for (i in 0...AOTD.playerData.length){
					var dat = Reflect.field(AOTD.playerData[i], data);
					var dat2 = Reflect.field(FlxG.save.data.playerData[i], data);
					Reflect.setField(dat2,dat,value);
				}
				
		}
		
	}
	public static function savePlayerData(player:Int){
		if(player < LevelState.players.length){
		var data:PlayerData = AOTD.playerData[player];
		//data.x = LevelState.players[player]._x;   /so it doesn't save the characters current position. only the one you set it as
		//data.y = LevelState.players[player]._y;
		//data.z = LevelState.players[player]._z;
		data.hp = LevelState.players[player]._hp;
		data.mp = LevelState.players[player].mp;
		data.coins = LevelState.players[player].coins;
		data.character = LevelState.players[player].character;
		var d = data.dead;
		data.dead = false;
		trace("player " + (player + 1) + ": ");
		trace("\t-x: \t" + data.x);
		trace("\t-y: \t" + data.y);
		trace("\t-z: \t" + data.z);
		trace("\t-hp: \t" + data.hp);
		trace("\t-mp: \t" + data.mp);
		trace("\t-coins: \t" + data.coins);
		trace("\t-character: \t" + data.character);
		trace("\t-dead: \t" + data.dead);
		
		
		FlxG.save.data.playerData = playerData;
		data.dead = d;
		}
	}
	
	public static function properlyExit(){
		LevelState.inCombat = false;
		LevelState.enemiesOnScreen = [];
		AOTD.camFollow = [];
	}
	
}