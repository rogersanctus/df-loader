package dfl.display;
import flash.display.DisplayObject;

/**
 * BasicSprite class
 * @author rogersanctus
 */
class DfBasicSprite
{
	private var renderer: DfRenderer;
	private var parent: DfBasicContainer;
	
	private var _x: Float;
	private var _y: Float;
	private var _width: Float;
	private var _height: Float;
	
	public var x(get, set): Float;
	public var y(get, set): Float;
	public var width(get, set): Float;
	public var height(get, set): Float;
	public var visible: Bool;

	public function new()
	{
		_x = 0;
		_y = 0;
		_width = 0;
		_height = 0;
		visible = true;
	}
	
	private function init( renderer: DfRenderer ): Void
	{
		this.renderer = renderer;
	}
	
	private function set_x( x: Float ): Float
	{
		return  _x = x;
	}	
	private function get_x(): Float
	{
		return _x;
	}
	
	private function set_y( y: Float ): Float
	{
		return  _y = y;
	}	
	private function get_y(): Float
	{
		return _y;
	}
	
	private function set_width( width: Float ): Float
	{
		return  _width = width;
	}	
	private function get_width(): Float
	{
		return _width;
	}
	
	private function set_height( height: Float ): Float
	{
		return  _height = height;
	}	
	private function get_height(): Float
	{
		return _height;
	}
}
