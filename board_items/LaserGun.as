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
package board_items
{
	import flash.display.MovieClip;
	
	public class LaserGun extends BoardItem
	{
		public var color:Number;
		public function LaserGun(color:Number, orientation:Number, square:BoardSquare = null)
		{
			super(orientation, square);
			this.color = color;
		}
		
		public override function next(incoming:BeamNode):Array
		{
			if(incoming == null || incoming.source != getSquare() || incoming.direction != this.orientation) // Don't pass incoming beams
			{
				return new Array();
			}
//			trace(incoming.source.gridX + "," + incoming.source.gridY);
			var nextSquare:BoardSquare = calculateNextSquare(orientation, getSquare());
			var nextNode:BeamNode = new BeamNode(nextSquare, this.orientation, this.color);
			return new Array(nextNode);
		}
		
		// This can be changed to have a laser gun emit multiple beams
		public function getBeams():Array
		{
			var beam:BeamNode = new BeamNode(getSquare(), this.orientation, this.color);
			return new Array(beam);
		}
	}
}