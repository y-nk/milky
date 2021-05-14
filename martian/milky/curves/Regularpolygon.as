/*
# @author Julien Barbay aka ynk
# @version 0.1
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
	
	public class Regularpolygon extends Curvegon
	{
		public function get edges():Number { return $parameters.edges; }
		public function set edges(value:Number):void { refresh( { edges:value } ); }
		
		public function get radius():Number { return $parameters.radius; }
		public function set radius(value:Number):void { refresh( { radius:value } ); }
		
		/**
		 * @param	parameters This object holds all the parameters of a regularpolygon. It can be omitted for later use of the object.
		 * 
		 * needed :
		 * - edges:int	 				=> number of edges of the regularpolygon
		 * - radius:Number				=> radius of the regularpolygon
		 * 
		 * additionnal :
		 * - ss:ShapeStyle 				=> Style of the current regularpolygon
		 * - ds:ShadowStyle 			=> Stylized dropshadow of the current regularpolygon
		 * - editable:Boolean = false 	=> Can lock the shape to be uneditable. Default is false.
		 */
		public function Regularpolygon(parameters:Object = null)
		{
			super(parameters);
		}
		
		/**
		 * @param parameters This object is same as the constructor one.
		 * This function overwrite current parameters of the regularpolygon with those given in parameters.
		 * All the additionnal parameters can be omitted not to overwrite them. To delete, simply overwrite to null.
		 */
		override public function store(parameters:Object):void
		{
			if (parameters.edges != undefined) { if (Utils.isA(parameters.edges, int)) { $parameters.edges = parameters.edges; } }
			else if ($parameters.edges == null) { throw new Error("edges parameter is missing"); }
			
			if (parameters.radius != undefined) { if (Utils.isA(parameters.radius, Number)) { $parameters.radius = parameters.radius; } }
			else if ($parameters.radius == null) { throw new Error("radius parameter is missing"); }
			
			parameters.closed = true;
			parameters.dots = new Array;
			
			for (var i:int = 0; i < $parameters.edges; i++)
			{
				var px:Number = $parameters.radius + Math.cos((i) * ((2 * Math.PI) / $parameters.edges)) * $parameters.radius; 
				var py:Number = $parameters.radius + Math.sin((i) * ((2 * Math.PI) / $parameters.edges)) * $parameters.radius; 	
				
				parameters.dots.push(new CurvePoint(px, py));
			}
			
			super.store(parameters);
		}
		
		override public function draw(e:MouseEvent = null):void 
		{
			super.draw(e);
			
			$originX = $originY = 0;
			$sizeX = $sizeY = 2 * $parameters.radius;
		}
	}
}
