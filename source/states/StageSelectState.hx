package states;
import flixel.*;
import flixel.effects.FlxFlicker;
import flixel.text.FlxBitmapText;
import flixel.tweens.FlxTween;

/**
 * ...
 * @author bbpanzu
 */
class StageSelectState extends AOTDState
{
	var level:FlxBitmapText;
	var levelName:FlxBitmapText;
	var stage:FlxSprite;
	var spots:Array<Int> = [15, 85, 142, 195, 233, 276, 323, 394, 467];
	var chosen:Bool = false;
	var tick:FlxSprite;
	public function new() 
	{
		super();
	}
	
	override public function create():Void 
	{
		super.create();
		
		var bg:FlxSprite = new FlxSprite(0,-135).loadGraphic("assets/sprites/bg/menu/bg.png");
		add(bg);
		level = new FlxBitmapText(Font.THICK);
		levelName = new FlxBitmapText(Font.SMALL);
		
		level.text = "LEVEL 1";
		levelName.text = "";
		tick = new FlxSprite(0, 100);
		tick.loadGraphic("assets/sprites/misc/tick.png", false);
		add(tick);
		var bgstage:FlxSprite = new FlxSprite().loadGraphic("assets/sprites/misc/stageselect.png", true, 480, 96);
		bgstage.animation.add("ff", [9], 0, false);
		bgstage.animation.play("ff");
		bgstage.screenCenter();
		add(bgstage);
		stage = new FlxSprite(0, 0).loadGraphic("assets/sprites/misc/stageselect.png", true, 480, 96);
		stage.animation.add("lvl", [0, 1, 2, 3, 4, 5, 6, 7, 8], 0, false);
		stage.animation.play("lvl", true, false, 0);
		stage.screenCenter();
		level.screenCenter(Y);
		add(stage);
		add(level);
		add(levelName);
		levelName.screenCenter(Y);
		AOTD.currentLevelInt = 0;
		level.x += 2;
		level.y += 20;
		levelName.x += 2;
		levelName.y += 50;
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		tick.x = spots[AOTD.currentLevelInt];
		if (!chosen){
			if (FlxG.keys.anyJustPressed(AOTD.keysets[0].RIGHT)){
				AOTD.currentLevelInt ++;
				FlxG.sound.play(AOTD.getSFX("sfx_hud_hover"));
				if (AOTD.currentLevelInt == 9) AOTD.currentLevelInt = 8;
				//if (!AOTD.storyLevels[AOTD.currentLevelInt].unlocked) AOTD.currentLevelInt--;
				
			}
			if (FlxG.keys.anyJustPressed(AOTD.keysets[0].LEFT)){
				AOTD.currentLevelInt --;
				FlxG.sound.play(AOTD.getSFX("sfx_hud_hover"));
				if (AOTD.currentLevelInt == -1) AOTD.currentLevelInt = 0;
			}
			
			
			if (FlxG.keys.anyJustPressed(AOTD.keysets[0].PUNCH)){
				if(AOTD.storyLevels[AOTD.currentLevelInt].unlocked){
				chosen = true;
				FlxG.sound.play(AOTD.getSFX("sfx_hud_start"));
				FlxG.sound.music.stop();
				FlxFlicker.flicker(stage);
				FlxTween.tween(FlxG.camera.scroll, {y: -270}, 1, {onComplete:go});
				}else{
					FlxG.sound.play(AOTD.getSFX("sfx_hud_disabled"));
					
				}
			}
			
		}
			stage.animation.play("lvl", true, false, AOTD.currentLevelInt);
			level.text = "LEVEL " + (AOTD.currentLevelInt + 1);
			levelName.text = AOTD.storyLevels[AOTD.currentLevelInt].levelName;
		
			if (!AOTD.storyLevels[AOTD.currentLevelInt].unlocked){
			level.text = "LEVEL " + (AOTD.currentLevelInt + 1) + "(LOCKED)";
			levelName.text = "BEAT LEVEL "+ (AOTD.currentLevelInt) +" IN STORY MODE TO UNLOCK THIS LEVEL";
				
			}
		
	}
	
	
	public function go(e:FlxTween=null){
		AOTD.parseCommand("/ts " + AOTD.storyLevels[AOTD.currentLevelInt].initScene + " " +AOTD.storyLevels[AOTD.currentLevelInt].x + " " +AOTD.storyLevels[AOTD.currentLevelInt].y + " " +AOTD.storyLevels[AOTD.currentLevelInt].z);
	}
	
}