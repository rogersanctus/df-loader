package ;

import nme.Assets;
import nme.display.Sprite;
import nme.events.Event;
import nme.Lib;
import dfl.display.DfRenderer;
import dfl.display.DfAnimations;
import dfl.display.DfAnimation;
import haxe.Timer;

/**
 * An example of loading and showing animations from a DarkFunctio animations file.
 * @author Rogério Santos
 */

class Main extends Sprite 
{
	private var animations: DfAnimations;
	private var animList: Array<DfAnimation>;
	
	private var renderer: DfRenderer;
	
	private var oldTime: Float;

	public function new() 
	{
		super();
		#if iphone
		Lib.current.stage.addEventListener(Event.RESIZE, init);
		#else
		addEventListener(Event.ADDED_TO_STAGE, init);
		#end
		
		addEventListener( Event.ENTER_FRAME, step );
	}

	private function init(e) 
	{
		animations = new DfAnimations( Assets.getText("assets/animation.anim"), "assets", "assets" );

		// The tile layer to render all the sprites in batch
		renderer = new DfRenderer( null, animations, false );

		animList = new Array<DfAnimation>();
		
		/* Add each animation to the animList
		 * checking first if it exist.
		 */
		/*if( animations.anims.exists("normal") )
		{
			animList.push( animations.anims.get("normal") );
			animations.anims.get("normal").x = 40;
			animations.anims.get("normal").y = 22;
		}
		
		if( animations.anims.exists("walk") )
		{
			animList.push( animations.anims.get("walk") );
			animations.anims.get("walk").x = 240;
			animations.anims.get("walk").y = 120;
		}
		
		if( animations.anims.exists("other") )
		{
			animList.push( animations.anims.get("other") );
			animations.anims.get("other").x = 300;
			animations.anims.get("other").y = 30;
		}*/
		var normal = new DfAnimation("normal");
		normal.x = 40;
		normal.y = 22;
		
		var walk = new DfAnimation("walk");
		walk.x = 240;
		walk.y = 120;
		
		var other = new DfAnimation("other");
		other.x = 300;
		other.y = 30;
		
		animList.push(normal);
		animList.push(walk);
		animList.push(other);
		
		// Add all the animations to the renderer
		for( anim in animList )
		{
			renderer.addChild( anim );
		}
		
		// And add the renderer view to the main sprite
		addChild( renderer.view );
		
		oldTime = Timer.stamp();
	}
	
	private function step(_)
	{
		var currTime = Timer.stamp();
		var diff = (currTime - oldTime) * 100;
		oldTime = currTime;
		
		// Update each animation
		for( anim in animList )
		{
			anim.step(diff);
		}

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