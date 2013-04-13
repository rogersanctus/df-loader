package dfl.display;

/**
 * BasicContainer class
 * @author rogersanctus
 */
class DfBasicContainer extends DfBasicSprite
{
	public var children: Array<DfBasicSprite>;

	public function new()
	{
		super();		
		children = new Array<DfBasicSprite>();
	}
	
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
		
		initChild( child );
		return children.push( child );
	}
	
	public function addChildAt( child: DfBasicSprite, at: Int )
	{
		removeChild( child );
		
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
			children.splice( i, 1 );
			child.parent = null;
		}
		
		return child;
	}
	
	public function removeChildAt( at: Int )
	{
		var child = children.splice( at, 1 )[0];
		
		if ( child != null )
		{
			child.parent = null;
		}
		return child;
	}
	
	public function removeAllChildren()
	{
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
}
