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
	import martian.milky.curves.Curvegon;
	import martian.milky.curves.CurvePoint;
	import martian.milky.styles.*;
	import martian.milky.core.Utils;
	
	import flash.geom.Point;
	import flash.events.MouseEvent;

	public class Starpolygon extends Curvegon
	{
		public function get spikes():Number { return $parameters.spikes; }
		public function set spikes(value:Number):void { refresh( { spikes:value } ); }
		
		public function get radius1():Number { return $parameters.radius1; }
		public function set radius1(value:Number):void { refresh( { radius1:value } ); }
		
		public function get radius2():Number { return $parameters.radius2; }
		public function set radius2(value:Number):void { refresh( { radius2:value } ); }
		
		/**
		 * @param	parameters This object holds all the parameters of a starpolygon. It can be omitted for later use of the object.
		 * 
		 * needed :
		 * - spikes:int	 				=> number of spikes of the starpolygon
		 * - radius1:int				=> biggest radius of the starpolygon
		 * - radius2:int				=> smallest radius of the starpolygon
		 * 
		 * additionnal :
		 * - ss:ShapeStyle 				=> Style of the current starpolygon
		 * - ds:ShadowStyle 			=> Stylized dropshadow of the current starpolygon
		 * - editable:Boolean = false 	=> Can lock the shape to be uneditable. Default is false.
		 */
		
		public function Starpolygon(parameters:Object = null)
		{
			super(parameters);
		}
		
		/**
		 * @param parameters This object is same as the constructor one.
		 * This function overwrite current parameters of the starpolygon with those given in parameters.
		 * All the additionnal parameters can be omitted not to overwrite them. To delete, simply overwrite to null.
		 */
		
		override public function store(parameters:Object):void
		{
			if (parameters.spikes != undefined) { if (Utils.isA(parameters.spikes, Number)) { $parameters.spikes = parameters.spikes; } }
			else if ($parameters.spikes <= 3) { throw new Error("spikes parameter is missing or less than 4"); }
			
			if (parameters.radius1 != undefined) { if (Utils.isA(parameters.radius1, Number)) { $parameters.radius1 = parameters.radius1; } }
			else if ($parameters.radius1 == null) { throw new Error("radius1 parameter is missing"); }
			
			if ((parameters.radius2 != undefined) && (parameters.radius2 >= 0) && (parameters.radius2 <= 1)) { if (Utils.isA(parameters.radius2, Number)) { $parameters.radius2 = parameters.radius2; } }
			else if ($parameters.radius2 == null) { $parameters.radius2 = 0.9; }
			
			var currentRadius:Number, smallRadius:Number = $parameters.radius1 * $parameters.radius2;
			
			parameters.closed = true;
			parameters.dots = new Array;
			
			for (var i:int = 0; i < $parameters.spikes; i++)
			{
				if (i % 2 == 0) { currentRadius = $parameters.radius1; } else { currentRadius = smallRadius; }
				
				var px:Number = $parameters.radius1 + Math.cos(i * (Number(2 * Math.PI) / $parameters.spikes)) * currentRadius; 
				var py:Number = $parameters.radius1 + Math.sin(i * (Number(2 * Math.PI) / $parameters.spikes)) * currentRadius; 	
				
				parameters.dots.push(new CurvePoint(px, py));
			}
			
			super.store(parameters);
		}
		
		override public function draw(e:MouseEvent = null):void 
		{
			super.draw(e);
			
			graphics.lineStyle(0, 0xffffff, 0)
			graphics.drawRect(0, 0, 2 * $parameters.radius1, 2 * $parameters.radius1);
		}
	}
}
