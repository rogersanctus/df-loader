package dfl.display;

import aze.display.TileSprite;

/**
 * This class represent a sprite in a <code>Cell</code>.
 * @author Rogério
 */

class CellSprite
{
	/**
	 * The sprite name
	 */
	public var name(default, null): String;
	
	/** 
	 * The x position of the sprite on it animation container.
	 */
	public var x(default, null): Int;
	
	/** 
	 * The y position of the sprite on it animation container.
	 */
	public var y(default, null): Int;
	
	/** 
	 * The order to draw this sprite.
	 */
	public var z(default, null): Int;
	
	/**
	 * The angle of rotation of this sprite.
	 */	 
	public var angle(default, null): Float;
	
	/**
	 * If to flip or not the sprite horizontally.
	 */
	public var flipH(default, null): Bool;
	
	/**
	 * If to flip or not the sprite vertically.
	 */
	public var flipV(default, null): Bool;
	
	/**
	 * The TileSprite representing this sprite.
	 */
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

		// Angle comes in degrees, so convert it to radians
		tileSprite.rotation = angle * Math.PI / 180;
		
		if (flipH) tileSprite.scaleX = -tileSprite.scaleX;
		if (flipV) tileSprite.scaleY = -tileSprite.scaleY;
	}
}