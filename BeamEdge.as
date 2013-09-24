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
	// An beam been two squares. Used for drawing the beams.
	public class BeamEdge
	{
		public var color:Number;
		
		public var square1:BoardSquare;
		public var square2:BoardSquare;
		
		public var drawn:Boolean = false;
		
		public var outgoingDirection:Number;
		public function BeamEdge()
		{
		}
		
		public function toString():String
		{
			return "Laser from " + this.square1.gridX + "," + this.square1.gridY + " to " + this.square2.gridX + "," + this.square2.gridY;
		}
	}
}