package dfl.display;
import nme.display.Sprite;
import nme.events.Event;

/**
 * The Animation class is who keep all data about each animation.
 * You will need to pass the container property to a TileLayer
 * so it can be drawn with it batch system.
 * @author Rogério
 */
class DfAnimationDef// extends DfBasicContainer
{
	public var loops: Int;
	
	/**
	 * Each animation have cells. Those cells are the same as the known frames.
	 * They also have an individual delay and can have more than one sprite.
	 */
	public var cells(default, null): Array<DfCell>;
	
	/**
	 * You may not need to call this directly, as the animation is
	 * constructed from the Animations class.
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
}