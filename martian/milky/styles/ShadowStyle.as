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

package martian.milky.styles
{
	import martian.milky.core.Utils;
	
	import flash.filters.DropShadowFilter;
	
	public class ShadowStyle
	{
		static private var $defaultdistance:int = 1;
		static private var $defaultangle:Number = 90;
		static private var $defaultcolor:int = 0;
		static private var $defaultalpha:Number = 0.5;
		static private var $defaultblur:int = 6;
		
		static public function set DEFAULT_DISTANCE(distance:int):void { $defaultdistance = distance; }
		static public function get DEFAULT_DISTANCE():int { return $defaultdistance; }
		
		static public function set DEFAULT_ANGLE(angle:Number):void { $defaultangle = angle; }
		static public function get DEFAULT_ANGLE():Number { return $defaultangle; }
		
		static public function set DEFAULT_COLOR(color:int):void { $defaultcolor = color; }
		static public function get DEFAULT_COLOR():int { return $defaultcolor; }
		
		static public function set DEFAULT_ALPHA(alpha:Number):void { $defaultalpha = alpha; }
		static public function get DEFAULT_ALPHA():Number { return $defaultalpha; }
		
		static public function set DEFAULT_BLUR(blur:int):void { $defaultblur = blur; }
		static public function get DEFAULT_BLUR():int { return $defaultblur; }
		
		static public function DEFAULT(parameters:Object):void
		{
			if ((parameters.distance != undefined) && (Utils.isA(parameters.distance, int))) { DEFAULT_DISTANCE = parameters.distance; }
			if ((parameters.angle != undefined) && (Utils.isA(parameters.angle, Number))){ DEFAULT_ANGLE = parameters.angle;  }
			if ((parameters.color != undefined) && (Utils.isA(parameters.color, int))) { DEFAULT_COLOR = parameters.color;  }
			if ((parameters.alpha != undefined) && (Utils.isA(parameters.alpha, Number))) { DEFAULT_ALPHA = parameters.alpha;  }
			if ((parameters.blur != undefined) && (Utils.isA(parameters.blur, int))) { DEFAULT_BLUR = parameters.blur; }
		}
		
		static public function getDefaultStyle():ShadowStyle { return new ShadowStyle(); }
		
		/********************/
		
		
		
		private var $distance:int;
		private var $angle:Number;
		private var $color:int;
		private var $alpha:Number;
		private var $blur:int;
		private var $render:Array = new Array(1);
		
		public function set distance(distance:int):void { $distance = distance; draw(); }
		public function get distance():int { return $distance; }
		
		public function set angle(angle:Number):void { $angle = angle; draw(); }
		public function get angle():Number { return $angle; }
		
		public function set color(color:int):void { $color = color; draw(); }
		public function get color():int { return $color; }
		
		public function set alpha(alpha:Number):void { $alpha = alpha; draw(); }
		public function get alpha():Number { return $alpha; }
		
		public function set blur(blur:int):void { $blur = blur; draw(); }
		public function get blur():int { return $blur; }
		
		public function get render():Array { return $render; }
		
		/**
		 * @param	distance distance of the shadow
		 * @param	angle angle of the shadow
		 * @param	color color of the shadow
		 * @param	alpha opacity of the shadow
		 * @param	blur of the shadow
		 */
		public function ShadowStyle(parameters:Object = null)
		{
			if (parameters != null)
			{
				if ((parameters.distance != undefined) && (Utils.isA(parameters.distance, int)))  { $distance = parameters.distance; }
				else { $distance = DEFAULT_DISTANCE; }
				
				if ((parameters.angle != undefined) && (Utils.isA(parameters.angle, Number))) { $angle = parameters.angle; }
				else { $angle = DEFAULT_ANGLE;  }
				
				if ((parameters.color != undefined) && (Utils.isA(parameters.color, int))) { $color = parameters.color; }
				else { $color = DEFAULT_COLOR;  }
				
				if ((parameters.alpha != undefined) && (Utils.isA(parameters.alpha, Number))) { $alpha = parameters.alpha; }
				else { $alpha = DEFAULT_ALPHA;  }
				
				if ((parameters.blur != undefined) && (Utils.isA(parameters.blur, int))) { $blur = parameters.blur; }
				else { $blur = DEFAULT_BLUR; }
			}
			else
			{
				$distance = DEFAULT_DISTANCE; $angle = DEFAULT_ANGLE; $color = DEFAULT_COLOR; $alpha = DEFAULT_ALPHA; $blur = DEFAULT_BLUR;
			}
			draw();
		}
		
		private function draw():void
		{
			$render = [ new DropShadowFilter($distance, $angle, $color, $alpha, $blur, $blur) ];
		}
		
		public function clone():ShadowStyle
		{
			return new ShadowStyle( { distance:$distance, angle:$angle, color:$color, alpha:$alpha, blur:$blur } );
		}
		
		public function toString():String {	return "$distance:" + $distance.toString() + "$angle:" + $angle.toString() + "$color:0x" + $color.toString(16) + "$alpha:" + $alpha.toString() + "$blur:" + $blur.toString(); }
	}
	
}
