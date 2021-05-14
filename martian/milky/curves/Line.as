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
	
	public class Line extends Curvegon
	{
		public function get length():Number { return $parameters.length; }
		public function set length(value:Number):void { refresh( { length:value } ); }
		
		public function get angle():Number { return $parameters.angle; }
		public function set angle(value:Number):void { refresh( { angle:value } ); }
		
		/**
		 * @param	parameters This object holds all the parameters of a line. It can be omitted for later use of the object.
		 * 
		 * needed :
		 * - length:int	 				=> length of the line
		 * 
		 * additionnal :
		 * - angle:int					=> angle of the line (degrees)
		 * - ss:ShapeStyle 				=> Style of the current line
		 * - ds:ShadowStyle 			=> Stylized dropshadow of the current line
		 * - editable:Boolean = false 	=> Can lock the shape to be uneditable. Default is false.
		 */
		public function Line(parameters:Object = null):void
		{	
			super(parameters);
		}
		
		/**
		 * @param parameters This object is same as the constructor one.
		 * This function overwrite current parameters of the line with those given in parameters.
		 * All the additionnal parameters can be omitted not to overwrite them. To delete, simply overwrite to null.
		 */		
		override public function store(parameters:Object):void
		{
			if (parameters.length != undefined) { if (Utils.isA(parameters.length, Number)) { $parameters.length = parameters.length; } }
			else if ($parameters.length == null) { throw new Error("length parameter is missing"); }
			
			if (parameters.angle != undefined) { if (Utils.isA(parameters.angle, Number)) { $parameters.angle = parameters.angle; } }
			else if ($parameters.angle == null) { $parameters.angle = 0; }
			
			parameters.dots = [ 	new CurvePoint(0, 0),
									new CurvePoint($parameters.length * Math.cos($parameters.angle * Math.PI / 180), $parameters.length * Math.sin($parameters.angle * Math.PI / 180))];
			
			super.store(parameters);
		}
	}
}
