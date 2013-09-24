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
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.utils.getDefinitionByName;
	import flash.text.TextField; 
	import flash.display.SimpleButton;
	import levels.*;

	// Main class for initialization
	public class LaserQuestMain extends MovieClip
	{
		private var victoryBox:MovieClip;
		public var level:Number = 1;
		
		public var levelClasses:Array;
		public var cachedLevels:Array;
		public function LaserQuestMain()
		{
			/*
			Ensure levels are included in compilation
			*/
			levelClasses = new Array();
			levelClasses.push(levels.Level1);
			levelClasses.push(levels.Level2);
			levelClasses.push(levels.Level3);
			levelClasses.push(levels.Level4);
			levelClasses.push(levels.Level5);
			levelClasses.push(levels.Level6);
			
			cachedLevels = new Array(levelClasses.length);
		}
		
		public function getNewLevel():GameLevel
		{
			var levelIndex:Number = level - 1;
			
			if(cachedLevels[levelInstance] != null)
			{
				return cachedLevels[levelInstance];
			}
			if(levelIndex >= this.levelClasses.length)
			{
				return null;
			}
			try
			{
				var levelClass:Class = this.levelClasses[levelIndex] as Class;
				var levelInstance:GameLevel = new levelClass();
				cachedLevels[levelIndex] = levelInstance;
				return levelInstance;
			}
			catch(e:Object)
			{
				return null;
			}
			return null;
		}
		
		// Trigger victory
		public function victory(centerOn:MovieClip)
		{
			this.stage.addEventListener(MouseEvent.MOUSE_DOWN, victoryMouseDown, true, 1);
			victoryBox = new VictoryBox();
			victoryBox.x = stage.width / 2;
			victoryBox.y = stage.height / 2;
			this.addChild(victoryBox);
		}
		
		// Bad level
		public function noLevel(centerOn:MovieClip)
		{
			var messageBox:MovieClip = new MessageBox();
			messageBox.x = stage.width / 2;
			messageBox.y = stage.height / 2;
			messageBox.message.text = "There is no such level";
			this.addChild(messageBox);
			messageBox.init();
		}
		
		// Post-victory
		public function victoryMouseDown(event:MouseEvent)
		{
			if(victoryBox != null)
			{
				this.removeChild(victoryBox);
				victoryBox = null;
			}
			level++;
			this.gotoAndPlay(2);
			event.stopPropagation();
			this.stage.removeEventListener(MouseEvent.MOUSE_DOWN, victoryMouseDown, true);
		}
	}
}