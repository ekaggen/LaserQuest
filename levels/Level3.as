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
	public class Level3 extends GameLevel
	{
		public function Level3()
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
			
			gameItems.push(new LaserGun(BoardItem.BLUE, BoardItem.NORTH, gameBoard.squares[8][6]));
			gameItems.push(new LaserGun(BoardItem.BLUE, BoardItem.EAST, gameBoard.squares[1][1]));
			
			gameItems.push(new Orb(BoardItem.BLUE, gameBoard.squares[2][1]));
			gameItems.push(new Orb(BoardItem.BLUE, gameBoard.squares[4][1]));
			gameItems.push(new Orb(BoardItem.BLUE, gameBoard.squares[8][2]));
			gameItems.push(new Orb(BoardItem.BLUE, gameBoard.squares[11][3]));
			gameItems.push(new Orb(BoardItem.BLUE, gameBoard.squares[5][5]));
			gameItems.push(new Orb(BoardItem.BLUE, gameBoard.squares[3][6]));
			gameItems.push(new Orb(BoardItem.BLUE, gameBoard.squares[7][7]));
			gameItems.push(new Orb(BoardItem.BLUE, gameBoard.squares[8][8]));
			
			generators.push({item:new Mirror(BoardItem.NORTH_WEST, null), name:"Mirror", amount:6});
		}
	}
}