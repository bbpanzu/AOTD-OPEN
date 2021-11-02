package states;
import flixel.*;
import enums.*;
import enemy.Enemy;
import flixel.addons.ui.FlxInputText;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.text.FlxText;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxTimer;
import hud.PlayerHud;
import level.*;
import openfl.display.BitmapData;
import openfl.Assets;
import shaders.*;

#if desktop
import sys.FileSystem;
#end
/**
 * ...
 * @author bbpanzu
 */
class LevelState extends AOTDState
{
	public static var players:Array<Player> = [];
	public static var numPlayers:UInt = 1;
	public static var heightmap:BitmapData;
	public static var json:Dynamic;
	public static var data:Xml;
	public static var world:FlxSpriteGroup;
	public static var shadow:FlxSpriteGroup;
	public static var effects:FlxSpriteGroup;
	public static var debug:FlxSpriteGroup;
	public static var bg:FlxSpriteGroup;
	public static var hud:HUD;
	public static var replay:Bool = false;
	public static var replaydata:String = "";
	public static var room:String = "testroom";
	public static var music:String = "basement";
	public static var cam:FlxCamera;
	public static var enableCollision:Bool = false;
	public static var spawnPoint:Point3D = new Point3D();
	public static var enemiesOnScreen:Array<Enemy> = new Array<Enemy>();
	
	var levelInit = 0;
	
	public static var camBound:FlxRect = new FlxRect(0, 0, 960, 270);
	
	
	
	
	
		private static var collisionMargin:UInt = 10;
		private static var shouldCollide:UInt = 0;
		private static var _signed:Bool = false;
		private static var color:String;
		private static var rgb:String;
		private static var r:Int;
		private static var g:Int;
		private static var b:Int;
		private static var rr:Int;
		private static var gg:Int;
		private static var bb:Int;
		private static var onRamp:Bool = false;
		public static var th:Int = 128;
		public static var entites:Array<Entity> = new Array<Entity>();
		public static var camfollow:FlxObject = new FlxObject(0, 0, 2, 2);
		public static var canPause:Bool = true;
		public static var hudType:UInt = 0;
		public static var instance:LevelState;
		public static var currentLevel:LevelState;
		public var watermark:FlxText;
		public static var inCombat:Bool = false;
		public var command:FlxInputText;
		public var bbb:FlxPoint = new FlxPoint(0, 0);
		public var watchout:FlxSprite = new FlxSprite(0, 200);
		public var playerInd:Array<FlxSprite> = new Array<FlxSprite>();
	
		var yy:UInt = 211;
	
	
	
	
	public function new() 
	{
		super();
		
	}
	
