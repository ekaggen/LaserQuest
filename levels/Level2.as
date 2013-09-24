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
package levels
{
	import board_items.*;
	public class Level2 extends GameLevel
	{
		public function Level2()
		{
			super();
		}
		public override function init(gameBoard:GameBoard)
		{
			gameItems = new Array();
			generators = new Array();
			
			if(gameBoard == null)
			{
				return;
			}
			
			gameItems.push(new LaserGun(BoardItem.RED, BoardItem.SOUTH, gameBoard.squares[10][2]));
			
			gameItems.push(new Orb(BoardItem.RED, gameBoard.squares[3][3]));
			gameItems.push(new Orb(BoardItem.RED, gameBoard.squares[6][5]));
			gameItems.push(new Orb(BoardItem.RED, gameBoard.squares[12][7]));
			
			generators.push({item:new Mirror(BoardItem.NORTH_WEST, null), name:"Mirror", amount:2});
			var sp = new Splitter(BoardItem.EAST, null);
			sp.addOutlet(BoardItem.NORTH);
			sp.addOutlet(BoardItem.SOUTH);
			gameItems.push(sp);
			
			generators.push({item:sp, name:"Splitter", amount:1});
		}
	}
}