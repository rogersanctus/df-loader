package dfl.display;

import aze.display.TileSprite;

/**
 * ...
 * @author Rogério
 */

class CellSprite
{
	public var name(default, null): String;
	public var x(default, null): Int;
	public var y(default, null): Int;
	public var z(default, null): Int;
	public var angle(default, null): Float;
	public var flipH(default, null): Bool;
	public var flipV(default, null): Bool;
	
	public var tileSprite(default, null): TileSprite;

	public function new(sprName: String, x: Int, y: Int, z: Int, angle: Float = 0.0, flipH: Bool = false, flipV: Bool = false )
	{
		this.name = sprName;
		this.x = x;
		this.y = y;
		this.z = z;
		this.angle = angle;
		this.flipH = flipH;
		this.flipV = flipV;
		
		tileSprite = new TileSprite(sprName);
		tileSprite.x = x;
		tileSprite.y = y;
		// Angle com in degrees, so convert to radians
		tileSprite.rotation = angle * Math.PI / 180;
		
		if (flipH) tileSprite.scaleX = -tileSprite.scaleX;
		if (flipV) tileSprite.scaleY = -tileSprite.scaleY;
	}
}