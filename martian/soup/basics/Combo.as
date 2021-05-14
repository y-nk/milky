package martian.soup.basics 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import martian.milky.labels.Label;
	import martian.milky.styles.*;
	import martian.soup.events.SettingEvent;
	
	public class Combo extends Sprite
	{
		private var $value:String;
		public function get value():String { return $value; }
		public function set value(str:String):void { update(str, false); }
		
		private var $values:Array;
		private var $margin:int = 5;
		private var $selected:Label;
		private var $plus:Sprite;
		private var $border:Sprite = new Sprite();
		private var $list:Sprite = new Sprite();
		
		private var $status:Boolean = false;
			public function get status():Boolean { return $status; }
		
		public function Combo(title:String, values:Array, selected:int = -1) 
		{
			$values = values;
			
			var state:Boolean;
			
			var lbl:Label = new Label( { str:title + " : ", ts:new TextStyle( { fontFamily:"h55", fontSize:11, fontColor:0xffffff, fontSpacing:0 } ), ss:new ShapeStyle( { fillColor:0x474747, fillAlpha:0, lineAlpha:0 } ) } );
				addChild(lbl);
			
			for (var i:int = 0; i < values.length; i++) { newElement(values[i]); }
			
			$selected = new Label( { str:title, ts:new TextStyle( { fontFamily:"h55", fontSize:11, fontColor:0xffffff, fontSpacing:0 } ), ss:new ShapeStyle( { fillColor:0x3d3d3d, fillAlpha:1, lineAlpha:0 } ) } );
			$selected.x = lbl.width;
			$selected.filters = [new DropShadowFilter(0, 90, 0x141414, 0.75, 3, 3, 1, 1, true)];
			$selected.addEventListener(MouseEvent.CLICK, toggle);
			
			$list.graphics.beginFill(0x474747);
			$list.graphics.drawRect(-1, -1, int($list.width + 3), int($list.height + 1));
			$list.graphics.endFill();
			$list.graphics.lineStyle(1, 0x595959);
			$list.graphics.drawRect(-1, -1, int($list.width), int($list.height));
			$list.filters = [new DropShadowFilter(0, 90, 0x101010, 1, 3, 3)];
			
			$plus = new Sprite;
				$plus.graphics.beginFill(0xffffff);
				$plus.graphics.drawRect(0, 0, 8, 8);
				$plus.graphics.drawRect(0, 0, 3, 3);
				$plus.graphics.drawRect(5, 0, 3, 3);
				$plus.graphics.drawRect(0, 5, 3, 3);
				$plus.graphics.drawRect(5, 5, 3, 3);
				$plus.graphics.endFill();
				$plus.addEventListener(MouseEvent.CLICK, toggle);
			
			$list.x = $selected.x + $selected.width - 5;
			$list.y = $selected.height - 5;

			addChild($selected);
			addChild($plus);
			addChild($border);
			
			update(values[0]);
		}
		
		public function newElement(value:String):void
		{
			var element:Label = new Label( { str:value, ss:new ShapeStyle( { fillColor:0x494949, fillAlpha:1, lineAlpha:0 } ), ts:new TextStyle( { fontFamily:"h55", fontSize:11, fontSpacing:0, fontColor:0xffffff } ) } );
				element.addEventListener(MouseEvent.CLICK, select);
				element.addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
				element.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
				
			if ($list.numChildren == 0)
			{
				$list.addChild(element);
				element.y = 0;
			}
			else
			{
				var last:* = $list.getChildAt($list.numChildren - 1);
				$list.addChild(element);
				element.y = last.y + last.height; 
			}
		}
		
		private function select(e:MouseEvent):void
		{
			update((e.currentTarget as Label).str);
			toggle(e);
		}
		
		private function update(value:String, dispatch:Boolean = true):void
		{
			var present:Boolean = false;
			for (var i:int = 0; i < $values.length; i++) { if ($values[i] == value) { present = true; } }
			
			if (present)
			{
				$value = value;
				
				$selected.refresh( { str:value } );
				
				$plus.x = int($selected.x + $selected.width + 5);
				$plus.y = int($selected.y) + 4;
				
				$list.x = $selected.x + $selected.width - 5;
				
				$border.graphics.clear();
				$border.graphics.lineStyle(1, 0x595959);
				$border.graphics.drawRect(-1, -1, int($selected.width) + 1, int($selected.height) + 1);
				$border.x = $selected.x;
				$border.y = $selected.y;
				
				if (dispatch) { dispatchEvent(new SettingEvent(SettingEvent.COMBO)); }
			}
		}
		
		public function toggle(e:MouseEvent = null):void
		{
			if ($status) { removeChild($list); }
			else
			{
				parent.setChildIndex(this, parent.numChildren - 1);
				addChild($list);
			}
			
			dispatchEvent(new SettingEvent(SettingEvent.COMBO));
			$status = !$status;
		}
		
		private function mouseOver(e:MouseEvent):void
		{
			(e.currentTarget as Label).refresh( { ss:new ShapeStyle( { fillColor:0x595959, fillAlpha:1 } ) } );
		}
		
		private function mouseOut(e:MouseEvent):void
		{
			(e.currentTarget as Label).refresh( { ss:new ShapeStyle( { fillColor:0x494949, fillAlpha:1 } ) } );
		}
	}
}