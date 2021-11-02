package level;

/**
 * ...
 * @author bbpanzu
 */
class StoryData 
{
	public var character:String = "";
	public var unlocked:Bool = true;
	public var levelName:String = "";
	public var rank:Int = -1;
	public var initScene:String = "";
	public var x:Float = 0;
	public var y:Float = 0;
	public var z:Float = 0;
	public function new(character:String,unlocked:Bool,levelName:String,rank:Int,initScene:String,x:Float=0,y:Float=0,z:Float=0) 
	{
		this.character = character;
		this.unlocked = unlocked;
		this.levelName = levelName;
		this.rank = rank;
		this.initScene = initScene;
		this.x = x;
		this.y = y;
		this.z = z;
	}
	
}