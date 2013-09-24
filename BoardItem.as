/*	
	Copyright (c) 2011 Eric Kaggen

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in
	all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
	THE SOFTWARE.
*/
package 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.display.StageQuality;
	
	import mx.core.mx_internal;

	public class BoardItem extends MovieClip
	{
		public static var EAST:Number = 0;
		public static var NORTH_EAST:Number = 45;
		public static var NORTH:Number = 90;
		public static var NORTH_WEST:Number = 135;
		public static var WEST:Number = 180;
		public static var SOUTH_WEST:Number = 225;
		public static var SOUTH:Number = 270;
		public static var SOUTH_EAST:Number = 315;
		
		public static var RED:Number = 0xFF0000;
		public static var GREEN:Number = 0x00FF00;
		public static var BLUE:Number = 0x0000FF;

		private var square:BoardSquare;
		private var gameBoard:GameBoard;
		
		public var orientation:Number;
		public var lockRotate:Boolean = true;
		public var lockMove:Boolean = true;
		public var active:Boolean = true;
		
		public var dragging:Boolean = false;
		public var dragOver:BoardSquare = null;
		
		private var creator:ItemGenerator = null;
		
		private var listenersInit:Boolean = false;
		// Could split locked into rotate and move locked (to allow preplaced items to be rotated eg)
		public function BoardItem(orientation:Number, square:BoardSquare = null)
		{
			setSquare(square);
			if(square != null)
			{
				gameBoard = square.gameBoard;
			}
			this.orientation = orientation;
			//this.stage.quality = StageQuality.BEST;
		}

		public function drag(redrawLasers:Boolean = true)
		{
			if(!listenersInit)
			{
				this.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoved);
				this.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
				listenersInit = true;
			}
			
			if(redrawLasers && square != null)
			{
				square.gameBoard.drawLasers();
			}
			this.hitArea = null;
			dragging = true;
			dragOver = null;
			this.startDrag(true);
			this.stage.addEventListener(Event.MOUSE_LEAVE, mouseLeft);
			this.stage.addEventListener(MouseEvent.MOUSE_UP, mouseLeft);
		}
		
		public function create(generator:ItemGenerator)
		{
			this.rotation = -this.orientation;
			creator = generator;
			gameBoard = creator.gameBoard;
			drag(false);
		}
		public function removeEventListeners()
		{
			this.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoved);
			this.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
			
			if(this.stage != null)
			{
				this.stage.removeEventListener(Event.MOUSE_LEAVE, mouseLeft);
				this.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseLeft);
			}
		}
		public function mouseLeft(event:Event)
		{
			if(dragging)
			{
				this.stage.removeEventListener(Event.MOUSE_LEAVE, mouseLeft);
				this.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseLeft);
				dragging = false;
				stopDrag();
				this.parent.removeChild(this);
				
				placementFail();
				if(dragOver != null)
				{
					dragOver.setHover(false);
					dragOver = null;
				}
			}
		}
		
		private function placementFail()
		{
			if(creator == null) // No creator?
			{
				square.putItem(this);
			}
			else
			{
				creator.placementFail(this);
			}
		}
		public function mouseUp(event:MouseEvent)
		{
			if(dragging)
			{
				this.stage.removeEventListener(Event.MOUSE_LEAVE, mouseLeft);
				this.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseLeft);
				dragging = false;
				stopDrag();
				this.parent.removeChild(this);
				if(dragOver != null)
				{
					dragOver.setHover(false);
					
					if(gameBoard.dropItem(this, dragOver))
					{
						setSquare(dragOver);
						dragOver.putItem(this);
						square.gameBoard.changeSelection(square);
					}
					else
					{
						placementFail();
					}
					dragOver = null;
					gameBoard.postItemDrop();
				}
				else
				{
					placementFail();
				}
			}
		}
		public function mouseMoved(event:MouseEvent)
		{
			if(dragging)
			{
//				trace("MKAY");
				for(var i:Number = 0; i < gameBoard.squares.length; i++)
				{
					for(var j:Number = 0; j < gameBoard.squares[i].length; j++)
					{
						var sq:BoardSquare = gameBoard.squares[i][j];
//						if(sq.hitTestPoint(this.localToGlobal(new Point()).x, this.localToGlobal(new Point()).y))
						if(sq.hitTestPoint(event.stageX, event.stageY))
						{
							if(sq.item == null)
							{
								if(this.dragOver != null)
								{
									this.dragOver.setHover(false);
								}
								this.dragOver = sq;
								this.dragOver.setHover(true);
	
								return;
							}
						}
					}
				}
				if(this.dragOver != null)
				{
					this.dragOver.setHover(false);
					this.dragOver = null
				}
			}
		}
		public function next(incoming:BeamNode):Array
		{
			return new Array();
		}
		//public function incomingLaser
		public function calculateNextSquare(direction:Number, currentSquare:BoardSquare):BoardSquare
		{
			// Limits
			var xLimit:Number = gameBoard.squares.length;
			var yLimit:Number = gameBoard.squares[0].length;
			
			// Coordinate based direction
			var xDir:Number;
			var yDir:Number;
			
			// New Coordiantes
			var x:Number = currentSquare.gridX;
			var y:Number = currentSquare.gridY;
			
			if(direction == BoardItem.EAST)			{ xDir = 1; yDir = 0; }
			if(direction == BoardItem.NORTH_EAST) 	{ xDir = 1; yDir = -1; }
			if(direction == BoardItem.NORTH) 		{ xDir = 0; yDir = -1; }
			if(direction == BoardItem.NORTH_WEST)	{ xDir = -1;yDir = -1; }
			if(direction == BoardItem.WEST)			{ xDir = -1;yDir = 0; }
			if(direction == BoardItem.SOUTH_WEST)	{ xDir = -1;yDir = 1; }
			if(direction == BoardItem.SOUTH)		{ xDir = 0; yDir = 1; }
			if(direction == BoardItem.SOUTH_EAST)	{ xDir = 1;	yDir = 1; }
			
			x += xDir;
			y += yDir;
			
			if(x >= 0 && x < xLimit && y >= 0 && y < yLimit)
			{
				return gameBoard.squares[x][y];
			}
			else
			{
				return null;
			}
		}
		
		public function setSquare(square:BoardSquare)
		{
			this.square = square;
		
			if(square != null)
			{
				this.hitArea = square;
				creator = null;
			}
		}
		
		public function putInSquare()
		{
			if(square != null)
			{
				square.putItem(this);
			}
		}
		
		public function removeFromSquare()
		{
			if(square != null)
			{
				square.removeItem();
			}
		}
		
		public function getSquare():BoardSquare
		{
			return square;
		}
	}
}
