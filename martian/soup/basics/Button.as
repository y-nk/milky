package martian.soup.basics
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import martian.soup.events.SettingEvent;
	
	import martian.milky.labels.Label;
	import martian.milky.styles.*;
	
	import gs.*;
	
	public class Button extends Sprite
	{
		private var $label:Label;
		public function get label():String { return $label.str; }
		
		public function Button(str:String = "button")
		{
			addChild($label = new Label( { str:str, ts:new TextStyle( { fontFamily:"arial", fontSize:11, fontSpacing:0, fontAlign:"center", fontColor:0xffffff } ), ss:new ShapeStyle( { fillColor:0x474747, lineAlpha:0, fillAlpha:1 } ), ds:new ShadowStyle( { distance:0, angle:90, color:0x101010, alpha:1, blur:3 } ) } ) );
			
			var border:Sprite = new Sprite();
				border.graphics.lineStyle(1, 0x595959);
				border.graphics.drawRect(0, 0, int($label.width) - 1, int($label.height) - 1);
				border.graphics.endFill();
				addChild(border);
				
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
		}
		
		private function mouseDown(e:MouseEvent):void
		{
			addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			stage.addEventListener(MouseEvent.MOUSE_UP, stageMouseUp);
		}
		
		private function mouseUp(e:MouseEvent):void
		{
			dispatchEvent(new SettingEvent(SettingEvent.BUTTON));
			removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
		}
		
		private function stageMouseUp(e:MouseEvent):void
		{
			removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stageMouseUp);
		}
	}
}