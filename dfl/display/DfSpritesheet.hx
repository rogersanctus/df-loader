package dfl.display;

import haxe.xml.Fast;
import openfl.Assets;
import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;
import openfl.display.Tilesheet;

/**
 * This class extends Tilesheet to parse the DarkFunction Spritesheet Xml file.
 * @author rogersanctus
 */
class DfSpritesheet extends Tilesheet
{
	private var indices: Map<String, Int>;
	public var rects(default, null): Array<Rectangle>;
	
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
		//bmpData = Assets.getBitmapData( imgPath );
		bmpData = Assets.getBitmapData( imgPath );
		
		super( bmpData );
		
		indices = new Map<String, Int>();
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
				var x: Int = 0,
					y: Int = 0,
					w: Int = 0,
					h: Int = 0;
					
				var vx = Std.parseInt( dir.att.x );
				var vy = Std.parseInt( dir.att.y );
				var vw = Std.parseInt( dir.att.w );
				var vh = Std.parseInt( dir.att.h );
				
				if ( vx != null ) x = vx;
				if ( vy != null ) y = vy;
				if ( vw != null ) w = vw;
				if ( vh != null ) h = vh;
				
				var center: Point = new Point(0, 0);
				var rect = new Rectangle(x, y, w, h);
				
				center.x = w / 2;
				center.y = h / 2;
				addDfSpriteDef( sprName, rect, center );
			}
		}
	}
	
	/**
	 * Gets a sprite index by it name.
	 * @param	name		The name of the sprite to be retrieved.
	 * @return				The index of the sprite or -1 if no sprite was found with
	 * 						the passed <code>name</code>.
	 */
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
		{
			return;
		}
		
		indices.set( name, rects.length );		
		var i: Int = indices.get( name );		
		rects[ i ] = rect;
		addTileRect( rects[i], center );
	}
}