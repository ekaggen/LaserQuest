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
	public class Mirror extends BoardItem
	{
		public var doubleSided:Boolean = true;
		public function Mirror(orientation:Number, square:BoardSquare = null)
		{
			super(orientation, square);
			this.lockMove = false;
			this.lockRotate = false;
		}
		
		public override function next(incoming:BeamNode):Array
		{
			// If the mirror isn't double sided then don't reflect off the right side of the mirror
			if(!doubleSided)
			{
				if((incoming.direction - this.orientation + 360) % 360 <= 180)
				{
					return new Array();
				}
			}
			var mirror:Number = this.orientation % 180;

			var newOrientation:Number = (2 * mirror - incoming.direction + 360) % 360;

			if(newOrientation == incoming.direction || newOrientation == (incoming.direction + 180) % 360) // BLOCK IT
			{
				return new Array();
			}
			
			var nextSquare:BoardSquare = calculateNextSquare(newOrientation, getSquare());
			var nextNode:BeamNode = new BeamNode(nextSquare, newOrientation, incoming.color);
			return new Array(nextNode);
		}
	}
}