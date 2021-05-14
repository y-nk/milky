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

package martian.milky.medias
{
	import martian.milky.styles.ShadowStyle;
	import martian.milky.core.Utils;
	import martian.milky.interfaces.*;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class Media extends Sprite implements MilkyObject, MilkyShadow
	{
		protected var $parameters:Object = new Object;
			public function get parameters():Object { return $parameters; }

			public function get ds():ShadowStyle { return $parameters.ds; }
			public function set ds(ds:ShadowStyle):void { refresh( { ds:ds } ); }
			
			public function get url():String { return $parameters.url; }
			
		protected var $size:Point = new Point();
			override public function get width():Number { return $size.x; }
			override public function get height():Number { return $size.y; }
		
		public function Media(parameters:Object = null)
		{
			if (parameters != null) { initialize(parameters); }
		}
		
		/**
		 * @param parameters This object is same as the constructor one.
		 * This function overwrite current parameters of the flash file with those given in parameters.
		 * All the additionnal parameters can be omitted not to overwrite them. To delete, simply overwrite to null.
		 */
		
		public function initialize(parameters:Object):void
		{
			store(parameters);
			draw();
		}
		
		/**
		 * @param parameters This object is same as the constructor one.
		 * This function overwrite current parameters of the flash file with those given in parameters.
		 * All the additionnal parameters can be omitted not to overwrite them. To delete, simply overwrite to null.
		 */

		public function store(parameters:Object):void
		{
			if (parameters.url != undefined) {	if (Utils.isA(parameters.url, String)) { $parameters.url = parameters.url; } }
			else if ($parameters.url == null) { throw new Error("url parameter is missing"); }
			
			if ((parameters.ds != undefined) && (Utils.isA(parameters.ds, ShadowStyle))) { $parameters.ds = parameters.ds; }
		}
		
		public function draw(e:MouseEvent = null):void {}
		
		public function refresh(parameters:Object):void
		{
			store(parameters);
			draw();
		}
		
		public function clone():MilkyObject {return null}
	}
}