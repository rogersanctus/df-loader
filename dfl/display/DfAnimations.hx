package dfl.display;

import haxe.xml.Fast;
import openfl.Assets;

/**
 * This class is responsible for the parsing process of the DarkFunction
 * anim Xml file.
 * @author rogersanctus
 */
class DfAnimations
{
	/**
	 * The spriteSheet used by the animations on this animations file. It
	 * is set by the <code>DfAnimations</code> class.
	 */
	public var spritesheet(default, null): DfSpritesheet;
	
	/**
	 * The Animation list of the animations described by the DarkFunction anim Xml file.
	 * You can use this list to acess each animation and then drawn it on
	 * the <code>DfRenderer</code>.
	 */
	public var anims(default, null): Map<String, DfAnimationDef>;
	
	/**
	 * The Animations constructor.
	 * @param xmlString			The anim Xml content. This is NOT the file name.
	 * @param imgPath			The path where your SpriteSheet image is on.
	 * @param dataPath			The path where are your SpriteSheet and Animation Xml files (.anim and .sprites).
	 *							The ones generates by the DarkFunction editor. If you dont pass this param it will be
	 *							the same as <code>imgPath</code>. 
	 */
	public function new( xmlString: String, imgPath: String, ?dataPath: String )
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
		
		if ( dataPath == null )
		{
			dataPath = imgPath;
		}
		
		if ( dataPath.charAt(dataPath.length - 1) != "/" || dataPath.charAt(dataPath.length - 1) != "\\" )
		{
			dataPath += "/";
		}
		dataPath += xml.node.animations.att.spriteSheet;
		
		spritesheet = new DfSpritesheet( Assets.getText(dataPath), imgPath );
		
		if ( spritesheet == null )
		{
			return;
		}
		
		anims = new Map<String, DfAnimationDef>();
		
		var animsNode = xml.node.animations.elements;
		
		for ( animNode in animsNode )
		{
			if ( animNode.name == "anim" )
			{
				var animName = animNode.att.name,
					loops = Std.parseInt(animNode.att.loops);
					
				var animation = new DfAnimationDef(loops);
				anims.set( animName, animation );				

				var cellsNode = animNode.elements;
				
				for ( cellNode in cellsNode )
				{
					var cellIndex = Std.parseInt( cellNode.att.index );
					var cellDelay = Std.parseInt( cellNode.att.delay );
					var cell = new DfCell( cellIndex, cellDelay );
					
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
							angle *= Math.PI / 180;
						}
						
						if ( sprNode.has.flipH )
						{
							flipH = (Std.parseInt( sprNode.att.flipH ) == 1)? true : false;
						}
						
						if ( sprNode.has.flipV )
						{
							flipV = (Std.parseInt( sprNode.att.flipV ) == 1)? true : false;
						}
						
						var cellSpr = new DfSprite( sprName, x, y, z, angle, flipH, flipV );
						cell.addSprite(cellSpr);
					}
				}
			}
		}
	}
}