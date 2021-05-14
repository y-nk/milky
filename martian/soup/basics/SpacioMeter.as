/*
# @author Julien Barbay aka ynk
# 
# Copyright (c) 2008 Julien Barbay aka ynk
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
*/

package martian.soup.basics 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import martian.soup.events.SettingEvent;
	
	public class SpacioMeter extends Sprite
	{
		private var $value:Array = new Array(2);
		public function get value():Array { return $value; }
		public function set value(value:Array):void
		{
			value[0] = value[0] * (35/2) / $coeff ;
			value[1] = value[1];
			update(value, false);
		}
		
		private var $bckgrnd:Sprite;
		private var $cursor:Sprite;
		
		private var $coeff:int = 20;
		
		public function SpacioMeter()
		{
			$bckgrnd = new Sprite;
				$bckgrnd.graphics.lineStyle(1, 0x595959);
				$bckgrnd.graphics.beginFill(0x3D3D3D);
				$bckgrnd.graphics.drawEllipse(0, 0, 35, 35);
				$bckgrnd.graphics.endFill();
				
			$cursor = new Sprite;
				$cursor.graphics.lineStyle(1, 0);
				$cursor.graphics.moveTo(0, -4);
				$cursor.graphics.lineTo(0, -2);
				$cursor.graphics.moveTo(0, 2);
				$cursor.graphics.lineTo(0, 4);
				$cursor.graphics.moveTo(-4, 0);
				$cursor.graphics.lineTo(-2, 0);
				$cursor.graphics.moveTo(2, 0);
				$cursor.graphics.lineTo(4, 0);
				$cursor.x = 35 / 2;
				$cursor.y = 35 / 2;
				
			var dot:Sprite = new Sprite;
				dot.graphics.beginFill(0);
				dot.graphics.drawCircle(0, 0, 2);
				dot.graphics.endFill();
				dot.x = 35 / 2;
				dot.y = 35 / 2;
				
			addChild($bckgrnd);
			addChild(dot);
			addChild($cursor);
			
			addEventListener(MouseEvent.MOUSE_DOWN, grab, false, 1000);
		}
		
		private function grab(e:MouseEvent):void
		{
			e.stopImmediatePropagation();
			
			drag();
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, drag, false, 1000);
			stage.addEventListener(MouseEvent.MOUSE_UP, drop, false, 1000);
		}
		
		private function drag(e:MouseEvent = null):void
		{
			if (e != null) { e.stopImmediatePropagation(); }
			
			var degree:Number = Math.atan2(mouseY - 35/2, mouseX - 35/2) * 180 / Math.PI;
			var length:Number = Point.distance(new Point(35/2, 35/2), new Point(mouseX, mouseY));
			
			update([length, degree]);
		}
		
		private function drop(e:MouseEvent):void
		{
			e.stopImmediatePropagation();
			
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, drag);
			stage.removeEventListener(MouseEvent.MOUSE_UP, drop);
		}
		
		private function update(point:Array, dispatch:Boolean = true):void
		{
			if (point[0] >= 35/2) { point[0] = 35/2; }
			
				$cursor.x = 35/2 + point[0] * Math.cos(point[1] * Math.PI / 180);
				$cursor.y = 35/2 + point[0] * Math.sin(point[1] * Math.PI / 180);
			
			$value[0] = point[0] * $coeff / (35/2);
			$value[1] = point[1];
			
			if (dispatch) { dispatchEvent(new SettingEvent(SettingEvent.SPACIO)); }
		}
	}
}