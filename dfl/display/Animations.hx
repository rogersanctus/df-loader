package dfl.display;

import haxe.xml.Fast;
import nme.Assets;

/**
 * ...
 * @author Rogério
 */

class Animations
{
	private var spriteSheet: SpriteSheet;
	public var anims(default, null): Hash<Animation>;
	
	public function new( xmlString: String, imgPath: String, dataPath: String, smooth: Bool = false )
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
					
				var animation = new Animation(spriteSheet, loops, smooth);
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