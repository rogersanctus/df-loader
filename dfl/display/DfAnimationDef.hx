package dfl.display;
import flash.display.Sprite;
import flash.events.Event;

/**
 * The <code>DfAnimation</code> class is who keep all data about each animation.
 * You will need to pass the container property to a <code>DfRenderer</code>
 * so it can be drawn.
 * @author rogersanctus
 */
class DfAnimationDef
{
	/**
	 * The number of repetitions that will be done by the animation.
	 * Pass 0 to infinite repetitions.
	 */
	public var loops(default, null): Int;
	
	/**
	 * Each animation have cells. Those cells are the same as the known frames.
	 * They also have an individual delay and can have more than one sprite.
	 */
	public var cells(default, null): Array<DfCell>;
	
	/**
	 * You may not need to call this directly, as the animation is
	 * constructed from the <code>DfAnimations</code> class.
	 * @param loops		How many times to repeat the animation.
	 */
	public function new( loops: Int )
	{
		this.loops = loops;
		
		cells = new Array<DfCell>();
		cells.sort(function(a: DfCell, b: DfCell) {
			return (a.index - b.index);
		});
	}	
	
	/**
	 * Used by the Animations class to add cells to the animation while
	 * parsing the anim xml file.
	 * @param cell		The <code>DfCell</code> to add.
	 */
	public function addCell( cell: DfCell ): Void
	{
		cells.push( cell );
	}
	
	/**
	 * Clones the AnimationDef data
	 * @return		A new instance of the <code>DfAnimationDef</code> data.
	 */
	public function clone(): DfAnimationDef
	{
		var cloneAnimdef = new DfAnimationDef( this.loops );
		for ( cell in cells )
		{
			cloneAnimdef.addCell( cell.clone() );
		}	
		
		return cloneAnimdef;
	}
}