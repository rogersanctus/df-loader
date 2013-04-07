package dfl.display;

/**
 * ...
 * @author Rogério
 */

class Cell
{
	public var index(default, null): Int;	
	public var delay(default, null): Float;	
	public var sprs(default, null): Array<CellSprite>;	
	
	public function new( index: Int, delay: Float )
	{
		this.index = index;
		this.delay = delay;
		sprs = new Array<CellSprite>();
		
		/*
		 * Sort on z value. The lesser the value, first
		 * the sprite will be on the list
		 */
		sprs.sort( function(spr1: CellSprite, spr2: CellSprite){
			return spr2.z - spr1.z;
		});
	}
	
	public function addSprite( spr: CellSprite )
	{
		sprs.push(spr);
	}
}