package dfl.display;
import nme.display.PixelSnapping;
import nme.geom.Matrix;
import nme.display.Graphics;
import nme.display.Sprite;
import nme.display.Tilesheet;
import nme.geom.Point;

/**
 * Renderer class
 * @author rogersanctus
 */
class DfRenderer extends DfBasicContainer
{
	public var view(default, null): Sprite;
	public var spritesheet(default, null): DfSpritesheet;
	public var animations(default, null): DfAnimations;
	public var smooth(default, null): Bool;
	
	private var drawlist: Array<Float>;

	/**
	 * Constructor for the Renderer object.
	 * @param	?animations		The animations definition object. If passed,
	 * 							will override the <code>spritesheet</code>
	 * 							with the onde came from animations definitions.
	 * @param	spritesheet		The Spritesheet with the sprites definitions.
	 * @param	smooth			To draw or not smoothed sprites.
	 */
	public function new( spritesheet: DfSpritesheet, ?animations: DfAnimations, smooth: Bool = false )
	{
		super();
		
		this.spritesheet = spritesheet;
		
		if( animations != null )
		{
			this.animations = animations;
			this.spritesheet = animations.spritesheet;
		}
		
		this.smooth = smooth;
		
		view = new Sprite();
		drawlist = new Array<Float>();
		
		init(this);
	}
	
	public function render(): Void
	{
		var i = renderContainer( this, 0, 0, 0 );
		
		// Remove sprites that are no more on the drawlist
		if ( i < drawlist.length )
		{
			drawlist.splice( i, drawlist.length - i );
		}
		
		#if flash
		view.addChild( sprContainer );
		
		#else
		view.graphics.clear();
		spritesheet.drawTiles(view.graphics, drawlist, smooth, Tilesheet.TILE_TRANS_2x2);
		#end
	}
	
	private function renderContainer( c: DfBasicContainer, index: Int, cx: Float, cy: Float): Int
	{
		if ( c.visible == false )
		{
			// Can't render invisible renderer ;)
			return -1;
		}
		
		#if flash
		c.sprContainer.x = c.x + cx;
		c.sprContainer.y = c.y + cy;

		#else
		cx += c.x;
		cy += c.y;
		#end
		
		for ( i in 0 ... c.children.length )
		{
			var child = c.children[i];
			
			if ( child.visible == false )
			{
				continue;
			}
			
			#if( flash || js )
			var container: DfBasicContainer = Std.is( child, DfBasicContainer )? cast child: null;
			#else
			var container: DfBasicContainer = cast child;
			#end
			
			// Is the child a container?
			if ( container != null )
			{
				index = renderContainer( container, index, cx, cy );
			}
			// Not? cast it to a Sprite
			else
			{
				var spr: DfSprite = cast child;
				
				// Something went wrong
				if ( spr == null )
				{
					continue;
				}
				
				#if flash
				var imgMat: Matrix = spr.bmp.transform.matrix;
				imgMat.identity();
				imgMat.concat( spr.getMatrix() );
				imgMat.translate( spr.x, spr.y );				
				spr.bmp.transform.matrix = imgMat;
				spr.bmp.smoothing = smooth;
				
				#else
				var matrix = spr.getMatrix();

				drawlist[index + 0] = spr.x + cx + 0.01;
				drawlist[index + 1] = spr.y + cy + 0.01;
				drawlist[index + 2] = spr.index;
				drawlist[index + 3] = matrix.a;
				drawlist[index + 4] = matrix.b;
				drawlist[index + 5] = matrix.c;
				drawlist[index + 6] = matrix.d;
				
				index += 7;
				#end
			}
		}
		return index;
	}
}
