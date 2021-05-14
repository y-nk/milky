package martian.soup.basics
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.display.BlendMode;
	import martian.milky.labels.Label;
	import martian.milky.styles.*;
	import martian.soup.events.SettingEvent;
	
	public class Meter extends Sprite
	{
		private var $value:Number;
		
		public function get value():Number { return $value; }
		public function set value(v:Number):void { draw(v, false); }

		private var $coeff:Number;
		public function get coeff():Number { return $coeff; }
		
		private var $str:String;
		private var $suffix:String;
		private var $width:int;
		
		private var $title:Label;
		private var $meter:Sprite;
		
		public function Meter(str:String = null, value:Number = 0, coeff:Number = 1, suffix:String = "%", width:int = 100)
		{
			$str = str;
			$coeff = coeff;
			$suffix = suffix;
			$width = width;
			
			if ($str != null) { $title = new Label( { str:str + " : ", ts:new TextStyle( { fontFamily:"arial", fontSize:11, fontColor:0xffffff, fontSpacing:0 } ), ss:new ShapeStyle( { fillAlpha:0, lineAlpha:0 } ) } ); }
			
			var bckgrnd:Sprite = new Sprite;
				bckgrnd.graphics.beginFill(0x3D3D3D);
				bckgrnd.graphics.drawRect(0, 0, $width, 10);
				bckgrnd.graphics.endFill();
				
			var shadow:Sprite = new Sprite;
				shadow.graphics.beginFill(0xFFFFFF);
				shadow.graphics.drawRect(0, 0, $width, 10);
				shadow.graphics.endFill();
				shadow.blendMode = BlendMode.MULTIPLY;
				shadow.filters = [new DropShadowFilter(0,45, 0x141414, 1, 4, 4, 1, 1, true)];
				
			$meter = new Sprite;
				$meter.blendMode = BlendMode.SCREEN;
				draw(value / coeff);
				
			var border:Sprite = new Sprite;
				border.graphics.lineStyle(1, 0x595959);
				border.graphics.drawRect(-1, -1, bckgrnd.width + 1, bckgrnd.height + 1);
				border.x = bckgrnd.x;
				border.y = bckgrnd.y;
			
			if ($str != null)
			{ 
				$title.x = border.width + 1;
				$title.y = -4;
			}
				
				addChild(bckgrnd);
				addChild($meter);
				addChild(shadow);
				addChild(border);
				if ($str != null) { addChild($title); }
				
				bckgrnd.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown, false, 1000);
				$meter.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown, false, 1000);
				shadow.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown, false, 1000);
		}	
		
		private function mouseDown(e:MouseEvent):void	
		{
			e.stopImmediatePropagation();
			
			draw(mouseX);
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove, false, 1000);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp, false, 1000);
		}
		
		private function mouseMove(e:MouseEvent):void
		{
			e.stopImmediatePropagation();
			
			draw(mouseX);
		}
		
		private function mouseUp(e:MouseEvent):void
		{
			e.stopImmediatePropagation();
			
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
		}
			
		private function draw(value:Number, dispatch:Boolean = true):void
		{
			var v:Number;
			
			if ((value >= 0) && (value <= $width)) { v = value; }
			else if (value > $width) { v = $width; }
			else if (value <= 0) { v = 0; }
			
			$meter.graphics.clear();
			$meter.graphics.beginFill(0x40C2F3);
			$meter.graphics.drawRect(0, 0, v, 10);
			$meter.graphics.endFill();
			
			v = v * 100 / $width;
			
			$value = int(v * $coeff * 100) / 100;
			
			if ($str != null) { $title.refresh( { str:$str + " : " + $value.toString() + $suffix } ); }
			
			if (dispatch) { dispatchEvent(new SettingEvent(SettingEvent.METER)); }
		}
		
	}
}
