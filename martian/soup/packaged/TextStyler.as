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

package martian.soup.packaged 
{
	import martian.milky.styles.TextStyle;
	import martian.soup.advanced.Colorimeter;
	import martian.soup.basics.Box;
	import martian.soup.basics.Combo;
	import martian.soup.events.SettingEvent;
	import martian.milky.fonts.FontManager;
	
	public class TextStyler extends Box
	{
		public function get value():TextStyle
		{
			var value:TextStyle = new TextStyle;
				value.fontFamily = $fontFamily.value;
				value.fontColor = $fontColor.color;
				value.fontSize = $fontColor.opacity * 100;
				value.fontAlign = $fontAlign.value;
				value.fontSpacing = int($fontSpacing.value);
			return value;
		}
		
		public function set value(ts:TextStyle):void
		{
			$fontFamily.value = ts.fontFamily;
			$fontColor.opacity = ts.fontSize;
			$fontColor.color = ts.fontColor;
			$fontAlign.value = ts.fontAlign;
			$fontSpacing.value = ts.fontSpacing.toString();
		}
		
		private var $fontFamily:Combo = new Combo("family", FontManager.fonts, 1);
		private var $fontColor:Colorimeter = new Colorimeter;
		private var $fontAlign:Combo = new Combo("align", ["left", "center", "right"], 0);
		private var $fontSpacing:Combo = new Combo("spacing", ["-5", "-4", "-3", "-2", "-1", "0", "1", "2", "3", "4", "5"], 5);

		public function TextStyler()
		{
			super("textstyler");
			
			addComponent($fontFamily);
				$fontFamily.value = TextStyle.DEFAULT_FONTFAMILY;
			addComponent($fontColor);
				$fontColor.color = TextStyle.DEFAULT_FONTCOLOR;
				$fontColor.opacity = TextStyle.DEFAULT_FONTSIZE;
			addComponent($fontAlign);
				$fontAlign.value = TextStyle.DEFAULT_FONTALIGN;
			addComponent($fontSpacing);
				$fontSpacing.value = TextStyle.DEFAULT_FONTSPACING.toString();
			
			addEventListener(SettingEvent.COMBO, update);
			addEventListener(SettingEvent.COLOR, update);
		}
		
		private function update(e:SettingEvent):void
		{
			e.stopImmediatePropagation();
			dispatchEvent(new SettingEvent(SettingEvent.TEXT));
			
			if (e.type == SettingEvent.COMBO)
			{
				if ((e.target != $fontFamily) && ($fontFamily.status)) { $fontFamily.toggle(); }
				if ((e.target != $fontAlign) && ($fontAlign.status)) { $fontAlign.toggle(); }
				if ((e.target != $fontSpacing) && ($fontSpacing.status)) { $fontSpacing.toggle(); }
			}
		}
	}
}