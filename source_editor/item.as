package  {
	
	import flash.display.MovieClip;
	
	
	public class item extends MovieClip {
		public var _x:Number = 0
		public var _y:Number = 0
		public var _z:Number = 0
		public var _floor:Number = 0
		public var me:item
		public var _type:String = "prop"
		
		public var _prop:String = "trashcan"
		public var _doortype:String = "shop"
		public var _doorto:String = "lvl x,y,z"
		
		public var _enemy = "zombie"
		public var _waittospawn:Boolean = true
		
		public var _sprite:String = ""
		public var _ofsx:int = 0;
		public var _ofsy:int = 0;
		
		public function item() {
			// constructor code
		}
	}
	
}
