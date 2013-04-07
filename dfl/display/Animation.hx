package dfl.display;

import aze.display.TileLayer;
import nme.display.Sprite;

/**
 * ...
 * @author Rogério
 */

class Animation// extends TileLayer
{
	public var loops: Int;
	public var cells(default, null): Array<Cell>;
	
	//public var layer(default, null): TileLayer;
	private var layer: TileLayer;
	
	public var view( getView, null): Sprite;
	
	private var _playing: Bool;
	private var _currLoop: Int;
	private var _currCell: Int;
	private var _cellTime: Float;
	
	public var x(getX, setX): Float;
	public var y(getY, setY): Float;
	
	private var _canAddSprites: Bool;

	public function new( spriteSheet: SpriteSheet, loops: Int, smooth: Bool = false )
	{
		this.loops = loops;
		
		cells = new Array<Cell>();
		cells.sort(function(a: Cell, b: Cell) {
			return (a.index - b.index);
		});
		
		layer = new TileLayer(spriteSheet, smooth);
		
		_playing = true;
		_currLoop = 0;
		_currCell = 0;
		_cellTime = 0;
		
		_canAddSprites = true;
	}
	
	public function play(): Void
	{
		if (!_playing)
		{
			_playing = true;
		}
	}
	
	public function stop(): Void
	{
		if ( _playing )
		{
			_playing = false;
			_currLoop = 0;
			_currCell = 0;
			_cellTime = 0;
		}
	}
	
	public function step( dt: Float ): Void
	{
		if (!_playing)
		{
			return;
		}
		
		if ( _currLoop <= loops )
		{

			if ( _currCell >= 0 && _currCell <= cells.length )
			{
				if ( _cellTime >= cells[_currCell].delay )
				{					
					// Remove all previous sprites from the layer
					layer.removeAllChildren();
					
					if ( _currCell < cells.length - 1)
					{
						_currCell++;
					}
					// End of animation cicle
					else
					{
						// Infinite loops
						if ( loops == 0 )
						{
							_currLoop = 0;
						}
						// Next loop
						else if( loops > 0 )
						{
							_currLoop++;					
						}
						_currCell = 0;
					}
					_cellTime = 0;
					
					_canAddSprites = true;
				}
				
				// Add all the sprites for this cell
				if ( _canAddSprites  )
				{
					for ( spr in cells[_currCell].sprs )
					{
						layer.addChild( spr.tileSprite );
					}
					_canAddSprites = false;
				}
			}
			
			_cellTime += dt;
		}
		
		layer.render();
	}
	
	public function addCell( cell: Cell ): Void
	{
		cells.push( cell );
	}
	
	private function getView(): Sprite
	{
		return layer.view;
	}
	
	private function setX( x: Float ): Float
	{
		return layer.x = x;
	}
	
	private function setY( y: Float ): Float
	{
		return layer.y = y;
	}
	
	private function getX(): Float
	{
		return layer.x;
	}
	
	private function getY(): Float
	{
		return layer.y;
	}
}