package;
import flixel.*;
import animateatlas.AtlasFrameMaker;
import flixel.group.FlxSpriteGroup;
import hscript.Expr;
import hscript.Interp;
import hscript.Parser;
import states.LevelState;
#if desktop
import sys.FileSystem;
import sys.io.File;
#end
/**
 * ...
 * @author bbpanzu
 */
class AOTDAnimation extends FlxSpriteGroup
{
	var parser:Parser;
	var interp:Interp;
	var program:Expr;
	public var linkedPlayer = 0;
	var updf:Void->Void;
	var frmf:Void->Void;
	var endf:Void->Void;
	var me:AOTDAnimation;
	
	var iscript:String = "";
	public var sprite:FlxSprite;
	public var ended = false;
	public var scripted = false;
	public function new(animationName:String = "test",fps:Int = 30,linkedPlayer:Int = 0) 
	{
		super();
		me = this;
		this.linkedPlayer = linkedPlayer;
		
		sprite = new FlxSprite();
		sprite.frames = AtlasFrameMaker.construct("assets/animations/" +animationName);
		//trace("f:"+sprite.frames);
		sprite.animation.addByPrefix("anim", animationName, fps,false);
		sprite.animation.play("anim");
		sprite.animation.callback = onFrame;
		add(sprite);
		sprite.animation.finishCallback = onEnd;
		
		
		if(AOTD.fileExists("assets/animations/"+animationName+"/script.hx")){
			scripted = true;
			interp = new Interp();
			parser = new Parser();
			program = parser.parseString(AOTD.getTextFile("assets/animations/" + animationName+"/script.hx"));
			interp.execute(program);
		
			interp.variables.set("setP", setP);
			interp.variables.set("getP", getP);
			interp.variables.set("self", this);
			interp.variables.set("removeSelf", removeSelf);
			interp.variables.set("FlxG", FlxG);
			interp.variables.set("x",x);
			interp.variables.set("add",add);
			interp.variables.set("copy",copy);
			interp.variables.set("y",y);
			interp.variables.set("curFrame",sprite.animation.curAnim.curFrame);
			interp.variables.set("player",linkedPlayer);
			interp.variables.set("Math",Math);
			interp.variables.set("random", function(min, max){
				return FlxG.random.float(min, max);
			});
			interp.variables.set("AOTD",AOTD);
			interp.variables.set("Game",LevelState);
			frmf = interp.variables.get("frame");
			updf = interp.variables.get("update");
			endf = interp.variables.get("end");
		}else{
			trace("No script.hx with this sprite.animation.");
		}
	}
	public function copy(sprite:FlxSprite = null){
		trace("called func");
		var newSprite:FlxSprite = new FlxSprite(0, 0);
		trace("made sprite");
		newSprite.loadGraphicFromSprite(sprite);
		trace("added graphic");
		add(newSprite);
		trace("put sprite");
		return newSprite;
	}
	override public function update(elapsed:Float):Void 
	{
		if(scripted){
			interp.variables.set("x",x);
			interp.variables.set("y",y);
			interp.variables.set("curFrame",sprite.animation.curAnim.curFrame);
			interp.variables.set("player",linkedPlayer);
		
		if(updf != null)updf();
		}
		super.update(elapsed);
	}
	function setFunctions(update=null,frame=null){
		updf = update;
		frmf = frame;
		trace("did a thing");
		
	}
	function onFrame(name=null,fn=null,fi=null){
		if(scripted){
		if (frmf != null) frmf();
		}
			
	}
	
	function onEnd(name=null){
		if(scripted){
		if (endf != null) endf();
		}
		ended = true;
	}
	
	function removeSelf(){
		me.removeSelf();
	}
	
	public function setP(instance,variable:String,value:Dynamic){//stollen from FNF Psych Engine.
		var killMe:Array<String> = variable.split('.');
			if(killMe.length > 1) {
				var coverMeInPiss:Dynamic = Reflect.getProperty(instance, killMe[0]);
				for (i in 1...killMe.length-1) {
					coverMeInPiss = Reflect.getProperty(coverMeInPiss, killMe[i]);
				}
				return Reflect.setProperty(coverMeInPiss, killMe[killMe.length-1], value);
			}
			return Reflect.setProperty(instance, variable, value);
	}
	public function getP(instance,variable:String){//stollen from FNF Psych Engine.
		var killMe:Array<String> = variable.split('.');
			if(killMe.length > 1) {
				var coverMeInPiss:Dynamic = Reflect.getProperty(instance, killMe[0]);
				for (i in 1...killMe.length-1) {
					coverMeInPiss = Reflect.getProperty(coverMeInPiss, killMe[i]);
				}
				return Reflect.getProperty(coverMeInPiss, killMe[killMe.length-1]);
			}
			return Reflect.getProperty(instance, variable);
	}
	
}