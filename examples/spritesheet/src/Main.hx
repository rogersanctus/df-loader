package ;

import openfl.Assets;
import flash.display.Sprite;
import flash.events.Event;
import flash.Lib;
import dfl.display.DfRenderer;
import dfl.display.DfContentDef;
import dfl.display.DfSpritesheet;
import dfl.display.DfSprite;

/**
 * An example of loading and showing sprites from a DarkFunctio spritesheet file.
 * @author rogersanctus
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
		var renderer = new DfRenderer( new DfContentDef(sprs), false);
		
		/* Create DfSprite with the names of each sprite
		 * you want to use
		 */
		var spr1 = new DfSprite("/sprite/0");
		var spr2 = new DfSprite("/sprite/1");
		var spr3 = new DfSprite("/sprite/0");
		var spr4 = new DfSprite("/sprite/1");
		
		spr1.x = 64;
		spr1.y = 32;	
		
		spr2.x = 324;
		spr2.y = 48;
		
		spr3.x = spr1.x;
		spr3.y = spr1.y + 48;
		
		spr4.x = spr2.x;
		spr4.y = spr2.y + 48;
		
		// Add them to the renderer.
		renderer.addChild(spr1);
		renderer.addChild(spr2);
		renderer.addChild(spr3);
		renderer.addChild(spr4);
		
		spr3.flipV = true;
		spr4.rotation = 135 * Math.PI / 180;	// Rotate 135 degrees.

		addChild(renderer.view);
		
		// And call render, so the sprites can be drawn.
		renderer.render();
	}
	
	static public function main() 
	{
		var stage = Lib.current.stage;
		stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		stage.align = flash.display.StageAlign.TOP_LEFT;
		
		Lib.current.addChild(new Main());
	}
	
}