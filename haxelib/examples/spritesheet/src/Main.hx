package ;

import aze.display.TileLayer;
import aze.display.TileSprite;
import nme.Assets;
import nme.display.Sprite;
import nme.events.Event;
import nme.Lib;
import dfl.display.SpriteSheet;

/**
 * An example of loading and showing sprites from a DarkFunctio spritesheet file.
 * @author Rogério Santos
 */

class Main extends Sprite 
{
	public function new() 
	{
		super();
		#if iphone
		Lib.current.stage.addEventListener(Event.RESIZE, init);
		#else
		addEventListener(Event.ADDED_TO_STAGE, init);
		#end
	}

	private function init(e) 
	{
		/* Create a spritesheet object, passing the xml content of the spritesheet.sprites
		 *  and the path where is the image of this spritesheet.
		 */
		var sprs = new SpriteSheet( Assets.getText("assets/spritesheet.sprites"), "assets" );
		
		// The Tilelayer where the sprites will be drawn.
		var layer = new TileLayer(sprs, false);
		
		/* Create TileSprites with the names of each sprite
		 * you want to use
		 */
		var spr1: TileSprite = new TileSprite("/sprite/0");
		var spr2: TileSprite = new TileSprite("/sprite/1");
		
		spr1.x = 64;
		spr1.y = 32;		
		
		spr2.x = 128;
		spr2.y = 48;		
		
		// Add them to the layer.
		layer.addChild(spr1);
		layer.addChild(spr2);

		addChild(layer.view);
		
		// And render the layer, so the sprites can be drawn.
		layer.render();
	}
	
	static public function main() 
	{
		var stage = Lib.current.stage;
		stage.scaleMode = nme.display.StageScaleMode.NO_SCALE;
		stage.align = nme.display.StageAlign.TOP_LEFT;
		
		Lib.current.addChild(new Main());
	}
	
}