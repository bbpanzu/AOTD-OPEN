package states;
import flixel.*;
import flash.utils.Timer;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxBitmapFont;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxSoundAsset;
import flixel.system.FlxSound;
import flixel.text.FlxBitmapText;
import flixel.text.FlxText;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import hud.PlayerHud;
import openfl.Assets;
import openfl.Lib;
#if desktop
import sys.io.File;
#end
/**
 * ...
 * @author bbpanzu
 */
class Shop extends FlxSubState
{
	var turns:Array<Player> = [];
	var bg:FlxSprite = new FlxSprite(0,41);
	var desk:FlxSprite = new FlxSprite(232,150);
	var shopkeeper:FlxSprite = new FlxSprite(262,97);
	var hud:FlxSprite = new FlxSprite();
	var shopdata:Array<ShopData> = [];
	
	var choice:Int = 0;
	var choiceMax:Int = 3;
	
	var dialogue:FlxTypeText;
	
	var menu:UInt = 0; 
	
	var initDia:String = "";
	
	var _exitcoord:Point3D;
	
	var ran:Int = 0;
	
	//0 main menu
	//1 buy
	//2 talk
	
	var datafile:String;
	
	
	var lines:Array<String> = ["buy","talk","exit",""];
	
	
	var tips:Array<String> = [
	"Don't get bit by those zombies. they don't do poison damage but they are really annoying",
	"Try to get as high a combo as possible. the higher the combo the more MP you gain",
	"use a condom.",
	"Treat yourself with kindness and respect, and avoid self-criticism. Make time for your hobbies and favorite projects, or broaden your horizons.\n I totally stole that quote from google.",
	"Apologize for what you did to the victim, not for making the victim feel upset.",
	"TONE INDICATORS:\n/j = jokes \n /s = sarcasm/satire \n /pos = positive\n /srs = serious",
	"report bugs to bbpanzu on the AOTD Discord server",
	"try to deal with your current enemies or you'll make new ones. this applies to irl and the game.",
	"White people will never face racial oppression.",
	"Pirate Adobe products",
	"you can access a cool debug feature by pressing  ` . try some commands ingame like '/crt 1' or '/ts testroom 300 300 0'",
	"Press I (or NUMPAD3) to carry objects on the ground. You can also pick up your fallen co-op partner too.",
	"By pressing 1 directional button and 1 attack button, you can input certain attacks. Try pressing DOWN and PUNCH"
	
	
	
	];
	
	var talkc:Dynamic = 
	{
	"jeremy":[
		"So, you're friend Michael. If you two aren't dating, i'll gladly take him off your hands",
		"After my parents found out i snuck out to a halloween party, they're making me take literally every single job in this city. it's whatevs i guess.",
		"You made him really sad after you ditched him at that halloween party. I hope it was worth the hoes and pussy."
	],
	"michael":[
		"Ayy Michael. If you aren't dating you're friend, i'll gladly take you off his hands ;)",
		"After my parents found out i snuck out to a halloween party, they're making me take literally every single job in this city. it's whatevs i guess.",
		"He really ditched you at that halloween party? What a jerk. I hope it was worth the hoes and pussy."
	],
	"chhristine":[
		"Oh hey! Your played Marjorie DuBois in that school play! I felt like we needed more strong women in theatre these days. You find that?",
		"Jake thing didn't work out? Figured. Din't seem like a fit for you anyway. Jeremy however...",
		"Jake really ditched you at that halloween party? What a jerk. I hope it was worth the hoes and pussy."
	]
	};
	
	var talk:Array<String> = [
		"As much as i really enjoy the Hamilton musical, i can't get past the fact it glorifies slave owners.",
		"Any person who hates pineapple on pizza 9/10 haven't even tried it yet. They have the cullinary stubborness of an Italian.",
		"With how technology has advanced these past years, you'd think McDonalds would get a better quality mic.",
		"With how technology has advanced these past years, you'd think banks would get better quality cameras.",
		"Alien invasion? Easy. just migrate to anywhere but America",
		"Tobacco companies kill their best customers and condom companies kill their future customers.",
		"Monopoly is a board game critiquing capitalism. Seeing as how each person tries to screw one another over to be on the top",
		"Cats only meow at humans because it's the only language they can speak that we can hear. They also speak at a volume only other cats can hear."
		
		];
	
	
	
