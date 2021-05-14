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
	import martian.milky.curves.Curvegon;
	
	import flash.display.CapsStyle;
	
	public class ShapeStyle
	{
		static public const PLAIN:String = "plain";
		static public const GRADIENT_LINEAR:String = "linear";
		static public const GRADIENT_RADIAL:String = "radial";
		
		static private var $defaultType:String = PLAIN;
		static private var $defaultfillColor:int = 0;
		static private var $defaultfillAlpha:Number = 1;
		static private var $defaultlineThick:Number = 0;
		static private var $defaultlineColor:int = 0;
		static private var $defaultlineAlpha:Number = 0;
		
		static public function set DEFAULT_FILLTYPE(type:String):void { $defaultType = type; }
		static public function get DEFAULT_FILLTYPE():String { return $defaultType; }
		
		static public function set DEFAULT_FILLCOLOR(color:int):void { $defaultfillColor = color; }
		static public function get DEFAULT_FILLCOLOR():int { return $defaultfillColor; }
				
		static public function set DEFAULT_FILLALPHA(alpha:Number):void { $defaultfillAlpha = alpha; }
		static public function get DEFAULT_FILLALPHA():Number { return $defaultfillAlpha; }
		
		static public function set DEFAULT_LINETHICK(thick:Number):void { $defaultlineThick = thick; }
		static public function get DEFAULT_LINETHICK():Number { return $defaultlineThick; }
		
		static public function set DEFAULT_LINECOLOR(color:int):void { $defaultlineColor = color; }
		static public function get DEFAULT_LINECOLOR():int { return $defaultlineColor; }
				
		static public function set DEFAULT_LINEALPHA(alpha:Number):void { $defaultlineAlpha = alpha; }
		static public function get DEFAULT_LINEALPHA():Number { return $defaultlineAlpha; }
		
		static public function DEFAULT(parameters:Object):void
		{
			if ((parameters.fillType != undefined) && (Utils.isA(parameters.fillType, String))) { DEFAULT_FILLTYPE = parameters.fillType; }
			
			if ((parameters.fillColor != undefined) && (Utils.isA(parameters.fillColor, int))) { DEFAULT_FILLCOLOR = parameters.fillColor; }
			
			if ((parameters.fillAlpha != undefined) && (Utils.isA(parameters.fillAlpha, Number))) { DEFAULT_FILLALPHA = parameters.fillAlpha; }
			
			if ((parameters.lineThick != undefined) && (Utils.isA(parameters.lineThick, Number))) { DEFAULT_LINETHICK = parameters.lineThick; }
			
			if ((parameters.lineColor != undefined) && (Utils.isA(parameters.lineColor, int))) { DEFAULT_LINECOLOR = parameters.lineColor; }
			
			if ((parameters.lineAlpha != undefined) && (Utils.isA(parameters.lineAlpha, Number))) { DEFAULT_LINEALPHA = parameters.lineAlpha; }
		}
		
		static public function getDefaultStyle():ShapeStyle { return new ShapeStyle(); }
		
		/********************/
		
		
		
		private var $fillColor:int;
		private var $fillAlpha:Number;
		private var $lineThick:Number;
		private var $lineColor:int;
		private var $lineAlpha:Number;
		
		public function set fillColor(color:int):void { $fillColor = color; }
		public function get fillColor():int { return $fillColor; }
		
		public function set fillAlpha(alpha:Number):void { $fillAlpha = alpha; }
		public function get fillAlpha():Number { return $fillAlpha; }
		
		public function set lineThick(thick:Number):void { $lineThick = thick; }
		public function get lineThick():Number { return $lineThick; }
		
		public function set lineColor(color:int):void { $lineColor = color; }
		public function get lineColor():int { return $lineColor; }
		
		public function set lineAlpha(alpha:Number):void { $lineAlpha = alpha; }
		public function get lineAlpha():Number { return $lineAlpha; }
		
		/**
		 * @param	if leaved as default, will be the current default value
		 */
		public function ShapeStyle(parameters:Object = null)
		{
			if (parameters != null)
			{
				if ((parameters.fillColor != undefined) && (Utils.isA(parameters.fillColor, int))) { fillColor = parameters.fillColor; } else { fillColor = DEFAULT_FILLCOLOR; }
				
				if ((parameters.fillAlpha != undefined) && (Utils.isA(parameters.fillAlpha, Number))) { $fillAlpha = parameters.fillAlpha; } else { $fillAlpha = DEFAULT_FILLALPHA; }
				
				if ((parameters.lineThick != undefined) && (Utils.isA(parameters.lineThick, Number))) { $lineThick = parameters.lineThick; } else { $lineThick = DEFAULT_LINETHICK; }
				
				if ((parameters.lineColor != undefined) && (Utils.isA(parameters.lineColor, int))) { lineColor = parameters.lineColor; } else { lineColor = DEFAULT_LINECOLOR; }
				
				if ((parameters.lineAlpha != undefined) && (Utils.isA(parameters.lineAlpha, Number))) { $lineAlpha = parameters.lineAlpha; } else { $lineAlpha = DEFAULT_LINEALPHA; }
			}
			else
			{
				$fillColor = DEFAULT_FILLCOLOR; $fillAlpha = DEFAULT_FILLALPHA; $lineThick = DEFAULT_LINETHICK; $lineColor = DEFAULT_LINECOLOR; $lineAlpha = DEFAULT_LINEALPHA;
			}
		}
		
		public function clone():ShapeStyle
		{
			return new ShapeStyle( { fillColor:$fillColor, fillAlpha:$fillAlpha, lineThick:$lineThick, lineColor:$lineColor, lineAlpha:$lineAlpha } );
		}
		
		public function toString():String
		{	
			return "$fillColor:0x" + $fillColor.toString(16) + "$fillAlpha:" + $fillAlpha.toString() + "$lineThick:" + $lineThick.toString() + "$lineColor:0x" + $lineColor.toString(16) + "$lineAlpha:" + $lineAlpha.toString();
		}
		
		public function applyTo(object:Curvegon):void
		{
			object.graphics.clear();
			
			var caps:String = object.closed ? CapsStyle.NONE : CapsStyle.ROUND;
			
			// plain fill
			if ($fillAlpha != 0) { object.graphics.beginFill($fillColor, $fillAlpha); }
			
			// plain line
			if (($lineAlpha != 0) && ($lineThick != 0)) { object.graphics.lineStyle($lineThick, $lineColor, $lineAlpha, false, "normal", caps); }
		}
	}
}
