package martian.soup.basics 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import martian.soup.events.SettingEvent;
	import martian.milky.curves.Ellipse;
	import martian.milky.labels.Label;
	import martian.milky.styles.*;
	
	public class Radio extends Sprite
	{
		private var $value:String;
		public function get value():String { return $value; }
		public function set value(str:String):void { for (var i:int = 0; i < $values.length; i++) { if (str == values[i]) { select(i, false); } } }
		
		private var $values:Array;
		public function get values():Array { return $values; }
		
		private var $margin:int = 5;
		
		public function Radio(title:String, values:Array, checked:int = -1) 
		{
			$values = values;
			
			var state:Boolean;
			
			var lbl:Label = new Label( { str:title + " : ", ts:new TextStyle( { fontFamily:"arial", fontSize:11, fontColor:0xffffff, fontSpacing:0 } ), ss:new ShapeStyle( { fillColor:0x474747, fillAlpha:1, lineAlpha:0 } ) } );
				addChild(lbl);
			
			for (var i:int = 0; i < values.length; i++)
			{
				if (i == checked) { state = true; $value = values[i] } else { state = false; }
				newElement(values[i], state);
			}
		}
		
		private function newElement(value:String, checked:Boolean = false):void
		{
			var circle:Ellipse = new Ellipse( { width:10, ss:new ShapeStyle( { lineThick:1, lineAlpha:1, lineColor:0xffffff, fillAlpha:1, fillColor:0x323232 } ), editable:false } );
			var round:Ellipse = new Ellipse( { width:6, ss:new ShapeStyle( { lineAlpha:0, fillColor:0xffffff, fillAlpha:1 } ), editable:false } );
				round.x = round.y = 2;
				if (!checked) { round.alpha = 0; }
			
			var title:Label = new Label( { str:value, ts:new TextStyle( { fontFamily:"arial", fontSize:11, fontColor:0xffffff, fontSpacing:0 } ), ss:new ShapeStyle( { fillAlpha:0, lineAlpha:0 } ) } );
				title.x = 11;
				title.y = -4;
				
			var radio:Sprite = new Sprite;
				radio.addChild(circle);
				radio.addChild(round);
				radio.addChild(title);
				radio.addEventListener(MouseEvent.CLICK, mouseClick);
				radio.name = value;
				
			if (numChildren == 0)
			{
				addChild(radio);
				radio.y = radio.height / 2 + $margin;
			}
			else
			{
				var last:* = getChildAt(numChildren - 1);
				addChild(radio);
				radio.y = int(last.y + last.height + $margin); 
			}
			
			radio.x = 2 * $margin;
		}
		
		private function mouseClick(e:MouseEvent):void
		{
			var selected:Sprite = e.currentTarget as Sprite;
			
			for (var i:int = 1; i < numChildren; i++)
			{
				if (selected == (getChildAt(i) as Sprite)) { select(i); }
			}
		}
		
		private function select(index:int, dispatch:Boolean = true):void
		{
			for (var i:int = 1; i < numChildren; i++)
			{
				if (i != index)
				{
					(getChildAt(i) as Sprite).getChildAt(1).alpha = 0;
				}
				else
				{
					$value = getChildAt(i).name;
					(getChildAt(i) as Sprite).getChildAt(1).alpha = 1;
				}
			}
			
			if (dispatch) { dispatchEvent(new SettingEvent(SettingEvent.RADIO)); }
		}
	}
}