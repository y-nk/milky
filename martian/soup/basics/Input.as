package martian.soup.basics
{
	import martian.milky.labels.*;
	import martian.milky.styles.ShapeStyle;
	import martian.milky.styles.TextStyle;
	
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;	
	import flash.text.*;
	
	public class Input extends Sprite
	{
		private var $width:Number;
		private var $str:String;
		private var $input:TextField;
		
		public function get value():String { return $input.text; }
		public function set value(v:String):void { $input.text = v; }
		
		public function Input(str:String, width:int, height:int = 16)
		{
			$width = width;
			$str = str;
			
			var title:Label = new Label( { str:$str + " : ", ts:new TextStyle( { fontFamily:"arial", fontSize:11, fontColor:0xffffff, fontSpacing:0 } ), ss:new ShapeStyle( { fillAlpha:0, lineAlpha:0 } ) } );
				addChild(title);
			
			var txtFrmt:TextFormat = new TextFormat;
				txtFrmt.font = "arial";
				txtFrmt.size = 11;
				txtFrmt.color = 0xFFFFFF;
				txtFrmt.align = TextFormatAlign.LEFT;
				
			$input = new TextField();
				$input.x = int(title.width);
				$input.type = TextFieldType.INPUT;
				$input.width = width - $input.x;
				$input.height = height;
				$input.antiAliasType = AntiAliasType.ADVANCED ;
				$input.background = true;
				$input.backgroundColor = 0x3D3D3D;
				$input.embedFonts = true;
				$input.defaultTextFormat = txtFrmt;
				$input.setTextFormat(txtFrmt);
				$input.filters = [new DropShadowFilter(0, 90, 0x141414, 0.75, 3, 3, 1, 1, true)];
				
			var border:Sprite = new Sprite;
				border.graphics.lineStyle(1, 0x595959);
				border.graphics.drawRect(-1, -1, $input.width + 1, $input.height + 1);
				border.x = $input.x;
				border.y = $input.y;
			
			addChild(title);
			addChild($input);
			addChild(border);
		}
	}
}
