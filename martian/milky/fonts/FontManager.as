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

package martian.milky.fonts
{
	import flash.text.Font;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	
	public class FontManager
	{
		static private var $fonts:Array = new Array;
			static public function get fonts():Array { return $fonts; }
		
		public function FontManager() { throw new Error("FontManager should not be instanciated"); }
		
		static public function activate():void {}
		
		static public function register(font:Class):void
		{
			if (!$fonts.some(function(item:*, index:int, arr:Array):Boolean { return item == font.name; } )) { $fonts.push(font.name); }
			else { trace('already registered'); }
		}
		
		static public function isAvailable(fontname:String):Boolean { return $fonts.some(function(item:*, index:int, arr:Array):Boolean { return item == fontname; } ); }
		
		/*private static var urlLoader:URLLoader;
		static public function load(url:String):void
		{
			urlLoader = new URLLoader();
				urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
				urlLoader.addEventListener(Event.COMPLETE, onComplete);
				urlLoader.load(new URLRequest("lib/arial.ttf"));
				
		}
		
		private static function onComplete(e:Event):void
		{
			trace(urlLoader.bytesLoaded.toString()  + " / " + urlLoader.bytesTotal.toString());
			
			var font:ByteArray = urlLoader.data;
			font.position = 0;
			var i : int = 0;
			
			while(font.bytesAvailable)
			{
				trace (i+' : '+font.readByte());
				i++;
			}
		}*/
	}
}
