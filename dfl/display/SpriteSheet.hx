package dfl.display;

import haxe.xml.Fast;
import aze.display.TilesheetEx;
import nme.Assets;
import nme.display.BitmapData;
import nme.geom.Point;
import nme.geom.Rectangle;

/**
 * This class extends TilesheetEx to parse the SpriteSheet Xml file.
 * @author Rogério
 */
class SpriteSheet extends TilesheetEx
{	
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
				makeSpriteList( dir/*, sprites*/, path );
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
				var bmp = new BitmapData(w, h, true, 0);
				center.x = -size.left;
				center.y = -size.top;
				bmp.copyPixels(img, rect, center);
				addDefinition(sprName, size, bmp);
				#else
				center.x = w / 2;
				center.y = h / 2;
				addDefinition(sprName, size, rect, center);
				#end				
			}
		}
	}	
}