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
	import board_items.*;
	
	import flash.display.SimpleButton;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	
	// Proof of concept alternative game board. Implements a tutorial.
	// This should be extended to read from a file instead of putting all business logic here.
	public class TutorialBoard extends GameBoard
	{
		private var tutorialStage:Number = 0;
		public var tutorialText:TextField;

		public var backButton:SimpleButton;
		public var nextButton:SimpleButton;
		
		private var redrawStage:Boolean = false;
		public function TutorialBoard()
		{
			super();
			tutorialStage = 0;
		}
		
		protected override function triggerVictory()
		{
			victory = false;
			if(orbs.length == 0)
			{
				return;
			}
			if(tutorialStage == 6)
			{
				tutorialStage++;
				drawTutorialStage();
			}
			else if(tutorialStage == 8)
			{
				tutorialStage++;
				drawTutorialStage();
			}
			else if(tutorialStage == 11)
			{
				tutorialStage++;
				drawTutorialStage();
			}
			else if(tutorialStage == 13)
			{
				tutorialStage++;
				//redrawStage = true;
				drawTutorialStage();
			}
			else if(tutorialStage == 16)
			{
				tutorialStage++;
				drawTutorialStage();
			}
			else if(tutorialStage == 18)
			{
				tutorialStage++;
				drawTutorialStage();
			}
			else if(tutorialStage == 24)
			{
				tutorialStage++;
				drawTutorialStage();
			}
		}
		
		public override function initialize(rows:Number, cols:Number, lineThickness:Number)
		{
			initSquares(rows, cols, lineThickness);
			boardActive = true;
			
			drawTutorialStage();
		}
		
		private function highlightSquare(state:Boolean, square:BoardSquare)
		{
			square.setHighlight(state);
			bringToFront(square);
		}
		private function drawTutorialStage(change:Number = 0, clear:Boolean = true)
		{
			if(change != 0)
			{
				tutorialStage += change;
				drawTutorialStage(0);
				return;
			}
			if(clear)
			{
				clearBoard();
				super.changeSelection(null);
				if(creationTray != null)
				{
					creationTray.reset();
				}
			}
			tutorialText.styleSheet = new StyleSheet();

			tutorialText.styleSheet.setStyle(".header", {
				color:"#FF0000",
				fontSize: "18px", 
				leading: "10px",
				textDecoration: "underline", 
				textAlign: "center"
			});
			
			tutorialText.styleSheet.setStyle(".instruction", {
				color:"#0000FF",
				textAlign: "center"
			});
			if(tutorialStage == 0)
			{
				tutorialText.text = "Welcome to the LaserQuest tutorial!\n\n" +
					"In this tutorial you will be taught the basics of the game.\n\n" +
					"You will also learn about the different items that you will use in your " +
					"quest to solve every puzzle. These items all have unique and special properties. " +
					"Learning how they all work is essential to becoming a master at LaserQuest.\n\n" +
					"This is an interactive tutorial, you will be given different tasks to complete. You must complete " +
					"these in order to continue with the tutorial.\n\n" +
					"Lets begin the tutorial! Please press next to continue the tutorial.";
				backButton.visible = false;
				nextButton.visible = true;
			}
			else if(tutorialStage == 1)
			{
				tutorialText.text = "<p class='header'>The Laser</p>This is a laser gun. It is the most important item in LaserQuest. Notice that it shoots out a " +
					"red laser beam.\n\n" +
					"Manipulating this laser beam is the way that you solve a LaserQuest puzzle.\n\nWe will introduce different items " +
					"that you can use to manipulate the laser beam later on.";
				backButton.visible = true;
				nextButton.visible = true;
				addItem(new LaserGun(BoardItem.RED, BoardItem.NORTH, squares[2][6]));
				highlightSquare(true, squares[2][6]);
			}
			else if(tutorialStage == 2)
			{
				tutorialText.text = "<p class='header'>Goal</p>This is an orb. The goal of LaserQuest is to light up all of the orbs on the board.\n\n" +
					"You can light up an orb by shining a laser beam onto it.\n\n\nLets do that now.";
				backButton.visible = true;
				nextButton.visible = true;
				
				addItem(new LaserGun(BoardItem.RED, BoardItem.NORTH, squares[2][6]));
				addItem(new Orb(BoardItem.RED, squares[6][2]));
				
				highlightSquare(true, squares[6][2]);
				
				//squares[5][5].addGhost(new LaserGun(BoardItem.RED, BoardItem.NORTH));
				//addItem();
			}
			else if(tutorialStage == 3)
			{
				tutorialText.text = "<p class='header'>Using Items</p>Notice that an item tray has appeared to the left of the game board under the title " +
					"\"Items Left\".\n\nThis is where you can grab items to place on the board.\n\nYou have been given one mirror to use " +
					"in order to solve this puzzle. The mirror can be used to redirect a beam of light. You will use it to shine the red laser" +
					" onto the orb.";
				backButton.visible = true;
				nextButton.visible = true;
				
				addItem(new LaserGun(BoardItem.RED, BoardItem.NORTH, squares[2][6]));
				addItem(new Orb(BoardItem.RED, squares[6][2]));
				
				creationTray.addGenerator(new Mirror(BoardItem.NORTH_WEST), "Mirror", 1);
				creationTray.getGeneratorByName("Mirror").setBlinking(true);
			}
			else if(tutorialStage == 4)
			{
				tutorialText.text = "<p class='header'>Solving Puzzles</p>Drag the mirror from the item tray onto the highlighted " +
					"square. This will change the direction of the laser beam.";
				backButton.visible = true;
				nextButton.visible = false;
				
				addItem(new LaserGun(BoardItem.RED, BoardItem.NORTH, squares[2][6]));
				addItem(new Orb(BoardItem.RED, squares[6][2]));
				
				squares[2][2].addGhost(new Mirror(BoardItem.NORTH_WEST));
				highlightSquare(true, squares[2][2]);
				creationTray.addGenerator(new Mirror(BoardItem.NORTH_WEST), "Mirror", 1);
			}
			else if(tutorialStage == 5)
			{
				tutorialText.text = "<p class='header'>Solving Puzzles</p>Great job! Notice that the laser beam is deflected to the left by the mirror that you " +
					"placed. Since the orb is to the right of the mirror you need to rotate it.\n\nTo rotate an item you begin " +
					"by selecting it.\n\n<p class='instruction'>Click the mirror to select it.</p>";
				backButton.visible = true;
				nextButton.visible = false;
				
				
				addItem(new LaserGun(BoardItem.RED, BoardItem.NORTH, squares[2][6]));
				addItem(new Orb(BoardItem.RED, squares[6][2]));
				
				var mirror:BoardItem = new Mirror(BoardItem.NORTH_WEST, squares[2][2]);
				addItem(mirror);
				mirror.lockMove = true;
				
				creationTray.addGenerator(new Mirror(BoardItem.NORTH_WEST), "Mirror", 0);
				
				highlightSquare(true, squares[2][2]);
			}
			else if(tutorialStage == 6)
			{
				tutorialText.text = "<p class='header'>Solving Puzzles</p>Now use the rotate buttons below the game board to rotate the mirror.\n\n(You can also use the left and right arrow keys)\n\n" +
					"<p class='instruction'>Rotate it clockwise twice.</p>";
				backButton.visible = true;
				nextButton.visible = false;
				
				
				addItem(new LaserGun(BoardItem.RED, BoardItem.NORTH, squares[2][6]));
				addItem(new Orb(BoardItem.RED, squares[6][2]));
				
				var mirror:BoardItem = new Mirror(BoardItem.NORTH_WEST, squares[2][2]);
				addItem(mirror);
				mirror.lockMove = true;
				
				creationTray.addGenerator(new Mirror(BoardItem.NORTH_WEST), "Mirror", 0);
				
				super.changeSelection(squares[2][2]);
				squares[2][2].addGhost(new Mirror(BoardItem.NORTH_EAST));
			}
			else if(tutorialStage == 7)
			{
				tutorialText.text = "<p class='header'>Solving Puzzles</p>Congratulations, you've solved the puzzle.\n\nNotice that after the orb is illuminated " +
					"by the laser beam it began pulsing. The goal of the game is to get all orbs to pulse like this.";
				backButton.visible = false;
				nextButton.visible = true;
				
				
				addItem(new LaserGun(BoardItem.RED, BoardItem.NORTH, squares[2][6]));
				addItem(new Orb(BoardItem.RED, squares[6][2]));
				
				var mirror:BoardItem = new Mirror(BoardItem.NORTH_EAST, squares[2][2]);
				addItem(mirror);
				mirror.lockMove = true;
				mirror.lockRotate = true;
				
				creationTray.addGenerator(new Mirror(BoardItem.NORTH_WEST), "Mirror", 0);
				
				super.changeSelection(squares[2][2]);
			}
			else if(tutorialStage == 8)
			{
				tutorialText.text = "<p class='header'>Practice</p>Before moving on lets try a simple puzzle with a few mirrors.\n\n" +
					"To help you out there are outlines of each mirror that you need to place on the game board.\n\n" +
					"<p class='instruction'>You will need to place 3 mirrors and rotate them appropriately.</p>";
				backButton.visible = false;
				nextButton.visible = false;
				
				
				addItem(new LaserGun(BoardItem.RED, BoardItem.NORTH, squares[2][6]));
				addItem(new LaserGun(BoardItem.RED, BoardItem.SOUTH, squares[6][6]));
				addItem(new Orb(BoardItem.RED, squares[6][2]));
				addItem(new Orb(BoardItem.RED, squares[8][4]));
				
				squares[2][2].addGhost(new Mirror(BoardItem.NORTH_EAST));
				squares[6][8].addGhost(new Mirror(BoardItem.NORTH_WEST));
				squares[8][8].addGhost(new Mirror(BoardItem.NORTH_EAST));
				creationTray.addGenerator(new Mirror(BoardItem.NORTH_WEST), "Mirror", 3);
			}
			else if(tutorialStage == 9)
			{
				tutorialText.text = "<p class='header'>Practice</p>" +
					"Very good. Now we will introduce another very important item into the game -- the beam splitter.";
				backButton.visible = false;
				nextButton.visible = true;
				addItem(new LaserGun(BoardItem.RED, BoardItem.NORTH, squares[2][6]));
				addItem(new LaserGun(BoardItem.RED, BoardItem.SOUTH, squares[6][6]));
				addItem(new Orb(BoardItem.RED, squares[6][2]));
				addItem(new Orb(BoardItem.RED, squares[8][4]));
				
				var mirror:BoardItem;
				
				mirror = new Mirror(BoardItem.NORTH_EAST, squares[2][2]);
				mirror.lockRotate = true;
				mirror.lockMove = true;
				addItem(mirror);
				mirror = new Mirror(BoardItem.NORTH_WEST, squares[6][8]);
				mirror.lockRotate = true;
				mirror.lockMove = true;
				addItem(mirror);
				mirror = new Mirror(BoardItem.NORTH_EAST, squares[8][8]);
				mirror.lockRotate = true;
				mirror.lockMove = true;
				addItem(mirror);

				creationTray.addGenerator(new Mirror(BoardItem.NORTH_WEST), "Mirror", 0);
			}
			else if(tutorialStage == 10)
			{
				tutorialText.text = "<p class='header'>Beam Splitter</p>The beam splitter has 3 places where light can enter and " +
					"exit, called ports.\n\n" +
					"Light entering the main port will be split into two beams coming out of the other 2 ports. Note the difference between " +
					"the main port on the bottom and the two secondary ports on the left and right side of the splitter." +
					"\n\n<p class='instruction'>Drag the beam splitter onto the game board to see it in action!</p>";
				backButton.visible = false;
				nextButton.visible = false;
				addItem(new LaserGun(BoardItem.RED, BoardItem.NORTH, squares[5][6]));
				
				
				var sp = new Splitter(BoardItem.NORTH, null);
				sp.addOutlet(BoardItem.NORTH);
				sp.addOutlet(BoardItem.SOUTH);
				squares[5][4].addGhost(sp);
				
				sp = new Splitter(BoardItem.NORTH, null);
				sp.addOutlet(BoardItem.NORTH);
				sp.addOutlet(BoardItem.SOUTH);
				creationTray.addGenerator(sp, "Splitter", 1);
				creationTray.getGeneratorByName("Splitter").setBlinking(true);
				
				addItem(new Orb(BoardItem.RED, squares[7][4]));
				addItem(new Orb(BoardItem.RED, squares[1][2]));
				
				//creationTray.addGenerator(new Mirror(BoardItem.NORTH_WEST), "Mirror", 1);
			}
			else if(tutorialStage == 11)
			{
				tutorialText.text = "<p class='header'>Beam Splitter</p>Notice that the beam was split in two. Now you have two laser beams to work with. This comes in handy " +
					"because you have two orbs to light up as well.\n\n" +
					"<p class='instruction'>Now finish this puzzle by using a mirror to reflect the beam coming " +
					"out of the splitter onto the unlit orb.</p>";
				backButton.visible = false;
				nextButton.visible = false;
				addItem(new LaserGun(BoardItem.RED, BoardItem.NORTH, squares[5][6]));
				
				
				var sp = new Splitter(BoardItem.NORTH, squares[5][4]);
				sp.addOutlet(BoardItem.NORTH);
				sp.addOutlet(BoardItem.SOUTH);
				sp.lockMove = true;
				sp.lockRotate = true;
				addItem(sp);

				creationTray.addGenerator(new Splitter(BoardItem.NORTH, null), "Splitter", 0);
				
				addItem(new Orb(BoardItem.RED, squares[1][2]));
				addItem(new Orb(BoardItem.RED, squares[7][4]));

				creationTray.addGenerator(new Mirror(BoardItem.NORTH_WEST), "Mirror", 1);
			}
			else if(tutorialStage == 12)
			{
				tutorialText.text = "<p class='header'>Beam Splitter</p>Good job. Lets move on.";
				backButton.visible = false;
				nextButton.visible = true;
				addItem(new LaserGun(BoardItem.RED, BoardItem.NORTH, squares[5][6]));
				
				
				var sp = new Splitter(BoardItem.NORTH, squares[5][4]);
				sp.addOutlet(BoardItem.NORTH);
				sp.addOutlet(BoardItem.SOUTH);
				sp.lockMove = true;
				sp.lockRotate = true;
				addItem(sp);
				
				creationTray.addGenerator(new Splitter(BoardItem.NORTH, null), "Splitter", 0);
				
				addItem(new Orb(BoardItem.RED, squares[1][2]));
				addItem(new Orb(BoardItem.RED, squares[7][4]));
				
				var mirror:BoardItem = new Mirror(BoardItem.NORTH_WEST, squares[1][4]);
				mirror.lockRotate = true;
				mirror.lockMove = true;
				addItem(mirror);
				
				creationTray.addGenerator(new Mirror(BoardItem.NORTH_WEST), "Mirror", 0);
			}
			else if(tutorialStage == 13)
			{
				tutorialText.text = "<p class='header'>Orb Overload</p>Before moving on we need to deal with one last thing. Sometimes you will have a situation where an orb " +
					"is illuminated by multiple laser beams.\n\nThis causes the orb to overload so it will not begin to pulse. Now that you " +
					"know, try to solve this puzzle.";
				
				backButton.visible = false;
				nextButton.visible = false;
				
				addItem(new LaserGun(BoardItem.RED, BoardItem.WEST, squares[7][4]));
				addItem(new LaserGun(BoardItem.RED, BoardItem.NORTH, squares[4][7]));
				addItem(new Orb(BoardItem.RED, squares[4][4]));
				
				squares[6][4].addGhost(new Mirror(BoardItem.NORTH_WEST));
				
				creationTray.addGenerator(new Mirror(BoardItem.NORTH_WEST), "Mirror", 1);
			}
			else if(tutorialStage == 14)
			{
				tutorialText.text = "<p class='header'>Orb Overload</p>Good job. Always check if an orb's glow is pulsing to see if it's solved. Don't just rely " +
					"on the color of the middle.\n\nNow lets move onto more exciting things.";
				
				backButton.visible = false;
				nextButton.visible = true;
				
				addItem(new LaserGun(BoardItem.RED, BoardItem.WEST, squares[7][4]));
				addItem(new LaserGun(BoardItem.RED, BoardItem.NORTH, squares[4][7]));
				addItem(new Orb(BoardItem.RED, squares[4][4]));
				
				var mirror:BoardItem = new Mirror(BoardItem.NORTH_WEST, squares[6][4]);
				mirror.lockRotate = true;
				mirror.lockMove = true;
				addItem(mirror);
				creationTray.addGenerator(new Mirror(BoardItem.NORTH_WEST), "Mirror", 0);
				
			}
			else if(tutorialStage == 15)
			{
				tutorialText.text = "<p class='header'>Colored Lasers</p>So far all of the laser beams have been red. However there are many different colors of " +
					"laser beams in LaserQuest.\n\nEach orb requires a certain color of laser beam in order to illuminate it.\n\nYou " +
					"can tell which color will light an orb by looking at the color of the glow surrounding it.\n\nThe orb will " +
					"start pulsing if you light up the center of the orb the same color as its glow.";
				
				backButton.visible = false;
				nextButton.visible = true;
			}
			else if(tutorialStage == 16)
			{
				tutorialText.text = "<p class='header'>Colored Lasers</p><p class='instruction'>Use the two mirrors that you are given to try this out.</p>\nRemember, shine the blue " +
					"laser on the orb which has a blue glow around it, and the red laser on the orb with a red glow.";
				
				backButton.visible = true;
				nextButton.visible = false;
				
				addItem(new LaserGun(BoardItem.BLUE, BoardItem.SOUTH, squares[3][0]));
				addItem(new LaserGun(BoardItem.RED, BoardItem.NORTH, squares[5][7]));
				
				addItem(new Orb(BoardItem.BLUE, squares[1][3]));
				addItem(new Orb(BoardItem.RED, squares[3][5]));
				
				creationTray.addGenerator(new Mirror(BoardItem.NORTH_WEST), "Mirror", 2);
			}
			else if(tutorialStage == 17)
			{
				tutorialText.text = "<p class='header'>Colored Lasers</p>Great job! Now we can learn about mixing colors to create different colored beams.";
				
				backButton.visible = false;
				nextButton.visible = true;
				
				addItem(new LaserGun(BoardItem.BLUE, BoardItem.SOUTH, squares[3][0]));
				addItem(new LaserGun(BoardItem.RED, BoardItem.NORTH, squares[5][7]));
				
				addItem(new Orb(BoardItem.BLUE, squares[1][3]));
				addItem(new Orb(BoardItem.RED, squares[3][5]));
				
				var mirror:BoardItem;
				
				mirror = new Mirror(BoardItem.NORTH_EAST, squares[3][3]);
				mirror.lockRotate = true;
				mirror.lockMove = true;
				addItem(mirror);
				mirror = new Mirror(BoardItem.NORTH_WEST, squares[5][5]);
				mirror.lockRotate = true;
				mirror.lockMove = true;
				addItem(mirror);
				
				creationTray.addGenerator(new Mirror(BoardItem.NORTH_WEST), "Mirror", 0);
			}
			else if(tutorialStage == 18)
			{
				tutorialText.text = "<p class='header'>Mixing Colors</p>Here we have a magenta colored orb. " +
					"However you only have a red laser beam and a blue laser beam at your disposal.\n\n" +
					"You can combine these two beams to form magenta light if you can get the beams to overlap.\n\n" +
					"<p class='instruction'>Drag the red laser onto the board and shine it at the blue one to see this in action.</p>";
				
				backButton.visible = false;
				nextButton.visible = false;
				
				addItem(new LaserGun(BoardItem.BLUE, BoardItem.EAST, squares[2][5]));
				
				addItem(new Orb(BoardItem.RED|BoardItem.BLUE, squares[4][5]));
				
				squares[7][5].addGhost(new LaserGun(BoardItem.RED, BoardItem.WEST, null));
				
				var laser:BoardItem = new LaserGun(BoardItem.RED, BoardItem.NORTH, null);
				laser.lockRotate = false;
				creationTray.addGenerator(laser, "Laser", 1);
			}
			else if(tutorialStage == 19)
			{
				tutorialText.text = "<p class='header'>Mixing Colors</p>Very good.\n\nCombining laser beams like this isn't terribly useful. There's no way to use mirrors " +
					"and there are lots of other problems.\n\nThankfully an interesting property of the splitter allows it to combine beams " +
					"if the way it's used is reversed.";
				
				backButton.visible = false;
				nextButton.visible = true;
				
				addItem(new LaserGun(BoardItem.BLUE, BoardItem.EAST, squares[2][5]));
				
				addItem(new Orb(BoardItem.RED|BoardItem.BLUE, squares[4][5]));
				
				addItem(new LaserGun(BoardItem.RED, BoardItem.WEST, squares[7][5]));
				
				creationTray.addGenerator(new LaserGun(BoardItem.RED, BoardItem.NORTH, null), "Laser", 0);
			}
			else if(tutorialStage == 20)
			{
				tutorialText.text = "<p class='header'>Mixing With The Splitter</p>First let's look at how this is possible." +
					"\n\n<p class='instruction'>Drag the splitter onto the highlighted board square.</p>";
				
				backButton.visible = false;
				nextButton.visible = false;
				
				addItem(new LaserGun(BoardItem.RED, BoardItem.EAST, squares[2][3]));
				
				var sp = new Splitter(BoardItem.NORTH, null);
				sp.addOutlet(BoardItem.NORTH);
				sp.addOutlet(BoardItem.SOUTH);
				squares[5][3].addGhost(sp);
				
				sp = new Splitter(BoardItem.NORTH, null);
				sp.addOutlet(BoardItem.NORTH);
				sp.addOutlet(BoardItem.SOUTH);
				creationTray.addGenerator(sp, "Splitter", 1);
				
				highlightSquare(true, squares[5][3]);
			}
			else if(tutorialStage == 21)
			{
				tutorialText.text = "<p class='header'>Mixing With The Splitter</p>Notice that the beam enters the left port of the splitter. There is no path between the left port " +
					"and the right port so the light doesn't go through.\n\nWe can direct another laser beam into the right port and it will come " +
					"out the bottom of the splitter too.\n\nIf these two beams of light are different colors they will mix to form a new color.";
				
				backButton.visible = false;
				nextButton.visible = true;
				
				addItem(new LaserGun(BoardItem.RED, BoardItem.EAST, squares[2][3]));
				
				var sp = new Splitter(BoardItem.NORTH, null);
				sp.addOutlet(BoardItem.NORTH);
				sp.addOutlet(BoardItem.SOUTH);
				squares[5][3].addGhost(sp);
				
				sp = new Splitter(BoardItem.NORTH, null);
				sp.addOutlet(BoardItem.NORTH);
				sp.addOutlet(BoardItem.SOUTH);
				sp.lockRotate = true;
				sp.lockMove = true;
				creationTray.addGenerator(sp, "Splitter", 1);
				
				highlightSquare(true, squares[5][3]);
			}
			else if(tutorialStage == 22)
			{
				tutorialText.text = "<p class='header'>Mixing With The Splitter</p><p class='instruction'>Use one of the mirrors " +
					"to direct the blue beam into the right side of the splitter.</p>\n" +
					"This will cause " +
					"it to combine with the red beam.";
				
				backButton.visible = false;
				nextButton.visible = false;
				
				addItem(new LaserGun(BoardItem.RED, BoardItem.EAST, squares[2][3]));
				addItem(new LaserGun(BoardItem.BLUE, BoardItem.NORTH, squares[8][7]));
				
				var sp = new Splitter(BoardItem.NORTH, squares[5][3]);
				sp.addOutlet(BoardItem.NORTH);
				sp.addOutlet(BoardItem.SOUTH);
				sp.lockRotate = true;
				sp.lockMove = true;
				addItem(sp);
				
				sp = new Splitter(BoardItem.NORTH, null);
				sp.addOutlet(BoardItem.NORTH);
				sp.addOutlet(BoardItem.SOUTH);
				creationTray.addGenerator(sp, "Splitter", 0);
				creationTray.addGenerator(new Mirror(BoardItem.NORTH_WEST), "Mirror", 2);
				highlightSquare(true, squares[8][3]);
				
				squares[8][3].addGhost(new Mirror(BoardItem.NORTH_WEST));
			}
			else if(tutorialStage == 23)
			{
				drawTutorialStage(1);
				return;
			}
			else if(tutorialStage == 24)
			{
				tutorialText.text = "<p class='header'>Mixing With The Splitter</p>Cool, now you've made magenta light and this time you can use a mirror to direct it around. " +
					"\n\n<p class='instruction'>Now use the other mirror to direct the magenta light onto the orb.</p>";
				
				backButton.visible = false;
				nextButton.visible = false;
				
				addItem(new Orb(BoardItem.RED|BoardItem.BLUE, squares[2][7]));
				
				addItem(new LaserGun(BoardItem.RED, BoardItem.EAST, squares[2][3]));
				addItem(new LaserGun(BoardItem.BLUE, BoardItem.NORTH, squares[8][7]));
				
				var sp = new Splitter(BoardItem.NORTH, squares[5][3]);
				sp.addOutlet(BoardItem.NORTH);
				sp.addOutlet(BoardItem.SOUTH);
				sp.lockRotate = true;
				sp.lockMove = true;
				addItem(sp);
				
				sp = new Splitter(BoardItem.NORTH, null);
				sp.addOutlet(BoardItem.NORTH);
				sp.addOutlet(BoardItem.SOUTH);
				creationTray.addGenerator(sp, "Splitter", 0);
				creationTray.addGenerator(new Mirror(BoardItem.NORTH_WEST), "Mirror", 1);
				highlightSquare(true, squares[5][7]);
				
				squares[5][7].addGhost(new Mirror(BoardItem.NORTH_EAST));
				
				var mirror:BoardItem;
				
				mirror = new Mirror(BoardItem.NORTH_WEST, squares[8][3]);
				mirror.lockRotate = true;
				mirror.lockMove = true;
				addItem(mirror);
//				mirror = new Mirror(BoardItem.NORTH_WEST, squares[5][5]);
//				mirror.lockRotate = true;
//				mirror.lockMove = true;
//				addItem(mirror);
			}
			else if(tutorialStage == 25)
			{
				tutorialText.text = "<p class='header'>Tutorial Completed</p>Excellent. This completes the tutorial. Press Main Menu to go back to the main menu and " +
					"start the game!\n\nGood luck.";
				
				backButton.visible = false;
				nextButton.visible = false;
				
				addItem(new Orb(BoardItem.RED|BoardItem.BLUE, squares[2][7]));
				
				addItem(new LaserGun(BoardItem.RED, BoardItem.EAST, squares[2][3]));
				addItem(new LaserGun(BoardItem.BLUE, BoardItem.NORTH, squares[8][7]));
				
				var sp = new Splitter(BoardItem.NORTH, squares[5][3]);
				sp.addOutlet(BoardItem.NORTH);
				sp.addOutlet(BoardItem.SOUTH);
				sp.lockRotate = true;
				sp.lockMove = true;
				addItem(sp);
				
				sp = new Splitter(BoardItem.NORTH, null);
				sp.addOutlet(BoardItem.NORTH);
				sp.addOutlet(BoardItem.SOUTH);
				creationTray.addGenerator(sp, "Splitter", 0);
				creationTray.addGenerator(new Mirror(BoardItem.NORTH_WEST), "Mirror", 0);
				
				squares[5][7].addGhost(new Mirror(BoardItem.NORTH_EAST));
				
				var mirror:BoardItem;
				
				mirror = new Mirror(BoardItem.NORTH_WEST, squares[8][3]);
				mirror.lockRotate = true;
				mirror.lockMove = true;
				addItem(mirror);
				mirror = new Mirror(BoardItem.NORTH_EAST, squares[5][7]);
				mirror.lockRotate = true;
				mirror.lockMove = true;
				addItem(mirror);
			}
		}
		
		public override function changeSelection(source:BoardSquare)
		{
			
			if(tutorialStage == 4)
			{
				if(source == squares[2][2])
				{
					tutorialStage++;
					drawTutorialStage();
					return;
				}
			}
			else if(tutorialStage == 5)
			{
				if(source == squares[2][2])
				{
					tutorialStage++;
					drawTutorialStage();
					return;
				}
			}
			else if(tutorialStage == 9)
			{
				return;
			}
			else if(tutorialStage == 12)
			{
				return;
			}
			else if(tutorialStage == 21)
			{
				return;
			}
			super.changeSelection(source);
		}
		
		public override function rotateItem(amount:Number)
		{
			super.rotateItem(amount);
		}
		
		public override function dropItem(item:BoardItem, target:BoardSquare):Boolean
		{
			if(tutorialStage == 4)
			{
				if(target == squares[2][2])
				{
					return true;
				}
			}
			if(tutorialStage == 8)
			{
				if(target == squares[2][2] || target == squares[6][8] || target == squares[8][8])
				{
					return true;
				}
			}
			else if(tutorialStage == 10)
			{
				if(target == squares[5][4])
				{
					tutorialStage++;
					redrawStage = true;
					return true;
				}
			}
			else if(tutorialStage == 11)
			{
				//if(target == squares[1][4])
				//{
					return true;
				//}
			}
			else if(tutorialStage == 13)
			{
				if(target == squares[6][4])
				{
					return true;
				}
			}
			else if(tutorialStage == 16)
			{
				//if(target == squares[3][3] || target == squares[5][5])
				//{
					return true;
				//}
			}
			else if(tutorialStage == 18)
			{
				if(target == squares[7][5])
				{
					return true;
				}
			}
			else if(tutorialStage == 20)
			{
				if(target == squares[5][3])
				{
					tutorialStage++;
					drawTutorialStage();
					return true;
				}
			}
			else if(tutorialStage == 22)
			{
				if(target == squares[8][3])
				{
					tutorialStage++;
					redrawStage = true;
					return true;
				}
			}
			else if(tutorialStage == 24)
			{
				if(target == squares[5][7])
				{
					return true;
				}
			}
			return false;
		}
		
		public function tutBack()
		{
			drawTutorialStage(-1);
		}
		
		public function tutNext()
		{
			drawTutorialStage(1);
		}
		
		public override function reset()
		{
			tutorialStage = 0;
			if(squares != null)
			{
				initialize(rows, cols, lineThickness);
				drawLasers();
			}
		}
		
		public override function postItemDrop()
		{
			if(redrawStage)
			{
				redrawStage = false;
				drawTutorialStage();
			}
		}
	}
}