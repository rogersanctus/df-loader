package dfl.display;

import haxe.xml.Fast;
import nme.Assets;
import nme.display.Tilesheet;
import nme.display.BitmapData;
import nme.geom.Point;
import nme.geom.Rectangle;

/**
 * This class extends Tilesheet to parse the SpriteSheet Xml file.
 * @author Rogério
 */
class DfSpritesheet extends Tilesheet
{
	private var indices: Hash<Int>;
	private var numIndices: Int;
	public var rects(default, null): Array<Rectangle>;
	public var centerPoints(default, null): Array<Point>;

	#if flash
	private var img: BitmapData;
	#end
	
	/**
	 * Receive a Xml content from a DarkFunction SpriteSheet file and parse it.
	 * @param xmlString			The xml content of the SpriteSheet file.
	 * @param imgPath			The path where is the SpriteSheet image file in.
	 */
	public function new( xmlString: String, imgPath: String )
	{		
		var xml = new Fast( Xml.parse(xmlString) );
		var bmpData: BitmapData;
		
		// We could not find an img element on the xml file
		if ( !xml.hasNode.img )
		{
			super(null);
			return;
		}			
		
		if ( imgPath.charAt(imgPath.length - 1) != "/" || imgPath.charAt(imgPath.length - 1) != "\\" )
		{
			imgPath += "/";
		}
		imgPath += xml.node.img.att.name;		
		bmpData = Assets.getBitmapData(imgPath);
		
		#if flash
		img = bmpData;
		#end
		
		super(bmpData);
		
		indices = new Hash<Int>();
		rects = new Array<Rectangle>();
		centerPoints = new Array<Point>();
		
		var defs = xml.node.img.elements.next();
		
		if ( defs != null && defs.name == "definitions" )
		{
			var root = defs.elements.next();
			
			if( root.att.name == "/" )
			{
				makeSpriteList(root, "/");
			}
		}
	}
	
	private function makeSpriteList( dirs: Fast, path: String )
	{
		for ( fdir in dirs.elements )
		{
			var dir: Fast = fdir;
			var oldpath: String;
			
			if ( dir.name == "dir" )
			{
				oldpath = path;
				path = path + dir.att.name + "/";
				makeSpriteList( dir, path );
				path = oldpath;
			}else if ( dir.name == "spr" )
			{
				var sprName = path + dir.att.name;
				var x = Std.parseInt(dir.att.x),
					y = Std.parseInt(dir.att.y),
					w = Std.parseInt(dir.att.w),
					h = Std.parseInt(dir.att.h);
				
				var center: Point = new Point(0, 0);
				var rect = new Rectangle(x, y, w, h);
				var size: Rectangle = new Rectangle(0, 0, w, h);
				
				#if flash
				/*var bmp = new BitmapData(w, h, true, 0);
				center.x = -size.left;
				center.y = -size.top;
				bmp.copyPixels(img, rect, center);
				addDfSpriteDef( sprName, size, bmp );*/
				#else
				center.x = w / 2;
				center.y = h / 2;
				addDfSpriteDef( sprName, rect, center );
				#end				
			}
		}
	}
	
	public function getSprite( name: String ): Int
	{
		if( indices.exists(name) )
		{
			return indices.get(name);
		}
		// Not found a indice to this sprite name
		return -1;
	}
	
	private function addDfSpriteDef( name: String, rect: Rectangle, center: Point )
	{
		// Sprite definition already added
		if( indices.exists(name) )
			return;

		indices.set(name, rects.length);
		rects.push( rect );
		//centerPoints.push(center);
		// Not passing centerPoint argument anymore. (Tilesheet drawTiles don't work good with it)
		//addTileRect( rect, null );
		addTileRect( rect, center );
	}
}