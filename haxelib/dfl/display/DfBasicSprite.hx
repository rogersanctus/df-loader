package dfl.display;

/**
 * BasicSprite class
 * @author rogersanctus
 */
class DfBasicSprite
{
	private var renderer: DfRenderer;
	private var parent: DfBasicContainer;
	
	public var x(getX, setX): Float;
	public var y(getY, setY): Float;
	public var width(getWidth, setWidth): Float;
	public var height(getHeight, setHeight): Float;
	public var visible: Bool;

	public function new()
	{
		x = 0;
		y = 0;
		visible = true;
	}
	
	private function init( renderer: DfRenderer )
	{
		this.renderer = renderer;
	}
	
	private function setX( x: Float ): Float
	{
		return  this.x = x;
	}	
	private function getX(): Float
	{
		return x;
	}
	
	private function setY( y: Float ): Float
	{
		return  this.y = y;
	}	
	private function getY(): Float
	{
		return y;
	}
	
	private function setWidth( width: Float ): Float
	{
		return  this.width = width;
	}	
	private function getWidth(): Float
	{
		return width;
	}
	
	private function setHeight( height: Float ): Float
	{
		return  this.height = height;
	}	
	private function getHeight(): Float
	{
		return height;
	}
}
