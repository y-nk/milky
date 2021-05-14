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
	import martian.milky.curves.CurvePoint;
	import martian.milky.events.*;
	import martian.milky.styles.*;
	import martian.milky.interfaces.*;
	import martian.milky.core.Utils;	

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class Curvegon extends Sprite implements MilkyObject, MilkyShape, MilkyShadow
	{
		//this const defines the relation between the diameter of an arc and its control point's position. found with a quick math study : (12 * V529) * 10^-3
		protected static const RATIO:Number = 0.276;
		
		static public const BASIC:String = "basic";
		static public const ADVANCED:String = "advanced";
		
		static private var $render:String = "basic";
			static public function get RENDER():String { return $render; }
			static public function set RENDER(str:String):void { if ((str == ADVANCED) || (str == BASIC)) { $render = str; } else { throw new Error("invalid curvegon rendering type"); } }
		
		static private var $quality:int = 100;
			static public function get QUALITY():int { return $quality; }
			static public function set QUALITY(num:int):void { if ((num > 0) && (num < 100)) { $quality = num; } else { $quality = 100; } };
			
			
		private var drawing:Sprite;
		
		private var $color:int = 0x4A7FF9;
			public function get editColor():int { return $color; }
			public function set editColor(value:int):void { $color = value; }			
			
		protected var $parameters:Object = new Object;
			public function get parameters():Object { return $parameters; }
			
			public function get dots():Array { return $parameters.dots; }
			public function set dots(value:Array):void { $parameters.dots = value; }
			
			public function get ss():ShapeStyle { return $parameters.ss; }
			public function set ss(value:ShapeStyle):void { refresh( { ss:value } ); }
			
			public function get ds():ShadowStyle { return $parameters.ds; }
			public function set ds(value:ShadowStyle):void { refresh( { ds:value } ); }
			
			public function get editable():Boolean { return $parameters.editable; }
			public function set editable(value:Boolean):void
			{
				$parameters.editable = value;
				
				if (value) { activate(); }
				else { desactivate(); }
			}
			
			protected var EDITED:Boolean = false;
				public function get pure():Boolean { return !EDITED; }
			
			private function get visibility():Boolean { return $parameters.visibility; }
			private function set visibility(value:Boolean):void { $parameters.visibility = value; }
			
			public function get closed():Boolean { return $parameters.closed; }
			public function set closed(value:Boolean):void { refresh( { closed:value } ); }
			
		protected var $originX:Number = 0, $originY:Number = 0;
			override public function get x():Number { return $originX + super.x; }
			override public function get y():Number { return $originY + super.y; }
		
		private var $destinationX:Number = 0, $destinationY:Number = 0;
		
		protected var $sizeX:Number = 0, $sizeY:Number = 0;
			override public function get width():Number { return $sizeX; }
			override public function get height():Number { return $sizeY; }
			
		public function get bounds():Rectangle { return new Rectangle($originX, $originY, $sizeX, $sizeY); }
		
		/**
		 * @param	parameters This object holds all the parameters of a curvegon. It can be omitted for later use of the object
		 * 
		 * needed :
		 * - dots:Array 				=> Array of Curvepoints of the shape
		 * 
		 * additionnal : 
		 * - ss:ShapeStyle 				=> Style of the current shape
		 * - ds:ShadowStyle 			=> Stylized dropshadow of the current shape
		 * - editable:Boolean = false 	=> Can lock the shape to be uneditable. Default is false.
		 */
		public function Curvegon(parameters:Object = null)
		{
			if (parameters != null) { initialize(parameters); }
			visibility = false;
		}
		
		public function initialize(parameters:Object):void
		{
			if (drawing == null)
			{
				drawing = new Sprite;
				addEventListener(CurveEvent.REMOVE_POINT, removePoint);
				
				refresh(parameters);
			}
			else
			{
				throw new Error("curvegon already initialized");
			}
		}
		
		/**
		 * @param parameters This object is same as the constructor one.
		 * This function overwrite current parameters of the shape with those given in parameters.
		 * All the additionnal parameters can be omitted not to overwrite them. To delete, simply overwrite to null.
		 */
		public function store(parameters:Object):void
		{
			if ((parameters.dots != undefined) && (!EDITED)) { if (Utils.isA(parameters.dots, Array)) { $parameters.dots = parameters.dots; } }
			else if ($parameters.dots == null) { throw new Error("dots parameter is missing"); }
			
			if ((parameters.ss != undefined) && (Utils.isA(parameters.ss, ShapeStyle))) { $parameters.ss = parameters.ss; }
			else if ($parameters.ss == null) { $parameters.ss = ShapeStyle.getDefaultStyle(); }
			
			if ((parameters.ds != undefined) && (Utils.isA(parameters.ds, ShadowStyle))) { $parameters.ds = parameters.ds; }
			
			if ((parameters.editable != undefined) && (Utils.isA(parameters.editable, Boolean))) { editable = parameters.editable; }
			else if ($parameters.editable == null) { editable = true; }
			
			if ((parameters.closed != undefined) && (Utils.isA(parameters.closed, Boolean))) { $parameters.closed = parameters.closed; }
			else if ($parameters.closed == null) { $parameters.closed = false; }
		}
		
		public function refresh(parameters:Object):void
		{
			store(parameters);
			draw();
		}
		
		/**
		 * @param e This event can be omitted for manual calls.
		 * This function draws the current shape with its style.
		 */
		public function draw(e:MouseEvent = null):void
		{
			$originX = dots[0].pointX;
			$originY = dots[0].pointY;
			
			$destinationX = $destinationY = 0;
			
			$sizeX = $sizeY = 0;
			
			ss.applyTo(this);
				drawing.graphics.clear();
				drawing.graphics.lineStyle(2, $color);
			
			if (ds != null) { filters = ds.render; }
			
			graphics.moveTo(dots[0].pointX, dots[0].pointY);	
				drawing.graphics.moveTo(dots[0].pointX, dots[0].pointY);	
			
			for (var i:int = 0; i < dots.length - 1; i++)
			{ curve(dots[i], dots[i + 1]); }
			
			if (closed) { curve(dots[dots.length - 1], dots[0]); }
			
			graphics.moveTo(dots[0].pointX, dots[0].pointY);
			graphics.endFill();
			
			//dispatchEvent(new ResizeEvent(ResizeEvent.RESIZE));
		}
		
		public function clone():MilkyObject
		{
			var cloned:Object = $parameters;
				//for each(var cp:CurvePoint in dots) { cloned.dots.push(cp.clone()); }
				
			return new Curvegon(cloned);
		}
		
		private function curve(start:CurvePoint, end:CurvePoint):void
		{
			for (var u:Number = 0; u <= 1; u += 1 / $quality)
			{
				var posX:Number, posY:Number;
				
				if ($render == BASIC)
				{
					posX = (u * u * ( end.pointX - start.pointX ) + 3 * ( 1 - u ) * ( u * ( end.anch1X - start.pointX ) + ( 1 - u ) * ( start.anch2X - start.pointX ) ) ) * u  + start.pointX;
					posY = (u * u * ( end.pointY - start.pointY ) + 3 * ( 1 - u ) * ( u * ( end.anch1Y - start.pointY ) + ( 1 - u ) * ( start.anch2Y - start.pointY ) ) ) * u  + start.pointY;
				}
				else if($render == ADVANCED)
				{
					posX = (u * u * u) * (end.pointX + 3 * (start.anch2X - end.anch1X) - start.pointX)
							+ 3 * (u * u) * (start.pointX - 2 * start.anch2X + end.anch1X)
							+ 3 * u * (start.anch2X - start.pointX) + start.pointX;
					
					posY = (u * u * u) * (end.pointY + 3 * (start.anch2Y - end.anch1Y) - start.pointY)
							+ 3 * (u * u) * (start.pointY - 2 * start.anch2Y + end.anch1Y)
							+ 3 * u * (start.anch2Y - start.pointY) + start.pointY;
				}
				
				graphics.lineTo(posX, posY);
					drawing.graphics.lineTo(posX, posY);
				
				if (posX < $originX) { $originX = posX; }
				if (posY < $originY) { $originY = posY; }
				
				if (posX > $destinationX) { $destinationX = posX; }
				if (posY > $destinationY) { $destinationY = posY; }
				
				$sizeX = $destinationX - $originX;
				$sizeY = $destinationY - $originY;
			}
		}
		
		/**
		 * @param e This event can be omitted for manual calls.
		 * This function closes the current shape.
		 */
		public function close(e:MouseEvent = null):void
		{
			if (e != null) { e.stopImmediatePropagation(); }
			
			closed = true;
			draw();
		}
		
		public function activate():void
		{
			doubleClickEnabled = true;
			addEventListener(MouseEvent.DOUBLE_CLICK, toggle);
		}
		
		public function desactivate():void
		{
			doubleClickEnabled = false;
			removeEventListener(MouseEvent.DOUBLE_CLICK, toggle);
		}
		
		private function toggle(e:MouseEvent):void
		{
			e.stopPropagation();
			
			if (!visibility) { show(); } else { hide(); }
		}
		
		public function show():void
		{
			EDITED = true;
			visibility = true;
			
			addChild(drawing);
				drawing.visible = true;
				drawing.addEventListener(MouseEvent.CLICK, addPoint);
			
			for (var i:int = 0; i < dots.length; i++)
			{
				addChild(dots[i]);
					dots[i].visible = true;
					dots[i].addEventListener(MouseEvent.MOUSE_DOWN, start, true, 1000);
					dots[i].addEventListener(MouseEvent.MOUSE_UP, stop, true, 1000);
					dots[i].addEventListener(MouseEvent.CLICK, draw);
			}
		}
		
		public function hide():void
		{
			visibility = false;
			
			removeChild(drawing);
				drawing.visible = false;
				drawing.removeEventListener(MouseEvent.CLICK, addPoint);
			
			for (var i:int = 0; i < dots.length; i++)
			{
				removeChild(dots[i]);
					dots[i].visible = false;
					dots[i].removeEventListener(MouseEvent.MOUSE_DOWN, start, true);
					dots[i].removeEventListener(MouseEvent.MOUSE_UP, stop, true);
					dots[i].removeEventListener(MouseEvent.CLICK, draw);
			}
		}
		
		private function start(e:MouseEvent):void { stage.addEventListener(MouseEvent.MOUSE_MOVE, draw); }
		private function stop(e:MouseEvent):void { stage.removeEventListener(MouseEvent.MOUSE_MOVE, draw); }
		
		/**
		 * @param dot Adds the passed CurvePoint to the shape
		 */
		public function push(dot:CurvePoint):void
		{
			dots.push(dot);
			if (visibility) { addChild(dot); }
		}
		
		private function addPoint(e:MouseEvent):void
		{
			e.stopImmediatePropagation();
			hide();
			
			var  i:int = 0, done:Boolean = false, u:Number, minX:Number, minY:Number, maxX:Number, maxY:Number;
			var max:int = closed ? dots.length : dots.length - 1;
				max = dots.length;
			var start:CurvePoint, end:CurvePoint;
			
			var posX:Number, posY:Number, oldX:Number = 0, oldY:Number = 0;
			
			do
			{
				start = i < dots.length - 1 ? dots[i] : dots[dots.length - 1];
				end = i < dots.length - 1 ? dots[i + 1] : dots[0];
				
				u = 0;
				
				do
				{
					posX = (u * u * ( end.pointX - start.pointX ) + 3 * ( 1 - u ) * ( u * ( end.anch1X - start.pointX ) + ( 1 - u ) * ( start.anch2X - start.pointX ) ) ) * u  + start.pointX;
					posY = (u * u * ( end.pointY - start.pointY ) + 3 * ( 1 - u ) * ( u * ( end.anch1Y - start.pointY ) + ( 1 - u ) * ( start.anch2Y - start.pointY ) ) ) * u  + start.pointY;
					
/*							if (u == 0)
							{
								minX = maxX = posX;
								minY = maxY = posY;
							}*/
							
							minX = (oldX < posX) ? oldX : posX;
							minY = (oldY < posY) ? oldY : posY;
							maxX = (oldX < posX) ? posX : oldX;
							maxY = (oldY < posY) ? posY : oldY;
					
					if ((minX-1 < mouseX) && (mouseX < maxX+1) && (minY-1 < mouseY) && (mouseY < maxY+1)) { done = true; }
					
					oldX = posX;
					oldY = posY;
					
					u += 1 / $quality;
				} while (!done && (u <= 1));
				
			} while (!done && (++i < max))
			
			if ((i != 0) || ((u * 100) != 1))
			{
				//trace("Le point est apres ", i, ", a", (u * 100).toFixed(0), "% du segment de courbe");
				
				var lBefore:Number = Math.sqrt((end.pointX - start.pointX) * (end.pointX - start.pointX) + (end.pointY - start.pointY) * (end.pointY - start.pointY)) / 2;
					lBefore *= u;
				
				var lAfter:Number = Math.sqrt((end.pointX - start.pointX) * (end.pointX - start.pointX) + (end.pointY - start.pointY) * (end.pointY - start.pointY)) / 2;
					lAfter *= (1 - u);
				
				u -= 2 * (1 / $quality);
				
					var xBefore:Number = (u * u * ( end.pointX - start.pointX ) + 3 * ( 1 - u ) * ( u * ( end.anch1X - start.pointX ) + ( 1 - u ) * ( start.anch2X - start.pointX ) ) ) * u  + start.pointX;
					var yBefore:Number = (u * u * ( end.pointY - start.pointY ) + 3 * ( 1 - u ) * ( u * ( end.anch1Y - start.pointY ) + ( 1 - u ) * ( start.anch2Y - start.pointY ) ) ) * u  + start.pointY;
					
				u += 2 * (1 / $quality);
					
					var xAfter:Number = (u * u * ( end.pointX - start.pointX ) + 3 * ( 1 - u ) * ( u * ( end.anch1X - start.pointX ) + ( 1 - u ) * ( start.anch2X - start.pointX ) ) ) * u  + start.pointX;
					var yAfter:Number = (u * u * ( end.pointY - start.pointY ) + 3 * ( 1 - u ) * ( u * ( end.anch1Y - start.pointY ) + ( 1 - u ) * ( start.anch2Y - start.pointY ) ) ) * u  + start.pointY;
						
				var angle:Number = Math.atan2(yAfter - yBefore, xAfter - xBefore);
					
				var anch1X:Number = mouseX - (lBefore * Math.cos(angle));
				var anch1Y:Number = mouseY - (lBefore * Math.sin(angle));
				
				var anch2X:Number = mouseX + (lAfter * Math.cos(angle));
				var anch2Y:Number = mouseY + (lAfter * Math.sin(angle));
				
				var dot:CurvePoint = new CurvePoint(mouseX, mouseY, anch1X, anch1Y, anch2X, anch2Y);
					dots.splice(++i, 0, dot);
					
				if (dots[i - 1] != undefined)
				{
					dots[i - 1].anch2XRel *= u;
					dots[i - 1].anch2YRel *= u;
				}
				
				
				
				if ((dots[i + 1] != undefined) && (i + 1 < dots.length))
				{
					dots[i + 1].anch1XRel *= (1 - u);
					dots[i + 1].anch1YRel *= (1 - u);
				}
				else if (i + 1 == dots.length)
				{
					dots[0].anch1XRel *= (1 - u);
					dots[0].anch1YRel *= (1 - u);
				}
			}
			show();
			draw();
		}
		
		private function removePoint(e:CurveEvent):void
		{
			e.stopImmediatePropagation();
			
			if (dots.length > 2)
			{
				var i:int = dots.indexOf(e.reference);
				
				removeChild(dots[i]);
					dots[i].visible = false;
					dots[i].removeEventListener(MouseEvent.MOUSE_DOWN, start, true);
					dots[i].removeEventListener(MouseEvent.MOUSE_UP, stop, true);
					dots[i].removeEventListener(MouseEvent.CLICK, draw);
					
				dots[i] = null;
				dots.splice(i, 1);
				
				draw();
			}
		}
	}
}
