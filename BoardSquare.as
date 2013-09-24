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
	import board_items.Block;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	// A square on the board. Contains all of the mouse movement and dragging logic for itself.
	public class BoardSquare extends MovieClip
	{
		public static var DRAG_THRESHOLD:Number = 10;
		
		public var gameBoard:GameBoard;
		public var item:BoardItem = null;
		
		public var gridX:Number;
		public var gridY:Number;
		
		public var beams:Array;
		
		private var highlighted:Boolean = false;
		private var hover:Boolean = false;
		
		private var mx:Number;
		private var my:Number;
		
		private var isMouseDown:Boolean = false;
		
		private var ghostItem:BoardItem;
//		private var dragging:Boolean = false;
		
		public function BoardSquare(gameBoard:GameBoard, gridX:Number, gridY:Number, init:Boolean = true)
		{
			if(init)
			{
				initialize();
			}
			
			this.gameBoard = gameBoard;
			this.gridX = gridX;
			this.gridY = gridY;
			
			this.beams = new Array();
		}
		
		public function initialize()
		{
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			this.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			this.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			this.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
		}
		
		public function mouseDown(event:MouseEvent)
		{
			isMouseDown = true;
			mx = event.stageX;
			my = event.stageY;
		}
		
		public function mouseUp(event:MouseEvent)
		{
			isMouseDown = false;
			//if(Math.abs(mx - event.localX) < DRAG_THRESHOLD && Math.abs(my - event.localY) < DRAG_THRESHOLD)
			if(Math.abs(mx - event.stageX) < DRAG_THRESHOLD && Math.abs(my - event.stageY) < DRAG_THRESHOLD)
			{
				if(item != null && !(item.lockMove && item.lockRotate))
				{
					selectThis();
				}
			}
//			trace("UP: " + event.stageX + "," + event.stageY + ";coords=" + gridX + "," + gridY);
		}
		
		public function mouseOut(event:MouseEvent)
		{
			if(isMouseDown)
			{
				isMouseDown = false;
			}
		}
		
		public function mouseMove(event:MouseEvent)
		{
			if(isMouseDown)
			{
				if(item != null && !item.lockMove)
				{
					if(Math.abs(mx - event.stageX) >= DRAG_THRESHOLD || Math.abs(my - event.stageY) >= DRAG_THRESHOLD)
					{
						var tempItem:BoardItem = item;
						isMouseDown = false;
						
						this.removeChild(item);
						this.parent.addChild(item);
						item = null;
						gameBoard.changeSelection(null);
						tempItem.drag();
					}
				}
			}
		}
		
		public function selectThis()
		{
			gameBoard.changeSelection(this);
		}
		public function putItem(item:BoardItem)
		{
//			trace(this + " got item");
			this.item = item;
			
			this.addChild(item);
			item.x = 0;
			item.y = 0;

			item.rotation = -item.orientation;

			gameBoard.drawLasers();
		}
		
		
		public function removeItem()
		{
			this.removeChild(item);
			this.item = null;
		}
		
		public function setSelected(selected:Boolean)
		{
			if(selected)
			{
				this.gotoAndStop(3);
			}
			else
			{
				if(highlighted)
				{
					this.gotoAndStop(4);
				}
				else
				{
					this.gotoAndStop(1);
				}
			}
		}
		public function setHighlight(highlight:Boolean)
		{
			this.highlighted = highlight;
			setHover(hover);
		}
		public function setHover(h:Boolean)
		{
			var newFrame:Number;
			if(h)
			{
				newFrame = 2;
			}
			else
			{
				newFrame = 1;
			}
			
			if(highlighted)
			{
				newFrame += 3;
			}
			this.gotoAndStop(newFrame);
		}
		
		public function getItem():BoardItem
		{
			return item;
		}
		
		public override function toString():String
		{
			return "[square " + this.gridX + "," + this.gridY + "]";
		}
		
		// Adds a ghost (non-working) item to the board and makes it transparent
		public function addGhost(item:BoardItem)
		{
			item.removeEventListeners();
			ghostItem = item;
			item.alpha = 0.3;
			this.addChild(item);
			item.x = 0;
			item.y = 0;
			
			item.rotation = -item.orientation;
			
		}
		
		// Removes the previously created ghost
		public function removeGhost()
		{
			if(ghostItem != null)
			{
				this.removeChild(ghostItem);
				ghostItem = null;
			}
		}
	}
}