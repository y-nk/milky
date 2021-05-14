package martian.soup.basics
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import martian.milky.labels.Label;
	import martian.milky.styles.*;
	import martian.soup.events.SettingEvent;
	
	public class RoundMeter extends Sprite
	{
		private var $value:Number;
		
		public function get value():Number { return $value; }
		public function set value(v:Number):void { draw(int(((v / $coeff) - 50) * 3.6), false); }

		private var $coeff:Number;
		public function get coeff():Number { return $coeff; }
		
		private var $aiming:Number = 0.8;
		
		private var $str:String;
		private var $suffix:String;
		
		private var $title:Label;
		private var $meter:Sprite;
		
		private var $color:int;
		
		public function RoundMeter(str:String, value:Number = 0, coeff:Number = 1, suffix:String = "%", color:int = 0x40C2F3)
		{
			$str = str;
			$coeff = coeff;
			$suffix = suffix;
			$color = color;
			
			$title = new Label( { str:value.toString(), ts:new TextStyle( { fontFamily:"h35", fontSize:11, fontColor:0xffffff, fontSpacing:0 } ), ss:new ShapeStyle( { fillAlpha:0, lineAlpha:0 } ) } );
			
			var bckgrnd:Sprite = new Sprite;
				bckgrnd.graphics.lineStyle(1, 0x595959);
				bckgrnd.graphics.beginFill(0x3D3D3D);
				bckgrnd.graphics.drawEllipse(0, 0, 35, 35);
				bckgrnd.graphics.endFill();
				
			var shadow:Sprite = new Sprite;
				shadow.graphics.beginFill(0xFFFFFF);
				shadow.graphics.drawEllipse(0, 0, 35, 35);
				shadow.graphics.endFill();
				shadow.blendMode = "multiply";
				
			$meter = new Sprite;
				$meter.x = $meter.y = 17;
				$meter.rotation = 90;
				$meter.blendMode = "screen";
				
				draw(value / coeff);
				
			var render1:Array = new Array;
				render1.push(new GlowFilter(0x141414, 0.75, 3, 3, 2, 1, true));
				shadow.filters = render1;
				
			var frgrnd:Sprite = new Sprite;
				frgrnd.graphics.lineStyle(1, 0x595959);
				frgrnd.graphics.beginFill(0x474747);
				frgrnd.graphics.drawEllipse(1, 1, 23, 23);
				frgrnd.graphics.endFill();
				frgrnd.x = frgrnd.y = 5;
				
			var render2:Array = new Array;
				render2.push(new GlowFilter(0x141414, 0.75, 3, 3));
				frgrnd.filters = render2;
				
				$title.x = 5;
				$title.y = bckgrnd.height / 2 - $title.height / 2;
				
				addChild(bckgrnd);
				addChild($meter);
				addChild(shadow);
				addChild(frgrnd);
				addChild($title);
				
				bckgrnd.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown, false, 1000);
				$meter.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown, false, 1000);
				shadow.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown, false, 1000);
				frgrnd.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown, false, 1000);
		}	
		
		private function mouseDown(e:MouseEvent):void	
		{
			e.stopImmediatePropagation();
			
			draw(angle());
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove, false, 1000);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp, false, 1000);
		}
		
		private function mouseMove(e:MouseEvent):void
		{
			e.stopImmediatePropagation();
			
			draw(angle());
		}
		
		private function mouseUp(e:MouseEvent):void
		{
			e.stopImmediatePropagation();
			
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
		}
			
		private function angle():Number	{ return int(Math.atan2($meter.mouseY, $meter.mouseX) * 180 / Math.PI); }
		
		private function draw(value:Number, dispatch:Boolean = true):void
		{
			if (value < - 180 + $aiming) { value = -180; }
			if (value > 180 - $aiming) { value = 180; }
			
			$meter.graphics.clear();
			$meter.graphics.beginFill($color);
			$meter.graphics.moveTo(0, 0);
			$meter.graphics.lineTo(17, 0);
			
			for (var i:Number = -180; i <= value; i += 0.1)
			{
				var px:Number = Math.cos(i * Math.PI / 180) * 17; 
				var py:Number = Math.sin(i * Math.PI / 180) * 17; 	
				
				$meter.graphics.lineTo(px, py);
			}
			
			$meter.graphics.endFill();
			
			$value = int(((value / 3.6) + 50) * $coeff);
			
			$title.x = $value > 99 ? 5 : $value > 9 ? 9 : 12;
			
			$title.refresh( { str:$value.toString() + $suffix } );
			
			if (dispatch) { dispatchEvent(new SettingEvent(SettingEvent.METER)); }
		}
		
	}
	
}
