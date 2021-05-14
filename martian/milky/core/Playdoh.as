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
	import martian.milky.events.*;
	import martian.milky.interfaces.MilkyModelable;
	import martian.milky.interfaces.MilkyObject;
	
	import flash.display.Sprite;
	import flash.events.*;
	import flash.geom.Point;
	
	//import gs.TweenMax;

	public class Playdoh extends Sprite implements MilkyModelable
	{	
		private var XYx:Number = 0, XYy:Number = 0, RSx:Number = 0, RSy:Number = 0;
		
		private var $object:*;
		public function get object():* { return $object; }
		
		private var $drag:Boolean;
		public function set draggable(bool:Boolean):void { $drag = bool; }
		public function get draggable():Boolean { return $drag; }
		
		private var $rotate:Boolean;
		public function set rotatable(bool:Boolean):void { $rotate = bool; }
		public function get rotatable():Boolean { return $rotate; }
		
		private var $scale:Boolean;
		public function set scalable(bool:Boolean):void { $scale = bool; }
		public function get scalable():Boolean { return $scale; }
		
		private var $debug:Boolean;
		public function set debug(bool:Boolean):void { $debug = bool; }
		public function get debug():Boolean { return $debug; }
		
		private var $active:Boolean = false;
		public function get active():Boolean { return $active; }
		
		/**
		 * Playdoh : Abstract class that implements $draggable, rotatable and scalable fonctionnalities. 
		**/
		
		public function Playdoh(object:*, draggable:Boolean = true, rotatable:Boolean = true, scalable:Boolean = true, centered:Boolean = true, debug:Boolean = false)
		{
			$object = object
			$drag = draggable;
			$rotate = rotatable;
			$scale = scalable;
			
			x = $object.x;
			y = $object.y;
			rotation = $object.rotation;
			scaleX = scaleY = $object.scaleX;
			
			addChild($object);
				$object.x = $object.y = 0;
				$object.rotation = 0;
				$object.scaleX = $object.scaleY = 1;
				
			if ($drag || $rotate || $scale) { activate(); }
			
			if (centered)
			{
				x += $object.width / 2;
				y += $object.height / 2;
				
				center();
				addEventListener(ResizeEvent.RESIZE, center);
				addEventListener(LoadEvent.DOWNLOAD_COMPLETE, center);
			}
			
			$debug = debug;
		}
		
		private function mouseDown(e:MouseEvent= null):void
		{
			if (e != null) { e.stopPropagation(); }
				
			definePlot();
			
			if ($drag || $rotate || $scale) { parent.setChildIndex(this, parent.numChildren - 1); }
				
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			stage.addEventListener(KeyboardEvent.KEY_UP, definePlot);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, definePlot);
		}
		
		private function mouseUp(e:MouseEvent):void
		{
			e.stopPropagation();
				
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
			stage.removeEventListener(KeyboardEvent.KEY_UP, definePlot);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, definePlot);
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
				if ($rotate && !e.ctrlKey) { rotating(); }
				if ($scale && !e.altKey) { scaling(); }
			}
			
			if ($debug)
			{
				graphics.clear();
				graphics.lineStyle(1, 0xff0000, 1);
				graphics.drawCircle(0, 0, 10);
				graphics.drawRect($object.x, $object.y, $object.width, $object.height);
			}

		}
		
		private function definePlot(e:KeyboardEvent = null):void
		{
			if (e != null) { e.stopImmediatePropagation(); }
			
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
		
		private function center(e:Event = null):void
		{
			if (e is LoadEvent) { removeEventListener(LoadEvent.DOWNLOAD_COMPLETE, center); }
			
			$object.x = - $object.width / 2;
			$object.y = - $object.height / 2;
		}
		
		public function clone():Playdoh
		{
			var clone:Playdoh = new Playdoh(object.clone(), $drag, $rotate, $scale);
				clone.x = x;
				clone.y = y;
				clone.rotation = rotation;
				clone.scaleX = clone.scaleY = scaleX;
				
				return clone;
		}
		
		public function activate():void { if (!$active) { addEventListener(MouseEvent.MOUSE_DOWN, mouseDown); $active = true; } }
		public function desactivate():void { if ($active) { removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown); $active = false; } }
	}
	
}
