package;

/**
 * ...
 * @author bbpanzu
 */
class ShopData 
{
	public var _name:String = "";
	public var _cost:Float = 0;
	public var _hp:Float = 0;
	public var _mp:Float = 0;
	public var _desc:String = "";
	public function new(NAME:String="",COST:Float=0,HP:Float=0,MP:Float=0,DESC:String="") 
	{
		_name = NAME;
		_cost = COST;
		_hp = HP;
		_mp = MP;
		_desc = DESC;
	}
	
}