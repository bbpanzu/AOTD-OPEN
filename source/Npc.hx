package;
import openfl.display.BitmapData;
import states.LevelState;

/**
 * ...
 * @author ...
 */
class Npc extends Entity
{

	public function new(X,Y,Z,id:UInt,frames:Int) 
	{
		super(X, Y, Z);
		var bitmap:BitmapData = BitmapData.fromFile("assets/sprites/npc/npc"+id+".png");
		_noclip = true;
		sprite.offset.x = 20;
		sprite.offset.y = 70;
		sprite.loadGraphic(bitmap, true, 64, 72);
		sprite.animation.add("idle", [0, 1, 2], 8, true);
		sprite.animation.play("idle");
		LevelState.world.add(this);
		_update = false;
	}
	
}