	override public function create():Void 
	{
		super.create();
		AOTD.crt(AOTD.crtFilter);
		AOTD.midGame = true;
		//AOTD.parseCommand("/mus "+room);
		
		watchout.loadGraphic("assets/sprites/misc/watchout.png", true, 176, 32);
		watchout.animation.add("watchout", [0,1,2,3,4,1,2,3,4,1,2,3,4,1,2,3,4,1,2,3,4,1,2,3,4,1,2,3,4,1,2,3,4,1,2,3,4,0], 15,false);
		watchout.screenCenter(FlxAxes.X);
		watchout.scrollFactor.set();
		instance = this;
		
		players = [];
		canPause = true;
		FlxG.camera.pixelPerfectRender = true;
		hud = new HUD(hudType);
		
		bg = new FlxSpriteGroup();
		//data = Xml.parse(Assets.getText("assets/maps/"+room+".xml"));
		heightmap = AOTD.getBitmapFile("assets/sprites/bg/"+room+"/"+room+"_heightmap.png");
		bg.add(new FlxSprite().loadGraphic(AOTD.getBitmapFile("assets/sprites/bg/"+room+"/"+room+".png")));
		FlxG.camera.setScrollBoundsRect(0, 0, bg.width, bg.height);
		shadow = new FlxSpriteGroup();
		world = new FlxSpriteGroup();
		effects = new FlxSpriteGroup();
		debug = new FlxSpriteGroup();
		
		
		add(bg);
		add(shadow);
		add(world);
		add(effects);
		
		camBound.setSize(bg.width, bg.height);
		cam = FlxG.camera;
		//players[0]._enabled = !replay;
		//if (cam.x > camBound.x + camBound.width) cam.x = camBound.x + camBound.width;
		//if (cam.x < camBound.x) cam.x = camBound.x;
		//if (cam.y > camBound.y + camBound.width) cam.x = camBound.x + camBound.width;
		//if (cam.y < camBound.y) cam.x = camBound.x;
		camera.setScrollBoundsRect(0, 0, camBound.width, camBound.height);  
		
				camfollow.x = spawnPoint._x;
				camfollow.y = spawnPoint.getFlatCoords().y;
				FlxG.camera.follow(camfollow, NO_DEAD_ZONE, 1);
		/*
		switch(room){
			case "testroom":
				spawnPoint.set(100, 225, 0);
				var cube1:FlxSprite = new FlxSprite(80, 96);
				cube1.loadGraphic("assets/sprites/bg/test/testroom_t1.png");
				bg.add(cube1);
				
				
				
				var cube2:Entity = new Entity(242, 256, 0);
				cube2._noclip = true;
				cube2._float = true;
				cube2._showshadow = false;
				cube2.loadGraphic("assets/sprites/bg/test/testroom_t2.png");
				cube2.offset.y = 32;
				world.add(cube2);
				
				var ball:Entity = new Entity(80, 230, 64);
				ball._bounce = 0.8;
				ball.loadGraphic("assets/sprites/misc/ball.png", false, 32, 32);
				ball.fixOffset();
				world.add(ball);
				
		}
		
		*/
		hud = new HUD(0);
		add(debug);
		watermark = new FlxText(0, 230, 0, "[DEBUG MODE]",8);
		command = new FlxInputText(0, 250, 480, "",8);
		watermark.setBorderStyle(FlxTextBorderStyle.OUTLINE, 0xFF000000, 1);
		debug.add(watermark);
		watermark.scrollFactor.set();
		debug.add(command);
		command.scrollFactor.set();
		add(hud);
		
		
		var bitch:Entity = new Entity(0, -999, 0);
		bitch.sprite.visible = false;
		world.add(bitch);
		bitch._showshadow = false;
		var bitch2:Entity = new Entity(0, 999, 0);
		world.add(bitch2);
		bitch2.sprite.visible = false;
		bitch2._showshadow = false;
		var deadshits = 0;
		for (i in 0...AOTD.playerData.length){
			var data:PlayerData = AOTD.playerData[i];
			trace(data);
			if (!data.dead){
				if(AOTD.gameMode == 0){
					data.character = AOTD.storyLevels[AOTD.currentLevelInt].character;
					trace("on story mode");
				}
				var pl:Player = new Player(Std.int(data.x)-(i*4), Std.int(data.y)+(i*8), Std.int(data.z), data.character);
				pl.player = i + 1;
				players.push(pl);
				AOTD.applyPlayerData(i-deadshits);
				world.add(players[i-deadshits]);
				
				var ind:FlxSprite = new FlxSprite();
				ind.loadGraphic(AOTD.getBitmapFile("assets/sprites/misc/playerdisp.png"), true, 13, 80);
				ind.animation.add("thing", [0, 1, 2, 3], 0);
				ind.animation.play("thing", true, false, i-deadshits);
				playerInd.push(ind);
				ind.offset.y = 64 + 13;
				ind.offset.x = 8;
				ind.scrollFactor.set();
				
				var phud = new PlayerHud(pl);
				hud.add(phud);
				hud.add(playerInd[i-deadshits]);
			}else{
				deadshits ++;
			}
			
		}
		
			//if (!replay){	
			//	FlxG.vcr.startRecording();
		//	}
		//entites = 
		
		var fadein:FlxSprite = new FlxSprite(0, 0);
		fadein.loadGraphic("assets/sprites/misc/fadein.png", true, 480, 270);
		fadein.animation.add("fadein", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15], 15,false);
		fadein.animation.play("fadein");
		fadein.scrollFactor.set();
		FlxG.sound.play("assets/sfx/sfx_trans_fadein.ogg");
		add(watchout);
		hud.add(fadein);
		
		
		var light:FlxSprite = new FlxSprite();
		if (AOTD.fileExists("assets/sprites/bg/" + room + "/" + room + "_shadow.png")){
			light.loadGraphic(AOTD.getBitmapFile("assets/sprites/bg/"+room+"/"+room+"_shadow.png"));
			LevelState.effects.add(light);
		}
		
	}
	
	public function createLevel(){
		
	}
	public function addToWorld(entity:Entity){
		LevelState.world.add(entity);
	}
	
	public override function update(elapsed:Float){
		//world.forEachAlive(function(e:FlxSprite){
		//haxe.ds.ArraySort.sort(world.members,sort_Y);
		//})
		//heightstuff()
		enemiesOnScreen = [];
		FlxG.watch.addQuick("inCombat", LevelState.inCombat);
		if(levelInit == 3){
			createLevel();
			AOTD.parseCommand("/script levels/"+LevelState.room);
		}
			if(levelInit < 4)levelInit ++;
			
		for (pl in LevelState.players){
				pl.visible = true;
		}
			if (FlxG.keys.anyJustPressed(AOTD.keyset.DEBUGTOGGLE)){
				Main.debug = !Main.debug;
			}
		
			debug.visible = Main.debug;
		if (Main.debug){
				if (FlxG.keys.justPressed.ENTER){
					
					AOTD.parseCommand(command.text);
					command.text = "";
					command.hasFocus = false;
					Main.debug = false;
				}
			if (FlxG.keys.anyPressed(AOTD.keyset.DEBUG)){
				
				command.text = "";
				if(FlxG.keys.justPressed.Q){
				players[0].initPos(true);
				}
				
				
				if (FlxG.keys.justPressed.Z) debugNPC();
				if (FlxG.keys.anyJustPressed([SEVEN])) FlxG.switchState(new AnimDebug());
				if (FlxG.keys.anyJustPressed([NINE]) && !FlxG.keys.anyPressed([SHIFT])) world.add(new Coin("bronze", FlxG.mouse.x, FlxG.mouse.y, AOTD.getHeightFromPoint(FlxG.mouse.getPosition()), 4, FlxG.random.float(-1,1), FlxG.random.float(-1,1)));
				if (FlxG.keys.anyJustPressed([NINE]) && FlxG.keys.anyPressed([SHIFT])) Coin.spawnMass(8, 4, FlxG.mouse.x, FlxG.mouse.y, AOTD.getHeightFromPoint(FlxG.mouse.getPosition()), ["bronze", "silver", "gold", "ruby"]);
		
				
				
				
				
			}
		}
		
		
		//if (FlxG.keys.anyJustPressed([R])) transScene(room);
		
		/*
		if (FlxG.keys.anyJustPressed([R])){
			replay = !replay;
			if (replay){
				replaydata = FlxG.vcr.stopRecording(false);
			FlxG.resetState();
			}else{
				FlxG.vcr.loadReplay(replaydata, new PlayerState());
			}
		}
		*/
			if (FlxG.keys.anyJustPressed(AOTD.keyset.PAUSE) && !Main.debug && LevelState.canPause){
				instance.persistentUpdate = false;
				FlxG.sound.play("assets/sfx/sfx_pause.ogg");
				openSubState(new OptionsSubstate());
			}
			FlxG.camera.shake(AOTD.camshake / 60);
			if (AOTD.camshake > 0) AOTD.camshake -= 0.5;
			
			bbb.set();
		for (i in 0...AOTD.camFollow.length){
			bbb.x += Math.round(AOTD.camFollow[i]._x)+AOTD.camFollow[i].campoint.x;
			if (AOTD.camFollow[i]._elevation < AOTD.CAM_Y_THRESHOLD){
				bbb.y += Math.round(AOTD.camFollow[i]._y-AOTD.camFollow[i]._floorz)+AOTD.camFollow[i].campoint.y;
			}else{
				bbb.y += Math.round(AOTD.camFollow[i].y)+AOTD.camFollow[i].campoint.y;
			}
		}
			bbb.set(bbb.x / AOTD.camFollow.length, bbb.y / AOTD.camFollow.length);
		if (!inCombat){
			watchout.animation.play("watchout", true);
		}
		switch(AOTD.camFollowType){
			case CamFollowType.STRICT:
				camfollow.x = bbb.x;
				camfollow.y = bbb.y;
			case CamFollowType.TOLERANT:
					if (camfollow.x > bbb.x){
						camfollow.x -= AOTD.camFollowLerp;
						if (camfollow.x < bbb.x)camfollow.x = bbb.x;
					}
					
					if (camfollow.x < bbb.x){
						camfollow.x += AOTD.camFollowLerp;
						if (camfollow.x > bbb.x)camfollow.x = bbb.x;
					}
					
					if (camfollow.y > bbb.y){
						camfollow.y -= AOTD.camFollowLerp;
						if (camfollow.y < bbb.y)camfollow.y = bbb.y;
					}
					
					if (camfollow.y < bbb.y){
						camfollow.y += AOTD.camFollowLerp;
						if (camfollow.y > bbb.y)camfollow.y = bbb.y;
					}
					
			case CamFollowType.FREE:
				if (FlxG.keys.pressed.NUMPADSIX) camfollow.x += AOTD.camFollowLerp;
				if (FlxG.keys.pressed.NUMPADFOUR) camfollow.x -= AOTD.camFollowLerp;
				if (FlxG.keys.pressed.NUMPADTWO || FlxG.keys.pressed.NUMPADFIVE) camfollow.y += AOTD.camFollowLerp;
				if (FlxG.keys.pressed.NUMPADEIGHT) camfollow.y -= AOTD.camFollowLerp;
		
		}
		
		if (FlxG.keys.pressed.ALT){
			if (FlxG.keys.justPressed.F1){
				if (AOTD.camFollowType != 3){
					AOTD.camFollowType = 3;
				}else{
					AOTD.camFollowType = 0;
				}
			}
		}
			FlxG.camera.follow(camfollow, TOPDOWN, 1);
			FlxG.camera.deadzone.width = 1;
			FlxG.camera.deadzone.height = 1;
			watermark.text = "[DEBUG MODE]\tCamMode: " + AOTD.camFollowType;
		world.sort(sort_Y, FlxSort.ASCENDING);
		
		FlxG.watch.addQuick("scrollx", FlxG.camera.scroll.x);
		FlxG.watch.addQuick("camx", FlxG.camera.x);
		
		for (i in 0...playerInd.length){
			if(players.length > 0 && players[i] != null){
				playerInd[i].x = players[i].x-FlxG.camera.scroll.x;
				playerInd[i].y = players[i].y-FlxG.camera.scroll.y;
				if (playerInd[i].x < 13) playerInd[i].x = 13;
				if (playerInd[i].y < 80) playerInd[i].y = 80;
				if (playerInd[i].x > (FlxG.width-13)) playerInd[i].x = (FlxG.width)-13;
				if (playerInd[i].y > (FlxG.height+64)) playerInd[i].y = (FlxG.height)+64;
			}
		}
		
		super.update(elapsed);
	}
	var sort_Y: Int->FlxSprite-> FlxSprite-> Int = function(ttt:Int, a:FlxSprite, b:FlxSprite): Int{
		return FlxSort.byValues(-1, Reflect.getProperty(a, "_y"), Reflect.getProperty(b, "_y"));
		/*
		if (a == null) return 0;
		if (b == null) return 0;
		if (Reflect.getProperty(a,"_y") > Reflect.getProperty(b,"_y")){
			return 1;
		}else{
			return -1;
		}
           return 0;*/
	}
	
	public function debugNPC(){
		
				new Npc(0+players[0]._x, yy+1, 0,22,3);
				new Npc(40+players[0]._x, yy, 0,22,3);
				new Npc(80+players[0]._x, yy+1, 0,22,3);
				new Npc(10+players[0]._x, yy, 0,22,3);
				new Npc(40+players[0]._x, yy+1, 0,22,3);
				new Npc(70+players[0]._x, yy, 0,22,3);
				new Npc(100+players[0]._x, yy+1, 0, 22, 3);
				yy += 10;
	}
	public static function getValue(col, channel: String):Float
	{
		var val = 0;
		r = new FlxColor(col).red;
		g = new FlxColor(col).green;
		b = new FlxColor(col).blue;
		
		if (channel.toLowerCase() == "red"){
			val = (r-th);
		}
		if (channel.toLowerCase() == "green"){
			val =  (g-th);
		}
		if (channel.toLowerCase() == "blue"){
			val =  (b-th);
		}
		if (channel.toLowerCase() == "value"){
			val =  (r-th);
		}
		
		if (r > 254 && g ==0 && b ==0) val = -999;
		return val;
	}
		
	public function heightstuff(){
		
		//for (i in ) checkfor(AOTD.WORLD.getChildAt(i))
			//trace(getValue(_bmpdata.getPixel(AOTD.players[0]._x,AOTD.players[0]._y)))
			//trace(AOTD.players[0]._elevation)
			if (_signed)
			{
				th = 128;
			}
			else
			{
				th = 0;
			}
	}
	
	public static function toShop(shop:String, exitCoord:Point3D){
		for (pl in LevelState.players){
							pl.setPos(exitCoord._x, exitCoord._y, exitCoord._z);
							pl.setPosition(exitCoord._x, exitCoord._y-exitCoord._z);
						}
		
		
		AOTD.inShopRN = true;
		instance.persistentUpdate = true;
		LevelState.instance.openSubState(new Shop(shop,exitCoord));
		
		
	}
	public static function transScene(scene:String,spawnPoint:Point3D){
		
		
		for (i in 0...AOTD.playerData.length ){
			AOTD.playerData[i].x = spawnPoint._x;
			AOTD.playerData[i].y = spawnPoint._y;
			AOTD.playerData[i].z = spawnPoint._z;
			AOTD.savePlayerData(i);
		}
		LevelState.inCombat = false;
		LevelState.canPause = false;
		AOTD.camFollow = [];
			
			
		if (instance != null){
			var fadeout:FlxSprite = new FlxSprite(0, 0);
			fadeout.loadGraphic("assets/sprites/misc/fadeout.png", true, 480, 270);
			fadeout.animation.add("fadeout", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15], 15,false);
			fadeout.animation.play("fadeout");
			fadeout.scrollFactor.set();
			hud.add(fadeout);
		}
			new FlxTimer().start(1, function(e:FlxTimer){
		if (instance != null){
			world.forEachExists(function(spr:FlxSprite){
				world.remove(spr);
				spr.destroy();
			});
			bg.forEachExists(function(spr:FlxSprite){
				world.remove(spr);
				spr.destroy();
			});
			hud.forEachExists(function(spr:FlxSprite){
				world.remove(spr);
				spr.destroy();
			});
			effects.forEachExists(function(spr:FlxSprite){
				world.remove(spr);
				spr.destroy();
			});
			
		}
		switch(scene){
			case "testroom":
				LevelState.room = "testroom";
				FlxG.switchState(new LVL_Test());
			default:
				LevelState.room = scene;
				FlxG.switchState(new LevelState());
		}
		});
	}
	
	
}