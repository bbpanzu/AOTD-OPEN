package;

/**
 * ...
 * @author bbpanzu
 */
class HitboxData 
{

	public var kbx:Float;
	public var kby:Float;
	public var hitlag:Float;
	public var hitstun:Float;
	public var dmg:Float;
	public var enabled:Bool = true;
	public function new(dmg:Float, kbx:Float, kby:Float, hitlag:Int, hitstun:Int){
		this.dmg = dmg;
		this.kbx = kbx;
		this.kby = kby;
		this.hitlag = hitlag;
		this.hitstun = hitstun;
	}
	public function setDamageData(dmg:Float, kbx:Float, kby:Float, hitlag:Int, hitstun:Int){
		this.dmg = dmg;
		this.kbx = kbx;
		this.kby = kby;
		this.hitlag = hitlag;
		this.hitstun = hitstun;
	}
	
}