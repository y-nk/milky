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
	import martian.milky.interfaces.*;
	
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	public class Link extends Label implements MilkyObject, MilkyShape, MilkyText, MilkyShadow, MilkyInteractive
	{
		public function get url():String { return $parameters.url; }
		public function set url(value:String):void { refresh( { url:value } ); }
		
		/**
		 * @param	parameters This object holds all the parameters of a hypertext-link label. It can be omitted for later use of the object
		 * 
		 * needed :
		 * - string:String				=> hypertext-link label's label
		 * - url:String 				=> Target of the hypertext-link label
		 * 
		 * additionnal : 
		 * - ss:ShapeStyle 				=> Style of the current hypertext-link label
		 * - ts:TextStyle 				=> Style of the current hypertext-link label's font
		 * - ds:ShadowStyle 			=> Stylized dropshadow of the current hypertext-link label
		 */
		
		public function Link(parameters:Object = null)
		{
			super(parameters);
			
			$layer.doubleClickEnabled = true;
		}
		
		/**
		 * @param parameters This object is same as the constructor one.
		 * This function overwrite current parameters of the hypertext-link label with those given in parameters.
		 * All the additionnal parameters can be omitted not to overwrite them. To delete, simply overwrite to null.
		 */
		override public function store(parameters:Object):void
		{			
			if (parameters.url != undefined) { if (Utils.isA(parameters.url, String)) { $parameters.url = parameters.url; } }
			else if ($parameters.url == null) { throw new Error("url parameter is missing"); }
			
			super.store(parameters);
		}
		
		override public function clone():MilkyObject { return new Link( $parameters ); }
		
		private function click(e:MouseEvent):void
		{
			e.stopImmediatePropagation();
			navigateToURL(new URLRequest($parameters.url), "_blank");
		}
		
		public function activate():void
		{
			$layer.useHandCursor = $layer.buttonMode = true;
			$layer.addEventListener(MouseEvent.DOUBLE_CLICK, click);
		}
		
		public function desactivate():void
		{
			$layer.useHandCursor = $layer.buttonMode = false;
			$layer.removeEventListener(MouseEvent.DOUBLE_CLICK, click);
		}
		
	}
	
}
