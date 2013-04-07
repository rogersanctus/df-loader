package dfl.display;

import haxe.xml.Fast;
import nme.Assets;

/**
 * This class is responsible for the parsing proccess of the DarkFunction
 * anim Xml file.
 * @author Rogério
 */
class Animations
{
	/**
	 * The spriteSheet used by the animations on this animations file. It
	 * is set by the Animations class.
	 */
	public var spriteSheet(default, null): SpriteSheet;
	
	/**
	 * The Animation list of the animations described by the anim Xml file.
	 * You can use this list to acess each animation and then drawn it on a
	 * TileLayer.
	 */
	public var anims(default, null): Hash<Animation>;
	
	/**
	 * The Animations constructor.
	 * @param xmlString			The anim Xml content. This is NOT the file name.
	 * @param imgPath			The path where your SpriteSheet image is on.
	 * @param dataPath			The path where are your SpriteSheet and Animation Xml files (.anim and .sprites).
	 *							The ones generates by the DarkFunction editor. This path can be
	 *							the same as imgPath.
	 */
	public function new( xmlString: String, imgPath: String, dataPath: String )
	{
		var xml = new Fast( Xml.parse(xmlString) );
		
		// We could not find an img element on the xml file
		if ( !xml.hasNode.animations )
		{
			return;
		}
		
		// No spriteSheet file found :(
		if (!xml.node.animations.has.spriteSheet)
		{
			return;
		}
		
		if ( dataPath.charAt(dataPath.length - 1) != "/" || dataPath.charAt(dataPath.length - 1) != "\\" )
		{
			dataPath += "/";
		}
		dataPath += xml.node.animations.att.spriteSheet;
		
		spriteSheet = new SpriteSheet( Assets.getText(dataPath), imgPath );
		
		if ( spriteSheet == null )
		{
			return;
		}
		
		anims = new Hash<Animation>();
		
		var animsNode = xml.node.animations.elements;
		
		for ( animNode in animsNode )
		{
			if ( animNode.name == "anim" )
			{
				var animName = animNode.att.name,
					loops = Std.parseInt(animNode.att.loops);
					
				var animation = new Animation(loops);
				anims.set( animName, animation );

				var cellsNode = animNode.elements;
				
				for ( cellNode in cellsNode )
				{
					var cellIndex = Std.parseInt( cellNode.att.index );
					var cellDelay = Std.parseInt( cellNode.att.delay );
					var cell = new Cell( cellIndex, cellDelay );
					
					animation.addCell(cell);
					
					var sprsNode = cellNode.elements;
					
					for ( sprNode in sprsNode )
					{
						var sprName = sprNode.att.name;
						var x = Std.parseInt(sprNode.att.x);
						var y = Std.parseInt(sprNode.att.y);
						var z = Std.parseInt(sprNode.att.z);
						var angle: Float = 0;
						var flipH: Bool = false;
						var flipV: Bool = false;
						
						if ( sprNode.has.angle )
						{
							angle = Std.parseFloat( sprNode.att.angle );
						}
						
						if ( sprNode.has.flipH )
						{
							flipH = (Std.parseInt( sprNode.att.flipH ) == 1)? true : false;
						}
						
						if ( sprNode.has.flipV )
						{
							flipV = (Std.parseInt( sprNode.att.flipV ) == 1)? true : false;
						}
						
						var cellSpr = new CellSprite( sprName, x, y, z, angle, flipH, flipV );
						cell.addSprite(cellSpr);
					}
				}
			}
		}
	}
}