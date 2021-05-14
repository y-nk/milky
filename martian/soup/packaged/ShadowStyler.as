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
	import flash.geom.Point;
	import martian.milky.styles.ShadowStyle;
	import martian.soup.basics.Box;
	import martian.soup.basics.RoundMeter;
	import martian.soup.basics.SpacioMeter;
	import martian.soup.advanced.Colorimeter;
	import martian.milky.curves.Rectangles;
	import martian.milky.styles.ShapeStyle;
	import martian.soup.events.SettingEvent;
	
	public class ShadowStyler extends Box
	{
		public function get value():ShadowStyle
		{
			var value:ShadowStyle = new ShadowStyle();	
				value.distance = $spaciometer.value[0];
				value.angle = $spaciometer.value[1];
				value.color = $shadColor.color;
				value.alpha = $shadColor.opacity;
				value.blur = $blur.value;
			return value;
		}
		
		public function set value(ds:ShadowStyle):void
		{
			$spaciometer.value = [ds.distance, ds.angle];
			$shadColor.color = ds.color;
			$shadColor.opacity = ds.alpha * 100;
			$blur.value = ds.blur;
		}
		
		private var $spaciometer:SpacioMeter = new SpacioMeter;
		private var $blur:RoundMeter = new RoundMeter("", 0, 0.25, "");
		private var $shadColor:Colorimeter = new Colorimeter;
		
		
		public function ShadowStyler() 
		{
			super("shadowstyler");
			
			addComponent($spaciometer);
				$spaciometer.value = [1, 90];
			
			addComponent(new Rectangles( { width:1, height:$spaciometer.height, ss:new ShapeStyle( { fillColor:0x505050 } ) } ), true);
			
			addComponent($blur, true);
				$blur.value = 4;
			
			addComponent(new Rectangles( { width:$shadColor.width, height:1, ss:new ShapeStyle( { fillColor:0x505050 } ) } ));
			addComponent($shadColor);
				$shadColor.color = 0;
				$shadColor.opacity = 0;
				
			addEventListener(SettingEvent.COLOR, update);
			addEventListener(SettingEvent.METER, update);
			addEventListener(SettingEvent.SPACIO, update);
		}
		
		private function update(e:SettingEvent):void
		{
			e.stopImmediatePropagation();
			dispatchEvent(new SettingEvent(SettingEvent.SHADOW));
		}
	}
}