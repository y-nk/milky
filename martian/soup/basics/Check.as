package martian.soup.basics
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import martian.soup.events.SettingEvent;
	import martian.milky.curves.Rectangles;
	import martian.milky.labels.Label;
	import martian.milky.styles.*;
	
	public class Check extends Sprite
	{
		private var $value:Boolean;
		public function get value():Boolean { return $value; }
		public function set value(bool:Boolean):void { $value = bool; update(bool, false); }
		
		public function Check(title:String, value:Boolean = false) 
		{
			var square:Rectangles = new Rectangles( { width:6, ss:new ShapeStyle( { lineAlpha:0, fillColor:0xffffff, fillAlpha:1 } ), editable:false } );
				square.x = square.y = 2;
				if (!value) { square.alpha = 0; }
			
			var lbl:Label = new Label( { str:title, ts:new TextStyle( { fontFamily:"arial", fontSize:11, fontColor:0xffffff, fontSpacing:0 } ), ss:new ShapeStyle( { fillAlpha:0, lineAlpha:0 } ) } );
				lbl.x = 11;
				lbl.y = -4;
			
			graphics.lineStyle(1, 0xffffff);
			graphics.drawRect(0, 0, 9, 9);
			
			addChild(square);
			addChild(lbl);
			addEventListener(MouseEvent.CLICK, mouseClick);
		}
		
		private function mouseClick(e:MouseEvent):void
		{
			update(!$value);
		}
		
		private function update(value:Boolean, dispatch:Boolean = true) :void
		{
			$value = value;
			
			var newAlpha:int = $value ? 1 : 0;
			getChildAt(0).alpha = newAlpha;
			
			if (dispatch) { dispatchEvent(new SettingEvent(SettingEvent.CHECK)); }
		}
			
	}
}