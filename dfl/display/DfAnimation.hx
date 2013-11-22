package dfl.display;
import dfl.display.DfRenderer;
import flash.display.Sprite;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Transform;


/**
 * A named Animation described by the DarkFunction anim Xml file.
 * @author rogersanctus
 */
class DfAnimation extends DfBasicContainer
{
	/**
	 * The animation name.
	 */
	public var name(default, null): String;
	
	/**
	 * Whereas to flip or not the animation horizontally. Only change this when you
	 * have added the animation to the renderer object.
	 */
	public var flipH(default, set): Bool;
	
	/**
	 * Whereas to flip or not the animation vertically. Only change this when you
	 * have added the animation to the renderer object.
	 */
	public var flipV(default, set): Bool;
	
	/**
	 * The rotation of the animation. Not working good to more than one sprites per cell(frame)
	 */	
	public var rotation(get, set): Float;
	
	private var _rotation: Float;
	private var _animationDef: DfAnimationDef;
	private var _playing: Bool;
	private var _currLoop: Int;
	private var _currCell: Int;
	private var _cellTime: Float;	
	private var _canAddSprites: Bool;

	/**
	 * Creates a new sprite with the name <code>name</code>.
	 * @param	name		The name of the animation.
	 */
	public function new( name: String )
	{
		super();
		
		this.name = name;		
		_animationDef = null;
		
		_playing = true;
		_currLoop = 0;
		_currCell = 0;
		_cellTime = 0;
		_rotation = 0;
		
		_canAddSprites = true;
	}
	
	override private function init(renderer:DfRenderer): Void 
	{
		if ( renderer == null )
		{
			return;
		}
		
		if ( renderer.contentDef.animations.anims.exists(name) )
		{
			// Gets an unique animationDef data.
			_animationDef = renderer.contentDef.animations.anims.get(name).clone();
		}else
		{
			trace("No animation with this name: " + name + " was found.");
		}		
		
		super.init( renderer );
		
		applyFlipH();
		applyFlipV();
		applyRotation();
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
			_cellTime = 0.0;
		}
	}
	
	/**
	 * Must be called from the main loop of the application or at least at once after
	 * the aniomation has been added to the renderer. It will play or not the animation,
	 * as you want.
	 * @param dt		The delta time of each frame. Default value is <code>1</code>
	 */
	public function step( dt: Float = 1 ): Void
	{		
		if ( Math.isNaN(dt) )
		{
			dt = 1;
		}
		
		if ( _animationDef == null || !_playing )
		{			
			return;
		}
		
		var loops = _animationDef.loops;
		var cells = _animationDef.cells;
		
		// Infinite loops
		if ( loops == 0 )
		{
			_currLoop = -1;
		}
		
		if ( _currLoop < loops )
		{
			if ( _currCell >= 0 && _currCell <= cells.length )
			{
				if ( _cellTime >= cells[_currCell].delay )
				{
					// Remove all previous sprites from the container
					removeAllChildren();
					
					if ( _currCell < cells.length - 1)
					{
						_currCell++;
					}
					// End of animation cicle
					else
					{						
						// Next loop
						if( loops > 0 )
						{
							_currLoop++;
						}
						// Don't go to the beginning if on the last loop
						if( _currLoop != loops )
						{
							_currCell = 0;
						}
					}
					_cellTime = 0;
					
					_canAddSprites = true;
				}
				
				// Add all the sprites for this cell
				if ( _canAddSprites  )
				{
					// Add sprites for cell from the end to the start
					// to be in the same order as shown on the DarkFunction editor
					//for ( spr in cells[_currCell].sprs )
					var sprs_length: Int = cells[_currCell].sprs.length;
					for( i_spr in 0 ... sprs_length )
					{
						var spr: DfSprite = cells[_currCell].sprs[ sprs_length - i_spr - 1 ];
						addChild( spr );
					}
					_canAddSprites = false;
				}
			}
		}
		_cellTime += dt;
	}	
	
	/**
	 * Flip the sprite horizontally.
	 * @param	flipH		Whether to flip or not
	 */
	private function set_flipH( flipH ): Bool
	{
		this.flipH = flipH;
		applyFlipH();
		
		return this.flipH;
	}
	
	/**
	 * Flip the sprite vertically.
	 * @param	flipV		Whether to flip or not
	 */
	private function set_flipV(flipV): Bool
	{
		this.flipV = flipV;
		applyFlipV();
		
		return this.flipV;
	}
	
	private function applyFlipH(): Void
	{
		if ( renderer != null )
		{
			// Apply the flip to all sprites of all the cells (frames)
			for ( cell in _animationDef.cells )
			{
				for ( spr in cell.sprs )
				{
					spr.flipH = this.flipH;
					var newXoffs = - width + Math.abs(width - spr.x);
					spr.x = newXoffs;
				}
			}
		}
	}
	
	private function applyFlipV(): Void
	{
		if ( renderer != null )
		{			
			// Apply the flip to all sprites of all the cells
			for ( cell in _animationDef.cells )
			{
				for ( spr in cell.sprs )
				{
					spr.flipV = this.flipV;
					var newYoffs = - height + Math.abs(height - spr.y);
					spr.y = newYoffs;
				}
			}
		}
	}
	
	private function get_rotation(): Float
	{
		return _rotation;
	}
	
	private function set_rotation( rotation: Float ): Float
	{
		_rotation = rotation;
		applyRotation();
		return _rotation;
	}	
	
	private function applyRotation(): Void
	{
		if ( renderer != null )
		{
			for( cell in _animationDef.cells )
			{
				for ( spr in cell.sprs )
				{				
					spr.rotation = rotation;
				}
			}
		}
	}
	
	/**
	 * Calculates the animation container width based on it's content.
	 * It wont work good at all cases.
	 * @return		The animation width.
	 */
	override private function get_width(): Float 
	{
		if ( _currCell >= 0 && _currCell < _animationDef.cells.length )
		{
			// Only one spr in this cell
			if ( _animationDef.cells[_currCell].sprs.length == 1 )
			{
				return _animationDef.cells[_currCell].sprs[0].bounds.width;
			}
			
			var minX: Float = Math.POSITIVE_INFINITY,
				maxX: Float = Math.NEGATIVE_INFINITY;
			
			for ( spr in _animationDef.cells[_currCell].sprs )
			{
				minX = Math.min( minX, spr.x + spr.bounds.left );
				maxX = Math.max( maxX, spr.x + spr.bounds.left + spr.bounds.width );
			}
			
			if ( maxX > minX )
			{
				return width = maxX - minX;
			}
		}
		return 0;
	}
	
	/**
	 * Calculates the animation container height based on it's content.
	 * It wont work good at all cases.
	 * @return		The animation height.
	 */
	override private function get_height(): Float 
	{
		if ( _currCell >= 0 && _currCell < _animationDef.cells.length )
		{
			// Only one spr in this cell
			if ( _animationDef.cells[_currCell].sprs.length == 1 )
			{
				return _animationDef.cells[_currCell].sprs[0].bounds.height;
			}
			
			var minY: Float = Math.POSITIVE_INFINITY,
				maxY: Float = Math.NEGATIVE_INFINITY;
			
			for ( spr in _animationDef.cells[_currCell].sprs )
			{
				minY = Math.min( minY, spr.y + spr.bounds.top );
				maxY = Math.max( maxY, spr.y + spr.bounds.top + spr.bounds.height );
			}
			
			if ( maxY > minY )
			{
				return height = maxY - minY;
			}
		}
		return 0;
	}	
}