package dfl.display;

import aze.display.TileGroup;
import nme.display.Sprite;

/**
 * The Animation class is who keep all data about each animation.
 * You will need to pass the container property to a TileLayer
 * so it can be drawn with it batch system.
 * @author Rogério
 */

class Animation
{
	/**
	 * Indicates how many loops the animation will do.
	 * If loops is equal to 0, so the animation will run
	 * infinitely.
	 */
	public var loops: Int;
	
	/**
	 * Each animation have cells. Those cells are the same as the known frames.
	 * They also have an individual delay and can have more than one sprite.
	 */
	public var cells(default, null): Array<Cell>;
	
	/**
	 * The TileGroup container that is used to pass all the sprites to
	 * a TileLayer.
	 */
	public var container(default, null): TileGroup;
	
	private var _playing: Bool;
	private var _currLoop: Int;
	private var _currCell: Int;
	private var _cellTime: Float;
	
	/**
	 * The x position of the animation.
	 */
	public var x(getX, setX): Float;
	
	/**
	 * The y position of the animation.
	 */
	public var y(getY, setY): Float;
	
	private var _canAddSprites: Bool;

	/**
	 * You may not need to call this directly, as the animation is
	 * constructed from the Animations class.
	 * @param loops		How many times to repeat the animation.
	 */
	public function new( loops: Int )
	{
		this.loops = loops;
		
		cells = new Array<Cell>();
		cells.sort(function(a: Cell, b: Cell) {
			return (a.index - b.index);
		});
		
		container = new TileGroup();
		
		_playing = true;
		_currLoop = 0;
		_currCell = 0;
		_cellTime = 0;
		
		_canAddSprites = true;
	}
	
	/**
	 * Call this to indicate you want to play the animation
	 */
	public function play(): Void
	{
		if (!_playing)
		{
			_playing = true;
		}
	}
	
	/**
	 * Call this to indicate you want to stop the animation.
	 * It will begin from the start. You need to call <code>play()</code> to
	 * make the animation run again.
	 */
	public function stop(): Void
	{
		if ( _playing )
		{
			_playing = false;
			_currLoop = 0;
			_currCell = 0;
			_cellTime = 0;
		}
	}
	
	/**
	 * Must be called from the main loop of the application. It will play or not the animation,
	 * as you want.
	 * @param dt		The delta time of each frame. Default value is <code>1</code>
	 */
	public function step( dt: Float = 1 ): Void
	{
		if (!_playing)
		{
			return;
		}
		
		if ( _currLoop <= loops )
		{

			if ( _currCell >= 0 && _currCell <= cells.length )
			{
				if ( _cellTime >= cells[_currCell].delay )
				{					
					// Remove all previous sprites from the container
					container.removeAllChildren();
					
					if ( _currCell < cells.length - 1)
					{
						_currCell++;
					}
					// End of animation cicle
					else
					{
						// Infinite loops
						if ( loops == 0 )
						{
							_currLoop = 0;
						}
						// Next loop
						else if( loops > 0 )
						{
							_currLoop++;					
						}
						_currCell = 0;
					}
					_cellTime = 0;
					
					_canAddSprites = true;
				}
				
				// Add all the sprites for this cell
				if ( _canAddSprites  )
				{
					for ( spr in cells[_currCell].sprs )
					{
						container.addChild( spr.tileSprite );
					}
					_canAddSprites = false;
				}
			}
			
			_cellTime += dt;
		}		
	}
	
	/**
	 * Used by the Animations class to add cells to the animation while
	 * parsing the anim xml file.
	 * @param cell		The <code>Cell</code> to add.
	 */
	public function addCell( cell: Cell ): Void
	{
		cells.push( cell );
	}
	
	private function setX( x: Float ): Float
	{
		return container.x = x;
	}
	
	private function setY( y: Float ): Float
	{
		return container.y = y;
	}
	
	private function getX(): Float
	{
		return container.x;
	}
	
	private function getY(): Float
	{
		return container.y;
	}
}