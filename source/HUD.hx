package;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import states.*;
import hud.PlayerHud;
/**
 * ...
 * @author ...
 */
class HUD extends FlxSpriteGroup
{
	public var playerHud:Array<PlayerHud> = [];
	public function new(HUDTYPE:UInt=0) 
	{
		super();
		
		
		scrollFactor.set();
		setHud(HUDTYPE);
		
		
	}
	
	
	public function setHud(type:UInt){
		this.clear();
		switch(type){
			case 0:
				
			
				
				
		}
	}
	
}