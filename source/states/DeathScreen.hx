package states;
import flixel.*;
import states.*;
import level.*;

/**
 * ...
 * @author bbpanzu
 */
class DeathScreen extends AOTDState
{
	var choice = false;
	
	var choices:FlxSprite = new FlxSprite();
	public function new() 
	{
		super();
	}
	
	override public function create():Void 
	{
		
		super.create();
		LevelState.instance = null;
		choices.loadGraphic("assets/sprites/bg/gameover/CHOICES.png", true, 128, 16);
		choices.animation.add("false", [0], 0);
		choices.animation.add("true", [1], 0);
		var bg:FlxSprite = new FlxSprite().loadGraphic("assets/sprites/bg/gameover/gameover.png");
		var gameover:FlxSprite = new FlxSprite().loadGraphic("assets/sprites/bg/gameover/GAMEOVER_TITLE.png");
		add(bg);
		add(gameover);
		LevelState.inCombat = false;
		FlxG.sound.playMusic(AOTD.getMusic("gameover"));
		
		add(choices);
		gameover.scale.x = 6;
		gameover.scale.y = 6;
		gameover.screenCenter();
		gameover.y -= 12;
		choices.screenCenter();
		choices.y = FlxG.height - choices.height - 32;
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		if(FlxG.keys.anyJustPressed(AOTD.keysets[0].LEFT) || FlxG.keys.anyJustPressed(AOTD.keysets[0].RIGHT)){
			choice = !choice;
			choices.animation.play(Std.string(choice));
		}
		
		if (FlxG.keys.anyJustPressed(AOTD.keysets[0].PUNCH)){
			for(i in AOTD.playerData){
				i.hp = 150;
				i.mp = 0;
				i.coins = 0;
				i.dead = false;
			}
			switch (choice){
				case false:
					
					FlxG.sound.playMusic(AOTD.getMusic(LevelState.music));
					LevelState.transScene(LevelState.room,new Point3D(FlxG.save.data.playerData[0].x,FlxG.save.data.playerData[0].y,FlxG.save.data.playerData[0].z));
				case true:
					FlxG.switchState(new TitleState());
			}
		}
		
		
	}
	
}