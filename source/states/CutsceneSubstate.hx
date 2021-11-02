package states;
import flixel.FlxG;
import flixel.FlxSubState;

/**
 * ...
 * @author bbpanzu
 */
class CutsceneSubstate extends FlxSubState
{
	var anim:AOTDAnimation;
	public function new(animationName:String = "test",fps:Int = 30,linkedPlayer:Int = 0) 
	{
		super();
				LevelState.instance.persistentUpdate = false;
				LevelState.canPause = false;
				anim = new AOTDAnimation(animationName, fps, linkedPlayer);
				anim.scrollFactor.set();
				add(anim);
	}
	
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		if (anim.ended){
				LevelState.canPause = true;
				LevelState.instance.persistentUpdate = true;
			close();
		}
	}
	
}