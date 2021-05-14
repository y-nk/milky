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

//TODO Rework like Curvegon pattern

package martian.milky.special
{
	import martian.milky.curves.Rectangles;
	import martian.milky.styles.ShapeStyle;
	import martian.milky.special.Pictogram;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class PixelArt extends Sprite
	{
		private var $parameters:Object
		private var $pixelSize:Number;
		private var $path:Array; 
		
		/**
		 * @param	parameters This object holds all the parameters of a curvegon. It can be omitted for later use of the object
		 * 
		 * needed :
		 * - path:Array 				=> example : [ [pixel(0,0).color, pixel(1,0).color] , [pixel(0,1).color, pixel(1,1).color] ]
		 * 
		 * additionnal : 
		 * - pixelSize:int 				=> Size of the pictogram's pixel
		 */
		public function PixelArt(parameters:Object = null)
		{
			if (parameters != null) { initialize(parameters); }
		}
		
		private function initialize(parameters:Object):void
		{
			$parameters = parameters;
			
			store(parameters);
			draw();
		}
		
		public function store(parameters:Object):void
		{
			$path = parameters.path;
			if (parameters.pixelSize != null) { $pixelSize = parameters.pixelSize; }
			else { $pixelSize = 1; }
		}
		
		public function draw():void
		{
			for (var i:Number = 0 ; i < $path.length; i++)
			{
				for (var j:Number = 0; j < $path[i].length; j++)
				{
					if ($path[i][j] != null)
					{
						var ss:ShapeStyle = new ShapeStyle();
							ss.$fillColor = $path[i][j];
							ss.$fillAlpha = 1;
							ss.$lineThick = ss.$lineAlpha = 0;
						
						addPixel(new Point(j * $pixelSize, i * $pixelSize), ss);
					}
				}
			}
		}
		
		public function redraw():void
		{
			for (var i:Number = 0; i < numChildren; i++) { removeChildAt(i); }
			draw();
		}
		
		private function addPixel(pixel:Point, ss:ShapeStyle):void
		{
			var dot:Rectangles = new Rectangles( { width: $pixelSize, ss: ss } );
				addChild(dot);
				dot.x = pixel.x;
				dot.y = pixel.y;
		}
	}
}
