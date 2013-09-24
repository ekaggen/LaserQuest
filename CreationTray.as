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
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	
	// Tray on the side which holds generators
	public class CreationTray extends MovieClip
	{
		public var gameBoard:GameBoard;
		private var generators:Array;
		
		public var spacing = 5;
		public var nextY = 0;
		
		public var refGenerator:ItemGenerator;
		public function CreationTray()
		{
			generators = new Array();
		}
		
		public function addGenerator(item:BoardItem, name:String, amount:Number)
		{
			var generator:ItemGenerator = new ItemGenerator(this.parent, gameBoard, item, name, amount);
			
			addGeneratorToContainer(generator);
			generators.push(generator);
		}
		private function addGeneratorToContainer(generator:ItemGenerator)
		{
			generator.x = 0;
			generator.y = nextY;
			
			nextY += getVisibleHeight(generator) + spacing;
			this.addChild(generator);
		}
		
		private function reflow()
		{
			clear();
			for(var i in generators)
			{
				addGeneratorToContainer(generators[i]);
			}
		}
		
		private function clear()
		{
			nextY = 0;
			while(this.numChildren > 0)
			{
				this.removeChildAt(0);
			}
		}
		
		public function reset()
		{
			generators = new Array();
			clear();
		}
		// Credit to moock's MegaPhone App Framework 1.0 for this idea
		function getVisibleHeight(gen:ItemGenerator):Number
		{
			var bitmapDataSize:int = 200;
			var bounds:Rectangle;
			var bitmapData:BitmapData = new BitmapData(bitmapDataSize, bitmapDataSize, true, 0);
			bitmapData.draw(gen);
			bounds = bitmapData.getColorBoundsRect( 0xFF000000, 0x00000000, false );
			bitmapData.dispose(); 
			return bounds.y + bounds.height;
		}
		
		public function getGeneratorByName(name:String):ItemGenerator
		{
			for(var i in generators)
			{
				if(generators[i].getName() == name)
				{
					return generators[i];
				}
			}
			return null;
		}
	}
}