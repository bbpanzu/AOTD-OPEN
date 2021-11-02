package level;
import flixel.*;
import gameobjects.Door;
import states.LevelState;

/**
 * ...
 * @author bbpanzu
 */
class Basement extends LevelState
{

	public static var spawn:Point3D = new Point3D(260, 180, 0);
	public static var door:Point3D = new Point3D(101,189,0);
	public function new() 
	{
		LevelState.room = "basement";
		LevelState.music = "basement";
		LevelState.spawnPoint.set(260, 180, 0);
		LevelState.th = 128;
		LevelState.currentLevel = this;
		super();
		
	}
	
	override public function createLevel() 
	{
		FlxG.sound.playMusic("assets/mus/basement.ogg");
		super.createLevel();
		var couch:Entity = new Entity(234, 130, 0);
		couch._weight = 0.2;
		couch._bounce = 0.3;
		couch.sprite.loadGraphic("assets/sprites/bg/basement/couch.png");
		couch.sprite.offset.set(76, 30);
		couch._showshadow = false;
		
		LevelState.world.add(couch);
		
		var tv:Entity = new Entity(318, 228, 0);
		tv.sprite.loadGraphic("assets/sprites/bg/basement/tv.png");
		tv.sprite.offset.set(18, 80);
		tv._showshadow = false;
		LevelState.world.add(tv);
		/*
		var light:FlxSprite = new FlxSprite();
		light.loadGraphic("assets/sprites/bg/basement/basement_shadow.png");
		
		LevelState.effects.add(light);
		
		
		var exit:Door = new Door(11, 173, 32, null, function(){
			LevelState.transScene("lvl1_house",LVL1_House.spawn);
		});
		add(exit);*/
		
		
	}
	
	
	override public function update(elapsed:Float) 
	{
		super.update(elapsed);
		
		
		
	}
	
}