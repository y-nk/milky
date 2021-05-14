package martian.soup.packaged 
{
	import martian.milky.curves.Rectangles;
	import martian.milky.styles.*;
	import martian.soup.advanced.Colorimeter;
	import martian.soup.basics.Box;
	import martian.soup.basics.Meter;
	import flash.events.MouseEvent;
	import martian.soup.events.SettingEvent;
	
	public class ShapeStyler extends Box
	{
		public function get value():ShapeStyle
		{
			var value:ShapeStyle = new ShapeStyle();
				value.fillColor = $fillColor.color;
				value.fillAlpha = $fillColor.opacity;
				value.lineThick = $lineThick.value;
				value.lineColor = $lineColor.color;
				value.lineAlpha = $lineColor.opacity;
				
			return value;
		}
		
		public function set value(ss:ShapeStyle):void
		{
			$fillColor.color = ss.fillColor;
			$fillColor.opacity = ss.fillAlpha * 100;
			$lineThick.value = ss.lineThick;
			$lineColor.color = ss.lineColor;
			$lineColor.opacity = ss.lineAlpha * 100;
		}
		
		private var $lineColor:Colorimeter = new Colorimeter;
		private var $lineThick:Meter = new Meter(null, 0, 1, "%", 100);
		private var $fillColor:Colorimeter = new Colorimeter;
		
		
		public function ShapeStyler()
		{
			super("shapestyler");
			
			addComponent($lineColor);
				$lineColor.color = 0;
				$lineColor.opacity = 0;
				
			addComponent($lineThick);
				$lineThick.value = 0;
			
			addComponent(new Rectangles( { width:1, height:$lineColor.height, ss:new ShapeStyle( { fillColor:0x505050 } ) } ), true);
			
			addComponent($fillColor, true);
				$fillColor.color = 0;
				$fillColor.opacity = 100;
				
			addEventListener(SettingEvent.COLOR, update);
			addEventListener(SettingEvent.METER, update);
		}
		
		private function update(e:SettingEvent):void
		{
			e.stopImmediatePropagation();
			dispatchEvent(new SettingEvent(SettingEvent.SHAPE));
		}
	}
}