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

package martian.milky.core
{
	import flash.display.Sprite;
	import flash.events.*;
	import flash.geom.Point;

	public class ExtendedScene extends Sprite
	{		
		private var XYx:Number = 0, XYy:Number = 0, RSx:Number = 0, RSy:Number = 0;
		
		private var $drag:Boolean;
		public function get draggable():Boolean { return $drag; }
		public function set draggable(value:Boolean):void { $drag = value; }
		
		private var $rotate:Boolean;
		public function get rotatable():Boolean { return $rotate; }
		public function set rotatable(value:Boolean):void { $rotate = value; }
		
		private var $scale:Boolean;
		public function get scalable():Boolean { return $scale; }
		public function set scalable(value:Boolean):void { $scale = value; }
		
		public function ExtendedScene(draggable:Boolean, rotatable:Boolean, scalable:Boolean)
		{
			$drag = draggable;
			$rotate = rotatable;
			$scale = scalable;
			
			addEventListener(Event.ADDED_TO_STAGE, initialize);
			addEventListener(Event.REMOVED_FROM_STAGE, bury);
		}
		
		private function initialize(e:Event):void { removeEventListener(Event.ADDED_TO_STAGE, initialize); activate(); }
		private function bury(e:Event):void { removeEventListener(Event.REMOVED_FROM_STAGE, bury); desactivate(); }
		
		private function mouseDown(e:MouseEvent):void
		{
			e.stopPropagation();
			definePlot();
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, definePlot);
			stage.addEventListener(KeyboardEvent.KEY_UP, definePlot);
		}
		
		private function mouseUp(e:MouseEvent):void
		{
			e.stopPropagation();
				
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, definePlot);
			stage.removeEventListener(KeyboardEvent.KEY_UP, definePlot);
		}
		
		private function mouseMove(e:MouseEvent):void
		{
			e.stopPropagation();
			
			if (!e.shiftKey)
			{
				if ($drag) { dragging(); }
			}
			else
			{
				if ($rotate) { rotating(); }
				if ($scale) { scaling(); }
			}
		}
		
		private function definePlot(e:KeyboardEvent = null):void
		{
			var XY:Point = globalToLocal(new Point(stage.mouseX, stage.mouseY));
				XY.x *= scaleX;
				XY.y *= scaleY;
				
			var rotationRad:Number = rotation * Math.PI / 180;
				XYx = XY.x * Math.cos(rotationRad) - XY.y * Math.sin(rotationRad);
				XYy = XY.x * Math.sin(rotationRad) + XY.y * Math.cos(rotationRad);
			
			RSx = Math.atan2(XY.y - 0, XY.x - 0) * 180 / Math.PI;
			RSy = Point.distance(new Point(parent.mouseX, parent.mouseY), new Point(x, y)) / scaleX;
		}
		
		private function dragging():void
		{		
			x = parent.mouseX - XYx;
			y = parent.mouseY - XYy;
		}
		
		private function rotating():void
		{
			rotation = Math.atan2(parent.mouseY - y, parent.mouseX - x) * 180 / Math.PI - RSx;
		}
		
		private function scaling():void
		{
			scaleX = scaleY = Point.distance(new Point(parent.mouseX, parent.mouseY), new Point(x, y)) / RSy;
		}
		
		public function activate():void { stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);	}
		public function desactivate():void { stage.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown); }
	}
	
}
