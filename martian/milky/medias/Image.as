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
	import martian.milky.interfaces.*;
	import martian.milky.curves.Rectangles;
	import martian.milky.events.LoadEvent;
	import martian.milky.styles.*;
	import martian.milky.core.Utils;
	
	import flash.display.*;
	import flash.net.URLRequest;
	import flash.events.*;
	import flash.geom.Point;
	
	public class Image extends Media implements MilkyObject, MilkyShadow
	{
		static public const FRAME:String = "frame";
		static public const POLAROID:String = "polaroid";
		
		private var $frame:String;
		
		private var $file:Loader;
			public function get bytesLoaded():uint { return $file.contentLoaderInfo.bytesLoaded; }
			public function get bytesTotal():uint { return $file.contentLoaderInfo.bytesTotal; }
		
		/**
		 * @param	parameters This object holds all the parameters of a picture. It can be omitted for later use of the object
		 * 
		 * needed :
		 * - url:String 				=> url of the picture
		 * 
		 * additionnal : 
		 * - frame:String				=> adds a frame on the picture. Values can be "frame" or "polaroid".
		 * - ds:ShadowStyle 			=> Stylized dropshadow of the current picture
		 */
		
		public function Image(parameters:Object = null)
		{
			super(parameters);
		}
		
		/**
		 * @param parameters This object is same as the constructor one.
		 * This function overwrite current parameters of the picture with those given in parameters.
		 * All the additionnal parameters can be omitted not to overwrite them. To delete, simply overwrite to null.
		 */
		
		override public function store(parameters:Object):void
		{			
			if ((parameters.frame != undefined) && (Utils.isA(parameters.frame, String))) { $frame = parameters.frame; }
			super.store(parameters);
		}
		
		override public function draw(e:MouseEvent = null):void
		{
			$file = new Loader;
			
			try
			{
				$file.load(new URLRequest(url));
					$file.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
					$file.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
			}
			catch (e:Error)
			{
				throw new Error("url introuvable : " + url);
			}
		}
		
		private function onProgress(e:ProgressEvent):void { dispatchEvent(new LoadEvent(LoadEvent.DOWNLOAD_INPROGRESS)); }
		
		private function onComplete(e:Event):void
		{
			if (ds != null) { filters = ds.render; }
			
			var image:Bitmap = Bitmap(e.target.content);
				image.smoothing = true;
			
			if ($frame != null)
			{
				var border:Rectangles;
				var style:ShapeStyle = new ShapeStyle( { fillColor:0xFFFFFF, fillAlpha:1, lineThick:0 } );
				
				switch($frame)
				{
					case "frame":
						border = new Rectangles( { width: image.width + 20, height: image.height + 20, ss: style, editable: false } );
							addChild(border);
							
							image.x = 10;
							image.y = 10; 
							
						break;
						
					case "polaroid":
						border = new Rectangles( { width: image.width + 40, height: image.height + 90, ss: style, editable: false } );
							addChild(border);
							
							image.x = 20;
							image.y = 20;
							
						break;
						
					case "none":
					case null:
						break;
				}
			}
			
			addChild(image);
			
			$size = new Point(image.width, image.height);
			
			$file.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			dispatchEvent(new LoadEvent(LoadEvent.DOWNLOAD_COMPLETE));
		}
	}
	
}