	var choiceText:FlxBitmapText;
	var priceText:FlxBitmapText;
	var serving:FlxText;
	var servingg:FlxText;
	
	
	public function new(shopdata:String,exitCoord:Point3D)
	{
		_exitcoord = exitCoord;
		super();
		datafile = shopdata;
	}
	
	override public function create():Void 
	{
		super.create();
		LevelState.world.visible = false;
		LevelState.bg.visible = false;
		LevelState.effects.visible = false;
		LevelState.canPause = false;
		choiceText = new FlxBitmapText(Font.THICK);
		priceText = new FlxBitmapText(Font.THICK);
		serving = new FlxText(251, 167, 43, "SERVING:\n", 16);
		servingg = new FlxText(248, 173, 48, "SERVING:\n", 16);
		serving.setFormat("assets/fonts/TinyUnicode.ttf", 16, 0xFF16cf00, "center");
		servingg.setFormat("assets/fonts/TinyUnicode.ttf", 16, 0xFF16cf00, "center");
		choiceText.x = 4;
		choiceText.y = 45;
		choiceText.fieldWidth = 198;
		priceText.x = 164;
		priceText.y = 45;
		priceText.fieldWidth = 100;
		var sd:String = AOTD.getTextFile("assets/shop/" + datafile + ".txt");
		var dd:Array<String> = sd.split("\n");
		var d:Array<String> = [];
		for (st in 0...dd.length){
			d = dd[st].split("|");
			trace(d);
			if (d[0] != "/data"){
				var n:String = d[0];
				var c:Float = Std.parseFloat(d[1]);
				var h:Float = Std.parseFloat(d[2]);
				var m:Float = Std.parseFloat(d[3]);
				var de:String = d[4];
				var item:ShopData = new ShopData(n, c, h, m, de);
				shopdata.push(item);
			}else{
				bg.loadGraphic(AOTD.getBitmapFile("assets/sprites/bg/shop/" + d[1] + ".png"));
				desk.loadGraphic(AOTD.getBitmapFile("assets/sprites/bg/shop/" + d[2] + ".png"));
				shopkeeper.loadGraphic(AOTD.getBitmapFile("assets/sprites/bg/shop/" + d[3] + ".png"), true, 224, 160);
				FlxG.sound.playMusic(AOTD.getSoundFile(AOTD.getMusic(d[4])));
				initDia = d[5];
			}
			
			
		}
		
		dialogue = new FlxTypeText(3, 197, 231, initDia, 8);
		dialogue.setFormat("assets/fonts/AOTDdefault.ttf", 16);
		//choiceText.setFormat("assets/fonts/AOTDmoney.ttf", 16);
		for (pl in LevelState.players){
			turns.push(pl);
			pl._enabled = false;
		}
		
		hud.loadGraphic("assets/sprites/bg/shop/shophud.png");
		shopkeeper.animation.add("idle", [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0], 10);
		shopkeeper.animation.add("talk", [2,3,4], 10);
		shopkeeper.animation.add("peace", [8,9,10,11,12,13,16,17,18,16,17,18,16,17,18,16,17,18,16,17,18], 10,false);
		shopkeeper.animation.play("idle");
		LevelState.canPause = false;
		
		add(bg);
		add(shopkeeper);
		add(desk);
		add(hud);
		bg.scrollFactor.set();
		desk.scrollFactor.set();
		shopkeeper.scrollFactor.set();
		hud.scrollFactor.set();
		serving.scrollFactor.set();
		servingg.scrollFactor.set();
		
		add(choiceText);
		add(priceText);
		add(serving);
		add(servingg);
		add(dialogue);
		choiceText.scrollFactor.set();
		priceText.scrollFactor.set();
		dialogue.scrollFactor.set();
		sayShit(initDia);
		
	}
	
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		priceText.text = "";
		
		serving.text = "SERVING:";
		if (turns.length > 0 ) servingg.text =  turns[0].character.toUpperCase();
		
