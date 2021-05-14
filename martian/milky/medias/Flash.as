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

package martian.milky.medias
{
	import martian.milky.styles.ShadowStyle;
	import martian.milky.core.Utils;
	import martian.milky.interfaces.*;
	import martian.milky.events.LoadEvent;
	
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.*;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.geom.Point;
	
	public class Flash extends Media implements MilkyObject, MilkyShadow
	{
		public function get remote():Object { return $file.content as Object; }
		
		private var $file:Loader;
			public function get bytesLoaded():uint { return $file.contentLoaderInfo.bytesLoaded; }
			public function get bytesTotal():uint { return $file.contentLoaderInfo.bytesTotal; }
		
		/**
		 * @param	parameters This object holds all the parameters of a Flash file. It can be omitted for later use of the object
		 * 
		 * needed :
		 * - url:String 				=> url of the flash file
		 * 
		 * additionnal : 
		 * - ds:ShadowStyle 			=> Stylized dropshadow of the current flash file
		 */
		public function Flash(parameters:Object = null)
		{	
			super(parameters);
		}
		
		override public function draw(e:MouseEvent = null):void
		{
			$file = new Loader();
			try
			{
				$file.load(new URLRequest(url), new LoaderContext(false, new ApplicationDomain()));
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
			if (ds != null) { filters = ds.render; };
			
			addChild($file.content);
			
			$size = new Point($file.content.width, $file.content.height);
			
			$file.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			dispatchEvent(new LoadEvent(LoadEvent.DOWNLOAD_COMPLETE));
		}
	}
}