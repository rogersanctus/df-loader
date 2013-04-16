package dfl.display;
import nme.display.DisplayObject;
import nme.display.Sprite;

/**
 * BasicContainer class
 * @author rogersanctus
 */
class DfBasicContainer extends DfBasicSprite
{
	public var children: Array<DfBasicSprite>;
	
	#if flash
	public var sprContainer(default, null): Sprite;
	#end

	public function new()
	{
		super();		
		children = new Array<DfBasicSprite>();
		
		#if flash
		sprContainer = new Sprite();
		#end
	}
	
	#if flash
	override public function getView():DisplayObject 
	{
		return sprContainer;
	}
	#end
	
	override private function init( renderer: DfRenderer )
	{
		this.renderer = renderer;
		initChildren();
	}
	
	private function initChild( child: DfBasicSprite )
	{
		child.parent = this;
		
		if ( renderer != null && child.renderer == null )
		{
			child.init( renderer );
		}
	}
	
	private function initChildren()
	{
		for ( child in children )
		{
			initChild( child );
		}
	}
	
	public inline function indexOf( child: DfBasicSprite ): Int
	{
		return Lambda.indexOf( children, child );
	}
	
	public function addChild( child: DfBasicSprite ): Int
	{
		removeChild( child );
		
		#if flash
		sprContainer.addChild( child.getView() );
		#end
		
		initChild( child );
		return children.push( child );
	}
	
	public function addChildAt( child: DfBasicSprite, at: Int )
	{
		removeChild( child );
		
		#if flash
		sprContainer.addChildAt( child.getView(), at );
		#end
		
		initChild( child );
		children.insert( at, child );
	}
	
	public function removeChild( child: DfBasicSprite )
	{
		if ( child.parent == null)
		{
			return child;
		}
		
		if ( child.parent != this )
		{
			return child;
		}
		
		var i = indexOf( child );
		
		if ( i >= 0 )
		{
			#if flash
			sprContainer.removeChild( child.getView() );
			#end
			children.splice( i, 1 );
			child.parent = null;
		}
		
		return child;
	}
	
	public function removeChildAt( at: Int )
	{
		#if flash
		sprContainer.removeChildAt( at );
		#end
		
		var child = children.splice( at, 1 )[0];
		
		if ( child != null )
		{
			child.parent = null;
		}
		return child;
	}
	
	public function removeAllChildren()
	{
		#if flash
		while ( sprContainer.numChildren > 0 )		
		{
			sprContainer.removeChildAt( 0 );
		}
		#end

		for ( child in children )
		{
			child.parent = null;
		}
		return children.splice(0, children.length);
	}
	
	public inline function iterator()
	{
		return children.iterator();
	}
	
	override private function setX(x:Float):Float 
	{
		#if flash
		if ( sprContainer != null )
		{
			sprContainer.x = x;
		}
		#end
		return super.setX(x);
	}
	
	override private function setY(y:Float):Float 
	{
		#if flash
		if ( sprContainer != null )
		{
			sprContainer.y = y;
		}
		#end
		return super.setY(y);
	}
}
