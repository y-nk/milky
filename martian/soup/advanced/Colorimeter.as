package martian.soup.advanced
{
	import flash.display.Sprite;
	import martian.soup.basics.ColorSpectrum;
	import martian.soup.basics.Meter;
	import martian.soup.basics.RoundMeter;
	import martian.soup.events.SettingEvent;
	import martian.soup.utils.Color;
	
	public class Colorimeter extends Sprite
	{
		private var $value:int;
		public function get color():int { return $value; }
		public function set color(v:int):void
		{
			var value:Array = Color.INTtoRGB(v);
				R.value = value[0];
				G.value = value[1];
				B.value = value[2];
		}
		
		public function get opacity():Number { return A.value; }
		public function set opacity(n:Number):void { A.value = n; }
		
		private var RGB:ColorSpectrum = new ColorSpectrum(100, 50);
		private var R:RoundMeter = new RoundMeter("red", 50, 2.55, "", 0xFF0040);
		private var G:RoundMeter = new RoundMeter("green", 50, 2.55, "", 0x80FF00);
		private var B:RoundMeter = new RoundMeter("blue", 50, 2.55, "", 0x0080FF);
		private var A:Meter = new Meter(null, 100, 0.01, "%", 100);
		
		public function Colorimeter()
		{
			addChild(R);
				R.x = 0;
			addChild(G);
				G.x = R.x + 35;
				G.y = R.y + R.height;
			addChild(B);
				B.x = R.x;
				B.y = G.y + G.height;
			addChild(A);
				A.x = G.x + G.width + A.height + 7;
				A.y = B.y + B.height;
				A.rotation = -90;
			addChild(RGB);
				RGB.x = 0;
				RGB.y = B.y + B.height + 10;

				
			addEventListener(SettingEvent.METER, meterHandler);
			addEventListener(SettingEvent.SPECTRUM, spectrumHandler);
		}
		
		private function spectrumHandler(e:SettingEvent):void
		{
			e.stopImmediatePropagation();
			
			var color:Array = (e.target as ColorSpectrum).value;
			
			R.value = color[0];
			G.value = color[1];
			B.value = color[2];
			
			$value = Color.RGBtoINT(color);
			
			dispatchEvent(new SettingEvent(SettingEvent.COLOR));
		}
		
		private function meterHandler(e:SettingEvent):void
		{
			e.stopImmediatePropagation();
			
			var r:int = Color.INTtoRGB($value)[0], g:int = Color.INTtoRGB($value)[1], b:int = Color.INTtoRGB($value)[2];
			
			switch (e.target)
			{
				case R:
					r = (e.target as RoundMeter).value;
					break;
					
				case G:
					g = (e.target as RoundMeter).value;
					break;
					
				case B:
					b = (e.target as RoundMeter).value;
					break;
			}
			
			$value = Color.RGBtoINT([r, g, b]);
			
			dispatchEvent(new SettingEvent(SettingEvent.COLOR));
		}
	}
	
}