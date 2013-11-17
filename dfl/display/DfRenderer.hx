package dfl.display;

import flash.geom.Matrix;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.geom.Point;
import openfl.display.Tilesheet;

/**
 * Renderer class
 * @author rogersanctus
 */
class DfRenderer extends DfBasicContainer
{
	/**
	 * The view Sprite of the renderer. You must add this into your main <code>Sprite</code>
	 * so the renderer content will be drawn on the screen.
	 */
	public var view(default, null): Sprite;
	public var contentDef(default, null) : DfContentDef;
	public var smooth(default, null): Bool;
	
	private var drawlist: Array<Float>;

	/**
	 * Constructor for the Renderer object.
	 * @param	contentDef		The content definition object.
	 * @param	smooth			To draw or not smoothed sprites.
	 */
	public function new( contentDef: DfContentDef, smooth: Bool = false )
	{
		super();
		this.contentDef = contentDef;
		
		this.smooth = smooth;
		
		view = new Sprite();
		drawlist = new Array<Float>();
		
		init(this);
	}
	
	/**
	 * Render all the sprites and animations to the <code>DfRenderer</code> <code>Sprite<code> container.
	 */
	public function render(): Void
	{
		var i = renderContainer( this, 0, 0, 0 );
		
		// Remove sprites that are no more on the drawlist
		if ( i < drawlist.length )
		{
			drawlist.splice( i, drawlist.length - i );
		}		
		
		view.graphics.clear();
		contentDef.spritesheet.drawTiles( view.graphics, drawlist, smooth, Tilesheet.TILE_TRANS_2x2 );
	}
	
	private function renderContainer( c: DfBasicContainer, index: Int, cx: Float, cy: Float): Int
	{
		if ( c.visible == false )
		{
			// Wan't render invisible container.
			return -1;
		}
		
		cx += c.x;
		cy += c.y;
		
		for ( i in 0 ... c.children.length )
		{
			var child = c.children[i];
			
			if ( child.visible == false )
			{
				continue;		// Skip. We don't need to render this.
			}
			
			var container: DfBasicContainer = Std.is( child, DfBasicContainer )? cast child: null;
			
			// Is the child a container?
			if ( container != null )
			{
				index = renderContainer( container, index, cx, cy );
			}
			// It's not? try to cast it to a DfSprite
			else
			{
				var spr: DfSprite = Std.is( child, DfSprite )? cast child: null;
				
				// Something went wrong
				if ( spr == null )
				{
					continue;
				}				
				
				/// The 0.01 factor is to try to correct some malfunctions when running on native targets.
				var efactor: Float = 0.0;
				#if (cpp || neko)
				efactor = 0.01;
				#else
				efactor = 0.0;
				#end
				
				drawlist[index + 0] = spr.x + cx + efactor;
				drawlist[index + 1] = spr.y + cy + efactor;
				drawlist[index + 2] = spr.index;
				drawlist[index + 3] = spr.matrix.a;
				drawlist[index + 4] = spr.matrix.b;
				drawlist[index + 5] = spr.matrix.c;
				drawlist[index + 6] = spr.matrix.d;
				
				index += 7;
			}
		}
		return index;
	}
}
