package martian.soup.basics 
{
	import flash.display.Sprite;
	import flash.events.*;
	import flash.geom.Point;
	import martian.milky.curves.Roundrectangles;
	import martian.milky.labels.Label;
	import martian.milky.styles.*;
	
	import gs.*;
	import gs.easing.*;
	
	public class Box extends Roundrectangles
	{
		private var $margin:int = 10;
		
		public function Box(title:String) 
		{
			super( { width:0, height:0, radius:4, ss:new ShapeStyle({fillColor:0x595959}), ds:ShadowStyle.getDefaultStyle(), editable:false } );
			
			var h1:Label = new Label( { str:title.toUpperCase(), ss:new ShapeStyle({ fillAlpha:0 }), ts:new TextStyle({fontColor:0xffffff, fontSize:11}), ds:ShadowStyle.getDefaultStyle() } );
				h1.x = 5;
				h1.y = 4;
				
				addChild(h1);
				
			doubleClickEnabled = true;
			addEventListener(MouseEvent.MOUSE_DOWN, drag);
			addEventListener(MouseEvent.DOUBLE_CLICK, disappear, false, 1000);
		}
		
		private function stop(e:MouseEvent):void { if (e.target != stage) { /*e.stopImmediatePropagation();*/ } }
		
		private function drag(e:MouseEvent):void
		{
			e.stopPropagation();
			addEventListener(MouseEvent.MOUSE_UP, drop);
			parent.setChildIndex(this, parent.numChildren - 1);
			startDrag();
		}
		private function drop(e:MouseEvent):void
		{
			e.stopPropagation();
			removeEventListener(MouseEvent.MOUSE_UP, drop);
			stopDrag();
		}
		
		public function appear(e:MouseEvent = null):void
		{
			if (e != null) { e.stopImmediatePropagation(); }
			TweenMax.to(this, 1, { autoAlpha:1, ease:Circ.easeInOut } );
		}
		
		public function disappear(e:MouseEvent = null):void
		{
			if (e != null) { e.stopImmediatePropagation(); }
			TweenMax.to(this, 1, { autoAlpha:0, ease:Circ.easeInOut } );
		}
		
		protected function addComponent(component:Sprite, float:Boolean = false):Sprite
		{
			var size:Point = new Point(width, height);
			
			if (numChildren <= 1)
			{
				component.x = $margin;
				component.y = 3 * $margin;
				addChild(component);
				
				size.x += component.x + component.width;
				size.y += component.y + component.height;
			}
			else
			{
				var last:* = getChildAt(numChildren - 1);
				
				if (!float)
				{
					component.x = $margin;
					component.y = int(last.y + last.height + $margin);
				}
				else
				{
					var first:* = getChildAt(1);
					
					component.x = int(last.x + last.width + $margin);
					component.y = first.y;
				}
				
				size.x += (component.x + component.width + $margin) > width ? (component.x + component.width + $margin) - width : 0;
				size.y += (component.y + component.height + $margin) > height ? (component.y + component.height + $margin) - height  : 0;	
				
				addChild(component);
			}
			
			refresh( { width:size.x, height:size.y, radius:4 } );
			
			return component;
		}
		
	}
	
}