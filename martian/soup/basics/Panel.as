package martian.soup.basics
{
	import martian.milky.curves.*;
	import martian.milky.labels.*;
	import martian.milky.styles.*;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import gs.*;

	
	
	public class Panel extends Rectangles
	{
		private var $width:int, $margin:int = 3;
		private var $visible:Point = new Point(), $hidden:Point = new Point();
		
		private var $line:Line;
		private var $buttons:Array;
		private var $selected:Sprite;
		private var $tabs:Array;
		public function get tabs():Array { return $tabs; }
		
		public var $status:Boolean = false, $locked:Boolean = false;
		
		public function Panel(width:int, tabs:Array = null)
		{
			super();
			$width = width;
			
			addEventListener(Event.ADDED_TO_STAGE, handlers);
			
			if (tabs != null)
			{
				$tabs = new Array();
				$buttons = new Array();
				
				for (var i:int = 0; i < tabs.length; i++)
				{
					$tabs.push(new Tab());
					
					$buttons.push(newButton(tabs[i]));
						if (i > 0) { $buttons[i].y = $buttons[i - 1].y + $buttons[i - 1].height - 13; }
						$buttons[i].rotation = 90;
						$buttons[i].x = width + $buttons[i].width - 2;
						$buttons[i].addEventListener(MouseEvent.CLICK, select);
						addChild($buttons[i]);
				}
				
				addChild($line = new Line( { length:0, ss:new ShapeStyle( { fillColor:0x474747, fillAlpha:1, lineThick:2, lineColor:0x595959, lineAlpha:1 } ) } ) );
				
				update(0);
			}
		}
		
		private function handlers(e:Event):void
		{
			refresh( { width:$width, height:stage.stageHeight, ss:new ShapeStyle( { fillColor:0x474747, fillAlpha:1, lineThick:2, lineColor:0x595959, lineAlpha:1 } ), ds:new ShadowStyle( { distance:0, angle:90, color:0x141414, alpha:1, blur:5 } ), editable:false } );
			if ($line != null)
			{
				$line.refresh( { length:stage.stageHeight } );
				$line.x = width;
				$line.rotation = 90;
			}
			
			addEventListener(MouseEvent.MOUSE_OVER, slideIn);
			addEventListener(MouseEvent.MOUSE_OUT, slideOut);
			
			addEventListener(MouseEvent.MOUSE_DOWN, stop);
			addEventListener(MouseEvent.MOUSE_WHEEL, stop);
			
			addEventListener(MouseEvent.DOUBLE_CLICK, lock);
			
			stage.addEventListener(Event.RESIZE, adjust);
			adjust(e);
			
			removeEventListener(Event.ADDED_TO_STAGE, handlers);
		}
		
		private function adjust(e:Event):void
		{
			place();
			refresh( { width:$width, height:stage.stageHeight } );
			
			if ($status)
			{
				x = $visible.x;
				y = $visible.y;
			}
			else
			{
				x = $hidden.x;
				y = $hidden.y;
			}
		}
		
		public function slideIn(e:MouseEvent = null):void
		{
			//place();
			
			TweenMax.to(this, 1, {	x:$visible.x,
									y:$visible.y });
			$status = true;
		}
		
		public function slideOut(e:MouseEvent = null):void
		{
			//place();
			
			if (!$locked)
			{
				TweenMax.to(this, 1, {	x:$hidden.x,
										y:$hidden.y });
				$status = false;
			}
		}
		
		private function stop(e:MouseEvent):void { e.stopPropagation();	}
		
		private function lock(e:MouseEvent):void { $locked = !$locked; }
		
		private function place():void
		{
			$hidden = new Point(- width + $margin, 0);
			$visible = new Point(0, 0);
		}
		
		private function newButton(value:String):Sprite
		{
			var lbl:Label = new Label( { str:value, ts:new TextStyle( { fontColor:0xffffff, fontSize:11, fontSpacing:0.5, fontFamily:"h55" } ), ss:new ShapeStyle( { fillAlpha:0, lineAlpha:0 } ) } );
				lbl.x = 10;
			
			var dot1:CurvePoint = new CurvePoint(new Point(0, lbl.height), null, new Point(5, lbl.height));
			var dot2:CurvePoint = new CurvePoint(new Point(10, 0), new Point(5, 0));
			var dot3:CurvePoint = new CurvePoint(new Point(lbl.width + 10, 0), null, new Point(lbl.width + 15, 0));
			var dot4:CurvePoint = new CurvePoint(new Point(lbl.width + 20, lbl.height), new Point(lbl.width + 15, lbl.height));
			
			var tab:Curvegon = new Curvegon( { dots:[dot1, dot2, dot3, dot4], ss:new ShapeStyle( { fillColor:0x323232, fillAlpha:1, lineThick:1, lineColor:0x474747, lineAlpha:1 } ), editable:false } );
				tab.addChild(lbl);
				
			return tab;
		}
		
		private function select(e:MouseEvent):void
		{
			e.stopPropagation();
			
			for (var i:int = 0; i < $buttons.length; i++)
			{
				if (e.target == $buttons[i]) { update(i); }
			}
		}
		
		private function update(index:int):void
		{
			if ($selected != null) { ($selected as Curvegon).stylize( { ss:new ShapeStyle( { fillColor:0x323232, fillAlpha:1, lineThick:1, lineColor:0x474747, lineAlpha:1 } ) } ); }
			
			for (var i:int = 0; i < numChildren; i++)
			{
				if (getChildAt(i) == $buttons[index])
				{
					$selected = $buttons[index];
					
					setChildIndex($selected, numChildren - 1);
					($selected as Curvegon).stylize( { ss:new ShapeStyle( { fillColor:0x474747, fillAlpha:1, lineThick:1, lineColor:0x595959, lineAlpha:1 } ) } );
				}
				
				if (getChildAt(i) is Tab) { removeChild(getChildAt(i)); }
			}
			
			setChildIndex($line, numChildren - 2);
				
			addChild($tabs[index]);
			
		}
	}
}