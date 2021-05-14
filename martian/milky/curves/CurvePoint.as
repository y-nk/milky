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

package martian.milky.curves
{
	import flash.display.Sprite;
	import flash.events.*;
	import flash.geom.Point;
	import martian.milky.events.CurveEvent;
	
	public class CurvePoint extends Sprite
	{
		static private const PI2:Number = Math.PI / 2;
		
		private var $id:int = 0;
			public function get id():int { return $id; }
			public function set id(value:int):void { $id = value; }
		
		private var $color:int = 0x4A7FF9;
			public function get color():int { return $color; }
			public function set color(value:int):void { $color = value; drawPoints(); drawLines(); }
		
		private var $pointX:Number, $pointY:Number;
			public function get pointX():Number { return $pointX; }
			public function set pointX(value:Number):void { $pointX = x = value; }
			public function get pointY():Number { return $pointY; }
			public function set pointY(value:Number):void { $pointY = y = value; }
		
		private var $anch1X:Number, $anch1Y:Number;
			public function get anch1X():Number { return $anch1X; }
			public function set anch1X(value:Number):void { $anch1X = value; $anch1.x = value - x; }
			public function get anch1Y():Number { return $anch1Y; }
			public function set anch1Y(value:Number):void { $anch1Y = value; $anch1.y = value - y; }
			
			public function get anch1XRel():Number { return $anch1X - x; }
			public function set anch1XRel(value:Number):void { $anch1X = value + x; $anch1.x = value; }
			public function get anch1YRel():Number { return $anch1Y - y; }
			public function set anch1YRel(value:Number):void { $anch1Y = value + y; $anch1.y = value; }
			
			public function get anch1Length():Number { return Math.sqrt(($anch1X - $pointX) * ($anch1X - $pointX) + ($anch1Y - $pointY) * ($anch1Y - $pointY)); }
			public function get anch1Angle():Number { return Math.atan2(anch1Y - pointY, anch1X - pointX); }
			
		private var $anch2X:Number, $anch2Y:Number;
			public function get anch2X():Number { return $anch2X; }
			public function set anch2X(value:Number):void { $anch2X = value; $anch2.x = value - x; }
			public function get anch2Y():Number { return $anch2Y; }
			public function set anch2Y(value:Number):void { $anch2Y = value; $anch2.y = value - y; }
			
			public function get anch2XRel():Number { return $anch2X - x; }
			public function set anch2XRel(value:Number):void { $anch2X = value + x; $anch2.x = value; }
			public function get anch2YRel():Number { return $anch2Y - y; }
			public function set anch2YRel(value:Number):void { $anch2Y = value + y; $anch2.y = value; }
			
			public function get anch2Length():Number { return Math.sqrt(($anch2X - $pointX) * ($anch2X - $pointX) + ($anch2Y - $pointY) * ($anch2Y - $pointY)); }
			public function get anch2Angle():Number { return Math.atan2(anch2Y - pointY, anch2X - pointX); }
			
		private var $point:Sprite = new Sprite();
		private var $anch:Sprite;
		private var $anch1:Sprite = new Sprite();
		private var $anch2:Sprite = new Sprite();
		
		private var $broken:Boolean = false;
		private var $mancall:Boolean = false;
		
		override public function get x():Number { return super.x; }
		override public function set x(value:Number):void
		{
			super.x = $pointX = value;
			
			$anch1X = value + $anch1.x;
			$anch2X = value + $anch2.x;
		}
		
		override public function get y():Number { return super.y; }
		override public function set y(value:Number):void
		{
			super.y = $pointY = value;
			
			$anch1Y = value + $anch1.y;
			$anch2Y = value + $anch2.y;
		}
		
		/**
		 * @param	point This is the absolute position of the main point in the shape.
		 * @param	anch1 This is the relative position of the left anchor regarding the main point.
		 * @param	anch2 This is the relative position of the right anchor regarding the main point.
		 */
		public function CurvePoint(_pointX:Number, _pointY:Number, _anch1X:Number = 0, _anch1Y:Number = 0, _anch2X:Number = 0, _anch2Y:Number = 0)
		{
			visible = false;
			
			pointX = $anch1X = $anch2X = _pointX;
			pointY = $anch1Y = $anch2Y = _pointY;
			
			if (_anch1X != 0) { anch1X = _anch1X; }
			if (_anch1Y != 0) { anch1Y = _anch1Y; }
			
			if (_anch2X != 0) { anch2X = _anch2X; }
			if (_anch2Y != 0) { anch2Y = _anch2Y; }
			
			drawPoints();
			drawLines();
			
			doubleClickEnabled = true;
			
			$point.addEventListener(MouseEvent.MOUSE_DOWN, pointDown);
			$point.addEventListener(MouseEvent.CLICK, pointClick);
			
			$anch1.addEventListener(MouseEvent.MOUSE_DOWN, anch1Down);
			$anch2.addEventListener(MouseEvent.MOUSE_DOWN, anch2Down);
			
			addEventListener(Event.ADDED_TO_STAGE, show);
		}
		
		private function drawPoints():void
		{
			$point.x = 0;
			$point.y = 0;
			
			$point.graphics.clear();
			$point.graphics.lineStyle(1, $color);
			$point.graphics.beginFill(0xFFFFFF);
			$point.graphics.drawRect(-2, -2, 4, 4);
			$point.graphics.endFill();
			
			for each (var $anch:Sprite in [$anch1, $anch2])
			{
				$anch.visible = false;
				
				$anch.graphics.clear();
				$anch.graphics.beginFill($color, 1);
				$anch.graphics.drawEllipse(-2, -2, 4, 4);
				$anch.graphics.endFill();
			}
		}
		
		private function drawLines():void
		{
			graphics.clear();
			graphics.lineStyle(1, $color);
			
			if (($anch1X != $pointX) || ($anch1Y != $pointY))
			{
				graphics.moveTo(0, 0);
				graphics.lineTo($anch1.x, $anch1.y);
			}
			
			if (($anch2X != $pointX) || ($anch2Y != $pointY))
			{
				graphics.moveTo(0, 0);
				graphics.lineTo($anch2.x, $anch2.y);
			}
		}
		
		/**
		 * @param e This event can be omitted for manual calls.
		 * This function display the current point and its anchors.
		 */
		public function show(e:Event = null):void
		{
			addChild($point);
				if (($anch1X != $pointX) || ($anch1Y != $pointY)) { anchShow(1); }
				if (($anch2X != $pointX) || ($anch2Y != $pointY)) { anchShow(2); }
				
				scaleX = scaleY = 1 / parent.scaleX;
		}
		
		public function hide():void
		{
			graphics.clear();
			
			removeChild($point);
				if (($anch1X != $pointX) && ($anch1Y != $pointY)) { anchHide(1); }
				if (($anch2X != $pointX) && ($anch2Y != $pointY)) { anchHide(2); }
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		public function pointDown(e:MouseEvent):void
		{
			e.stopImmediatePropagation();
				stage.addEventListener(MouseEvent.MOUSE_MOVE, pointMove);
				stage.addEventListener(MouseEvent.MOUSE_UP, pointUp);
		}
		
		private function pointMove(e:MouseEvent):void
		{
			if (!e.shiftKey)
			{ x = parent.mouseX; y = parent.mouseY; }
			else
			{ pointUp(); anchShow(2); anch2Down(); }
		}
		 
		public function pointUp(e:MouseEvent = null):void
		{
			if (e != null) { e.stopImmediatePropagation(); }
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, pointMove);
				stage.removeEventListener(MouseEvent.MOUSE_UP, pointUp);
		}
		
		private function pointClick(e:MouseEvent):void
		{
			if (e.altKey && !e.shiftKey)
			{
				if (($anch1X != $pointX) && ($anch1Y != $pointY)) { anchHide(1); }
				if (($anch2X != $pointX) && ($anch2Y != $pointY)) { anchHide(2); }
				
				anch1X = anch2X = pointX;
				anch1Y = anch2Y = pointY; 
				
				drawLines();
			}
			
			if (e.altKey && e.shiftKey)
			{
				dispatchEvent(new CurveEvent(CurveEvent.REMOVE_POINT, this));
			}
		}
		
		
		
		
		
		
		
		
		
		
		
		
		private function anchShow(id:int):void
		{
			if (id == 1) { $anch = $anch1; }
			if (id == 2) { $anch = $anch2; }
			
			if (!$anch.visible) { addChild($anch); $anch.visible = true; }
			drawLines();
			
			setChildIndex($point, numChildren - 1);
		}
		
		private function anchHide(id:int):void
		{
			if (id == 1) { $anch = $anch1; }
			if (id == 2) { $anch = $anch2; }
			
			graphics.clear();
			
			if ($anch.visible) { removeChild($anch); $anch.visible = false; }
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		private function anch1Down(e:MouseEvent):void
		{
			e.stopImmediatePropagation();
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, anch1Move);
			stage.addEventListener(MouseEvent.MOUSE_UP, anch1Up);
		}
		
		private function anch1Move(e:MouseEvent):void
		{
			anch1X = parent.mouseX;
			anch1Y = parent.mouseY;
			
			if (!e.shiftKey && !e.altKey && $anch2.visible && !$broken)
			{		
				var ratio:Number = Point.distance(new Point(), new Point($anch2.x, $anch2.y)) / Point.distance(new Point(), new Point($anch1.x, $anch1.y));
				if ((ratio == Infinity) || isNaN(ratio)) { ratio = 1; }
				
				anch2X = x + (- $anch1.x * ratio);
				anch2Y = y + (- $anch1.y * ratio);
			}
			
			if (e.shiftKey && !e.altKey)
			{
				if (!$anch2.visible) { anchShow(2); }
				
				anch2X = x + (- $anch1.x);
				anch2Y = y + (- $anch1.y);
				
				$broken = false;
			}
			
			if (e.altKey) { $broken = true; }
			
			drawLines();
		}
		
		private function anch1Up(e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, anch1Move);
			stage.removeEventListener(MouseEvent.MOUSE_UP, anch1Up);
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		/**
		 * @param e This event can be omitted for manual calls.
		 * This function can be used after shape edition to auto-edit the added-point anchors.
		 */
		public function anch2Down(e:MouseEvent = null):void
		{
			if (e != null) { e.stopImmediatePropagation(); }
			else { $mancall = true; }
			
			if ($mancall && !$anch2.visible) { anchShow(2); }
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, anch2Move);
			stage.addEventListener(MouseEvent.MOUSE_UP, anch2Up);
		}
		
		private function anch2Move(e:MouseEvent):void
		{
			anch2X = parent.mouseX;
			anch2Y = parent.mouseY;
			
			if (!e.shiftKey && !e.altKey && $anch1.visible && !$broken)
			{		
				var ratio:Number = Point.distance(new Point(), new Point($anch1.x, $anch1.y)) / Point.distance(new Point(), new Point($anch2.x, $anch2.y));
				if ((ratio == Infinity) || isNaN(ratio)) { ratio = 1; }
				
				anch1X = x + (- $anch2.x * ratio);
				anch1Y = y + (- $anch2.y * ratio);
			}
			
			if ((e.shiftKey && !e.altKey) || $mancall)
			{
				if (!$anch1.visible) { anchShow(1); }
				
				anch1X = x - $anch2.x;
				anch1Y = y - $anch2.y;
				
				$broken = false;
			}
			
			if (e.altKey) { $broken = true; }
			
			drawLines();
		}
		
		private function anch2Up(e:MouseEvent):void
		{
			$mancall = false;
			
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, anch2Move);
			stage.removeEventListener(MouseEvent.MOUSE_UP, anch2Up);
		}
		
		//public function clone():CurvePoint { return new CurvePoint($pointX, $pointY, $anch1X, $anch1Y, $anch2X, $anch2Y); }
		
		override public function toString():String { return "[" + pointX.toString() + ", " + pointY.toString() + "][" + anch1X.toString() + ", " + anch1Y.toString() + "][" + anch2X.toString() + ", " + anch2Y.toString() + "]"; }
	}
}