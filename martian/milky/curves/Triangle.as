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
	
	public class Triangle extends Curvegon
	{
		override public function set width(value:Number):void { refresh( { width:value } ) ; }
		override public function set height(value:Number):void { refresh( { height:value } ) ; }
		
		/**
		 * @param	parameters This object holds all the parameters of a triangle. It can be omitted for later use of the object.
		 * 
		 * needed :
		 * - width:int	 				=> width of the triangle
		 * 
		 * additionnal :
		 * - height:int					=> if omitted, shape will be an equilateral triangle
		 * - ss:ShapeStyle 				=> Style of the current triangle
		 * - ds:ShadowStyle 			=> Stylized dropshadow of the current triangle
		 * - editable:Boolean = false 	=> Can lock the shape to be uneditable. Default is false.
		 */
		
		public function Triangle(parameters:Object = null)
		{
			super(parameters);
		}
		
		/**
		 * @param parameters This object is same as the constructor one.
		 * This function overwrite current parameters of the triangle with those given in parameters.
		 * All the additionnal parameters can be omitted not to overwrite them. To delete, simply overwrite to null.
		 */
		override public function store(parameters:Object):void
		{
			if (parameters.width != undefined) { if (Utils.isA(parameters.width, Number)) { $parameters.width = parameters.width; } }
			else if ($parameters.width == null) { throw new Error("width parameter is missing"); }
			
			if (parameters.height != undefined) { if (Utils.isA(parameters.height, Number)) { $parameters.height = parameters.height; } }
			else if ($parameters.height == null) { throw new Error("height parameter is missing"); }
			
			parameters.closed = true;
			parameters.dots = [ new CurvePoint(0, 0),
								new CurvePoint($parameters.width / 2, $parameters.height),
								new CurvePoint($parameters.width, 0) ];
			
			super.store(parameters);
		}
	}
}
