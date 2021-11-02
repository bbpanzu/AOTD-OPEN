package level;
import states.*;
import flixel.*;
import enemy.Zombie;
import gameobjects.Door;
import shaders.*;

/**
 * ...
 * @author bbpanzu
 */
class LVL_Test extends LevelState
{

	public static var spawn:Point3D = new Point3D(100, 225, 0);
	
	public var ball:Prop;
	public static var instance:LVL_Test;
	public function new() 
	{
		super();
		LVL_Test.instance = this;
		LevelState.th = 128;
		LevelState.room = "testroom";
		LevelState.currentLevel = this;
	}
	
	override public function createLevel() 
	{
		super.createLevel();
		
		
		var cube1:FlxSprite = new FlxSprite(80, 96);
		cube1.loadGraphic("assets/sprites/bg/testroom/testroom_t1.png");
		LevelState.bg.add(cube1);
		
		
		/*
		var data:Xml = Xml.parse(Assets.getText("assets/maps/" + room + ".xml"))
		
		var f:Entity = data.
		*/
		
		var cube2:Entity = new Entity(242, 256, 0);
		cube2._noclip = true;
		cube2._float = true;
		cube2._showshadow = false;
		cube2.sprite.loadGraphic("assets/sprites/bg/testroom/testroom_t2.png");
		cube2.sprite.offset.y = 32;
		LevelState.world.add(cube2);
		
		ball  = new Prop(80, 230, 64,"ball");
		LevelState.world.add(ball);
		
		
		
		//var zombie:Zombie = new Zombie(400, 240, 160, 160,"wait");
		//addToWorld(zombie);
		
		//AOTD.parseCommand("/add enemy 2 400 230 0 160");
		
		var exit:Door = new Door(40, 173, 0, null, function(){
			LevelState.toShop("testshop",new Point3D(40,230,0));
		});
		add(exit);
		
	}
	
	
	override public function update(elapsed:Float) 
	{
		super.update(elapsed);
		
	}
}