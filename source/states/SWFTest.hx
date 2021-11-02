package states;
import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxFrame;
import flixel.graphics.frames.FlxFramesCollection;
import flixel.math.FlxRect;
import openfl.Assets;
import openfl.display.BitmapData;
import openfl.display.MovieClip;
import openfl.geom.Matrix;

/**
 * ...
 * @author bbpanzu
 */
class SWFTest extends AOTDState
{
	public var frames:Array<BitmapData> = [];
	public function new() 
	{
		
		super();
		Assets.loadLibrary ("force_michael").onComplete (function (_) {
	
			trace ("SWF library loaded");
		var clip = Assets.getMovieClip ("force_michael:force_michael");
			trace ("SWF library loaded");
		var sp:FlxSprite = new FlxSprite();
			trace ("SWF library loaded");
		
		var bitch = new BitmapData(480, 270,true,0);
			trace ("SWF library loaded");
		bitch.drawWithQuality(clip);
			trace ("SWF library loaded");
			trace ("SWF library loaded");
		
				var frameCollection = new FlxFramesCollection(FlxGraphic.fromBitmapData(bitch),FlxFrameCollectionType.IMAGE);
				var largeBitmap:BitmapData = new BitmapData(480*clip.totalFrames, 280, true, 0);
					trace(clip.totalFrames);
				for (i in 0...clip.totalFrames){
					clip.gotoAndStop(i + 1);
					frames.push(new BitmapData(480, 270, false, 0));
					largeBitmap.drawWithQuality(clip,new Matrix(1,0,0,1,480*i,0),null,null,null,false,"low");
				}
				sp.loadGraphic(largeBitmap, true, 480, 270);
				trace(getframes(clip.totalFrames));
				sp.animation.add("balls", getframes(clip.totalFrames),30, true);
				sp.animation.play("balls");
			
			
			
		add(sp);
			
		});
		
	}
	
	
	function getframes(r):Array<Int>{
		var a:Array<Int> = [];
		
		for (i in 0...r){
			
			a.push(i);
			
		}
			return a;
	}
	
}