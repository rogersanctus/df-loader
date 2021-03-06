package dfl.display;

/**
 * This class is only to keep the animation on the way
 * DarkFunction do animations.
 * It also automatically sort the sprites on it by the z value
 * of each sprite.
 * @author rogersanctus
 */
class DfCell
{
	/**
	 * The index of this Cell on the animation. The order in which
	 * it will be drawn.
	 */
	public var index(default, null): Int;	
	
	/**
	 * The delay time to this sprite before other one can be drawn.
	 */
	public var delay(default, null): Float;
	
	/**
	 * The sprite list for this cell.
	 */
	public var sprs(default, null): Array<DfSprite>;	
	
	/**
	 * This constructed is called from Animations class
	 * @param index			The index for this cell.
	 * @param delay			The time to wait drawing this cell before draw another cell.
	 */
	public function new( index: Int, delay: Float )
	{
		this.index = index;
		this.delay = delay;
		sprs = new Array<DfSprite>();
		
		/*
		 * Sort on z value. The lesser the value, first
		 * the sprite will be on the list
		 */
		sprs.sort( function(spr1: DfSprite, spr2: DfSprite){
			return spr2.z - spr1.z;
		});
	}
	
	/**
	 * Add a CellSprite in this Cell sprites list.
	 */
	public function addSprite( spr: DfSprite ): Void
	{
		sprs.push(spr);
	}
	
	/**
	 * Clones the Cell
	 * @return		A new instance of the <code>DfCell</code> data.
	 */
	public function clone(): DfCell
	{
		var cloneCell = new DfCell( this.index, this.delay );
		
		for ( spr in sprs )
		{
			cloneCell.addSprite( spr.clone() );
		}
		
		return cloneCell;
	}
}