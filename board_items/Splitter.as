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
	public class Splitter extends BoardItem
	{
		public var outlets:Array;
		public var inlets:Array;
		public var oneWay:Boolean = false; // Can light come into the outlets to come out the inlets?
		public function Splitter(orientation:Number, square:BoardSquare=null)
		{
			super(orientation, square);
			gotoAndStop(1);
			this.outlets = new Array();
			this.inlets = new Array();
			addInlet(BoardItem.EAST);
			
			this.lockMove = false;
			this.lockRotate = false;
		}
		public override function next(incoming:BeamNode):Array
		{
			var nextNodes:Array = new Array();
			for(var i in inlets)
			{
				var inlet:Number = (this.orientation + inlets[i]) % 360;
				if(incoming.direction == inlet)
				{
					for(var j in outlets)
					{
						var outlet:Number = (this.orientation + outlets[j]) % 360;
						var outDir:Number = outlet;
						var nextSquare:BoardSquare = calculateNextSquare(outDir, getSquare());
						var nextNode:BeamNode = new BeamNode(nextSquare, outDir, incoming.color);
						nextNodes.push(nextNode);
					}
				}
			}
			
			if(!oneWay)
			{
				for(var i in outlets)
				{
					var outlet:Number = (this.orientation + outlets[i]) % 360;
					if(incoming.direction == (outlet + 180) % 360)
					{
						
						for(var j in inlets)
						{
							var inlet:Number = (this.orientation + inlets[j]) % 360;
							var outDir:Number = (inlet + 180) % 360;
							var nextSquare:BoardSquare = calculateNextSquare(outDir, getSquare());
							var nextNode:BeamNode = new BeamNode(nextSquare, outDir, incoming.color);
							nextNodes.push(nextNode);
						}
					}
				}
			}
			return nextNodes;
		}
		public function addOutlet(orientation:Number)
		{
			removeOutlet(orientation);
			outlets.push(orientation);
		}
		
		public function removeOutlet(orientation:Number)
		{
			var i = 0;
			while(i < outlets.length)
			{
				if(outlets[i] == orientation)
				{
					outlets.splice(i, 1);
				}
				else
				{
					i++;
				}
			}
		}
		
		public function addInlet(orientation:Number)
		{
			removeInlet(orientation);
			inlets.push(orientation);
		}
		
		public function removeInlet(orientation:Number)
		{
			var i = 0;
			while(i < inlets.length)
			{
				if(inlets[i] == orientation)
				{
					inlets.splice(i, 1);
				}
				else
				{
					i++;
				}
			}
		}
	}
}