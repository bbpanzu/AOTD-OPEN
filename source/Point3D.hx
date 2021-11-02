package;
import flixel.math.FlxPoint;
import flixel.*;

/**
 * ...
 * @author ...
 */
class Point3D
{
	public var _x:Float = 0;
	public var _y:Float = 0;
	public var _z:Float = 0;
	public function new(X:Float=0,Y:Float=0,Z:Float=0) 
	{
		_x = X;
		_y = Y;
		_z = Z;
	}
	
	public function set(X:Float=0,Y:Float=0,Z:Float=0) 
	{
		_x = X;
		_y = Y;
		_z = Z;
	}
	public function setByPoint(point:Point3D) 
	{
		_x = point._x;
		_y = point._y;
		_z = point._z;
	}
	
	public function getFlatCoords():FlxPoint{
		return new FlxPoint(_x, _y);
	}
}