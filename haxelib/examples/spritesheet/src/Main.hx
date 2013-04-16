package ;

import nme.Assets;
import nme.display.Sprite;
import nme.events.Event;
import nme.Lib;
import dfl.display.DfRenderer;
import dfl.display.DfSpritesheet;
import dfl.display.DfSprite;

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
		var sprs = new DfSpritesheet( Assets.getText("assets/spritesheet.sprites"), "assets" );
		
		// The Renderer that will draw the sprites.
		var renderer = new DfRenderer(sprs, false);
		
		/* Create DfSprite with the names of each sprite
		 * you want to use
		 */
		var spr1 = new DfSprite("/sprite/0");
		var spr2 = new DfSprite("/sprite/1");
		
		spr1.x = 64;
		spr1.y = 32;	
		
		spr2.x = 128;
		spr2.y = 48;		
		
		// Add them to the renderer.
		renderer.addChild(spr1);
		renderer.addChild(spr2);

		addChild(renderer.view);
		
		// And call render, so the sprites can be drawn.
		renderer.render();
	}
	
	static public function main() 
	{
		var stage = Lib.current.stage;
		stage.scaleMode = nme.display.StageScaleMode.NO_SCALE;
		stage.align = nme.display.StageAlign.TOP_LEFT;
		
		Lib.current.addChild(new Main());
	}
	
}