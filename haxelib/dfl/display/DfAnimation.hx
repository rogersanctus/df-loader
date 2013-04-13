package dfl.display;
import dfl.display.DfRenderer;
import nme.display.Sprite;
import nme.geom.Matrix;
import nme.geom.Point;
import nme.geom.Transform;


/**
 * ...
 * @author Rogério
 */

class DfAnimation extends DfBasicContainer
{
	/**
	 * The animation name.
	 */
	public var name(default, null): String;
	
	/**
	 * Whereas to flip or not the animation horizontally.
	 */
	public var flipH(default, setFlipH): Bool;
	
	/**
	 * Whereas to flip or not the animation vertically.
	 */
	public var flipV(default, setFlipV): Bool;
	
	/**
	 * Not working good to more than one sprites per cell(frame)
	 */
	public var rotation(getRotation, setRotation): Float;
	
	private var animationDef: DfAnimationDef;
	private var _playing: Bool;
	private var _currLoop: Int;
	private var _currCell: Int;
	private var _cellTime: Float;	
	private var _canAddSprites: Bool;

	public var debugSprite: Sprite;
	private var boundRectOffset: Point;

	/**
	 * Creates a new sprite with the name <code>name</code>.
	 * @param	name		The name of the animation.
	 */
	public function new( name: String )
	{
		super();
		
		this.name = name;		
		animationDef = null;
		
		_playing = true;
		_currLoop = 0;
		_currCell = 0;
		_cellTime = 0;
		
		_canAddSprites = true;
		
		debugSprite = new Sprite();
		boundRectOffset = new Point();
	}
	
	override private function init(renderer:DfRenderer):Dynamic 
	{
		if ( renderer != null )
		{
			if ( renderer.animations.anims.exists(name) )
			{
				animationDef = renderer.animations.anims.get(name);
			}else
			{
				trace("No animation with this name: " + name + " was found.");
			}
		}

		super.init(renderer);
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
		debugSprite.graphics.clear();

		debugSprite.graphics.beginFill( 0xFF0000, 0.45 );
		debugSprite.graphics.drawRect( x + boundRectOffset.x, y + boundRectOffset.y, width, height );
		debugSprite.graphics.endFill();
		
		
		if ( animationDef == null || !_playing )
		{
			return;
		}
		
		var loops = animationDef.loops;
		var cells = animationDef.cells;
		
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
					//children.splice(0, children.length);
					
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
					for ( spr in cells[_currCell].sprs )
					{
						//spr.hadTransformation = true;						
						addChild( spr );
					}
					_canAddSprites = false;
				}
			}
			
			_cellTime += dt;
		}
	}
	
	private function setFlipH(flipH): Bool
	{
		// Apply the flip to all sprites of all the cells (frames)
		for ( cell in animationDef.cells )
		{
			for ( spr in cell.sprs )
			{
				spr.scaleX = -spr.scaleX;
				var newXoffs = - width + Math.abs(width - spr.x);
				spr.x = newXoffs;
			}
		}
		return this.flipH = flipH;
	}
	
	private function setFlipV(flipV): Bool
	{
		// Apply the flip to all sprites of all the cells
		for ( cell in animationDef.cells )
		{
			for ( spr in cell.sprs )
			{
				spr.scaleY = -spr.scaleY;
				var newYoffs = - height + Math.abs(height - spr.y);
				spr.y = newYoffs;
			}
		}
		return this.flipV = flipV;
	}
	
	private function getRotation(): Float
	{
		return rotation;
	}
	
	private function setRotation( rotation: Float ): Float
	{
		for( cell in animationDef.cells )
		{
			for ( spr in cell.sprs )
			{
				var m = new Matrix();
				m.translate(spr.x, spr.y);
				//m.rotate(spr.rotation);
				m.rotate(rotation);
				
				spr.x = m.tx;
				spr.y = m.ty;
				
				spr.rotation = rotation;
			}
		}
		return this.rotation = rotation;
	}
	
	override private function getWidth(): Float 
	{
		if ( _currCell >= 0 && _currCell < animationDef.cells.length )
		{
			// Only one spr in this cell
			if ( animationDef.cells[_currCell].sprs.length == 1 )
			{
				boundRectOffset.x = -animationDef.cells[_currCell].sprs[0].bounds.width / 2;
				return animationDef.cells[_currCell].sprs[0].bounds.width;
			}
			
			var minX: Float = Math.POSITIVE_INFINITY,
				maxX: Float = Math.NEGATIVE_INFINITY;
			
			for ( spr in animationDef.cells[_currCell].sprs )
			{
				minX = Math.min( minX, spr.x + spr.bounds.left );
				maxX = Math.max( maxX, spr.x + spr.bounds.left + spr.bounds.width );
			}
			
			if ( maxX > minX )
			{
				boundRectOffset.x = minX;
				return width = maxX - minX;
			}
		}
		return 0;
	}
	
	override private function getHeight(): Float 
	{
		if ( _currCell >= 0 && _currCell < animationDef.cells.length )
		{
			// Only one spr in this cell
			if ( animationDef.cells[_currCell].sprs.length == 1 )
			{
				boundRectOffset.y = -animationDef.cells[_currCell].sprs[0].bounds.height / 2;
				return animationDef.cells[_currCell].sprs[0].bounds.height;
			}
			
			var minY: Float = Math.POSITIVE_INFINITY,
				maxY: Float = Math.NEGATIVE_INFINITY;
			
			for ( spr in animationDef.cells[_currCell].sprs )
			{
				minY = Math.min( minY, spr.y + spr.bounds.top );
				maxY = Math.max( maxY, spr.y + spr.bounds.top + spr.bounds.height );
			}
			
			if ( maxY > minY )
			{
				boundRectOffset.y = minY;
				return height = maxY - minY;
			}
		}
		return 0;
	}
	
}