package level;
import level.*;
import states.*;
import flixel.*;
import enemy.Zombie;
import gameobjects.Door;

/**
 * ...
 * @author bbpanzu
 */
class LVL1_House extends LevelState 
{
	var triggered = false;
	var upstairs:Bool = false;
	
	public static var spawn:Point3D = new Point3D(300, 440, 2);
	public static var door:Point3D = new Point3D(800, 440, 2);
	
	
	public function new() 
	{
		
		LevelState.room = "lvl1_house";
		super();
		LevelState.th = 128;
		LevelState.currentLevel = this;
	}
	
	
	override public function createLevel() 
	{
		super.createLevel();
		FlxG.sound.playMusic("assets/mus/lvl1.ogg");
		//LevelState.spawnPoint.set(300, 440, 2);
		
		LevelState.camBound.set(177,257,779,270);
		
		
		var light:FlxSprite = new FlxSprite();
		light.loadGraphic("assets/sprites/bg/lvl1_house/lvl1_house_shadow.png");
		
		LevelState.effects.add(light);
		
		var ups:Door = new Door(368, 380, 0, null, function(){
			go(true);
		});
		var dns:Door = new Door(166, 265, 0, null, function(){
			go(false);
		});
		var exit:Door = new Door(880, 441, 0, null, function(){
			LevelState.transScene("lvl1",LVL1.spawn);
		});
		var exit2:Door = new Door(246, 437, 0, null, function(){
			LevelState.transScene("lvl2",new Point3D(64,440,0));
		});
		
		add(dns);
		add(ups);
		add(exit);
		add(exit2);
		AOTD.parseCommand("/add enemy zombie 520 450 0 64 wait 1");
		//AOTD.parseCommand("/add door 520 400 0 level lvl2 64,440,0");
		//zom._z = 128;
		//zom._y = 440;
	}
	
	
	
	override public function update(elapsed:Float) 
	{
		super.update(elapsed);
		
		if (upstairs){
			LevelState.camBound.set(135, -30, 543, 270);
		}else{
			LevelState.camBound.set(177,257,779,270);
		}
		
		
			//
		if (LevelState.camfollow.x > 400 && LevelState.camfollow.x < 420 && !triggered && !upstairs){
			triggered = true;
			
		}
	}
	
	
	public function go(upstairs:Bool = true){
		if (upstairs){
			this.upstairs = true;
			AOTD.parseCommand("/player all pos 184 200 0");
		}else{
			this.upstairs = false;
			AOTD.parseCommand("/player all pos 365 440 0");
		}
	}
	
}