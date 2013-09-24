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
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;

	public class Orb extends BoardItem
	{
		public static var GLOW_MAX_STEP:Number = 12; // Number of steps
		public static var GLOW_STOPPED_STEP:Number = 10; // Step that a non-glowing orb stops at
		public static var GLOW_AMOUNT:Number = 2; // Glow change per step
		private var glowStep:Number = 0;
		private var glowAscending:Boolean = true;
		private var glowLayer:MovieClip;
		
		public var color:Number;
		
		public var litColor:Number;
		public var orbDone:Boolean = false;

		public function Orb(color:Number, square:BoardSquare=null)
		{
			super(BoardItem.EAST, square);
			stop();
			//trace(tmpBmp.smoothing);
			this.color = color;
			
			glowLayer = new MovieClip();
			glowLayer.x = 0;
			glowLayer.y = 0;
			glowLayer.graphics.beginFill(0xCCCCCC);
			glowLayer.graphics.drawCircle(0, 0, 20);
			glowLayer.graphics.endFill();
			this.addChild(glowLayer);
			this.setChildIndex(glowLayer, 0);
			this.addEventListener(Event.ENTER_FRAME, enterFrame);
		}
		
		private function convertColor(c:Number):Number
		{
			var red:Number = c & 0x010000;
			var green:Number = c & 0x000100;
			var blue:Number = c & 0x000001;
			
			return (red >> 14) | (green >> 7) | blue;
		}
		
		public function calculateState()
		{
			litColor = 0;
			var firstBeam:Boolean = true;
			var singleBeam:Boolean = true;
			var beamDirection:Number;
			for(var i in getSquare().beams)
			{
				var beam:BeamEdge = getSquare().beams[i];
				if(firstBeam)
				{
					beamDirection = beam.outgoingDirection;
					firstBeam = false;
				}
				else if(beamDirection != beam.outgoingDirection)
				{
					// Eric's fix, 5/11/11
					if((beamDirection + 180) % 360 != beam.outgoingDirection)
					{
						singleBeam = false;
					}
				}
				litColor |= beam.color;
			}
			this.gotoAndStop(convertColor(litColor) + 1);
			if(singleBeam && litColor == this.color)
			{
				glowAscending = false; // Start out by glowing inwards
				orbDone = true;
			}
			else
			{
				orbDone = false;
			}
		}
		public function enterFrame(event:Event)
		{
			if(orbDone)
			{
				if(glowAscending)
				{
					if(glowStep >= GLOW_MAX_STEP)
					{
						glowAscending = false;
					}
					else
					{
						applyGlow();
						glowStep++;
					}
				}
				else
				{
					if(glowStep <= 0)
					{
						glowAscending = true;
					}
					else
					{
						applyGlow();
						glowStep--;
					}
				}
			}
			else
			{
				glowStep = GLOW_STOPPED_STEP;
				applyGlow();
			}
		}
		public function applyGlow()
		{
			var glow:GlowFilter = new GlowFilter();
			glow.knockout = true;
			glow.color = this.color;
			glow.alpha = 1;
			glow.blurX = GLOW_AMOUNT * glowStep;
			glow.blurY = GLOW_AMOUNT * glowStep;
			glow.strength = 2.6;
			glow.quality = 2;
			this.glowLayer.filters = new Array(glow);
		}
		
		public override function next(incoming:BeamNode):Array
		{
			var nextSquare:BoardSquare = calculateNextSquare(incoming.direction, getSquare());
			var nextNode:BeamNode = new BeamNode(nextSquare, incoming.direction, incoming.color);
			return new Array(nextNode);
		}
	}
	
}