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
package martian.milky.labels
{
	import martian.milky.labels.Label;
	import martian.milky.styles.*;
	import martian.milky.core.Utils;
	import martian.milky.events.TweenEvent;
	import martian.milky.interfaces.*;
	
	import flash.events.MouseEvent;
	
	public class Mover extends Label implements MilkyObject, MilkyShape, MilkyText, MilkyShadow, MilkyInteractive
	{
		public function get move():Object { return $parameters.move; }
		
		public function set moveX(value:Number):void { $parameters.move.x = value; }
		public function set moveY(value:Number):void { $parameters.move.y = value; }
		public function set moveR(value:Number):void { $parameters.move.r = value; }
		public function set moveS(value:Number):void { $parameters.move.s = value; }
		
		public function Mover(parameters:Object = null)
		{
			super(parameters);
		}
		
		/**
		 * @param parameters This object is same as the constructor one.
		 * This function overwrite current parameters of the hypertext-link label with those given in parameters.
		 * All the additionnal parameters can be omitted not to overwrite them. To delete, simply overwrite to null.
		 */
		override public function store(parameters:Object):void
		{
			if (parameters.move != undefined) { if (Utils.isA(parameters.move, Object)) { $parameters.move = parameters.move; } }
			else if ($parameters.move == null) { throw new Error("move parameter is missing"); }
			
			super.store(parameters);
		}
		
		override public function clone():MilkyObject { return new Mover( $parameters ); }
		
		public function launch():void { click(); }
		private function click(e:MouseEvent = null):void
		{
			if (e != null) { e.stopImmediatePropagation(); }
			dispatchEvent(new TweenEvent(TweenEvent.MOVE, $parameters.move));
		}
		
		public function activate():void
		{
			$layer.useHandCursor = $layer.buttonMode = true;
			$layer.addEventListener(MouseEvent.DOUBLE_CLICK, click);
			$layer.doubleClickEnabled = true;
		}
		
		public function desactivate():void
		{
			$layer.useHandCursor = $layer.buttonMode = false;
			$layer.removeEventListener(MouseEvent.DOUBLE_CLICK, click);
			$layer.doubleClickEnabled = false;
		}
	}
	
}
