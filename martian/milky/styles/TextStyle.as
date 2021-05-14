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

package martian.milky.styles
{
	import martian.milky.core.Utils;
	import martian.milky.fonts.FontManager;
	
	import flash.text.*;

	public class TextStyle
	{
		static private var $defaultfontFamily:String = "h85";
		static private var $defaultfontSize:int = 14;
		static private var $defaultfontColor:int = 0xFFFFFF;
		static private var $defaultfontAlign:String = "left";
		static private var $defaultfontSpacing:Number = -1;
		
		static public function set DEFAULT_FONTFAMILY(fontFamily:String):void { $defaultfontFamily = fontFamily; }
		static public function get DEFAULT_FONTFAMILY():String { return $defaultfontFamily; }
		
		static public function set DEFAULT_FONTSIZE(fontSize:int):void { $defaultfontSize = fontSize; }
		static public function get DEFAULT_FONTSIZE():int { return $defaultfontSize; }
		
		static public function set DEFAULT_FONTCOLOR(fontColor:int):void { $defaultfontColor = fontColor; }
		static public function get DEFAULT_FONTCOLOR():int { return $defaultfontColor; }
		
		static public function set DEFAULT_FONTALIGN(fontAlign:String):void { $defaultfontAlign = fontAlign; }
		static public function get DEFAULT_FONTALIGN():String { return $defaultfontAlign; }
		
		static public function set DEFAULT_FONTSPACING(fontSpacing:Number):void { $defaultfontSpacing = fontSpacing; }
		static public function get DEFAULT_FONTSPACING():Number { return $defaultfontSpacing; }
		
		static public function DEFAULT(parameters:Object):void
		{
			if ((parameters.fontFamily != null) && (Utils.isA(parameters.fontFamily, String))) { DEFAULT_FONTFAMILY = parameters.fontFamily; }
			if ((parameters.fontSize != undefined) && (Utils.isA(parameters.fontSize, String))) { DEFAULT_FONTSIZE = parameters.fontSize; }
			if ((parameters.fontColor != undefined) && (Utils.isA(parameters.fontColor, int))) { DEFAULT_FONTCOLOR = parameters.fontColor; }
			if ((parameters.fontAlign != null) && (Utils.isA(parameters.fontAlign, String))) { DEFAULT_FONTALIGN = parameters.fontAlign; }
			if ((parameters.fontSpacing != undefined) && (Utils.isA(parameters.fontSpacing, Number))) { DEFAULT_FONTSPACING = parameters.fontSpacing; }
		}
		
		static public function getDefaultStyle():TextStyle { return new TextStyle(); }

		/********************/
		
		
		
		private var $fontFamily:String;
		private var $fontSize:int;
		private var $fontColor:int;
		private var $fontAlign:String;
		private var $fontSpacing:Number;
		
		public function set fontFamily(fontFamily:String):void { $fontFamily = FontManager.isAvailable(fontFamily) ? fontFamily : DEFAULT_FONTFAMILY; }
		public function get fontFamily():String { return $fontFamily; }
		
		public function set fontSize(fontSize:int):void { $fontSize = fontSize; }
		public function get fontSize():int { return $fontSize; }
		
		public function set fontColor(fontColor:int):void { $fontColor = fontColor; }
		public function get fontColor():int { return $fontColor; }
		
		public function set fontAlign(fontAlign:String):void { $fontAlign = fontAlign; }
		public function get fontAlign():String { return $fontAlign; }
		
		public function set fontSpacing(fontSpacing:Number):void { $fontSpacing = fontSpacing; }
		public function get fontSpacing():Number { return $fontSpacing; }
		
		/**
		 * @param	fontFamily name of the label's font (null => DEFAULT_FONTFAMILY)
		 * @param	fontSize size of the label's font (-1 => DEFAULT_FONTSIZE)
		 * @param	fontColor color of the label's font (-1 => DEFAULT_FONTCOLOR)
		 * @param	fontAlign alignment of the label's textfield (null => DEFAULT_FONTFALIGN)
		 * @param	fontSpacing letterspacing of the label's font (null => DEFAULT_FONTSPACING)
		 */
		public function TextStyle(parameters:Object = null)
		{
			if (parameters != null)
			{
				if ((parameters.fontFamily != null) && (Utils.isA(parameters.fontFamily, String))) { fontFamily = parameters.fontFamily; } else { $fontFamily = DEFAULT_FONTFAMILY; }
				if ((parameters.fontSize != undefined) && (Utils.isA(parameters.fontSize, int))) { fontSize = parameters.fontSize; } else { $fontSize = DEFAULT_FONTSIZE; }
				if ((parameters.fontColor != undefined) && (Utils.isA(parameters.fontColor, int))) { fontColor = parameters.fontColor; } else { $fontColor = DEFAULT_FONTCOLOR; }
				if ((parameters.fontAlign != null) && (Utils.isA(parameters.fontAlign, String))) { fontAlign = parameters.fontAlign; } else { $fontAlign = DEFAULT_FONTALIGN; }
				if ((parameters.fontSpacing != undefined) && (Utils.isA(parameters.fontSpacing, Number))) { fontSpacing = parameters.fontSpacing; } else { $fontSpacing = DEFAULT_FONTSPACING; }
			}
			else
			{
				$fontFamily = DEFAULT_FONTFAMILY; $fontSize = DEFAULT_FONTSIZE; $fontColor = DEFAULT_FONTCOLOR; $fontAlign = DEFAULT_FONTALIGN; $fontSpacing = DEFAULT_FONTSPACING;
			}
		}
		
		public function clone():TextStyle
		{
			return new TextStyle( { fontFamily:$fontFamily, fontSize:$fontSize, fontColor:$fontColor, fontAlign:$fontAlign, fontSpacing:$fontSpacing } );
		}
		
		public function toString():String {	return "$fontAlign:" + $fontAlign + "$fontColor:0x" + $fontColor.toString(16) + "$fontFamily:" + $fontFamily + "$fontSpacing:" + $fontSpacing.toString() + "$fontSize:" + $fontSize.toString(); }
		
		public function appliedTo(textfield:TextField):void
		{
			//TODO : Appliquer un style a un textfield
		}
	}
}
