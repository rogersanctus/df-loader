package dfl.display;

import haxe.xml.Fast;
import nme.Assets;
import nme.display.Tilesheet;
import nme.display.BitmapData;
import nme.geom.Point;
import nme.geom.Rectangle;

/**
 * This class extends Tilesheet to parse the SpriteSheet Xml file.
 * @author Rog�rio
 */
class DfSpritesheet extends Tilesheet
{
	private var indices: Hash<Int>;
	private var numIndices: Int;
	public var rects(default, null): Array<Rectangle>;

	#if flash
	private var imgs: Array<BitmapData>;
	#end
	
	/**
	 * Receive a Xml content from a DarkFunction SpriteSheet file and parse it.
	 * @param xmlString			The xml content of the SpriteSheet file.
	 * @param imgPath			The path where is the SpriteSheet image file in.
	 */
	public function new( xmlString: String, imgPath: String )
	{		
		var xml = new Fast( Xml.parse( xmlString ) );
		var bmpData: BitmapData;
		
		// We could not find an img element on the xml file
		if ( !xml.hasNode.img )
		{
			super(null);
			return;
		}			
		
		if ( imgPath.charAt( imgPath.length - 1 ) != "/" || imgPath.charAt( imgPath.length - 1 ) != "\\" )
		{
			imgPath += "/";
		}
		imgPath += xml.node.img.att.name;		
		bmpData = Assets.getBitmapData( imgPath );
		
		#if flash
		imgs = new Array<BitmapData>();
		#end
		
		super( bmpData );
		
		indices = new Hash<Int>();
		rects = new Array<Rectangle>();
		
		var defs = xml.node.img.elements.next();
		
		if ( defs != null && defs.name == "definitions" )
		{
			var root = defs.elements.next();
			
			if( root.att.name == "/" )
			{
				makeSpriteList( root, "/", bmpData );
			}
		}
	}
	
	private function makeSpriteList( dirs: Fast, path: String, bmpData: BitmapData )
	{
		for ( fdir in dirs.elements )
		{
			var dir: Fast = fdir;
			var oldpath: String;
			
			if ( dir.name == "dir" )
			{
				oldpath = path;
				path = path + dir.att.name + "/";
				makeSpriteList( dir, path, bmpData );
				path = oldpath;
			}else if ( dir.name == "spr" )
			{
				var sprName = path + dir.att.name;
				var x = Std.parseInt( dir.att.x ),
					y = Std.parseInt( dir.att.y ),
					w = Std.parseInt( dir.att.w ),
					h = Std.parseInt( dir.att.h );
				
				var center: Point = new Point(0, 0);
				var rect = new Rectangle(x, y, w, h);
				
				#if flash
				var img = new BitmapData(w, h, true, 0);
				center.x = 0;
				center.y = 0;
				img.copyPixels(bmpData, rect, center);
				addDfSpriteDef( sprName, rect, img );
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
	
	#if !flash
	private function addDfSpriteDef( name: String, rect: Rectangle, center: Point )
	{
		// Sprite definition already added
		if( indices.exists(name) )
		{
			return;
		}

		indices.set(name, rects.length);
		rects.push( rect );
		addTileRect( rect, center );
	}
	
	#else
	private function addDfSpriteDef( name: String, rect: Rectangle, img: BitmapData )
	{
		if ( indices.exists(name) )
		{
			return;
		}
		
		indices.set( name, rects.length );
		rects.push( rect );
		imgs.push( img );
	}
	
	public function getBitmap( index: Int ): BitmapData
	{
		if ( index >= 0 && index < imgs.length )
		{
			return imgs[index];
		}
		return null;
	}
	#end
}