package states;
import flixel.*;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.math.FlxMath;
import flixel.text.FlxBitmapText;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxSort;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxStringUtil;
import openfl.display.BitmapData;

/**
 * ...
 * @author bbpanzu
 */
class ResultsScreen extends FlxSubState
{
	var s = 0;
	var statIcons:Array<FlxSprite> = [];
	var statHp:Array<FlxText> = [];
	var statMp:Array<FlxText> = [];
	var statCoins:Array<FlxText> = [];
	var portraits:FlxSpriteGroup = new FlxSpriteGroup();
	var medal:FlxSprite;
	var done = [0, 0, 0, 0];
	var avscore:Int = 0;
	var scores = [];
	public function new(level:UInt,levelName:String) 
	{
		super();
		
		var lvl:FlxBitmapText = new FlxBitmapText(Font.THICK);
		var lvlname:FlxBitmapText = new FlxBitmapText(Font.SMALL);
		lvl.text = "LEVEL " + (AOTD.currentLevelInt + 1);
		lvlname.text = AOTD.storyLevels[AOTD.currentLevelInt].levelName;
		
		FlxG.sound.playMusic("assets/mus/victory.ogg", 1, false);
		FlxG.sound.music.onComplete = end;
		var bg:FlxSprite = new FlxSprite().loadGraphic("assets/sprites/resultscreen/resultscreen.png");
		add(bg);
		lvl.setPosition(285, 69);
		lvlname.setPosition(285, 80);
		add(lvl);
		add(lvlname);
		bg.scrollFactor.set();
		var total = 0;
		for (i in 0...LevelState.players.length){
			scores.push(calculateScore(i));
			total += calculateScore(i);
			var s:FlxSprite = new FlxSprite(7+64*i,13).loadGraphic("assets/sprites/misc/staticons.png");
			add(s);
			statIcons.push(s);
			s.scrollFactor.set();
			var h:FlxText = new FlxText(22 + 64 * i, 11, 0, "BALLS", 16);
			h.font = "assets/fonts/AOTDmoney.ttf";
			add(h);
			statHp.push(h);
			h.scrollFactor.set();
		
			var m:FlxText = new FlxText(22+64*i,36,0,"IN MY",16);
			m.font = "assets/fonts/AOTDmoney.ttf";
			add(m);
			statMp.push(m);
			m.scrollFactor.set();
		
			var c:FlxText = new FlxText(22+64*i,60,0,"MOUTH",16);
			add(c);
			c.font = "assets/fonts/AOTDmoney.ttf";
			c.scrollFactor.set();
			statCoins.push(c);
			
			var p:FlxSprite = new FlxSprite(14+(64*i),174).loadGraphic(AOTD.getBitmapFile("assets/sprites/resultscreen/rs_"+LevelState.players[i].character+".png"),true,96,96);
			portraits.add(p);
			p.animation.add("wait", [0, 1], 2);
			p.animation.add("rank0", [2, 3], 2);
			p.animation.add("rank1", [4, 5], 2);
			p.animation.add("rank2", [6, 7], 2);
			p.animation.play("wait",false);
			p.scrollFactor.set();
			add(portraits);
			
		
		
		}
		
		trace(scores);
		avscore = Math.round(total / LevelState.players.length);
		trace(avscore);
		trace( calculateRank(avscore));
			medal = new FlxSprite(296+32,129+32).loadGraphic(AOTD.getBitmapFile("assets/sprites/resultscreen/medal.png"),true,64,64);
			
			medal.animation.add("medal", [0,1,2], 0);
			add(medal);
		medal.animation.play("medal", true, false, calculateRank(avscore));
			medal.visible = false;
			medal.scale.set(2,2);
		portraits.sort(sortX, FlxSort.ASCENDING);
		
		lvl.scrollFactor.set();
		lvlname.scrollFactor.set();
		medal.scrollFactor.set();
		portraits.scrollFactor.set();
		portraits.scrollFactor.set();
	}
	
	function sortX(ttt:Int, a:FlxSprite, b:FlxSprite): Int{
		return FlxSort.byValues(1, Reflect.getProperty(a, "x"), Reflect.getProperty(b, "x"));
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
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		if(FlxG.sound.music.time > 1000){
			for (i in 0...LevelState.players.length){
				
				if (FlxG.keys.anyJustPressed(AOTD.keysets[i].PUNCH)){
					end();
				}
			}
		}
		if (done[0] == 0){
			
			for (i in 0...LevelState.players.length){
				statHp[i].text = ""+FlxG.random.int(10,99);
			}
		}
		if (done[1] == 0){
			
			for (i in 0...LevelState.players.length){
				statMp[i].text = ""+FlxG.random.int(10,99);
			}
		}
		if (done[2] == 0){
			
			for (i in 0...LevelState.players.length){
				statCoins[i].text = ""+FlxStringUtil.formatMoney(FlxG.random.float(10.00,99.99),true);
			}
		}
		
		
		
		if (FlxG.sound.music.time > 2560){
			for (i in 0...LevelState.players.length){
				statHp[i].text = "" + LevelState.players[i]._hp;
				
			}
			done[0] = 1;
		}
		if (FlxG.sound.music.time > 3000){
			for (i in 0...LevelState.players.length){
				statMp[i].text = ""+LevelState.players[i].mp;
			}
			done[1] = 1;
		}
		if (FlxG.sound.music.time > 3455){
			for (i in 0...LevelState.players.length){
				statCoins[i].text = "" + FlxStringUtil.formatMoney(LevelState.players[i].coins);
				
			}
			done[2] = 1;
		}
		if (FlxG.sound.music.time > 4800){
			for (i in 0...LevelState.players.length){
				portraits.members[i].animation.play("rank" + calculateRank(scores[i]));
				
			}
			done[3] = 1;
		}
		if ( hitMS(4800,elapsed)){
			medal.visible = true;
			
		}
		
	}
	function end(){
		
					FlxG.camera.fade(0xFF000000, 1, false, function(){
						
						
						if(AOTD.currentLevelInt == 1 && AOTD.gameMode == 0){
							FlxG.switchState(new EndingDemo());
						}else{
							if (AOTD.gameMode == 0){
								AOTD.currentLevelInt++;
								AOTD.parseCommand("/ul " + AOTD.currentLevelInt);
								FlxG.save.data.storyLevels = AOTD.storyLevels;
								FlxG.save.flush();
								trace(FlxG.save.data.storyLevels);
								AOTD.parseCommand("/ts " + AOTD.storyLevels[AOTD.currentLevelInt].initScene + " " +AOTD.storyLevels[AOTD.currentLevelInt].x + " " +AOTD.storyLevels[AOTD.currentLevelInt].y + " " +AOTD.storyLevels[AOTD.currentLevelInt].z);
								
							}
							if (AOTD.gameMode > 0){
								FlxG.switchState(new TitleState());
							}
						}
						
						
						
						close();
					},true);
					FlxG.sound.music.fadeOut();
	}
	function hitMS(ms:Int,el:Float):Bool{
		var hitted = false;
		
		if (ms >= FlxG.sound.music.time-el*2000 && ms <= FlxG.sound.music.time){
			hitted = true;
			
		}
		return hitted;
	}
	
	function calculateScore(player):Int{
		var score:Int = 0;
		score = Math.round(LevelState.players[player]._hp + LevelState.players[player].mp + (LevelState.players[player].coins)*5);
		return score;
	}
	
	function calculateRank(score):Int{
		var rank = 0;
		if (score > 200){
			rank = 1;
		}
		if (score > 300){
			rank = 2;
		}
		
		
		
		return rank;
	}
	
}