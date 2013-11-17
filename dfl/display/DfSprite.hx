package dfl.display;
import dfl.display.DfRenderer;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;

/**
 * This class represent a sprite of a <code>DfCell</code>.
 * @author rogersanctus
 */
class DfSprite extends DfBasicSprite
{
	/**
	 * The sprite name
	 */
	public var name(default, null): String;
	
	/**
	 * The index of the sprite on the internal Tilesheet object.
	 */
	public var index(default, null): Int;

	/** 
	 * The order to draw this sprite.
	 */
	public var z(default, null): Int;

	/**
	 * If to flip or not the sprite horizontally.
	 */
	public var flipH(default, set): Bool;
	
	/**
	 * If to flip or not the sprite vertically.
	 */
	public var flipV(default, set): Bool;
	
	/**
	 * Get the Sprite transformation matrix.
	 */
	public var matrix(get, null): Matrix;
	
	private var _scaleX: Float;
	private var _scaleY: Float;
	private var _scale: Float;
	private var _rotation: Float;
	private var _matrix: Matrix;
	
	public var scaleX(get, set): Float;
	public var scaleY(get, set): Float;
	public var scale(get, set): Float;
	public var rotation(get, set): Float;
	public var hadTransformation: Bool;
	public var bounds(get, null):  Rectangle;

	public function new(sprName: String, x: Int = 0, y: Int = 0, z: Int = 0, rotation: Float = 0.0, flipH: Bool = false, flipV: Bool = false )
	{
		super();

		name = sprName;
		this.x = x;
		this.y = y;
		this.z = z;		
		scale = 1;
		scaleX = 1;
		scaleY = 1;
		_matrix = new Matrix();
		
		this.flipH = flipH;
		this.flipV = flipV;
		_rotation = rotation;
		
		index = -1;
		hadTransformation = true;
		
		bounds = new Rectangle();
	}
	
	/**
	 * Clones all the <code>DfSprite</code> data
	 * @return		A new instance of the DfSprite data.
	 */ 
	public function clone(): DfSprite
	{
		var cloneSprite = new DfSprite( name, Std.int(x), Std.int(y), Std.int(z), _rotation, flipH, flipV );
		
		cloneSprite.index = index;
		cloneSprite.visible = visible;
		cloneSprite.parent = parent;
		cloneSprite.renderer = renderer;
		
		cloneSprite.width = width;
		cloneSprite.height = height;
		
		cloneSprite._scaleX = _scaleX;
		cloneSprite._scaleY = _scaleY;
		cloneSprite._scale = _scale;
		cloneSprite.flipH = flipH;
		cloneSprite.flipV = flipV;
		cloneSprite.bounds = bounds;
		cloneSprite.hadTransformation = hadTransformation;
		
		return cloneSprite;
	}
	
	override private function init( renderer: DfRenderer ): Void
	{
		this.renderer = renderer;
		
		if ( renderer.contentDef.spritesheet == null )
		{
			trace("Oops. Spritesheet can't be null here." );
			return;
		}
		
		index = renderer.contentDef.spritesheet.getSprite(name);
		
		if ( index == -1 )
		{
			trace("Wrong index returned for: " + name);
			return;
		}
		
		width = renderer.contentDef.spritesheet.rects[index].width;
		height = renderer.contentDef.spritesheet.rects[index].height;
		
		bounds.x = ( width != 0 )? -width / 2: 0;
		bounds.y = ( height != 0 )? -height / 2: 0;
		bounds.width = width;
		bounds.height = height;
		
		// Every time the sprite is added into its container, apply transformations.
		hadTransformation = true;
	}
	
	private function set_flipH( value: Bool ): Bool
	{
		scaleX = (value == true)? -1: 1;
		return flipH = value;		
	}
	
	private function set_flipV( value: Bool ): Bool
	{
		scaleY = (value == true)? -1: 1;
		return flipV = value;		
	}
	
	private function set_scaleX( scaleX: Float ): Float
	{
		hadTransformation = true;
		return  _scaleX = scaleX;
	}

	private function get_scaleX(): Float
	{
		return _scaleX;
	}
	
	private function set_scaleY( scaleY: Float ): Float
	{
		hadTransformation = true;
		return  _scaleY = scaleY;
	}

	private function get_scaleY(): Float
	{
		return _scaleY;
	}

	private function set_scale( scale: Float ): Float
	{
		hadTransformation = true;
		_scaleX = scale;
		_scaleY = scale;
		
		return  _scale = scale;
	}

	private function get_scale(): Float
	{
		return _scale;
	}
	
	/*
	 * Set the rotation of the sprite.
	 * Do not support rotation of multiples sprites.
	 */
	private function set_rotation( rotation: Float ): Float
	{		
		hadTransformation = true;
		return  _rotation = rotation;
	}

	private function get_rotation(): Float
	{
		return _rotation;
	}
	
	private function get_matrix(): Matrix
	{
		if ( hadTransformation )
		{
			// Don't get accumulative transformations, start a new matrix ;)
			var m = _matrix;
			m.identity();
			
			if ( _scaleX != 0 && _scaleY != 0 )
			{
				m.scale( _scaleX, _scaleY );
			}
			
			m.rotate( rotation );			
			
			hadTransformation = false;
			return _matrix = m;
		}
		
		return _matrix;
	}
	
	private function get_bounds(): Rectangle
	{
		var m = matrix;
		if ( m != null )
		{			
			var halfwidth: Float = width / 2,
				halfheight: Float = height / 2;
			
			var topleft = m.transformPoint( new Point( -halfwidth, - halfheight ) );
			var topright = m.transformPoint( new Point( halfwidth, - halfheight ) );
			var bottomleft = m.transformPoint( new Point( -halfwidth, halfheight ) );
			var bottomright = m.transformPoint( new Point( halfwidth, halfheight ) );
			
			var left = Math.min( Math.min(topleft.x, topright.x), Math.min(bottomleft.x, bottomright.x) );
			var right = Math.max( Math.max(topleft.x, topright.x), Math.max(bottomleft.x, bottomright.x) );
			var top = Math.min( Math.min(topleft.y, topright.y), Math.min(bottomleft.y, bottomright.y) );
			var bottom = Math.max( Math.max(topleft.y, topright.y), Math.max(bottomleft.y, bottomright.y) );
			
			return bounds = new Rectangle( left, top, right - left, bottom - top );
		}
		
		return bounds;
	}
}