package dfl.display;
import dfl.display.DfRenderer;
import nme.geom.Matrix;
import nme.geom.Point;
import nme.geom.Rectangle;

/**
 * This class represent a sprite in a <code>Cell</code>.
 * @author Rogério
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
	public var flipH(default, null): Bool;
	
	/**
	 * If to flip or not the sprite vertically.
	 */
	public var flipV(default, null): Bool;
	
	public var scaleX(getScaleX, setScaleX): Float;
	public var scaleY(getScaleY, setScaleY): Float;
	public var scale(getScale, setScale): Float;
	public var rotation(getRotation, setRotation): Float;
	public var hadTransformation: Bool;
	public var bounds(getBounds, null):  Rectangle;
	
	private var matrix: Matrix;

	public function new(sprName: String, x: Int = 0, y: Int = 0, z: Int = 0, rotation: Float = 0.0, flipH: Bool = false, flipV: Bool = false )
	{
		super();
		
		matrix = new Matrix();

		this.name = sprName;
		this.x = x;
		this.y = y;
		this.z = z;
		this.rotation = rotation;
		this.flipH = flipH;
		this.flipV = flipV;
		this.scale = 1;
		this.scaleX = 1;
		this.scaleY = 1;
		
		index = -1;
		hadTransformation = false;
		
		if (flipH)
		{
			hadTransformation = true;
			scaleX = -scaleX;
		}
		if (flipV)
		{
			hadTransformation = true;
			scaleY = -scaleY;
		}
		
		if ( rotation != 0 )
		{
			hadTransformation = true;
		}
		
		bounds = new Rectangle();
	}
	
	override private function init( renderer: DfRenderer )
	{
		this.renderer = renderer;
		
		if ( renderer.spritesheet == null )
		{
			trace("Oops. Spritesheet can't be null here." );
			return;
		}
		
		index = renderer.spritesheet.getSprite(name);
		
		if ( index == -1 )
		{
			trace("Wrong index returned for: " + name);
			return;
		}

		width = renderer.spritesheet.rects[index].width;
		height = renderer.spritesheet.rects[index].height;
		
		bounds.x = x;
		bounds.y = y;
		bounds.width = width;
		bounds.height = height;
	}
	
	private function setScaleX( scaleX: Float ): Float
	{
		hadTransformation = true;
		return  this.scaleX = scaleX;
	}	
	private function getScaleX(): Float
	{
		return scaleX;
	}
	
	private function setScaleY( scaleY: Float ): Float
	{
		hadTransformation = true;
		return  this.scaleY = scaleY;
	}	
	private function getScaleY(): Float
	{
		return scaleY;
	}
	
	private function setScale( scale: Float ): Float
	{
		hadTransformation = true;
		scaleX = scale;
		scaleY = scale;

		return  this.scale = scale;
	}	
	private function getScale(): Float
	{
		hadTransformation = true;
		return scale;
	}
	
	private function setRotation( rotation: Float ): Float
	{
		hadTransformation = true;
		return  this.rotation = rotation;
	}	
	private function getRotation(): Float
	{
		return rotation;
	}
	
	public function getMatrix(): Matrix
	{
		if ( hadTransformation )
		{
			// Don't get accumulative transformations, start a new matrix ;)
			var m = new Matrix();
			
			if ( rotation != 0 )
			{
				m.rotate(rotation);
			}
			if ( scaleX != 0 || scaleY != 0 )
			{
				m.scale(scaleX, scaleY);
			}

			hadTransformation = false;			
			return matrix = m;
		}
		
		return matrix;
	}	
	
	private function getBounds(): Rectangle
	{
		var m = getMatrix();
		if ( m != null )
		{			
			var halfwidth = width / 2,
				halfheight = height / 2;
			
			var topleft = m.deltaTransformPoint( new Point( -halfwidth, - halfheight ) );
			var topright = m.deltaTransformPoint( new Point( halfwidth, - halfheight ) );
			var bottomleft = m.deltaTransformPoint( new Point( -halfwidth, halfheight ) );
			var bottomright = m.deltaTransformPoint( new Point( halfwidth, halfheight ) );
			
			var left = Math.min( Math.min(topleft.x, topright.x), Math.min(bottomleft.x, bottomright.x) );
			var right = Math.max( Math.max(topleft.x, topright.x), Math.max(bottomleft.x, bottomright.x) );
			var top = Math.min( Math.min(topleft.y, topright.y), Math.min(bottomleft.y, bottomright.y) );
			var bottom = Math.max( Math.max(topleft.y, topright.y), Math.max(bottomleft.y, bottomright.y) );

			return bounds = new Rectangle( left, top, right - left, bottom - top );
		}

		return bounds;
	}
}