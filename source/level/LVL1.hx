package level;
import states.*;
import flixel.*;
import level.*;
import gameobjects.Door;

/**
 * ...
 * @author bbpanzu
 */
class LVL1 extends LevelState
{
	public static var spawn:Point3D = new Point3D(450, 165, 2);
	public function new() 
	{
		super();
		LevelState.th = 128;
		LevelState.room = "lvl1";
		LevelState.currentLevel = this;
	}
	
	override public function createLevel() 
	{
		super.createLevel();
		//FlxG.sound.playMusic("assets/mus/lvl1.ogg");
		//spawnPoint.set(450, 165, 2);
		
		
		
		
		//var exit:Door = new Door(437, 129, 0, null, function(){
		//	LevelState.transScene("lvl1_house",LVL1_House.door);
		//});
		//add(exit);
		
		//var shop:Door = new Door(1585, 130, 24, null, function(){
		//	LevelState.toShop("houseshop",new Point3D(1585, 200, 24));
		//});
		//add(shop);
		
		//addToWorld(new Prop(570, 184, 0, "trashcan"));
		//addToWorld(new Prop(560, 186, 0, "trashbag"));
		//addToWorld(new Prop(500, 187, 0, "box"));
		
		//addToWorld(new Prop(1090, 184, 0, "trashcan"));
		//addToWorld(new Prop(1080, 186, 0, "trashbag"));
		//addToWorld(new Prop(970, 187, 0, "box"));
		
		
		
		/*
		 
		/add prop 570 184 0 trashcan
/add prop 560 186 0 trashbag
/add prop 500 187 0 box
/add door 437 129 0 toHouse
/add door 437 129 0 toShop1
/add npc 1059 195 0 1
/add npc 1865 162 3
		
		
		
		
	
		
		
		
		AOTD.parseCommand("/add enemy zombie 1020 250 0 220 wait 1");
		AOTD.parseCommand("/add enemy tinydemon 1060 250 0 220 wait 1");
		AOTD.parseCommand("/add enemy zombie 1050 260 0 220 wait 1");
		AOTD.parseCommand("/add enemy tinydemon 1040 250 0 220 wait 1");
		AOTD.parseCommand("/add enemy tinydemon 1020 230 0 220 wait 1");
		
		
		AOTD.parseCommand("/add enemy 0 2020 250 35 220 wait 1");
		AOTD.parseCommand("/add enemy 2 2060 450 35 220 wait 1");
		AOTD.parseCommand("/add enemy 0 2050 260 35 220 wait 1");
		AOTD.parseCommand("/add enemy 0 2070 280 35 220 wait 1");
		AOTD.parseCommand("/add enemy 2 2040 250 35 220 wait 1");
		AOTD.parseCommand("/add enemy 2 2020 230 35 220 wait 1");
		*/
		
	}
	
	override public function update(elapsed:Float) 
	{
		super.update(elapsed);
	}
	
	
}