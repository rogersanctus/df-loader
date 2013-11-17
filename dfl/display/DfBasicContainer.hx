package dfl.display;
import flash.display.DisplayObject;
import flash.display.Sprite;

/**
 * BasicContainer class
 * @author rogersanctus
 */
class DfBasicContainer extends DfBasicSprite
{
	/// All contained objects.
	public var children(default, null): Array<DfBasicSprite>;

	public function new()
	{
		super();		
		children = new Array<DfBasicSprite>();
	}
	
	override private function init( renderer: DfRenderer ): Void
	{
		this.renderer = renderer;
		initChildren();
	}
	
	private function initChild( child: DfBasicSprite ): Void
	{
		child.parent = this;
		
		if ( renderer != null && child.renderer == null )
		{
			child.init( renderer );
		}
	}
	
	private function initChildren(): Void
	{
		for ( child in children )
		{
			initChild( child );
		}
	}
	
	/**
	 * Gets the index of a child element.
	 * @param	child		The child in which to retrieve the index.
	 * @return	The child index,
	 */
	public inline function indexOf( child: DfBasicSprite ): Int
	{
		return Lambda.indexOf( children, child );
	}
	
	/**
	 * Insert a child element inside the container.
	 * @param	child		The child to be added.
	 * @return	The offset it was added at.
	 */
	public function addChild( child: DfBasicSprite ): Int
	{
		removeChild( child );
		
		initChild( child );
		return children.push( child );
	}
	
	/**
	 * Insert a child element inside the container at a specified position.
	 * @param	child		The child to be added.
	 * @param	at			Where to add the child.
	 */
	public function addChildAt( child: DfBasicSprite, at: Int ): Void
	{
		removeChild( child );
		
		initChild( child );
		children.insert( at, child );
	}
	
	/**
	 * Remove a child element from the container.
	 * @param	child		The child to be removed.
	 * @return	The removed child reference.
	 */
	public function removeChild( child: DfBasicSprite ): DfBasicSprite
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
	
	/**
	 * Remove a child element at a specified position from the container.
	 * @param	at			The offset where the child is.
	 * @return	The removed child reference.
	 */
	public function removeChildAt( at: Int ): DfBasicSprite
	{		
		var child = children.splice( at, 1 )[0];
		
		if ( child != null )
		{
			child.parent = null;
		}
		return child;
	}
	
	/**
	 * Removes all children elements from the container
	 * @return	A list of all the removed children references.
	 */
	public function removeAllChildren(): Array<DfBasicSprite>
	{
		for ( child in children )
		{
			child.parent = null;
		}
		return children.splice(0, children.length);
	}
	
	/**
	 * Returns the children iterator.
	 * @return	The children iterator.
	 */
	public inline function iterator(): Iterator<DfBasicSprite>
	{
		return children.iterator();
	}
}
