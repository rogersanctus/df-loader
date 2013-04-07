package ;

import aze.display.TileLayer;
import aze.display.TileSprite;
import nme.Assets;
import nme.display.Sprite;
import nme.events.Event;
import nme.Lib;
import dfl.display.Animations;
import dfl.display.Animation;
import haxe.Timer;

/**
 * ...
 * @author Rogério Santos
 */

class Main extends Sprite 
{
	private var animations: Animations;
	private var animList: Array<Animation>;
	
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
		animations = new Animations( Assets.getText("assets/animation.anim"), "assets", "assets" );
		animList = new Array<Animation>();
		
		if( animations.anims.exists("normal") )
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
		}
		
		/* Or just add all animations */
		/*
		 * for( anim in animations.anims )
		 * {
		 *		animList.push( anim );
		 * }
		 */
		 
		for( anim in animList )
		{
			addChild( anim.view );
		}
		
		oldTime = Timer.stamp();
	}
	
	private function step(_)
	{
		var currTime = Timer.stamp();
		var diff = (currTime - oldTime) * 100;
		oldTime = currTime;
		
		for( anim in animList )
		{
			anim.step(diff);
		}
	}
	
	static public function main() 
	{
		var stage = Lib.current.stage;
		stage.scaleMode = nme.display.StageScaleMode.NO_SCALE;
		stage.align = nme.display.StageAlign.TOP_LEFT;
		
		Lib.current.addChild(new Main());
	}
	
}