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
	import board_items.Orb;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	public class ItemGenerator extends MovieClip
	{
		// The item this generates
		private var item:BoardItem;
		
		// The stock this generate has
		private var amount:Number;
		
		// A reference to the gameboard
		public var gameBoard:GameBoard
		
		// What to add the newly created items into
		private var creationContainer:DisplayObjectContainer;
		
		private var itemName:String;
		public function ItemGenerator(creationContainer:DisplayObjectContainer, gameBoard:GameBoard, item:BoardItem, name:String, initialAmount:Number)
		{
			stop();
			this.creationContainer = creationContainer;
			this.item = item;
			this.amount = initialAmount;
			this.gameBoard = gameBoard;
			this.itemName = name;
			
			item.gotoAndStop(1);
			item.x = 39;
			item.y = 67;
			item.rotation = -item.orientation;
			addChild(item);
			
			quantity.text = amount.toString();
			label.text = name;
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
//			this.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
		}
		
		public function mouseDown(event:MouseEvent)
		{
			if(amount > 0)
			{
				// Make a new copy and place it on the cursor
				var newItem:BoardItem = clone();
				if(newItem != null)
				{
					setAmount(amount - 1);
					creationContainer.addChild(newItem);
					newItem.create(this);
				}
			}
		}
		
		// Clones the dummy item inside this ItemGenerator
		private function clone():BoardItem
		{
			var returnItem:BoardItem;
			try
			{
				// Use reflection to clone this object
				var refClass:Class = getDefinitionByName(getQualifiedClassName(item)) as Class;
				var newItem;
				
				var sourceInfo:XML = describeType(item);
				var prop:XML;
				
				var argCount:Number = 0;
				
				// A very very very hackish workaround
				for each(prop in sourceInfo.constructor.parameter)
				{
					if(prop.@optional == "false")
					{
						argCount++;
					}
				}
				// A very very very very very very hackish workaround
				if(argCount == 0) newItem= new refClass();
				if(argCount == 1) newItem= new refClass(null);
				if(argCount == 2) newItem= new refClass(null, null);
				if(argCount == 3) newItem= new refClass(null, null, null);
				if(argCount == 4) newItem= new refClass(null, null, null, null);
				if(argCount == 5) newItem= new refClass(null, null, null, null, null);
				if(argCount == 6) newItem= new refClass(null, null, null, null, null, null);
				

				for each(prop in sourceInfo.variable)
				{
					if(item[prop.@name] is Array) // This won't properly clone a multi-dimensional array!!!!!! </actionscript-limitations>
					{
						newItem[prop.@name] = new Array();
						
						var srcArray:Array = item[prop.@name] as Array;
						var dstArray:Array = newItem[prop.@name] as Array;
						var element;
						for each(element in srcArray)
						{
							dstArray.push(element);
						}
					}
					else
					{
						newItem[prop.@name] = item[prop.@name];
					}
				}
				
				
				returnItem = newItem;
			}
			catch(e:Object)
			{
				trace("failed to clone object" + e);
			}
			return returnItem;
		}
		
		// If the user fails to place the generated item in a valid spot
		// we need to increase the supply again because it is destroyed
		public function placementFail(item:BoardItem)
		{
			item.removeEventListeners();
			setAmount(amount + 1);
		}
		public function setAmount(num:Number)
		{
			this.amount = num;
			quantity.text = amount.toString();
		}
		public function getAmount():Number
		{
			return amount;
		}
		
		public function getName()
		{
			return itemName;
		}
		
		public function setBlinking(b:Boolean)
		{
			if(b)
			{
				this.gotoAndPlay(25);
			}
			else
			{
				this.gotoAndStop(1);
			}
		}
	}
}