		switch(menu){
			case 0:
				
				
		
		if (FlxG.keys.anyJustPressed(AOTD.keysets[turns[0].player - 1].DOWN)){
			choice++;
			FlxG.sound.play(AOTD.getSFX("sfx_hud_hover"));
		}
		if (FlxG.keys.anyJustPressed(AOTD.keysets[turns[0].player - 1].UP)){
			choice--;
			FlxG.sound.play(AOTD.getSFX("sfx_hud_hover"));
		}
		
		if (choice == choiceMax) choice = 0;
		if (choice == -1) choice = choiceMax-1;
				
				
				choiceMax = 3;
				lines = ["BUY", "TALK", "EXIT", ""];
				
				choiceText.text = "";
				for (i in 0...lines.length-1){
					if (i == choice){
						choiceText.text += ">";
					}
					choiceText.text += lines[i]+"\n";
				}
				
				if (FlxG.keys.anyJustPressed(AOTD.keysets[turns[0].player - 1].PUNCH)){
					menu = choice+1;
					choice = 0;
					FlxG.sound.play(AOTD.getSFX("sfx_hud_select"));
					
					if (menu == 1){
				lines = [shopdata[0]._name,
				shopdata[1]._name,
				shopdata[2]._name,
				shopdata[3]._name];
						sayShit("" + shopdata[0]._hp + " HP " + shopdata[0]._mp + " MP\n-----------------\n" + shopdata[0]._desc,1);
						
						priceText.text = FlxStringUtil.formatMoney(shopdata[0]._cost) + "\n" + FlxStringUtil.formatMoney(shopdata[1]._cost) + "\n" + FlxStringUtil.formatMoney(shopdata[2]._cost) + "\n" + FlxStringUtil.formatMoney(shopdata[3]._cost);
					}
					if (menu == 2){
						sayShit("Whats up?",1);
					}
					if (menu == 3){
						sayShit("Cya!");
					}
					
				}
				
			case 1:
				
				
				
		
		if (FlxG.keys.anyJustPressed(AOTD.keysets[turns[0].player - 1].DOWN)){
			choice++;
			
			FlxG.sound.play(AOTD.getSFX("sfx_hud_hover"));
			if (choice == choiceMax) choice = 0;
		
			sayShit("" + shopdata[choice]._hp + " HP " + shopdata[choice]._mp + " MP\n-----------------\n" + shopdata[choice]._desc,1);
			
		}
		if (FlxG.keys.anyJustPressed(AOTD.keysets[turns[0].player - 1].UP)){
			choice--;
			FlxG.sound.play(AOTD.getSFX("sfx_hud_hover"));
		if (choice == -1) choice = choiceMax - 1;
			sayShit("" + shopdata[choice]._hp + " HP " + shopdata[choice]._mp + " MP\n-----------------\n" + shopdata[choice]._desc,1);
			
		}
		priceText.text = "$"+FlxStringUtil.formatMoney(shopdata[0]._cost) + "\n$" + FlxStringUtil.formatMoney(shopdata[1]._cost) + "\n$" + FlxStringUtil.formatMoney(shopdata[2]._cost) + "\n$" + FlxStringUtil.formatMoney(shopdata[3]._cost);
				choiceMax = 4;
				
				
				
				/*
				dialogue.applyMarkup(
					dialogue.text,
					[new FlxTextFormatMarkerPair(new FlxTextFormat(0xFF00CCFF, true, false, 0xFFFFFFFF), "*"),
					new FlxTextFormatMarkerPair(new FlxTextFormat(0xFF0033FF, true, false, 0xFFFFFFFF), "^"),
					]
				);
				*/
				
				choiceText.text = "";
				
				//dialogue = new FlxTypeText(2,42,198,shopdata[choice]._hp)
				for (i in 0...lines.length){
					if (i == choice) choiceText.text += ">";
					choiceText.text += lines[i]+"\n";
				}
				
				if (FlxG.keys.anyJustPressed(AOTD.keysets[turns[0].player - 1].PUNCH)){
					if(shopdata[choice]._cost <= turns[0].coins){
						turns[0]._hp += shopdata[choice]._hp;
						turns[0].mp += shopdata[choice]._mp;
						turns[0].coins -= shopdata[choice]._cost;
						FlxG.sound.play(AOTD.getSFX("sfx_purchase"));
					}else{	
						FlxG.sound.play(AOTD.getSFX("sfx_hud_disabled"));
						sayShit("Sorry, you a little short.");
					}
				}
				if (FlxG.keys.anyJustPressed(AOTD.keysets[turns[0].player - 1].KICK)){
					menu = 0;
					choice = 0;
					sayShit(initDia);
				}
				
				
				
				
			case 2:
				
				
				
		
		if (FlxG.keys.anyJustPressed(AOTD.keysets[turns[0].player - 1].DOWN)){
			choice++;
			FlxG.sound.play(AOTD.getSFX("sfx_hud_hover"));
			
		if (choice == -1) choice = choiceMax - 1;
		
		}
		if (FlxG.keys.anyJustPressed(AOTD.keysets[turns[0].player - 1].UP)){
			choice--;
			FlxG.sound.play(AOTD.getSFX("sfx_hud_hover"));
			if (choice == choiceMax) choice = 0;
			
		}
		
				choiceMax = 3;
				
				
				
				/*
				dialogue.applyMarkup(
					dialogue.text,
					[new FlxTextFormatMarkerPair(new FlxTextFormat(0xFF00CCFF, true, false, 0xFFFFFFFF), "*"),
					new FlxTextFormatMarkerPair(new FlxTextFormat(0xFF0033FF, true, false, 0xFFFFFFFF), "^"),
					]
				);
				*/
				lines = ["Your thoughts?",
				"About me?",
				"Tips?",
				"Exit"];
				
				choiceText.text = "";
				
				//dialogue = new FlxTypeText(2,42,198,shopdata[choice]._hp)
				for (i in 0...lines.length){
					if (i == choice) choiceText.text += ">";
					choiceText.text += lines[i]+"\n";
				}
				
				if (FlxG.keys.anyJustPressed(AOTD.keysets[turns[0].player - 1].PUNCH)){
					switch(choice){
						case 0:
							var oldran = ran;
							while (ran == oldran){
								ran = FlxG.random.int(0, talk.length - 1);
							}
							sayShit(talk[ran]);
							
						case 1:
							var tt:Array<String> = Reflect.getProperty(talkc, turns[0].character);
							var oldran = ran;
							while (ran == oldran){
								ran = FlxG.random.int(0, tt.length - 1);
							}
							sayShit(tt[ran]);
							
						case 2:
							var oldran = ran;
							while (ran == oldran){
								ran = FlxG.random.int(0, tips.length - 1);
							}
							sayShit(tips[ran]);
							
						case 3:
							sayShit(initDia);
							
							menu = 0;
							
					}
				}
				if (FlxG.keys.anyJustPressed(AOTD.keysets[turns[0].player - 1].KICK)){
					menu = 0;
					choice = 0;
					sayShit(initDia);
				}
				
				
				
				
				
				
			case 3:
						choiceText.text = "";
						
					shopkeeper.animation.play("peace");
				if (shopkeeper.animation.curAnim.curFrame >= 15){
						close();
				}
				if (shopkeeper.animation.curAnim.curFrame >= 14){
					
					turns.shift();
					trace(turns.length + " players left");
					if (turns.length == 0){
						//Lib.setTimeout(function(e:FlxTimer){
							trace("bitch");
							for (pl in LevelState.players){
								pl._enabled = true;
								pl.visible = true;
								trace(pl._enabled);
								pl.setPos(_exitcoord._x, _exitcoord._y, _exitcoord._z);
								pl.setPosition(_exitcoord._x, _exitcoord._y-_exitcoord._z);
							}
						//},20);
						LevelState.world.visible = true;
						LevelState.bg.visible = true;
						LevelState.effects.visible = true;
						AOTD.inShopRN = false; 
						FlxG.sound.playMusic(AOTD.getMusic(LevelState.music));
						LevelState.canPause = true;
						
					}else{
						
					sayShit(initDia);
						menu = 0;
					}
					
				}
				
				
		}
		
		for (i in LevelState.hud.playerHud){
				i.color.brightness = 1;
			if (i._player.player != turns[0].player){
				i.color.brightness = 0.5;
			}
		}
		
	}
	
	public function exit(e:FlxTimer){
		close();
	}
	public function isTalking(){
		trace("is talking");
		if(menu != 3)shopkeeper.animation.play("talk");
	}
	public function isDoneTalking(){
		trace("is not talktign");
		if(menu != 3)shopkeeper.animation.play("idle");
	}
	
	public function sayShit(dia:String,sp:Int=2){
		
					dialogue.resetText(dia);
					isTalking();
					dialogue.start(sp/100, false, false, null, isDoneTalking);
	}
	
}