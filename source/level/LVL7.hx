package level;
import states.*;
import flixel.*;
import flixel.group.*;
import enums.CamFollowType;
/**
 * ...
 * @author bbpanzu
 */
class LVL7 extends LevelState
{

	public function new() 
	{
		LevelState.room = "lvl7";
		LevelState.currentLevel = this;
		super();
	}
	
	override public function createLevel() 
	{
		super.createLevel();
		LevelState.th = 0;
		
		
		LevelState.spawnPoint.set(115, 652, 800);
		FlxG.sound.playMusic("assets/mus/lvl7.ogg");
		var bgg:FlxSprite = new FlxSprite(0, 0);
		bgg.loadGraphic("assets/sprites/bg/lvl7/lvl7_backdrop.png");
		bgg.scrollFactor.set(0.25, 1);
		add(bgg);
		
		var trees:Array<FlxSprite> = new Array<FlxSprite>();
		
		
		var treees:Array<FlxSprite> = new Array<FlxSprite>();
		
		for (u in 0...4){
			var t:FlxSprite = new FlxSprite().loadGraphic("assets/sprites/bg/lvl7/trees.png");
			trees.push(t);
			LevelState.effects.add(trees[u]);
		}
		
		for (i in 0...2){
			var t:FlxSprite = new FlxSprite(0, 0).loadGraphic("assets/sprites/bg/lvl7/treees.png");
			treees.push(t);
			LevelState.effects.add(treees[i]);
			
		}
		
		
		trees[0].setPosition(-3,450);
		trees[1].setPosition(-46,531);
		trees[2].setPosition(1059,650);
		trees[3].setPosition(1059, 650);
		
		treees[0].setPosition(2176,432);
		treees[1].setPosition(2177, 576);
		
		
		/*
		var cube1:FlxSprite = new FlxSprite(80, 96);
		cube1.loadGraphic("assets/sprites/bg/07/testroom_t1.png");
		LevelState.bg.add(cube1);
		
		
		
		
		var cube2:Entity = new Entity(242, 256, 0);
		cube2._noclip = true;
		cube2._float = true;
		cube2._showshadow = false;
		cube2.loadGraphic("assets/sprites/bg/test/testroom_t2.png");
		cube2.offset.y = 32;
		LevelState.world.add(cube2);
		
		var ball:Entity = new Entity(80, 230, 64);
		ball._bounce = 0.8;
		ball.loadGraphic("assets/sprites/misc/ball.png", false, 32, 32);
		ball.fixOffset();
		LevelState.world.add(ball);
		*/
	}
	
	
	override public function update(elapsed:Float) 
	{
		super.update(elapsed);
		
		for(pl in LevelState.players){
		if(pl._z < -128 && pl._x > 2700 && pl._x < 3150){
				if(pl._x < 2975){
					pl._y = 675;
					pl._x = 2650;
					pl._z = 168;
				}else{
					pl._y = 675;
					pl._x = 2650;
					pl._z = 168;
				}
				//AOTD.camFollowType = CamFollowType.STRICT;
			}
			if(pl._z < -128 && pl._x > 3200){
					pl._z = 320;
					pl._y = 535;
					pl._x = 3224;
					pl._hp -= 8;
				//AOTD.camFollowType = CamFollowType.STRICT;
				
			}
		}
		
	}
	
}